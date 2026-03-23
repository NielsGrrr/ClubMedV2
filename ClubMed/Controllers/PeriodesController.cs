using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;

namespace ClubMed.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PeriodesController : ControllerBase
    {
        private readonly IDataRepository<Periode> dataRepository;

        public PeriodesController(IDataRepository<Periode> dataRepo)
        {
            dataRepository = dataRepo;
        }

        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<IEnumerable<Periode>>> GetPeriodes()
        {
            var liste = await dataRepository.GetAllAsync();
            return Ok(liste);
        }

        [HttpGet("{id}")] // Plus de :int car c'est un string !
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<Periode>> GetPeriode(string id)
        {
            // On utilise GetByStringAsync pour la Période !
            var periode = await dataRepository.GetByStringAsync(id);
            if (periode == null) return NotFound();
            return Ok(periode);
        }

        [HttpPut("{id}")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> PutPeriode(string id, Periode periode)
        {
            if (id != periode.NumPeriode) return BadRequest();

            var existing = await dataRepository.GetByStringAsync(id);
            if (existing == null) return NotFound();

            await dataRepository.UpdateAsync(existing, periode);
            return NoContent();
        }

        [HttpPost]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status409Conflict)]
        public async Task<ActionResult<Periode>> PostPeriode(Periode periode)
        {
            // Vérification si la période existe déjà (car c'est nous qui choisissons l'ID string)
            var existing = await dataRepository.GetByStringAsync(periode.NumPeriode);
            if (existing != null) return Conflict("Cette période existe déjà.");

            await dataRepository.AddAsync(periode);
            return CreatedAtAction(nameof(GetPeriode), new { id = periode.NumPeriode }, periode);
        }

        [HttpDelete("{id}")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> DeletePeriode(string id)
        {
            var periode = await dataRepository.GetByStringAsync(id);
            if (periode == null) return NotFound();

            await dataRepository.DeleteAsync(periode);
            return NoContent();
        }
    }
}