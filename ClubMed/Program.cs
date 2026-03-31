
using ClubMed.Models.DataManager;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;

namespace ClubMed
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.

            builder.Services.AddControllers().AddJsonOptions(options =>
            {
                options.JsonSerializerOptions.ReferenceHandler = System.Text.Json.Serialization.ReferenceHandler.IgnoreCycles;
                options.JsonSerializerOptions.DefaultIgnoreCondition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull;
            });
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            // D�finir la politique CORS
            builder.Services.AddCors(options =>
            {
                options.AddPolicy("AllowVueApp",
                    policy =>
                    {
                        policy.WithOrigins("http://51.83.36.122:8080", "http://localhost:5173", "http://localhost:8080")
                              .AllowAnyHeader()
                              .AllowAnyMethod();
                    });
            });

            // Configure JWT Authentication
            var jwtKey = builder.Configuration["Jwt:Key"];
            builder.Services.AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            })
            .AddJwtBearer(options =>
            {
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = true,
                    ValidateIssuerSigningKey = true,
                    ValidIssuer = builder.Configuration["Jwt:Issuer"],
                    ValidAudience = builder.Configuration["Jwt:Audience"],
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey ?? "DefaultSecretKeyNeedToBeLongEnough123!"))
                };
            });

            // Add DbContext
            builder.Services.AddDbContext<ClubMedDbContext>(options =>
                options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection"))
                       .UseLoggerFactory(ClubMedDbContext.MyLoggerFactory)
                       .EnableSensitiveDataLogging()
            );
            builder.Services.AddScoped<IDataRepository<Partenaire>, PartenaireManager>();
            builder.Services.AddScoped<IDataRepository<TypeActivite>, TypeActiviteManager>();
            builder.Services.AddScoped<IDataRepository<ActiviteAdulte>, ActiviteAdulteManager>();
            builder.Services.AddScoped<IStripeManager, StripeManager>();
            builder.Services.AddScoped<IDataRepository<LieuRestauration>, LieuRestaurationManager>();
            builder.Services.AddScoped<IDataRepository<Avis>, AvisManager>();

            builder.Services.AddScoped<IDataRepository<Station>, StationManager>();
            builder.Services.AddScoped<IDataRepository<Localisation>, LocalisationManager>();
            builder.Services.AddScoped<IDataRepository<Club>, ClubManager>();
            builder.Services.AddScoped<IClubManager, ClubManager>();
            builder.Services.AddScoped<ClubManager>();
            builder.Services.AddScoped<IDataRepository<TypeChambre>, TypeChambreManager>();

            builder.Services.AddScoped<IDataRepository<Client>, ClientManager>();
            builder.Services.AddScoped<IDataRepository<Reservation>, ReservationManager>();
            builder.Services.AddScoped<IDataRepository<Transaction>, TransactionManager>();
            builder.Services.AddScoped<IDataRepository<Transport>, TransportManager>();

            // Add Data Managers
            builder.Services.AddScoped<IDataRepository<Equipement>, EquipementManager>();
            builder.Services.AddScoped<IDataRepository<Service>, ServiceManager>();
            builder.Services.AddScoped<IDataRepository<Photo>, PhotoManager>();
            builder.Services.AddScoped<IDataRepository<Periode>, PeriodeManager>();
            


            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseHttpsRedirection();


            app.UseRouting();

            app.UseCors("AllowVueApp");

            app.UseAuthentication();
            app.UseAuthorization();

            app.MapControllers();
            

            app.Run();
        }
    }
}
