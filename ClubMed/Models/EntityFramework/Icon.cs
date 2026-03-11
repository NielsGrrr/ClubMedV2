using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_icon_ico")]
    public partial class Icon
    {
        [Key]
        [Column("ico_num")]
        public int NumIcon { get; set; }

        [Column("ptf_num")]
        public int NumPointFort { get; set; }

        [Column("srv_num")]
        public int NumService { get; set; }

        [Column("esb_num")]
        public int NumEquipementSalleDeBain { get; set; }

        [Column("ico_lien")]
        [StringLength(1024)]
        public string? LienIcon { get; set; }

        [InverseProperty(nameof(PointFort.Icons))]
        public virtual PointFort PointFortNav { get; set; } = null!;

        [InverseProperty(nameof(Service.Icons))]
        public virtual Service ServiceNav { get; set; } = null!;

        [InverseProperty(nameof(EquipementSalleDeBain.Icons))]
        public virtual EquipementSalleDeBain EquipementSalleDeBainNav { get; set; } = null!;

        [InverseProperty(nameof(Equipement.Icon))]
        public virtual ICollection<Equipement> Equipements { get; set; } = new List<Equipement>();
    }
}
