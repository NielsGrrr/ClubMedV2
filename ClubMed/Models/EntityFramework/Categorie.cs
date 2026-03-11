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

        public virtual ICollection<ClubCategorie> ClubCategories { get; set; } = new List<ClubCategorie>();

        public virtual ICollection<CategorieLocalisation> CategorieLocalisations { get; set; } = new List<CategorieLocalisation>();

        public virtual ICollection<CategorieTypeClub> CategorieTypeClubs { get; set; } = new List<CategorieTypeClub>();

    }
}
