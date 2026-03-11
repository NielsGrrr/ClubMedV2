using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_typechambreequipement_tce")]
    public class TypeChambreEquipement
    {
        [Key]
        [Column("equ_numequipement")]
        public int NumEquipement { get; set; }

        [Key]
        [Column("tch_id")]
        public int IdTypeChambre { get; set; }

        [InverseProperty(nameof(Equipement.TypeChambreEquipements))]
        public virtual Equipement EquipementNav { get; set; } = null!;

        [InverseProperty(nameof(TypeChambre.TypeChambreEquipements))]
        public virtual TypeChambre TypeChambreNav { get; set; } = null!;
    }
}
