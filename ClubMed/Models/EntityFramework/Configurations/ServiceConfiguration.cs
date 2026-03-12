using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class ServiceConfiguration : IEntityTypeConfiguration<Service>
    {
        public void Configure(EntityTypeBuilder<Service> builder)
        {
            // 1. Clé Primaire
            builder.HasKey(s => s.NumService).HasName("pk_service");

            // 2. Contraintes et Propriétés
            builder.Property(s => s.Nom).HasMaxLength(1024);

            // 3. Relations
        }
    }
}
