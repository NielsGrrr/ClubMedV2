
using ClubMed.Models.DataManager;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using Microsoft.EntityFrameworkCore;

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
            });
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            // Add DbContext
            builder.Services.AddDbContext<ClubMedDbContext>(options =>
                options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection"))
                       .UseLoggerFactory(ClubMedDbContext.MyLoggerFactory)
                       .EnableSensitiveDataLogging()
            );
            //builder.Services.AddScoped<IDataRepository<Avis>, AvisManager>();

            builder.Services.AddScoped<IDataRepository<Station>, StationManager>();
            builder.Services.AddScoped<IDataRepository<Localisation>, LocalisationManager>();
            builder.Services.AddScoped<IDataRepository<Club>, ClubManager>();
            builder.Services.AddScoped<IDataRepository<TypeChambre>, TypeChambreManager>();

            var app = builder.Build();


            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }


            app.UseHttpsRedirection();

            app.UseAuthorization();


            app.MapControllers();

            app.Run();
        }
    }
}
