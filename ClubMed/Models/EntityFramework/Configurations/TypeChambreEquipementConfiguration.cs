using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class TypeChambreEquipementConfiguration : IEntityTypeConfiguration<TypeChambreEquipement>
    {
        public void Configure(EntityTypeBuilder<TypeChambreEquipement> builder)
        {
            // 1. Clé Primaire
            builder.HasKey(tce => new { tce.NumEquipement, tce.IdTypeChambre })
                .HasName("pk_type_chambre_equipement");

            // 2. Contraintes et Propriétés

            // 3. Relations
            builder.HasOne(tce => tce.EquipementNav)
                .WithMany()
                .HasForeignKey(tce => tce.NumEquipement)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_type_chambre_equipement_equipement");

            builder.HasOne(tce => tce.TypeChambreNav)
                .WithMany(tc => tc.TypeChambreEquipements)
                .HasForeignKey(tce => tce.IdTypeChambre)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_type_chambre_equipement_typechambre");
        }
    }
}

