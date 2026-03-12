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

            builder.HasMany(c => c.ClubCategories)
                .WithOne(cc => cc.Categorie)
                .HasForeignKey(cc => cc.NumCategory)
                .HasConstraintName("fk_clubcategorie_numcategory");

            builder.HasMany(c => c.CategorieLocalisations)
                .WithOne(cl => cl.Categorie)
                .HasForeignKey(cl => cl.NumCategory)
                .HasConstraintName("fk_categorielocalisation_numcategory");

            builder.HasMany(c => c.CategorieTypeClubs)
                .WithOne(ctc => ctc.Categorie)
                .HasForeignKey(ctc => ctc.NumCategory)
                .HasConstraintName("fk_categorietypeclub_numcategory");
        }
    }
}
