using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class SousLocalisationConfiguration : IEntityTypeConfiguration<SousLocalisation>
    {
        public void Configure(EntityTypeBuilder<SousLocalisation> builder)
        {
            // 1. Nom de la table
            builder.ToTable("t_r_souslocalisation_slc");

            // 2. Clé primaire
            builder.HasKey(s => s.NumPays).HasName("pk_souslocalisation");

            // 3. Contraintes et propriétés
            builder.Property(s => s.NumPays).HasColumnName("slc_numpays");

            builder.Property(s => s.NumPhoto)
                   .IsRequired()
                   .HasColumnName("slc_numphoto");

            builder.Property(s => s.NomPays)
                   .HasMaxLength(1024)
                   .HasColumnName("slc_nompays");

            // 4. Relations
            // Relation vers Photo à configurer ici ultérieurement :
            // builder.HasOne(s => s.PhotoAssociee)...
        }
    }
}