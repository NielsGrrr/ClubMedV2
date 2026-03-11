using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_clubstation_clu")]
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

    }
}
