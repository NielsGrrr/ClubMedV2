using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_sousreservationactivite_sra")]
    public class SousReservationActivite
    {
        [Column("sre_id")]
        public int SousReservationId { get; set; }

        [Column("act_id")]
        public int ActiviteId { get; set; }

        [JsonIgnore]
        public virtual SousReservation SousReservation { get; set; } = null!;

        [JsonIgnore]
        public virtual Activite Activite { get; set; } = null!;
    }
}