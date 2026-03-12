using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_activiteenfant_ace")]
    public class ActiviteEnfant
    {
        [Key]
        [Column("ace_id")]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ActiEnfantId { get; set; }

        [Column("ace_numtranche")]
        [Required]
        public int ActiEnfantNumTranche { get; set; }

        [Column("ace_titre")]
        [Required]
        [StringLength(1024)]
        public string ActiEnfantTitre { get; set; } = null!;

        [Column("ace_description")]
        [Required]
        [StringLength(1024)]
        public string ActiEnfantDescription { get; set; } = null!;

        [Column("ace_prixmin")]
        [Required]
        public decimal ActiEnfantPrixMin { get; set; }

        [Column("ace_detail")]
        [Required]
        [StringLength(1024)]
        public string ActiEnfantDetail { get; set; } = null!;

        public virtual TrancheAge TrancheAge { get; set; } = null!;
    }
}