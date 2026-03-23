using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class PaysRegionConfiguration : IEntityTypeConfiguration<PaysRegion>
    {
        public void Configure(EntityTypeBuilder<PaysRegion> builder)
        {
            // 1. Nom de la table
            builder.ToTable("t_j_paysregion_pyr");

            // 2. Clé primaire composée
            builder.HasKey(pr => new { pr.NumLocalisation, pr.NumPays }).HasName("pk_pays_region");

            // 3. Contraintes et propriétés
            builder.Property(pr => pr.NumLocalisation).HasColumnName("pyr_numlocalisation");
            builder.Property(pr => pr.NumPays).HasColumnName("pyr_numpays");

            // 4. Relations
            builder.HasOne(pr => pr.LocalisationAssociee)
                   .WithMany(l => l.PaysRegions)
                   .HasForeignKey(pr => pr.NumLocalisation)
                   .OnDelete(DeleteBehavior.Cascade) // Ou Restrict selon ta logique métier
                   .HasConstraintName("fk_pyr_loc");

            builder.HasOne(pr => pr.SousLocalisationAssociee)
                   .WithMany(s => s.PaysRegions)
                   .HasForeignKey(pr => pr.NumPays)
                   .OnDelete(DeleteBehavior.Cascade)
                   .HasConstraintName("fk_pyr_slc");
        }
    }
}