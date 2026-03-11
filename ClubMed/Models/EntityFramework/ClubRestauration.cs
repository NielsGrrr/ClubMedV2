using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_clubrestauration_cre")]
    public class ClubRestauration
    {
        /*-- Table: club_restauration
CREATE TABLE club_restauration (
    idclub integer NOT NULL,
    numrestauration integer NOT NULL
);*/
        [Column("clu_idclub")]
        public int IdClub { get; set; }

        [Column("lre_numrestauration")]
        public int NumRestauration { get; set; }

        [ForeignKey("cre_IdClub")]
        public virtual Club Club { get; set; } = null!;

        [ForeignKey("NumRestauration")]
        public virtual LieuRestauration LieuRestauration { get; set; } = null!;
    }
}
