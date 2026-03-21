using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_clubcategorie_cca")]
    public class ClubCategorie
    {
        [Required]
        [Column("clu_idclub")]
        public int IdClub { get; set; }

        [Required]
        [Column("cat_numcategory")]
        public int NumCategory { get; set; }

        public virtual Club Club { get; set; } = null!;

        public virtual Categorie Categorie { get; set; } = null!;

    }
}
