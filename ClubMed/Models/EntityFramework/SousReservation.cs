using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_sousreservation_sre")]
    public class SousReservation
    {
        [Key]
        [Column("sre_id")]
        public int SousReservationId { get; set; }

        [Required]
        [Column("res_numreservation")]
        public int ResaNum { get; set; }

        [Required]
        [Column("cli_numclient")]
        public int ClientNum { get; set; }

        [Required]
        [Column("tra_idtransport")]
        public int TransportId { get; set; }

        [Column("sre_nom")]
        [StringLength(100)]
        public string? SousReservationNom { get; set; }

        [Column("sre_prenom")]
        [StringLength(100)]
        public string? SousReservationPrenom { get; set; }

        [Column("sre_datenaissance")]
        public DateTime? SousReservationDateNaissance { get; set; }

        [Column("sre_type")]
        [StringLength(20)]
        public string? SousReservationType { get; set; }

        [JsonIgnore]
        public virtual Reservation? Reservation { get; set; } = null!;

        [JsonIgnore]
        public virtual Client? Client { get; set; } = null!;

        [JsonIgnore]
        public virtual Transport? Transport { get; set; } = null!;

        public virtual ICollection<SousReservationActivite> SousReservationActivites { get; set; } = new List<SousReservationActivite>();
    }
}