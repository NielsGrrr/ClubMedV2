using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_r_souslocalisation_slc")]
    public class SousLocalisation
    {
        [Key]
        [Column("slc_numpays")]
        public int NumPays { get; set; }

        [Required]
        [Column("slc_numphoto")]
        public int NumPhoto { get; set; }

        [Column("slc_nompays")]
        [StringLength(1024)]
        public string? NomPays { get; set; }

        [InverseProperty(nameof(PaysRegion.SousLocalisationAssociee))]
        public virtual ICollection<PaysRegion> PaysRegions { get; set; } = new List<PaysRegion>();
    }
}