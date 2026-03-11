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

        [Key]
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

        [Key]
        [Column("clu_id")]
        public int IdClub { get; set; }

        [Column("tch_indisponible")]
        public bool? Indisponible { get; set; } = false;

        [InverseProperty(nameof(Chambre.Type))]
        public virtual ICollection<Chambre> Chambres { get; set; } = new List<Chambre>();

        [InverseProperty(nameof(Club.TypeChambre))]
        public virtual ICollection<Club> Clubs { get; set; } = new List<Club>();

        [InverseProperty(nameof(TypeChambreEquipement.TypeChambreNav))]
        public virtual ICollection<TypeChambreEquipement> TypeChambreEquipements { get; set; } = new List<TypeChambreEquipement>();

        [InverseProperty(nameof(TypeChambreSdb.TypeChambreNav))]
        public virtual ICollection<TypeChambreSdb> TypeChambreSdbs { get; set; } = new List<TypeChambreSdb>();

        [InverseProperty(nameof(TypeChambreService.TypeChambreNav))]
        public virtual ICollection<TypeChambreService> TypeChambreServices { get; set; } = new List<TypeChambreService>();

        [InverseProperty(nameof(TypeChambrePointFort.TypeChambreNav))]
        public virtual ICollection<TypeChambrePointFort> TypeChambrePointForts { get; set; } = new List<TypeChambrePointFort>();
    }
}
