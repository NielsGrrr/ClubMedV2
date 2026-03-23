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

        public virtual PointFort PointFortNav { get; set; } = null!;

        public virtual Service ServiceNav { get; set; } = null!;

        public virtual EquipementSalleDeBain EquipementSalleDeBainNav { get; set; } = null!;

        public virtual ICollection<Equipement> Equipements { get; set; } = new List<Equipement>();
    }
}
