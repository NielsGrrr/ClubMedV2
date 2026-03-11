using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class AvisConfig : IEntityTypeConfiguration<Avis>
    {
        public void Configure(EntityTypeBuilder<Avis> builder)
        {
            
            builder.ToTable("t_j_avis_avi");

            
            builder.HasKey(a => a.NumAvis).HasName("pk_avis");

            
            builder.Property(a => a.NumAvis)
                   .HasColumnName("avi_numavis");

            builder.Property(a => a.IdClub)
                   .HasColumnName("clu_idclub");

            builder.Property(a => a.NumClient)
                   .HasColumnName("cli_numclient");

            builder.Property(a => a.Titre)
                   .HasColumnName("avi_titre")
                   .HasMaxLength(100); 
            builder.Property(a => a.Commentaire)
                   .IsRequired()
                   .HasColumnName("avi_commentaire")
                   .HasColumnType("text");

            builder.Property(a => a.Note)
                   .HasColumnName("avi_note");

            builder.Property(a => a.Reponse)
                   .HasColumnName("avi_reponse")
                   .HasColumnType("text");

            builder.Property(a => a.NumReservation)
                   .HasColumnName("res_numreservation");

            
            builder.HasOne(a => a.Club)
                   .WithMany(c => c.Avis)
                   .HasForeignKey(a => a.IdClub)
                   .OnDelete(DeleteBehavior.Cascade)
                   .HasConstraintName("fk_avis_club");

            builder.HasOne(a => a.Client)
                   .WithMany(c => c.Avis)
                   .HasForeignKey(a => a.NumClient)
                   .OnDelete(DeleteBehavior.Cascade)
                   .HasConstraintName("fk_avis_client");

            builder.HasMany(a => a.PhotoAvis)
                    .WithOne(p => p.Avis)
                    .HasForeignKey(p => p.NumAvis)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("fk_photoavis_avis");

            
        }
    }
}
