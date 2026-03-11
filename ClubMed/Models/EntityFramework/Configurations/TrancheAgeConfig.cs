using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class TrancheAgeConfig : IEntityTypeConfiguration<TrancheAge>
    {
        public void Configure(EntityTypeBuilder<TrancheAge> builder)
        {
            builder.ToTable("t_e_trancheage_tra");

            builder.HasKey(t => t.TrancheNum)
                   .HasName("pk_trancheage");

            builder.Property(t => t.TrancheNum)
                   .HasColumnName("tra_numtranche")
                   .ValueGeneratedOnAdd();

            builder.Property(t => t.TrancheAgeMin)
                   .IsRequired()
                   .HasColumnName("tra_agemin");

            builder.Property(t => t.TrancheAgeMax)
                   .IsRequired()
                   .HasColumnName("tra_agemax");

            builder.HasMany(t => t.ActivitesEnfants)
                   .WithOne(a => a.TrancheAge)
                   .HasForeignKey(a => a.ActiEnfantNumTranche)
                   .OnDelete(DeleteBehavior.Cascade)
                   .HasConstraintName("fk_activiteenfant_trancheage");
        }
    }
}
