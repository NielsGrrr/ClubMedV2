using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_typechambrepointfort_tpf")]
    public partial class TypeChambrePointFort
    {
        [Key]
        [Column("numpointfort")]
        public int NumPointFort { get; set; }

        [Key]
        [Column("idtypechambre")]
        public int IdTypeChambre { get; set; }

        [InverseProperty(nameof(PointFort.TypeChambrePointForts))]
        public virtual PointFort PointFortNav { get; set; } = null!;

        [InverseProperty(nameof(TypeChambre.TypeChambrePointForts))]
        public virtual TypeChambre TypeChambreNav { get; set; } = null!;
    }
}
