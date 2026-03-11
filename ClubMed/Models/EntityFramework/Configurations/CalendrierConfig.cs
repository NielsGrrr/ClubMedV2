using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class CalendrierConfig : IEntityTypeConfiguration<Calendrier>
    {
        public void Configure(EntityTypeBuilder<Calendrier> builder)
        {
            builder.ToTable("t_e_calendrier_cal");

            builder.HasKey(c => c.CalDate)
                   .HasName("pk_calendrier");

            builder.Property(c => c.CalDate)
                   .HasColumnName("cal_date");

            builder.HasMany(c => c.Disponibilites)
                   .WithOne(d => d.Calendrier)
                   .HasForeignKey(d => d.DispoDate)
                   .OnDelete(DeleteBehavior.Cascade)
                   .HasConstraintName("fk_disponibilite_calendrier");
        }
    }
}
