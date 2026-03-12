using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class PrixPeriodeConfiguration : IEntityTypeConfiguration<PrixPeriode>
    {
        public void Configure(EntityTypeBuilder<PrixPeriode> builder)
        {
            // 1. Cl� Primaire
            builder.HasKey(pp => new { pp.NumPeriode, pp.IdTypeChambre })
                .HasName("pk_prix_periode");

            // 2. Contraintes et Propri�t�s
            builder.Property(pp => pp.NumPeriode).HasMaxLength(10);

            builder.Property(pp => pp.Prix)
                .HasPrecision(10, 2);

            // 3. Relations
            builder.HasOne(pp => pp.Periode)
                .WithMany(p => p.PrixPeriodes)
                .HasForeignKey(pp => pp.NumPeriode)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_prix_periode_periode");

            builder.HasOne(pp => pp.TypeChambreNav)
                .WithMany(tc => tc.PrixPeriodes)
                .HasForeignKey(pp => pp.IdTypeChambre)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_prix_periode_typechambre");
        }
    }
}
