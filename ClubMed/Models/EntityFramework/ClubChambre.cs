using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_clubchambre_cch")]
    public partial class ClubChambre
    {
        [Key]
        [Column("clu_id")]
        public int IdClub { get; set; }

        [Key]
        [Column("cha_num")]
        public int NumChambre { get; set; }

        [InverseProperty(nameof(Club.Chambre))]
        public virtual Club Club { get; set; } = null!;

        [InverseProperty(nameof(Chambre.Club))]
        public virtual Chambre Chambre { get; set; } = null!;

    }
}
