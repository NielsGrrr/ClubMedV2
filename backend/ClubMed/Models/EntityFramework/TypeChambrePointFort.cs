using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_typechambrepointfort_tpf")]
    public partial class TypeChambrePointFort
    {
        [Column("numpointfort")]
        public int NumPointFort { get; set; }

        [Column("idtypechambre")]
        public int IdTypeChambre { get; set; }

        public virtual PointFort PointFortNav { get; set; } = null!;

        public virtual TypeChambre TypeChambreNav { get; set; } = null!;
    }
}
