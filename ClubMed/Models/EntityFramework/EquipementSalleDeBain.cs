using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_equipementsalledebain_esb")]
    public partial class EquipementSalleDeBain
    {
        [Key]
        [Column("esb_num")]
        public int NumEquipementSalleDeBain { get; set; }

        [Column("esb_nom")]
        [StringLength(1024)]
        public string? Nom { get; set; }

        public virtual ICollection<TypeChambreSdb> TypeChambreSdbs { get; set; } = new List<TypeChambreSdb>();

        public virtual ICollection<Icon> Icons { get; set; } = new List<Icon>();
    }
}
