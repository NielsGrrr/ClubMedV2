using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_typechambresdb_tcs")]
    public partial class TypeChambreSdb
    {
        [Column("esb_num")]
        public int NumEquipementSalleDeBain { get; set; }

        [Column("tch_id")]
        public int IdTypeChambre { get; set; }

        public virtual EquipementSalleDeBain EquipementSalleDeBainNav { get; set; } = null!;

        public virtual TypeChambre TypeChambreNav { get; set; } = null!;
    }
}
