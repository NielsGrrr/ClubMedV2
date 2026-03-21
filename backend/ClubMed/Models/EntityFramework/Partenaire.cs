using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_partenaire_par")]
    public class Partenaire
    {
        [Key]
        [Column("par_id")]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int PartenaireId { get; set; }

        [Column("par_nom")]
        [Required]
        [StringLength(255)]
        public string PartenaireNom { get; set; } = null!;

        [Column("par_email")]
        [StringLength(255)]
        [EmailAddress]
        public string? PartenaireEmail { get; set; }

        [Column("par_telephone")]
        [StringLength(50)]
        [Phone]
        public string? PartenaireTelephone { get; set; }
    }
}