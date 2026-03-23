using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_typechambreequipement_tce")]
    public class TypeChambreEquipement
    {
        [Column("equ_numequipement")]
        public int NumEquipement { get; set; }

        [Column("tch_id")]
        public int IdTypeChambre { get; set; }

        public virtual Equipement EquipementNav { get; set; } = null!;

        public virtual TypeChambre TypeChambreNav { get; set; } = null!;
    }
}
