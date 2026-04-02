using Microsoft.AspNetCore.Mvc;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;

namespace ClubMed.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SousReservationActivitesController : ControllerBase
    {
        private readonly IDataRepository<SousReservationActivite> _dataRepository;

        public SousReservationActivitesController(IDataRepository<SousReservationActivite> dataRepository)
        {
            _dataRepository = dataRepository;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<SousReservationActivite>>> GetSousReservationActivites()
        {
            var activities = await _dataRepository.GetAllAsync();
            return activities.ToList();
        }

        [HttpPost]
        public async Task<ActionResult<SousReservationActivite>> PostSousReservationActivite(SousReservationActivite sra)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            await _dataRepository.AddAsync(sra);
            
            // Retourne l'objet créé (pas de GetById simple car clé composite, 
            // mais suffisant pour confirmer le succès au frontend)
            return CreatedAtAction(nameof(GetSousReservationActivites), sra);
        }

        [HttpDelete]
        public async Task<IActionResult> DeleteSousReservationActivite(int sousReservationId, int activiteId)
        {
            // Note: On pourrait ajouter une méthode DeleteByKeyAsync au Repository si besoin
            var all = await _dataRepository.GetAllAsync();
            var target = all.FirstOrDefault(x => x.SousReservationId == sousReservationId && x.ActiviteId == activiteId);
            
            if (target == null)
            {
                return NotFound();
            }

            await _dataRepository.DeleteAsync(target);
            return NoContent();
        }
    }
}
