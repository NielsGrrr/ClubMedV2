using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class PointFortConfiguration : IEntityTypeConfiguration<PointFort>
    {
        public void Configure(EntityTypeBuilder<PointFort> builder)
        {
            // 1. Clé Primaire
            builder.HasKey(pf => pf.NumPointFort).HasName("pk_pointfort");

            // 2. Contraintes et Propriétés
            builder.Property(pf => pf.Nom).HasMaxLength(1024);

            // 3. Relations
        }
    }
}
