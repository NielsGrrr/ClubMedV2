using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    /*-- Table: icon
CREATE TABLE icon (
    numicon integer NOT NULL,
    numpointfort integer NOT NULL,
    numservice integer NOT NULL,
    numequipementsallebain integer NOT NULL,
    lienicon character varying(1024)
);*/
    [Table("t_e_icon_ico")]
    public partial class Icon
    {
        [Key]
        [Column("ico_num")]
        public int NumIcon { get; set; }

        [Key]
        [Column("ptf_num")]
        public int NumPointFort { get; set; }

        [Key]
        [Column("srv_num")]
        public int NumService { get; set; }

        [Key]
        [Column("esb_num")]
        public int NumEquipementSalleDeBain { get; set; }

        [Column("ico_lien")]
        [StringLength(1024)]
        public string? LienIcon { get; set; }

    }
}
