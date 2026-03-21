using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class RegroupementConfiguration : IEntityTypeConfiguration<Regroupement>
    {
        public void Configure(EntityTypeBuilder<Regroupement> builder)
        {
            // 1. Nom de la table
            builder.ToTable("t_r_regroupement_rgr");

            // 2. Clé primaire
            builder.HasKey(r => r.NumRegroupement).HasName("pk_regroupement");

            // 3. Contraintes et propriétés
            builder.Property(r => r.NumRegroupement).HasColumnName("rgr_numregroupement");

            builder.Property(r => r.LibelleRegroupement)
                   .HasMaxLength(1024)
                   .HasColumnName("rgr_libelleregroupement");

            // 4. Relations (gérées dans la table de jointure)
        }
    }
}