using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace ClubMed.Models.EntityFramework
{
    [Table("t_j_clubactivite_cla")] 
    public class ClubActivite
    {
        [Column("cla_idclub")]
        public int ClubId { get; set; }

        [Column("cla_idactivite")]
        public int ActiviteId { get; set; }

        [JsonIgnore] public virtual Club? Club { get; set; }
        [JsonIgnore] public virtual Activite? Activite { get; set; }
    }
}