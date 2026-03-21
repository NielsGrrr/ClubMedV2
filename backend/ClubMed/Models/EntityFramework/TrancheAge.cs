using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_trancheage_tra")]
    public class TrancheAge
    {
        [Key]
        [Column("tra_numtranche")]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int TrancheNum { get; set; }

        [Column("tra_agemin")]
        [Required]
        public int? TrancheAgeMin { get; set; }

        [Column("tra_agemax")]
        [Required]
        public int? TrancheAgeMax { get; set; }

        public virtual ICollection<ActiviteEnfant> ActivitesEnfants { get; set; } = new List<ActiviteEnfant>();
    }
}