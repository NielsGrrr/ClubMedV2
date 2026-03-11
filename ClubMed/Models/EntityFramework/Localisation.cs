using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_r_localisation_loc")]
    public class Localisation
    {
        [Key]
        [Column("loc_numlocalisation")]
        public int NumLocalisation { get; set; }

        [Column("loc_nomlocalisation")]
        [StringLength(1024)]
        public string? NomLocalisation { get; set; }

        [InverseProperty(nameof(PaysRegion.LocalisationAssociee))]
        public virtual ICollection<PaysRegion> PaysRegions { get; set; } = new List<PaysRegion>();
    }
}