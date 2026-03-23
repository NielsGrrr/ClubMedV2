using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class AutreVoyageurConfig : IEntityTypeConfiguration<AutreVoyageur>
    {
        public void Configure(EntityTypeBuilder<AutreVoyageur> builder)
        {
            builder.ToTable("t_e_autrevoyageur_auv");

            builder.HasKey(a => a.AutreVoyageurId)
                   .HasName("pk_autrevoyageur");

            builder.Property(a => a.AutreVoyageurId)
                   .HasColumnName("auv_numvoyageur")
                   .ValueGeneratedOnAdd();

            builder.Property(a => a.AutreVoyageurNumResa)
                   .IsRequired()
                   .HasColumnName("auv_numreservation");

            builder.Property(a => a.AutreVoyageurGenre)
                   .HasMaxLength(1024)
                   .HasColumnName("auv_genre");

            builder.Property(a => a.AutreVoyageurPrenom)
                   .HasMaxLength(1024)
                   .HasColumnName("auv_prenom");

            builder.Property(a => a.AutreVoyageurNom)
                   .IsRequired()
                   .HasMaxLength(1024)
                   .HasColumnName("auv_nom");

            builder.Property(a => a.AutreVoyageurDateNaissance)
                   .IsRequired()
                   .HasColumnName("auv_datenaissance");

            builder.HasOne(a => a.Reservation)
                   .WithMany(r => r.AutresVoyageurs)
                   .HasForeignKey(a => a.AutreVoyageurNumResa)
                   .OnDelete(DeleteBehavior.Cascade)
                   .HasConstraintName("fk_autrevoyageur_reservation");
        }
    }
}
