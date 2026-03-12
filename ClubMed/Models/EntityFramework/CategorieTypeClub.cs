using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_categorietypeclub_ctc")]
    public class CategorieTypeClub
    {
        [Column("cat_numcategory")]
        public int NumCategory { get; set; }
        [Column("tcl_numtype")]
        public int NumType { get; set; }

        [ForeignKey("NumCategory")]
        public virtual Categorie Categorie { get; set; } = null!;
        [ForeignKey("NumType")]
        public virtual TypeClub TypeClub { get; set; } = null!;
    }
}
