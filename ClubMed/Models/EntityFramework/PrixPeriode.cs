using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_prixperiode_prp")]
    public class PrixPeriode
    {
        [Column("per_num")]
        public string NumPeriode { get; set; } = null!;

        [Column("tch_id")]
        public int IdTypeChambre { get; set; }

        [Column("prp_prixperiode", TypeName = "numeric")]
        public decimal? Prix { get; set; }

        public virtual Periode Periode { get; set; } = null!;

        public virtual TypeChambre TypeChambreNav { get; set; } = null!;
    }
}
