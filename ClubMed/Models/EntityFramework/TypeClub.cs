using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_typeclub_tcl")]
    public class TypeClub
    {
        [Key]
        [Column("tcl_numtype")]
        public int NumType { get; set; }

        [Column("tcl_nomtype")]
        [StringLength(100)]
        public string? NomType { get; set; }

    }
}
