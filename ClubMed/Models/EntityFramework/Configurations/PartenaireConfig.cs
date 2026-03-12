using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class PartenaireConfig : IEntityTypeConfiguration<Partenaire>
    {
        public void Configure(EntityTypeBuilder<Partenaire> builder)
        {
            builder.ToTable("t_e_partenaire_par");

            builder.HasKey(p => p.PartenaireId)
                   .HasName("pk_partenaire");

            builder.Property(p => p.PartenaireId)
                   .HasColumnName("par_id")
                   .ValueGeneratedOnAdd();

            builder.Property(p => p.PartenaireNom)
                   .IsRequired()
                   .HasMaxLength(255)
                   .HasColumnName("par_nom");

            builder.Property(p => p.PartenaireEmail)
                   .HasMaxLength(255)
                   .HasColumnName("par_email");

            builder.Property(p => p.PartenaireTelephone)
                   .HasMaxLength(50)
                   .HasColumnName("par_telephone");
        }
    }
}
