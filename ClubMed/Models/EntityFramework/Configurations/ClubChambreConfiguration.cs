using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class ClubChambreConfiguration : IEntityTypeConfiguration<ClubChambre>
    {
        public void Configure(EntityTypeBuilder<ClubChambre> builder)
        {
            // 1. Clé Primaire
            builder.HasKey(cc => new { cc.IdClub, cc.NumChambre })
                .HasName("pk_club_chambre");

            // 2. Contraintes et Propriétés

            // 3. Relations
            builder.HasOne(cc => cc.Club)
                .WithMany(c => c.ClubChambres)
                .HasForeignKey(cc => cc.IdClub)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_club_chambre_club");

            builder.HasOne(cc => cc.Chambre)
                .WithMany(c => c.ClubChambres)
                .HasForeignKey(cc => cc.NumChambre)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_club_chambre_chambre");
        }
    }
}
