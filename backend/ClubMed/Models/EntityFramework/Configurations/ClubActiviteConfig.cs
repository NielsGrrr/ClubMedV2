using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class ClubActiviteConfig : IEntityTypeConfiguration<ClubActivite>
    {
        public void Configure(EntityTypeBuilder<ClubActivite> builder)
        {
            builder.ToTable("t_j_clubactivite_cla");

            builder.HasKey(ca => new { ca.ClubId, ca.ActiviteId })
                   .HasName("pk_clubactivite");

            builder.Property(ca => ca.ClubId)
                   .HasColumnName("cla_idclub");

            builder.Property(ca => ca.ActiviteId)
                   .HasColumnName("cla_idactivite");
        }
    }
}
