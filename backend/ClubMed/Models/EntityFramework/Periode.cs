using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_periode_per")]
    public partial class Periode
    {
        [Key]
        [Column("per_num")]
        [StringLength(10)]
        public string NumPeriode { get; set; } = null!;

        [Column("per_datedeb", TypeName = "date")]
        public DateTime? DateDeb { get; set; }

        [Column("per_datefin", TypeName = "date")]
        public DateTime? DateFin { get; set; }

        public virtual ICollection<PrixPeriode> PrixPeriodes { get; set; } = new List<PrixPeriode>();
    }
}
