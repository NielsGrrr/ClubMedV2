using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class ActiviteAdulteConfig : IEntityTypeConfiguration<ActiviteAdulte>
    {
        public void Configure(EntityTypeBuilder<ActiviteAdulte> builder)
        {
            builder.ToTable("t_e_activiteadulte_aca");

            builder.HasKey(a => a.ActiAdulteId)
                   .HasName("pk_activiteadulte");

            builder.Property(a => a.ActiAdulteId)
                   .HasColumnName("aca_id")
                   .ValueGeneratedOnAdd();

            builder.Property(a => a.ActiAdulteNumType)
                   .IsRequired()
                   .HasColumnName("aca_numtypeactivite");

            builder.Property(a => a.ActiAdulteTitre)
                   .IsRequired()
                   .HasMaxLength(1024)
                   .HasColumnName("aca_titre");

            builder.Property(a => a.ActiAdulteDescription)
                   .IsRequired()
                   .HasMaxLength(1024)
                   .HasColumnName("aca_description");

            builder.Property(a => a.ActiAdultePrixMin)
                   .IsRequired()
                   .HasColumnName("aca_prixmin")
                   .HasColumnType("decimal(18,2)");

            builder.Property(a => a.ActiAdulteDuree)
                   .IsRequired()
                   .HasColumnName("aca_duree")
                   .HasColumnType("decimal(18,2)");

            builder.Property(a => a.ActiAdulteAgeMin)
                   .IsRequired()
                   .HasColumnName("aca_ageminimum");

            builder.Property(a => a.ActiAdulteFrequence)
                   .IsRequired()
                   .HasMaxLength(1024)
                   .HasColumnName("aca_frequence");

            builder.HasOne(a => a.TypeActivite)
                   .WithMany(t => t.ActivitesAdultes)
                   .HasForeignKey(a => a.ActiAdulteNumType)
                   .OnDelete(DeleteBehavior.Cascade)
                   .HasConstraintName("fk_activiteadulte_typeactivite");
        }
    }
}
