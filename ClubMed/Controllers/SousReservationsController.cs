using Microsoft.AspNetCore.Mvc;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;

namespace ClubMed.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SousReservationsController : ControllerBase
    {
        private readonly IDataRepository<SousReservation> _dataRepository;

        public SousReservationsController(IDataRepository<SousReservation> dataRepository)
        {
            _dataRepository = dataRepository;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<SousReservation>>> GetSousReservations()
        {
            var sousReservations = await _dataRepository.GetAllAsync();
            // On retourne directement la liste (ce qui remplit result.Value pour les tests)
            return sousReservations.ToList();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<SousReservation>> GetSousReservation(int id)
        {
            var sousReservation = await _dataRepository.GetByIdAsync(id);
            if (sousReservation == null)
            {
                return NotFound();
            }
            // On retourne directement l'objet (ce qui remplit result.Value pour les tests)
            return sousReservation;
        }

        [HttpPost]
        public async Task<ActionResult<SousReservation>> PostSousReservation(SousReservation sousReservation)
        {
            // AJOUT : Vérification manuelle du ModelState pour que le Test Unitaire puisse l'intercepter
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            await _dataRepository.AddAsync(sousReservation);
            return CreatedAtAction("GetSousReservation", new { id = sousReservation.SousReservationId }, sousReservation);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutSousReservation(int id, SousReservation sousReservation)
        {
            if (id != sousReservation.SousReservationId)
            {
                return BadRequest();
            }

            var sousReservationToUpdate = await _dataRepository.GetByIdAsync(id);
            if (sousReservationToUpdate == null)
            {
                return NotFound();
            }

            await _dataRepository.UpdateAsync(sousReservationToUpdate, sousReservation);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteSousReservation(int id)
        {
            var sousReservation = await _dataRepository.GetByIdAsync(id);
            if (sousReservation == null)
            {
                return NotFound();
            }

            await _dataRepository.DeleteAsync(sousReservation);
            return NoContent();
        }
    }
}