using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_photo_pho")]
    public class Photo
    {

        [Key]
        [Column("pho_numphoto")]
        public int NumPhoto { get; set; }

        [Column("pho_url")]
        [StringLength(1024)]
        public string? Url { get; set; }
    }
}
