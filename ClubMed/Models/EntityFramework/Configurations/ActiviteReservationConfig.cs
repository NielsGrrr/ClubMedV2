using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class ActiviteReservationConfig : IEntityTypeConfiguration<ActiviteReservation>
    {
        public void Configure(EntityTypeBuilder<ActiviteReservation> builder)
        {
            builder.ToTable("t_j_activitereservation_rea");

            builder.HasKey(ar => new { ar.ResaNum, ar.ActiId })
                   .HasName("pk_activitereservation");

            builder.Property(ar => ar.ResaNum)
                   .HasColumnName("rea_numreservation");

            builder.Property(ar => ar.ActiId)
                   .HasColumnName("rea_idactivite");

            builder.Property(ar => ar.ResaNbPersonnes)
                   .IsRequired()
                   .HasColumnName("rea_nbpersonnes");

            builder.Property(ar => ar.IsDispoConfirmee)
                   .IsRequired()
                   .HasColumnName("rea_disponibiliteconfirmee")
                   .HasDefaultValue(false);

            builder.Property(ar => ar.ResaToken)
                   .HasMaxLength(255)
                   .HasColumnName("rea_token");

            builder.Property(ar => ar.ResaDateEnvoi)
                   .HasColumnName("rea_dateenvoi");

            builder.HasOne(ar => ar.Reservation)
                   .WithMany(r => r.ActivitesReservations)
                   .HasForeignKey(ar => ar.ResaNum)
                   .OnDelete(DeleteBehavior.Cascade)
                   .HasConstraintName("fk_activitereservation_reservation");
        }
    }
}
