using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_categorielocalisation_clo")]
    public class CategorieLocalisation
    {
        [Column("numcategory")]
        public int NumCategory { get; set; }

        [Column("numlocalisation")]
        public int NumLocalisation { get; set; }

        public virtual Categorie Categorie { get; set; } = null!;

        public virtual Localisation Localisation { get; set; } = null!;

    }
}
