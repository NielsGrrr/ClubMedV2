using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_chambre_cha")]
    public partial class Chambre
    {
        [Key]
        [Column("cha_num")]
        public int NumChambre { get; set; }

        [Column("tch_id")]
        public int IdTypeChambre { get; set; }

        public virtual TypeChambre Type { get; set; } = null!;

        public virtual ICollection<ClubChambre> ClubChambres { get; set; } = new List<ClubChambre>();
    }
}
