using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_disponibilite_dis")]
    public class Disponibilite
    {
        [Column("dis_date")]
        [Required]
        public DateTime DispoDate { get; set; }

        [Column("dis_numchambre")]
        [Required]
        public int DispoNumChambre { get; set; }

        [Column("dis_idclub")]
        [Required]
        public int ClubId { get; set; }

        [Column("dis_estdisponibilite")]
        public bool? IsDisponible { get; set; }

        public virtual Calendrier Calendrier { get; set; } = null!;
    }
}