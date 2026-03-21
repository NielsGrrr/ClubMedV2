using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class StationConfig : IEntityTypeConfiguration<Station>
    {
        public void Configure(EntityTypeBuilder<Station> builder)
        {
            builder.ToTable("t_e_station_sta");

            builder.HasKey(e => e.IdStation)
                .HasName("pk_station");

            builder.Property(e => e.IdStation)
                .HasColumnName("sta_id");

            builder.Property(e => e.NumPhoto)
                .IsRequired()
                .HasColumnName("sta_numphoto");

            builder.Property(e => e.NomStation)
                .IsRequired()
                .HasMaxLength(1024)
                .HasColumnName("sta_nomstation");

            builder.Property(e => e.AltitudeStation)
                .IsRequired()
                .HasColumnType("numeric(10,2)")
                .HasColumnName("sta_altitudestation");

            builder.Property(e => e.LongueurPistes)
                .IsRequired()
                .HasColumnType("numeric(10,2)")
                .HasColumnName("sta_longueurpistes");

            builder.Property(e => e.NbPistes)
                .IsRequired()
                .HasColumnName("sta_nbpistes");

            builder.Property(e => e.InfoSki)
                .IsRequired()
                .HasColumnType("text")
                .HasColumnName("sta_infoski");
        }
    }
}
