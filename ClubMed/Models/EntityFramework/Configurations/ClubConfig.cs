using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class ClubConfig : IEntityTypeConfiguration<Club>
    {
        public void Configure(EntityTypeBuilder<Club> builder)
        {
            builder.ToTable("t_e_club_clu");

            builder.HasKey(c => c.IdClub)
                .HasName("pk_club");

            builder.Property(c => c.IdClub)
                .HasColumnName("clu_id");

            builder.Property(c => c.NumPhoto)
                .IsRequired()
                .HasColumnName("clu_numphoto");

            builder.Property(c => c.Titre)
                .HasMaxLength(100)
                .HasColumnName("clu_titre");

            builder.Property(c => c.Description)
                .HasColumnType("text")
                .HasColumnName("clu_description");

            builder.Property(c => c.NoteMoyenne)
                .HasColumnType("numeric(3,2)")
                .HasColumnName("clu_notemoyenne");

            builder.Property(c => c.LienPdf)
                .HasMaxLength(1024)
                .HasColumnName("clu_lienpdf");

            builder.Property(c => c.NumPays)
                .HasColumnName("clu_numpays");

            builder.Property(c => c.Email)
                .HasMaxLength(255)
                .HasColumnName("clu_email");

            builder.Property(c => c.StatutMiseEnLigne)
                .HasMaxLength(50)
                .HasColumnName("clu_statut_mise_en_ligne")
                .HasDefaultValue("EN_CREATION");

            builder.HasOne(c => c.Pays)
                .WithMany(p => p.Clubs)
                .HasForeignKey(c => c.NumPays)
                .HasConstraintName("fk_club_pays");

            builder.HasMany(c => c.Avis)
                .WithOne(a => a.Club)
                .HasForeignKey(a => a.IdClub)
                .HasConstraintName("fk_avis_club");

            builder.HasMany(c => c.ClubStations)
                .WithOne(cs => cs.Club)
                .HasForeignKey(cs => cs.IdClub)
                .HasConstraintName("fk_clubstation_club");

            builder.HasMany(c => c.ClubCategories)
                .WithOne(cc => cc.Club)
                .HasForeignKey(cc => cc.IdClub)
                .HasConstraintName("fk_clubcategorie_club");

            builder.HasMany(c => c.PhotoClubs)
                .WithOne(pc => pc.Club)
                .HasForeignKey(pc => pc.IdClub)
                .HasConstraintName("fk_photoclub_club");

            builder.HasMany(c => c.ClubRestaurations)
                .WithOne(cr => cr.Club)
                .HasForeignKey(cr => cr.IdClub)
                .HasConstraintName("fk_clubrestauration_club");
        }
    }
}
