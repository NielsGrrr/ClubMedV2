using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class ReservationConfig : IEntityTypeConfiguration<Reservation>
    {
        public void Configure(EntityTypeBuilder<Reservation> builder)
        {
            builder.ToTable("t_e_reservation_res");

            builder.HasKey(r => r.ResaNum)
                   .HasName("pk_reservation");

            builder.Property(r => r.ResaNum)
                   .HasColumnName("res_numreservation")
                   .ValueGeneratedOnAdd();

            builder.Property(r => r.ClubId)
                   .IsRequired()
                   .HasColumnName("res_idclub");

            builder.Property(r => r.TransportId)
                   .IsRequired()
                   .HasColumnName("res_idtransport");

            builder.Property(r => r.ClientNum)
                   .IsRequired()
                   .HasColumnName("res_numclient");

            builder.Property(r => r.ResaDateDebut)
                   .HasColumnName("res_datedebut");

            builder.Property(r => r.ResaDateFin)
                   .HasColumnName("res_datefin");

            builder.Property(r => r.ResaNbPersonnes)
                   .HasColumnName("res_nbpersonnes");

            builder.Property(r => r.ResaLieuDepart)
                   .HasMaxLength(1024)
                   .HasColumnName("res_lieudepart");

            builder.Property(r => r.ResaPrix)
                   .HasColumnName("res_prix")
                   .HasColumnType("decimal(18,2)");

            builder.Property(r => r.ResaStatut)
                   .IsRequired()
                   .HasMaxLength(50)
                   .HasColumnName("res_statut")
                   .HasDefaultValue("EN_ATTENTE");

            builder.Property(r => r.ResaEtatCalcule)
                   .HasMaxLength(20)
                   .HasColumnName("res_etatcalcule");

            builder.Property(r => r.ResaMailEnvoye)
                   .HasColumnName("res_mail")
                   .HasDefaultValue(false);

            builder.Property(r => r.IsDispoConfirmee)
                   .HasColumnName("res_disponibiliteconfirmee")
                   .HasDefaultValue(false);

            builder.Property(r => r.IsMailConfirmeEnvoye)
                   .HasColumnName("res_mailconfirmationenvoye");

            builder.Property(r => r.IsDemandeAnnulation)
                   .HasColumnName("res_veutannuler")
                   .HasDefaultValue(false);

            builder.HasOne(r => r.Transport)
                   .WithMany(t => t.Reservations)
                   .HasForeignKey(r => r.TransportId)
                   .OnDelete(DeleteBehavior.Cascade)
                   .HasConstraintName("fk_reservation_transport");
        }
    }
}
