using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_calendrier_cal")]
    public class Calendrier
    {
        [Key]
        [Column("cal_date")]
        public DateTime CalDate { get; set; }

        [InverseProperty(nameof(Disponibilite.Calendrier))]
        public virtual ICollection<Disponibilite> Disponibilites { get; set; } = new List<Disponibilite>();
    }
}