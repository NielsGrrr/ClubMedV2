using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_paysregion_pyr")]
    public class PaysRegion
    {
        [Column("pyr_numlocalisation")]
        public int NumLocalisation { get; set; }

        [Column("pyr_numpays")]
        public int NumPays { get; set; }

        public virtual Localisation LocalisationAssociee { get; set; } = null!;

        public virtual SousLocalisation SousLocalisationAssociee { get; set; } = null!;

        public virtual ICollection<Club> Clubs { get; set; } = new List<Club>();
    }
}