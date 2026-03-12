using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class TypeChambreServiceConfiguration : IEntityTypeConfiguration<TypeChambreService>
    {
        public void Configure(EntityTypeBuilder<TypeChambreService> builder)
        {
            // 1. Clé Primaire
            builder.HasKey(tcs => new { tcs.NumService, tcs.IdTypeChambre })
                .HasName("pk_type_chambre_service");

            // 2. Contraintes et Propriétés

            // 3. Relations
            builder.HasOne(tcs => tcs.ServiceNav)
                .WithMany()
                .HasForeignKey(tcs => tcs.NumService)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_type_chambre_service_service");

            builder.HasOne(tcs => tcs.TypeChambreNav)
                .WithMany(tc => tc.TypeChambreServices)
                .HasForeignKey(tcs => tcs.IdTypeChambre)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_type_chambre_service_typechambre");
        }
    }
}

