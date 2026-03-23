using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_clubregroupement_crg")]
    public class ClubRegroupement
    {
        [Column("crg_idclub")]
        public int IdClub { get; set; }

        [Column("crg_numregroupement")]
        public int NumRegroupement { get; set; }

        public virtual Club ClubAssocie { get; set; } = null!;

        public virtual Regroupement RegroupementAssocie { get; set; } = null!;
    }
}