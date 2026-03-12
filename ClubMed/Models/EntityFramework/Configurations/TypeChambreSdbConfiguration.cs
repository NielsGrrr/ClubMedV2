using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class TypeChambreSdbConfiguration : IEntityTypeConfiguration<TypeChambreSdb>
    {
        public void Configure(EntityTypeBuilder<TypeChambreSdb> builder)
        {
            // 1. Clé Primaire
            builder.HasKey(tcsdb => new { tcsdb.NumEquipementSalleDeBain, tcsdb.IdTypeChambre })
                .HasName("pk_type_chambre_sdb");

            // 2. Contraintes et Propriétés

            // 3. Relations
            builder.HasOne(tcsdb => tcsdb.EquipementSalleDeBainNav)
                .WithMany()
                .HasForeignKey(tcsdb => tcsdb.NumEquipementSalleDeBain)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_type_chambre_sdb_equipementsalledebain");

            builder.HasOne(tcsdb => tcsdb.TypeChambreNav)
                .WithMany(tc => tc.TypeChambreSdbs)
                .HasForeignKey(tcsdb => tcsdb.IdTypeChambre)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_type_chambre_sdb_typechambre");
        }
    }
}

