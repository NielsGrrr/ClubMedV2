using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class ActiviteConfig : IEntityTypeConfiguration<Activite>
    {
        public void Configure(EntityTypeBuilder<Activite> builder)
        {
            builder.ToTable("t_e_activite_act");

            builder.HasKey(a => a.ActiviteId)
                   .HasName("pk_activite");

            builder.Property(a => a.ActiviteId)
                   .HasColumnName("act_id")
                   .ValueGeneratedOnAdd();

            builder.Property(a => a.Titre)
                   .HasMaxLength(1024)
                   .HasColumnName("act_titre");

            builder.Property(a => a.Description)
                   .IsRequired()
                   .HasMaxLength(1024)
                   .HasColumnName("act_description");

            builder.Property(a => a.PrixMin)
                   .IsRequired()
                   .HasColumnName("act_prixmin")
                   .HasColumnType("decimal(18,2)");

            builder.Property(a => a.PartenaireId)
                   .HasColumnName("act_idpartenaire");
        }
    }
}
