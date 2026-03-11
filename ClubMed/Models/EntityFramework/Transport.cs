using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_e_transport_tra")]
    public class Transport
    {
        [Key]
        [Column("tra_id")]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int TransportId { get; set; }

        [Column("tra_lieudepart")]
        [StringLength(1024)]
        [Required]
        public string? TransportLieuDepart { get; set; }

        [Column("tra_prix")]
        [Required]
        public decimal? TransportPrix { get; set; }
    }
}