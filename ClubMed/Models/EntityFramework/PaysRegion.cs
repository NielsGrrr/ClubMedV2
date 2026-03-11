using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_paysregion_pyr")]
    [PrimaryKey(nameof(NumLocalisation), nameof(NumPays))]
    public class PaysRegion
    {
        [Column("pyr_numlocalisation")]
        public int NumLocalisation { get; set; }

        [Column("pyr_numpays")]
        public int NumPays { get; set; }

        [ForeignKey(nameof(NumLocalisation))]
        [InverseProperty(nameof(Localisation.PaysRegions))]
        public virtual Localisation LocalisationAssociee { get; set; } = null!;

        [ForeignKey(nameof(NumPays))]
        [InverseProperty(nameof(SousLocalisation.PaysRegions))]
        public virtual SousLocalisation SousLocalisationAssociee { get; set; } = null!;
    }
}