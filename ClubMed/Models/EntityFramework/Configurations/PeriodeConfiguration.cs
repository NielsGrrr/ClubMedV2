using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class PeriodeConfiguration : IEntityTypeConfiguration<Periode>
    {
        public void Configure(EntityTypeBuilder<Periode> builder)
        {
            // 1. Clé Primaire
            builder.HasKey(p => p.NumPeriode).HasName("pk_periode");

            // 2. Contraintes et Propriétés
            builder.Property(p => p.NumPeriode).HasMaxLength(10);

            builder.Property(p => p.DateDeb).HasColumnType("date");

            builder.Property(p => p.DateFin).HasColumnType("date");

            // 3. Relations
            builder.HasMany(p => p.PrixPeriodes)
                .WithOne(pp => pp.Periode)
                .HasForeignKey(pp => pp.NumPeriode)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_prix_periode_periode");
        }
    }
}
