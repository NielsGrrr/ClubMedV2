using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_photo_club_pcl")]
    public class PhotoClub
    {
        [Column("clu_idclub")]
        public int IdClub { get; set; }

        [Column("pho_numphoto")]
        public int NumPhoto { get; set; }

        [Column("pcl_ordre")]
        public int? Ordre { get; set; }

        public virtual Club Club { get; set; } = null!;

        public virtual Photo Photo { get; set; } = null!;
    }
}
