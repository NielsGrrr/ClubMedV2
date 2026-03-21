using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_activite_act")]
    public class Activite
    {
        [Key]
        [Column("act_id")]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ActiviteId { get; set; }

        [Column("act_titre")]
        [StringLength(1024)]
        public string? Titre { get; set; }

        [Column("act_description")]
        [Required]
        [StringLength(1024)]
        public string Description { get; set; } = null!;

        [Column("act_prixmin")]
        [Required]
        public decimal PrixMin { get; set; }

        [Column("act_idpartenaire")]
        public int? PartenaireId { get; set; }
    }
}
