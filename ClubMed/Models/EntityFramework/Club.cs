using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

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

        [ForeignKey("NumPays")]
        public virtual Pays? Pays { get; set; }
    }
}
