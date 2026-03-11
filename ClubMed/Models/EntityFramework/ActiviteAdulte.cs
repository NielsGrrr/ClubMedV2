using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_activiteadulte_aca")]
    public class ActiviteAdulte
    {
        [Key]
        [Column("aca_id")]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ActiAdulteId { get; set; }

        [Column("aca_numtypeactivite")]
        [Required]
        public int ActiAdulteNumType { get; set; }

        [Column("aca_titre")]
        [Required]
        [StringLength(1024)]
        public string? ActiAdulteTitre { get; set; }

        [Column("aca_description")]
        [Required]
        [StringLength(1024)]
        public string ActiAdulteDescription { get; set; } = null!;

        [Column("aca_prixmin")]
        [Required]
        public decimal ActiAdultePrixMin { get; set; }

        [Column("aca_duree")]
        [Required]
        public decimal ActiAdulteDuree { get; set; }

        [Column("aca_ageminimum")]
        [Required]
        public int ActiAdulteAgeMin { get; set; }

        [Column("aca_frequence")]
        [Required]
        [StringLength(1024)]
        public string ActiAdulteFrequence { get; set; } = null!;
    }
}