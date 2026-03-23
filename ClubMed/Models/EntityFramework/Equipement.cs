using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_equipement_equ")]
    public partial class Equipement
    {
        [Key]
        [Column("equ_num")]
        public int NumEquipement { get; set; }

        [Column("icn_num")]
        public int NumIcon { get; set; }

        [Column("equ_nom")]
        [StringLength(1024)]
        public string? Nom { get; set; }

        public virtual ICollection<TypeChambreEquipement> TypeChambreEquipements { get; set; } = new List<TypeChambreEquipement>();

        public virtual Icon Icon { get; set; } = null!;
    }
}
