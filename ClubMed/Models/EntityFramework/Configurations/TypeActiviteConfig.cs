using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class TypeActiviteConfig : IEntityTypeConfiguration<TypeActivite>
    {
        public void Configure(EntityTypeBuilder<TypeActivite> builder)
        {
            builder.ToTable("t_e_typeactivite_tya");

            builder.HasKey(t => t.TypeActiviteNum)
                   .HasName("pk_typeactivite");

            builder.Property(t => t.TypeActiviteNum)
                   .HasColumnName("tya_numtypeactivite")
                   .ValueGeneratedOnAdd();

            builder.Property(t => t.TypeActiviteNumPhoto)
                   .IsRequired()
                   .HasColumnName("tya_numphoto");

            builder.Property(t => t.TypeActiviteDescription)
                   .IsRequired()
                   .HasMaxLength(1024)
                   .HasColumnName("tya_description");

            builder.Property(t => t.TypeActiviteNbCarte)
                   .IsRequired()
                   .HasColumnName("tya_nbactivitecarte");

            builder.Property(t => t.TypeActiviteNbIncluse)
                   .IsRequired()
                   .HasColumnName("tya_nbactiviteincluse");

            builder.Property(t => t.TypeActiviteTitre)
                   .IsRequired()
                   .HasMaxLength(1024)
                   .HasColumnName("tya_titre");
        }
    }
}
