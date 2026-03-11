using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_activitereservation_rea")]
    [PrimaryKey(nameof(ResaNum), nameof(ActiId))]
    public class ActiviteReservation
    {
        [Column("rea_numreservation")]
        public int ResaNum { get; set; }

        [Column("rea_idactivite")]
        public int ActiId { get; set; }

        [Column("rea_nbpersonnes")]
        [Required]
        public int ResaNbPersonnes { get; set; }

        [Column("rea_disponibiliteconfirmee")]
        [Required]
        public bool IsDispoConfirmee { get; set; } = false;

        [Column("rea_token")]
        [StringLength(255)]
        public string? ResaToken { get; set; }

        [Column("rea_dateenvoi")]
        public DateTime? ResaDateEnvoi { get; set; }
    }
}