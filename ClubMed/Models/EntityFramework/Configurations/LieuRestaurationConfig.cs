using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class LieuRestaurationConfig : IEntityTypeConfiguration<LieuRestauration>
    {
        public void Configure(EntityTypeBuilder<LieuRestauration> builder)
        {
            builder.ToTable("t_e_lieurestauration_lre");

            builder.HasKey(e => e.NumRestauration)
                .HasName("PK_lre_numrestauration");

            builder.Property(e => e.NumRestauration)
                .HasColumnName("lre_numrestauration");

            builder.Property(e => e.NumPhoto)
                .IsRequired()
                .HasColumnName("lre_numphoto");

            builder.Property(e => e.Presentation)
                .HasColumnType("character varying(1024)")
                .HasColumnName("lre_presentation");

            builder.Property(e => e.Nom)
                .IsRequired()
                .HasColumnType("character varying(1024)")
                .HasColumnName("lre_nom");

            builder.Property(e => e.Description)
                .IsRequired()
                .HasColumnType("character varying(1024)")
                .HasColumnName("lre_description");

            builder.Property(e => e.EstBar)
                .HasColumnName("lre_estbar");

            builder.HasMany(e => e.ClubRestaurations)
                .WithOne(cr => cr.LieuRestauration)
                .HasForeignKey(cr => cr.NumRestauration)
                .HasConstraintName("FK_ClubRestauration_LieuRestauration");
        }
    }
}
