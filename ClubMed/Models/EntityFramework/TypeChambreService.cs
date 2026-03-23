using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_typechambreservice_tcr")]
    public class TypeChambreService
    {
        [Column("numservice")]
        public int NumService { get; set; }

        [Column("idtypechambre")]
        public int IdTypeChambre { get; set; }

        public virtual Service ServiceNav { get; set; } = null!;

        public virtual TypeChambre TypeChambreNav { get; set; } = null!;
    }
}
