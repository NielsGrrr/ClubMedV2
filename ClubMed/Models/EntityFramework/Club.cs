using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_club_clu")]
    public class Club
    {
        [Key]
        [Column("clu_id")]
        public int IdClub { get; set; }

        [Required]
        [Column("clu_numphoto")]
        public int NumPhoto { get; set; }

        [Column("clu_titre")]
        [StringLength(100)]
        public string? Titre { get; set; }

        [Column("clu_description", TypeName = "text")]
        public string? Description { get; set; }

        [Column("clu_notemoyenne", TypeName = "numeric(3,2)")]
        public decimal? NoteMoyenne { get; set; }

        [Column("clu_lienpdf")]
        [StringLength(1024)]
        public string? LienPdf { get; set; }

        [Column("clu_numpays")]
        public int? NumPays { get; set; }

        [Column("clu_email")]
        [EmailAddress]
        [StringLength(255)]
        public string? Email { get; set; }

        [Column("clu_statut_mise_en_ligne")]
        [StringLength(50)]
        public string? StatutMiseEnLigne { get; set; } = "EN_CREATION";

        [JsonIgnore]
        public virtual Photo? Photo { get; set; }

        public virtual SousLocalisation? SousLocalisation { get; set; }

        [NotMapped]
        public decimal? PrixBase { get; set; } 

        [NotMapped]
        public int? TailleM2 { get; set; }

        [NotMapped]
        public int? CapacitePersonnes { get; set; }

        [NotMapped]
        public string? TypeSejour { get; set; }

        public virtual ICollection<Avis> Avis { get; set; } = new List<Avis>();

        public virtual ICollection<ClubStation> ClubStations { get; set; } = new List<ClubStation>();

        public virtual ICollection<ClubCategorie> ClubCategories { get; set; } = new List<ClubCategorie>();

        public virtual ICollection<PhotoClub> PhotoClubs { get; set; } = new List<PhotoClub>();

        public virtual ICollection<ClubRestauration> ClubRestaurations { get; set; } = new List<ClubRestauration>();

        public virtual ICollection<ClubChambre> ClubChambres { get; set; } = new List<ClubChambre>();

        public virtual ICollection<TypeChambre> TypeChambres { get; set; } = new List<TypeChambre>();

        public virtual ICollection<ClubRegroupement> ClubRegroupements { get; set; } = new List<ClubRegroupement>();

        public virtual ICollection<ClubActivite> ClubActivites { get; set; } = new List<ClubActivite>();
    }
}
