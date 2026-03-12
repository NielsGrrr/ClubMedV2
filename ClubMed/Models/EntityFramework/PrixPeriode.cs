using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    /* --  Table: prix_periode                   
CREATE TABLE prix_periode (
    numperiode character(10) NOT NULL,
    idtypechambre integer NOT NULL,
    prixperiode numeric
);*/
    [Table("t_j_prixperiode_prp")]
    public class PrixPeriode
    {
        [Key]
        [Column("per_num")]
        [StringLength(10)]
        public string NumPeriode { get; set; } = null!;

        [Key]
        [Column("tch_id")]
        public int IdTypeChambre { get; set; }

        [Column("prp_prixperiode", TypeName = "numeric")]
        public decimal? Prix { get; set; }

        [InverseProperty(nameof(Periode.PrixPeriodes))]
        public virtual Periode Periode { get; set; } = null!;

        [InverseProperty(nameof(TypeChambre.PrixPeriodes))]
        public virtual TypeChambre TypeChambreNav { get; set; } = null!;
    }
}
