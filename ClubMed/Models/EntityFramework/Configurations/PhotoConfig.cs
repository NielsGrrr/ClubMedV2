using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class PhotoConfig : IEntityTypeConfiguration<Photo>
    {
        public void Configure(EntityTypeBuilder<Photo> builder)
        {
            builder.ToTable("t_e_photo_pho");

            builder.HasKey(p => p.NumPhoto)
                   .HasName("pho_numphoto");

            builder.Property(p => p.Url)
                .HasColumnName("pho_url")
                .HasMaxLength(1024);

            builder.HasMany(p => p.PhotoClubs)
                   .WithOne(pc => pc.Photo)
                   .HasForeignKey(pc => pc.NumPhoto)
                   .OnDelete(DeleteBehavior.Cascade);

            builder.HasMany(p => p.PhotoAvis)
                .WithOne(pa => pa.Photo)
                .HasForeignKey(pa => pa.NumPhoto)
                .OnDelete(DeleteBehavior.Cascade);
        }
    }
}
