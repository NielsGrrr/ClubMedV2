using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_typechambresdb_tcs")]
    public partial class TypeChambreSdb
    {
        [Key]
        [Column("esb_num")]
        public int NumEquipementSalleDeBain { get; set; }

        [Key]
        [Column("tch_id")]
        public int IdTypeChambre { get; set; }

        [InverseProperty(nameof(EquipementSalleDeBain.TypeChambreSdbs))]
        public virtual EquipementSalleDeBain EquipementSalleDeBainNav { get; set; } = null!;

        [InverseProperty(nameof(TypeChambre.TypeChambreSdbs))]
        public virtual TypeChambre TypeChambreNav { get; set; } = null!;
    }
}
