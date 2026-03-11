using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_typechambreservice_tcr")]
    public class TypeChambreService
    {
        [Key]
        [Column("numservice")]
        public int NumService { get; set; }

        [Key]
        [Column("idtypechambre")]
        public int IdTypeChambre { get; set; }

        [InverseProperty(nameof(Service.TypeChambreServices))]
        public virtual Service ServiceNav { get; set; } = null!;

        [InverseProperty(nameof(TypeChambre.TypeChambreServices))]
        public virtual TypeChambre TypeChambreNav { get; set; } = null!;
    }
}
