using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class CategorieConfig : IEntityTypeConfiguration<Categorie>
    {
        public void Configure(EntityTypeBuilder<Categorie> builder)
        {
            builder.ToTable("t_e_categorie_cat");

            builder.HasKey(c => c.NumCategory)
                .HasName("pk_numcategory");

            builder.Property(c => c.NumCategory)
                .HasColumnName("numcategory");

            builder.Property(c => c.NomCategory)
                .HasColumnName("nomcategory")
                .HasMaxLength(100);
        }
    }
}
