using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class ChambreConfiguration : IEntityTypeConfiguration<Chambre>
    {
        public void Configure(EntityTypeBuilder<Chambre> builder)
        {
            // 1. Clé Primaire
            builder.HasKey(c => c.NumChambre).HasName("pk_chambre");

            // 2. Contraintes et Propriétés

            // 3. Relations
            builder.HasOne(c => c.Type)
                .WithMany(tc => tc.Chambres)
                .HasForeignKey(c => c.IdTypeChambre)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_chambre_typechambre");
        }
    }
}
