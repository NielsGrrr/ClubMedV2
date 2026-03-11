using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class CategorieTypeClubConfig : IEntityTypeConfiguration<CategorieTypeClub>
    {
        public void Configure(EntityTypeBuilder<CategorieTypeClub> builder)
        {
            builder.ToTable("t_e_categorietypeclub_ctc");

            builder.HasKey(ctc => new { ctc.NumCategory, ctc.NumType }).HasName("pk_categorie_typeclub");

            builder.Property(ctc => ctc.NumCategory)
                .HasColumnName("cat_numcategory");

            builder.Property(ctc => ctc.NumType)
                .HasColumnName("tcl_numtype");

            builder.HasOne(ctc => ctc.Categorie)
                .WithMany(c => c.CategorieTypeClubs)
                .HasForeignKey(ctc => ctc.NumCategory)
                .HasConstraintName("fk_categorie_typeclub_category");

            builder.HasOne(ctc => ctc.TypeClub)
                .WithMany(tc => tc.CategorieTypeClubs)
                .HasForeignKey(ctc => ctc.NumType)
                .HasConstraintName("fk_categorie_typeclub_typeclub");
        }
    }
}
