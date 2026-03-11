using Microsoft.AspNetCore.Http.HttpResults;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_pointfort_ptf")]
    public partial class PointFort
    {
        [Key]
        [Column("ptf_numpointfort")]
        public int NumPointFort { get; set; }

        [Column("ptf_nom")]
        [StringLength(1024)]
        public string? Nom { get; set; }

        [InverseProperty(nameof(TypeChambrePointFort.PointFortNav))]
        public virtual ICollection<TypeChambrePointFort> TypeChambrePointForts { get; set; } = new List<TypeChambrePointFort>();

        [InverseProperty(nameof(Icon.PointFortNav))]
        public virtual ICollection<Icon> Icons { get; set; } = new List<Icon>();
    }
}
