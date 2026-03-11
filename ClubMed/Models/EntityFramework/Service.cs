using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_service_srv")]
    public partial class Service
    {
        [Key]
        [Column("srv_num")]
        public int NumService { get; set; }

        [Column("srv_nom")]
        [StringLength(1024)]
        public string? Nom { get; set; }

        [InverseProperty(nameof(TypeChambreService.ServiceNav))]
        public virtual ICollection<TypeChambreService> TypeChambreServices { get; set; } = new List<TypeChambreService>();
    }
}
