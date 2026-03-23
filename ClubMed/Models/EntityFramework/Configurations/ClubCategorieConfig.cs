using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class ClubCategorieConfig : IEntityTypeConfiguration<ClubCategorie>
    {
        public void Configure(EntityTypeBuilder<ClubCategorie> builder)
        {
            builder.ToTable("t_j_clubcategorie_cca");

            builder.HasKey(cc => new { cc.IdClub, cc.NumCategory }).HasName("pk_club_categorie");

            builder.Property(cc => cc.IdClub)
                .HasColumnName("clu_idclub")
                .IsRequired();

            builder.Property(cc => cc.NumCategory)
                .HasColumnName("cat_numcategory")
                .IsRequired();

            builder.HasOne(cc => cc.Club)
                .WithMany(c => c.ClubCategories)
                .HasForeignKey(cc => cc.IdClub)
                .OnDelete(DeleteBehavior.Cascade);

            builder.HasOne(cc => cc.Categorie)
                .WithMany(c => c.ClubCategories)
                .HasForeignKey(cc => cc.NumCategory)
                .OnDelete(DeleteBehavior.Cascade);


        }
    }
}
