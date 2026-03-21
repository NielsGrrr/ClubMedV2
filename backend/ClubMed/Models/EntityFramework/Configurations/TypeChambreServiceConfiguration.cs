using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class TypeChambreServiceConfiguration : IEntityTypeConfiguration<TypeChambreService>
    {
        public void Configure(EntityTypeBuilder<TypeChambreService> builder)
        {
            // 1. Cl� Primaire
            builder.HasKey(tcs => new { tcs.NumService, tcs.IdTypeChambre })
                .HasName("pk_type_chambre_service");

            // 2. Contraintes et Propri�t�s

            // 3. Relations
            builder.HasOne(tcs => tcs.ServiceNav)
                .WithMany(s => s.TypeChambreServices)
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

