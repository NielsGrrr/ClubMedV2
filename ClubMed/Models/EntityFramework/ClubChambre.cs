using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_clubchambre_cch")]
    public partial class ClubChambre
    {
        [Column("clu_id")]
        public int IdClub { get; set; }

        [Column("cha_num")]
        public int NumChambre { get; set; }

        public virtual Club Club { get; set; } = null!;

        public virtual Chambre Chambre { get; set; } = null!;
    }
}
