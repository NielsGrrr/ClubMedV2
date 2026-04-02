using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class SousReservationConfig : IEntityTypeConfiguration<SousReservation>
    {
        public void Configure(EntityTypeBuilder<SousReservation> builder)
        {
            builder.ToTable("t_e_sousreservation_sre");
            builder.HasKey(sr => sr.SousReservationId).HasName("pk_sousreservation");
            builder.Property(sr => sr.SousReservationId).HasColumnName("sre_id").ValueGeneratedOnAdd();
            builder.Property(sr => sr.ResaNum).IsRequired().HasColumnName("res_numreservation");
            builder.Property(sr => sr.ClientNum).IsRequired().HasColumnName("cli_numclient");
            builder.Property(sr => sr.TransportId).IsRequired().HasColumnName("tra_idtransport");

            builder.HasOne(sr => sr.Reservation).WithMany().HasForeignKey(sr => sr.ResaNum).HasConstraintName("fk_sousresa_reservation");
            builder.HasOne(sr => sr.Client).WithMany().HasForeignKey(sr => sr.ClientNum).HasConstraintName("fk_sousresa_client");
            builder.HasOne(sr => sr.Transport).WithMany().HasForeignKey(sr => sr.TransportId).HasConstraintName("fk_sousresa_transport");
        }
    }
}