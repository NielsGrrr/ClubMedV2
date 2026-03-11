using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_r_regroupement_rgr")]
    public class Regroupement
    {
        [Key]
        [Column("rgr_numregroupement")]
        public int NumRegroupement { get; set; }

        [Column("rgr_libelleregroupement")]
        [StringLength(1024)]
        public string? LibelleRegroupement { get; set; }

        [InverseProperty(nameof(ClubRegroupement.RegroupementAssocie))]
        public virtual ICollection<ClubRegroupement> ClubRegroupements { get; set; } = new List<ClubRegroupement>();
    }
}