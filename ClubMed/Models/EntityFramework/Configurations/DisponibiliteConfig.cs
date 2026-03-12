using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class DisponibiliteConfig : IEntityTypeConfiguration<Disponibilite>
    {
        public void Configure(EntityTypeBuilder<Disponibilite> builder)
        {
            builder.ToTable("t_e_disponibilite_dis");

            builder.HasKey(d => new { d.DispoDate, d.DispoNumChambre, d.ClubId })
                   .HasName("pk_disponibilite");

            builder.Property(d => d.DispoDate)
                   .IsRequired()
                   .HasColumnName("dis_date");

            builder.Property(d => d.DispoNumChambre)
                   .IsRequired()
                   .HasColumnName("dis_numchambre");

            builder.Property(d => d.ClubId)
                   .IsRequired()
                   .HasColumnName("dis_idclub");

            builder.Property(d => d.IsDisponible)
                   .HasColumnName("dis_estdisponibilite");

            builder.HasOne(d => d.Calendrier)
                   .WithMany(c => c.Disponibilites)
                   .HasForeignKey(d => d.DispoDate)
                   .OnDelete(DeleteBehavior.Cascade)
                   .HasConstraintName("fk_disponibilite_calendrier");
        }
    }
}
