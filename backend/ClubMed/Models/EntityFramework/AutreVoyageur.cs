using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_autrevoyageur_auv")]
    public class AutreVoyageur
    {
        [Key]
        [Column("auv_numvoyageur")]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int AutreVoyageurId { get; set; }

        [Column("auv_numreservation")]
        [Required]
        public int AutreVoyageurNumResa { get; set; }

        [Column("auv_genre")]
        [StringLength(1024)]
        public string? AutreVoyageurGenre { get; set; }

        [Column("auv_prenom")]
        [StringLength(1024)]
        public string? AutreVoyageurPrenom { get; set; }

        [Column("auv_nom")]
        [Required]
        [StringLength(1024)]
        public string? AutreVoyageurNom { get; set; }

        [Column("auv_datenaissance")]
        [Required]
        public DateTime? AutreVoyageurDateNaissance { get; set; }

        public virtual Reservation Reservation { get; set; } = null!;
    }
}