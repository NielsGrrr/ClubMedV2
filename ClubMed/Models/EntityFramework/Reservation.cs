using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_reservation_res")]
    public class Reservation
    {
        [Key]
        [Column("res_numreservation")]
        public int ResaNum { get; set; }

        [Column("res_idclub")]
        [Required]
        public int ClubId { get; set; }

        [Column("res_idtransport")]
        [Required]
        public int TransportId { get; set; }

        [Column("res_numclient")]
        [Required]
        public int ClientNum { get; set; }

        [Column("res_datedebut")]
        public DateTime? ResaDateDebut { get; set; }

        [Column("res_datefin")]
        public DateTime? ResaDateFin { get; set; }

        [Column("res_nbpersonnes")]
        public int? ResaNbPersonnes { get; set; }

        [Column("res_lieudepart")]
        [StringLength(1024)]
        public string? ResaLieuDepart { get; set; }

        [Column("res_prix")]
        public decimal? ResaPrix { get; set; }

        [Column("res_statut")]
        [Required]
        [StringLength(50)]
        public string? ResaStatut { get; set; } = "EN_ATTENTE";

        [Column("res_etatcalcule")]
        [StringLength(20)]
        public string? ResaEtatCalcule { get; set; }

        [Column("res_mail")]
        public bool? ResaMailEnvoye { get; set; } = false;

        [Column("res_disponibiliteconfirmee")]
        public bool? IsDispoConfirmee { get; set; } = false;

        [Column("res_mailconfirmationenvoye")]
        public bool? IsMailConfirmeEnvoye { get; set; }

        [Column("res_veutannuler")]
        public bool? IsDemandeAnnulation { get; set; } = false;
    }
}