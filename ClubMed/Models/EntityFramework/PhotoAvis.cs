using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_photo_avis_pav")]
    public class PhotoAvis
    {
        [Column("avi_numavis")]
        public int NumAvis { get; set; }

        [Column("pho_numphoto")]
        public int NumPhoto { get; set; }

        public virtual Avis Avis { get; set; } = null!;

        public virtual Photo Photo { get; set; } = null!;
    }
}
