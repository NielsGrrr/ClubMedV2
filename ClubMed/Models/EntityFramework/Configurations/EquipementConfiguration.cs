using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class EquipementConfiguration : IEntityTypeConfiguration<Equipement>
    {
        public void Configure(EntityTypeBuilder<Equipement> builder)
        {
            // 1. Clé Primaire
            builder.HasKey(e => e.NumEquipement).HasName("pk_equipement");

            // 2. Contraintes et Propriétés
            builder.Property(e => e.Nom).HasMaxLength(1024);

            // 3. Relations
            builder.HasOne(e => e.Icon)
                .WithMany(i => i.Equipements)
                .HasForeignKey(e => e.NumIcon)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_equipement_icon");
        }
    }
}
