using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class ActiviteEnfantConfig : IEntityTypeConfiguration<ActiviteEnfant>
    {
        public void Configure(EntityTypeBuilder<ActiviteEnfant> builder)
        {
            builder.ToTable("t_e_activiteenfant_ace");

            builder.HasKey(a => a.ActiEnfantId)
                   .HasName("pk_activiteenfant");

            builder.Property(a => a.ActiEnfantId)
                   .HasColumnName("ace_id")
                   .ValueGeneratedOnAdd();

            builder.Property(a => a.ActiEnfantNumTranche)
                   .IsRequired()
                   .HasColumnName("ace_numtranche");

            builder.Property(a => a.ActiEnfantTitre)
                   .IsRequired()
                   .HasMaxLength(1024)
                   .HasColumnName("ace_titre");

            builder.Property(a => a.ActiEnfantDescription)
                   .IsRequired()
                   .HasMaxLength(1024)
                   .HasColumnName("ace_description");

            builder.Property(a => a.ActiEnfantPrixMin)
                   .IsRequired()
                   .HasColumnName("ace_prixmin")
                   .HasColumnType("decimal(18,2)");

            builder.Property(a => a.ActiEnfantDetail)
                   .IsRequired()
                   .HasMaxLength(1024)
                   .HasColumnName("ace_detail");

            builder.HasOne(a => a.TrancheAge)
                   .WithMany(t => t.ActivitesEnfants)
                   .HasForeignKey(a => a.ActiEnfantNumTranche)
                   .OnDelete(DeleteBehavior.Cascade)
                   .HasConstraintName("fk_activiteenfant_trancheage");
        }
    }
}
