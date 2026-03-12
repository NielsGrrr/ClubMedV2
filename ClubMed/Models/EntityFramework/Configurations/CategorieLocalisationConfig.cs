using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class CategorieLocalisationConfig : IEntityTypeConfiguration<CategorieLocalisation>
    {
        public void Configure(EntityTypeBuilder<CategorieLocalisation> builder)
        {
            builder.ToTable("t_e_categorielocalisation_clo");

            builder.HasKey(cl => new { cl.NumCategory, cl.NumLocalisation }).HasName("pk_categorie_localisation");

            builder.Property(cl => cl.NumCategory)
                .HasColumnName("numcategory");

            builder.Property(cl => cl.NumLocalisation)
                .HasColumnName("numlocalisation");

            builder.HasOne(cl => cl.Categorie)
                .WithMany(c => c.CategorieLocalisations)
                .HasForeignKey(cl => cl.NumCategory)
                .HasConstraintName("fk_categorie_localisation_category");

            builder.HasOne(cl => cl.Localisation)
                // Ajouter à localisation
                .WithMany(l => l.CategorieLocalisations)
                .HasForeignKey(cl => cl.NumLocalisation)
                .HasConstraintName("fk_categorie_localisation_localisation");
        }
    }
}
