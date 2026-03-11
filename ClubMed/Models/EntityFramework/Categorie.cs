using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_categorie_cat")]
    public class Categorie
    {
        [Key]
        [Column("cat_numcategory")]
        public int NumCategory { get; set; }

        [Column("cat_nomcategory")]
        [StringLength(100)]
        public string? NomCategory { get; set; }

    }
}
