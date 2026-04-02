using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class SousReservationActiviteConfig : IEntityTypeConfiguration<SousReservationActivite>
    {
        public void Configure(EntityTypeBuilder<SousReservationActivite> builder)
        {
            builder.ToTable("t_j_sousreservationactivite_sra");
            builder.HasKey(sra => new { sra.SousReservationId, sra.ActiviteId }).HasName("pk_sousreservationactivite");

            builder.Property(sra => sra.SousReservationId).HasColumnName("sre_id");
            builder.Property(sra => sra.ActiviteId).HasColumnName("act_id");

            builder.HasOne(sra => sra.SousReservation)
                   .WithMany(sr => sr.SousReservationActivites)
                   .HasForeignKey(sra => sra.SousReservationId)
                   .HasConstraintName("fk_sra_sousresa");

            builder.HasOne(sra => sra.Activite)
                   .WithMany()
                   .HasForeignKey(sra => sra.ActiviteId)
                   .HasConstraintName("fk_sra_activite");
        }
    }
}