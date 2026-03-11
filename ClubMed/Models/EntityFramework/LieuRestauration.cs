using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_lieurestauration_lre")]
    public class LieuRestauration
    {
        [Key]
        [Column("lre_numrestauration")]
        public int NumRestauration { get; set; }

        [Required]
        [Column("lre_numphoto")]
        public int NumPhoto { get; set; }

        [Column("lre_presentation", TypeName = "character varying(1024)")]
        public string? Presentation { get; set; }

        [Required]
        [Column("lre_nom", TypeName = "character varying(1024)")]
        public string Nom { get; set; } = null!;

        [Required]
        [Column("lre_description", TypeName = "character varying(1024)")]
        public string Description { get; set; } = null!;

        [Column("lre_estbar")]
        public bool? EstBar { get; set; }

        public virtual ICollection<ClubRestauration> ClubRestaurations { get; set; } = new List<ClubRestauration>();
    }
}
