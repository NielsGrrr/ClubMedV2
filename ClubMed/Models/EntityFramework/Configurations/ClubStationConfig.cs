using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class ClubStationConfig : IEntityTypeConfiguration<ClubStation>
    {
        /*[Table("t_j_clubstation_clu")]
    public class ClubStation
    {
        // Clé composite : IdClub + IdStation

        [Column("clu_id")]
        public int IdClub { get; set; }

        [Column("sta_id")]
        public int IdStation { get; set; }

        [Column("clu_numphoto")]
        public int? NumPhoto { get; set; }

        [Column("clu_titre")]
        [StringLength(100)]
        public string? Titre { get; set; }

        [Required]
        [Column("clu_description", TypeName = "text")]
        public string Description { get; set; } = null!;

        [Required]
        [Column("clu_notemoyenne", TypeName = "numeric(3,2)")]
        public decimal NoteMoyenne { get; set; }

        [Required]
        [Column("clu_lienpdf")]
        [StringLength(1024)]
        public string LienPdf { get; set; } = null!;

        [Required]
        [Column("clu_altitudeclub", TypeName = "char(10)")]
        public string AltitudeClub { get; set; } = null!;

        [ForeignKey("IdClub")]
        public virtual Club Club { get; set; } = null!;

        [ForeignKey("IdStation")]
        public virtual Station Station { get; set; } = null!;

    }*/
        public void Configure(EntityTypeBuilder<ClubStation> builder)
        {
            builder.ToTable("t_j_clubstation_clu");

            builder.HasKey(cs => new { cs.IdClub, cs.IdStation }).HasName("pk_club_station");

            builder.Property(cs => cs.IdClub)
                .HasColumnName("clu_id");

            builder.Property(cs => cs.IdStation)
                .HasColumnName("sta_id");

            builder.Property(cs => cs.NumPhoto)
                .HasColumnName("clu_numphoto");

            builder.Property(cs => cs.Titre)
                .HasColumnName("clu_titre")
                .HasMaxLength(100);

            builder.Property(cs => cs.Description)
                .IsRequired()
                .HasColumnName("clu_description")
                .HasColumnType("text");

            builder.Property(cs => cs.NoteMoyenne)
                .IsRequired()
                .HasColumnName("clu_notemoyenne")
                .HasColumnType("numeric(3,2)");

            builder.Property(cs => cs.LienPdf)
                .IsRequired()
                .HasColumnName("clu_lienpdf")
                .HasMaxLength(1024);

            builder.Property(cs => cs.AltitudeClub)
                .IsRequired()
                .HasColumnName("clu_altitudeclub")
                .HasColumnType("char(10)");

            builder.HasOne(cs => cs.Club)
                .WithMany(c => c.ClubStations)
                .HasForeignKey(cs => cs.IdClub)
                .HasConstraintName("fk_clubstation_club");

            builder.HasOne(cs => cs.Station)
                .WithMany(s => s.ClubStations)
                .HasForeignKey(cs => cs.IdStation)
                .HasConstraintName("fk_clubstation_station");

        }
    }
}
