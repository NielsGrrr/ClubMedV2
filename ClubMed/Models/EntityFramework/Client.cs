using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_client_cli")]
    public class Client
    {
        [Key]
        [Column("cli_numclient")]
        public int NumClient { get; set; }

        [Column("cli_numadresse")]
        public int? NumAdresse { get; set; }

        [Column("cli_genre")]
        [StringLength(1024)]
        public string? Genre { get; set; }

        [Required]
        [Column("cli_prenom")]
        [StringLength(1024)]
        public string Prenom { get; set; } = null!;

        [Required]
        [Column("cli_nom")]
        [StringLength(1024)]
        public string Nom { get; set; } = null!;

        [Column("cli_datenaissance", TypeName = "date")]
        public DateTime? DateNaissance { get; set; }

        [Required]
        [Column("cli_email")]
        [EmailAddress(ErrorMessage = "Format d'email invalide.")]
        [StringLength(1024)]
        public string Email { get; set; } = null!;

        [Column("cli_telephone")]
        [StringLength(1024)]
        public string? Telephone { get; set; }

        [Required]
        [Column("cli_motdepasse_crypter")]
        [StringLength(1024)]
        public string MotDePasseCrypter { get; set; } = null!;

        [Column("cli_role")]
        [StringLength(20)]
        public string? Role { get; set; } = "client";

        [Column("cli_a2f_active")]
        public bool? A2fActive { get; set; } = false;

        [Column("cli_stripe_id")]
        [StringLength(255)]
        public string? StripeId { get; set; }

        [Column("cli_pm_type")]
        [StringLength(255)]
        public string? PmType { get; set; }

        [Column("cli_pm_last_four", TypeName = "char(4)")]
        [StringLength(4)]
        public string? PmLastFour { get; set; }

        [Column("cli_trial_ends_at")]
        public DateTime? TrialEndsAt { get; set; }

        public virtual Adresse? AdresseResidence { get; set; }

        public virtual ICollection<Avis> Avis { get; set; } = new List<Avis>();
    }
}