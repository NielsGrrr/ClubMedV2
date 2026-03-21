using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class LocalisationConfiguration : IEntityTypeConfiguration<Localisation>
    {
        public void Configure(EntityTypeBuilder<Localisation> builder)
        {
            // 1. Nom de la table
            builder.ToTable("t_r_localisation_loc");

            // 2. Clé primaire
            builder.HasKey(l => l.NumLocalisation).HasName("pk_localisation");

            // 3. Contraintes et propriétés
            builder.Property(l => l.NumLocalisation).HasColumnName("loc_numlocalisation");

            builder.Property(l => l.NomLocalisation)
                   .HasMaxLength(1024)
                   .HasColumnName("loc_nomlocalisation");

            // 4. Relations
            // Les relations Many-to-Many sont gérées dans la table de jointure
        }
    }
}