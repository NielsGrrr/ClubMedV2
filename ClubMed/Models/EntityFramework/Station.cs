using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_station_sta")]
    public class Station
    {

        [Key]
        [Column("sta_id")]
        public int IdStation { get; set; }

        [Required]
        [Column("sta_numphoto")]
        public int NumPhoto { get; set; }

        [Required]
        [Column("sta_nomstation")]
        [StringLength(1024)]
        public string NomStation { get; set; } = null!;

        [Required]
        [Column("sta_altitudestation", TypeName = "numeric(10,2)")]
        public decimal AltitudeStation { get; set; }

        [Required]
        [Column("sta_longueurpistes", TypeName = "numeric(10,2)")]
        public decimal LongueurPistes { get; set; }

        [Required]
        [Column("sta_nbpistes")]
        public int NbPistes { get; set; }

        [Required]
        [Column("sta_infoski", TypeName = "text")]
        public string InfoSki { get; set; } = null!;

        public virtual ICollection<ClubStation> ClubStations { get; set; } = new List<ClubStation>();
    }
}
