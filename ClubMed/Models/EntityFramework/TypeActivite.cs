using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_typeactivite_tya")]
    public class TypeActivite
    {
        [Key]
        [Column("tya_numtypeactivite")]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int TypeActiviteNum { get; set; }

        [Column("tya_numphoto")]
        [Required]
        public int TypeActiviteNumPhoto { get; set; }

        [Column("tya_description")]
        [Required]
        [StringLength(1024)]
        public string TypeActiviteDescription { get; set; } = null!;

        [Column("tya_nbactivitecarte")]
        [Required]
        public int TypeActiviteNbCarte { get; set; }

        [Column("tya_nbactiviteincluse")]
        [Required]
        public int TypeActiviteNbIncluse { get; set; }

        [Column("tya_titre")]
        [Required]
        [StringLength(1024)]
        public string? TypeActiviteTitre { get; set; }
    }
}