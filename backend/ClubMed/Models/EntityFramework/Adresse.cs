using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_adresse_adr")]
    public class Adresse
    {
        [Key]
        [Column("adr_numadresse")]
        public int NumAdresse { get; set; }

        [Required]
        [Column("adr_numrue")]
        public int NumRue { get; set; }

        [Required]
        [Column("adr_nomrue")]
        [StringLength(1024)]
        public string NomRue { get; set; } = null!;

        [Required]
        [Column("adr_codepostal", TypeName = "char(5)")]
        [StringLength(5)]
        public string CodePostal { get; set; } = null!;

        [Required]
        [Column("adr_ville")]
        [StringLength(1024)]
        public string Ville { get; set; } = null!;

        [Required]
        [Column("adr_pays")]
        [StringLength(1024)]
        public string Pays { get; set; } = null!;

        public virtual ICollection<Client> Clients { get; set; } = new List<Client>();
    }
}