using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_typechambre_tch")]
    public partial class TypeChambre
    {
        [Key]
        [Column("tch_id")]
        public int IdTypeChambre { get; set; }

        [Column("pht_id")]
        public int NumPhoto { get; set; }

        [Column("tch_nom")]
        [StringLength(1024)]
        public string? NomType { get; set; }

        [Column("tch_surface")]
        public double? Surface { get; set; }

        [Column("tch_textepresentation")]
        [StringLength(1024)]
        public string? TextePresentation { get; set; }

        [Column("tch_capacitemax")]
        public int? CapaciteMax { get; set; }

        [Column("clu_id")]
        public int IdClub { get; set; }

        [Column("tch_indisponible")]
        public bool? Indisponible { get; set; } = false;

        public virtual Photo PhotoNav { get; set; } = null!;

        public virtual ICollection<Chambre> Chambres { get; set; } = new List<Chambre>();

        public virtual Club ClubNav { get; set; } = null!;

        public virtual ICollection<TypeChambreEquipement> TypeChambreEquipements { get; set; } = new List<TypeChambreEquipement>();

        public virtual ICollection<TypeChambreSdb> TypeChambreSdbs { get; set; } = new List<TypeChambreSdb>();

        public virtual ICollection<TypeChambreService> TypeChambreServices { get; set; } = new List<TypeChambreService>();

        public virtual ICollection<TypeChambrePointFort> TypeChambrePointForts { get; set; } = new List<TypeChambrePointFort>();

        public virtual ICollection<PrixPeriode> PrixPeriodes { get; set; } = new List<PrixPeriode>();
    }
}
