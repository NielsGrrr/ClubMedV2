using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class ClubRestaurationConfig : IEntityTypeConfiguration<ClubRestauration>
    {
        public void Configure(EntityTypeBuilder<ClubRestauration> builder)
        {
            builder.ToTable("t_j_clubrestauration_cre");

            builder.HasKey(cr => new { cr.IdClub, cr.NumRestauration }).HasName("pk_club_lieurestuaration");

            builder.Property(cr => cr.IdClub)
                .HasColumnName("clu_idclub");

            builder.Property(cr => cr.NumRestauration)
                .HasColumnName("lre_numrestauration");

            builder.HasOne(cr => cr.Club)
                .WithMany(c => c.ClubRestaurations)
                .HasForeignKey(cr => cr.IdClub)
                .HasConstraintName("fk_clubrestauration_club");

            builder.HasOne(cr => cr.LieuRestauration)
                .WithMany(lr => lr.ClubRestaurations)
                .HasForeignKey(cr => cr.NumRestauration)
                .HasConstraintName("fk_clubrestauration_lieurestauration");
        }
    }
}
