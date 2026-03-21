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
        }
    }
}
