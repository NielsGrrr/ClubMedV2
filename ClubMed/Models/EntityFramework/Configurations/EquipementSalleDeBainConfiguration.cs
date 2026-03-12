using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class EquipementSalleDeBainConfiguration : IEntityTypeConfiguration<EquipementSalleDeBain>
    {
        public void Configure(EntityTypeBuilder<EquipementSalleDeBain> builder)
        {
            // 1. Clé Primaire
            builder.HasKey(esdb => esdb.NumEquipementSalleDeBain).HasName("pk_equipementsalledebain");

            // 2. Contraintes et Propriétés
            builder.Property(esdb => esdb.Nom).HasMaxLength(1024);

            // 3. Relations
        }
    }
}
