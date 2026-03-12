using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class ClubRegroupementConfiguration : IEntityTypeConfiguration<ClubRegroupement>
    {
        public void Configure(EntityTypeBuilder<ClubRegroupement> builder)
        {
            // 1. Nom de la table
            builder.ToTable("t_j_clubregroupement_crg");

            // 2. Clé primaire composée
            builder.HasKey(cr => new { cr.IdClub, cr.NumRegroupement }).HasName("pk_club_regroupement");

            // 3. Contraintes et propriétés
            builder.Property(cr => cr.IdClub).HasColumnName("crg_idclub");
            builder.Property(cr => cr.NumRegroupement).HasColumnName("crg_numregroupement");

            // 4. Relations
            builder.HasOne(cr => cr.RegroupementAssocie)
                   .WithMany(r => r.ClubRegroupements)
                   .HasForeignKey(cr => cr.NumRegroupement)
                   .OnDelete(DeleteBehavior.Cascade)
                   .HasConstraintName("fk_crg_rgr");

            builder.HasOne(cr => cr.ClubAssocie)
                   .WithMany(c => c.ClubRegroupements)
                   .HasForeignKey(cr => cr.IdClub)
                   .OnDelete(DeleteBehavior.Cascade)
                   .HasConstraintName("fk_crg_clb");
        }
    }
}