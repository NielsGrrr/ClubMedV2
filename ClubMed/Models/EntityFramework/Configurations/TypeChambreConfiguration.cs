using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class TypeChambreConfiguration : IEntityTypeConfiguration<TypeChambre>
    {
        public void Configure(EntityTypeBuilder<TypeChambre> builder)
        {
            // 1. Clé Primaire
            builder.HasKey(tc => tc.IdTypeChambre).HasName("pk_typechambre");

            // 2. Contraintes et Propriétés
            builder.Property(tc => tc.NomType).HasMaxLength(1024);
            builder.Property(tc => tc.TextePresentation).HasMaxLength(1024);
            builder.Property(tc => tc.Indisponible).HasDefaultValue(false);

            // 3. Relations
            builder.HasOne(tc => tc.PhotoNav)
                .WithMany(p => p.TypeChambres)
                .HasForeignKey(tc => tc.NumPhoto)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_typechambre_photo");

            builder.HasOne(tc => tc.ClubNav)
                .WithMany(c => c.TypeChambre)
                .HasForeignKey(c => c.IdClub)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_club_typechambre");
        }
    }
}
