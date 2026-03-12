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
        }
    }
}
