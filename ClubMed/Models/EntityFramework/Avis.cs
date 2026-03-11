using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_avis_avi")]
    public class Avis
    {
        [Key]
        [Column("avi_numavis")]
        public int NumAvis { get; set; }

        [Required]
        [Column("clu_idclub")]
        public int IdClub { get; set; }

        [Required]
        [Column("cli_numclient")]
        public int NumClient { get; set; }

        [Column("avi_titre")]
        [StringLength(100)]
        public string? Titre { get; set; }

        [Required]
        [Column("avi_commentaire", TypeName = "text")]
        public string Commentaire { get; set; } = null!;

        [Required]
        [Column("avi_note")]
        public int Note { get; set; }

        [Required]
        [Column("res_numreservation")]
        public int NumReservation { get; set; }

        [Column("avi_reponse", TypeName = "text")]
        public string? Reponse { get; set; }
        
        [ForeignKey("IdClub")]
        public virtual Club Club { get; set; } = null!;

        [ForeignKey("NumClient")]
        public virtual Client Client { get; set; } = null!;

        public virtual ICollection<PhotoAvis> PhotoAvis { get; set; } = new List<PhotoAvis>();

    }
}
