using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_clubregroupement_crg")]
    [PrimaryKey(nameof(IdClub), nameof(NumRegroupement))]
    public class ClubRegroupement
    {
        [Column("crg_idclub")]
        public int IdClub { get; set; }

        [Column("crg_numregroupement")]
        public int NumRegroupement { get; set; }

        [ForeignKey(nameof(NumRegroupement))]
        [InverseProperty(nameof(Regroupement.ClubRegroupements))]
        public virtual Regroupement RegroupementAssocie { get; set; } = null!;
    }
}