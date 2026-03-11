using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_transaction_trs")]
    public class Transaction
    {
        [Key]
        [Column("trs_id")]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int TransactionId { get; set; }

        [Column("trs_numreservation")]
        [Required]
        public int ResaNum { get; set; }

        [Column("trs_montant")]
        [Required]
        public decimal? TransactionMontant { get; set; }

        [Column("trs_datetransaction")]
        [Required]
        public DateTime? TransactionDate { get; set; } = DateTime.Now;

        [Column("trs_moyenpaiement")]
        [Required]
        [StringLength(50)]
        public string? TransactionMoyenPaiement { get; set; }

        [Column("trs_statutpaiement")]
        [Required]
        [StringLength(50)]
        public string? TransactionStatut { get; set; }

        [ForeignKey(nameof(ResaNum))]
        [InverseProperty(nameof(Models.EntityFramework.Reservation.Transactions))]
        public virtual Reservation Reservation { get; set; } = null!;
    }
}