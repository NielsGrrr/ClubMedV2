using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class IconConfiguration : IEntityTypeConfiguration<Icon>
    {
        public void Configure(EntityTypeBuilder<Icon> builder)
        {
            // 1. Clé Primaire
            builder.HasKey(i => i.NumIcon).HasName("pk_icon");

            // 2. Contraintes et Propriétés

            // 3. Relations
            builder.HasOne(i => i.PointFortNav)
                .WithMany()
                .HasForeignKey(i => i.NumPointFort)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_icon_pointfort");

            builder.HasOne(i => i.ServiceNav)
                .WithMany()
                .HasForeignKey(i => i.NumService)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_icon_service");

            builder.HasOne(i => i.EquipementSalleDeBainNav)
                .WithMany()
                .HasForeignKey(i => i.NumEquipementSalleDeBain)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_icon_equipementsalledebain");
        }
    }
}
