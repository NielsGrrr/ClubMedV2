using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class PhotoClubConfig : IEntityTypeConfiguration<PhotoClub>
    {
        public void Configure(EntityTypeBuilder<PhotoClub> builder)
        {
            builder.ToTable("t_j_photo_club_pcl");

            builder.HasKey(e => new { e.IdClub, e.NumPhoto }).HasName("pk_club_photo");

            builder.Property(e => e.IdClub)
                .HasColumnName("clu_idclub");

            builder.Property(e => e.NumPhoto)
                .HasColumnName("pho_numphoto");

            builder.Property(e => e.Ordre)
                .HasColumnName("pcl_ordre");

            builder.HasOne(d => d.Club)
                .WithMany(p => p.PhotoClubs)
                .HasForeignKey(d => d.IdClub)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_club_photo_club");

            builder.HasOne(d => d.Photo)
                .WithMany(p => p.PhotoClubs)
                .HasForeignKey(d => d.NumPhoto)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_club_photo_photo");
        }
    }
}
