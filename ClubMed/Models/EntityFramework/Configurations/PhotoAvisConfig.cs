using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class PhotoAvisConfig : IEntityTypeConfiguration<PhotoAvis>
    {
        public void Configure(EntityTypeBuilder<PhotoAvis> builder)
        {
            builder.ToTable("t_j_photo_avis_pav");

            builder.HasKey(pa => new { pa.NumAvis, pa.NumPhoto })
                .HasName("pk_avis_photo");

            builder.Property(pa => pa.NumAvis)
                .HasColumnName("avi_numavis");

            builder.Property(pa => pa.NumPhoto)
                .HasColumnName("pho_numphoto");

            builder.HasOne(pa => pa.Avis)
                .WithMany(a => a.PhotoAvis)
                .HasForeignKey(pa => pa.NumAvis)
                .OnDelete(DeleteBehavior.Cascade);

            builder.HasOne(pa => pa.Photo)
                .WithMany(p => p.PhotoAvis)
                .HasForeignKey(pa => pa.NumPhoto)
                .OnDelete(DeleteBehavior.Cascade);
        }
    }
}
