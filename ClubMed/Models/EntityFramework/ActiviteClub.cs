using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_clubactivite_cla")]
    [PrimaryKey(nameof(ClubId), nameof(ActiviteId))] // Définit la clé composée
    public class ClubActivite
    {
        [Column("cla_idclub")]
        [Required]
        public int ClubId { get; set; }

        [Column("cla_idactivite")]
        [Required]
        public int ActiviteId { get; set; }

        // Propriétés de navigation (Optionnel, si tu as les classes Club et Activite)
        /*
        [ForeignKey(nameof(ClubId))]
        public virtual Club Club { get; set; } = null!;

        [ForeignKey(nameof(ActiviteId))]
        public virtual Activite Activite { get; set; } = null!;
        */
    }
}