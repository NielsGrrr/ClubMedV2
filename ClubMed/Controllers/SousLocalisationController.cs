using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;

namespace ClubMed.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SousLocalisationsController : ControllerBase
    {
        private readonly IDataRepository<SousLocalisation> dataRepository;

        public SousLocalisationsController(IDataRepository<SousLocalisation> dataRepo)
        {
            dataRepository = dataRepo;
        }

        // GET: api/Localisations
        [HttpGet]
        public async Task<ActionResult<IEnumerable<SousLocalisation>>> GetSousLocalisations()
        {
            var sousLocalisations = await dataRepository.GetAllAsync();
            return sousLocalisations.ToList();
        }

        // GET: api/SousLocalisations/5
        [HttpGet("{id}")]
        public async Task<ActionResult<SousLocalisation>> GetSousLocalisationById(int id)
        {
            var sousLocalisation = await dataRepository.GetByIdAsync(id);
            if (sousLocalisation == null)
            {
                return NotFound();
            }

            return sousLocalisation;
        }

        // PUT: api/SousLocalisations/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutSousLocalisation(int id, SousLocalisation sousLocalisation)
        {
            if (id != sousLocalisation.NumPays)
            {
                return BadRequest();
            }

            var sousLocalisationToUpdate = await dataRepository.GetByIdAsync(id);

            if (sousLocalisationToUpdate == null)
            {
                return NotFound();
            }
            else
            {
            await dataRepository.UpdateAsync(sousLocalisationToUpdate, sousLocalisation);
            return NoContent();
            }
        }

        // POST: api/Localisations
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<SousLocalisation>> PostSousLocalisation(SousLocalisation sousLocalisation)
        {
            var existant = await dataRepository.GetByIdAsync(sousLocalisation.NumPays);

            if (existant != null)
            {
                return Conflict("Cet élément existe déjà en base de données.");
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            await dataRepository.AddAsync(sousLocalisation);

            return CreatedAtAction("GetSousLocalisationById", new { id = sousLocalisation.NumPays}, sousLocalisation);
        }

        // DELETE: api/SousLocalisations/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteSousLocalisation(int id)
        {
            var sousLocalisation = await dataRepository.GetByIdAsync(id);
            if (sousLocalisation == null)
            {
                return NotFound();
            }

            await dataRepository.DeleteAsync(sousLocalisation);

            return NoContent();
        }
        /*
        private bool SousLocalisationExists(int id)
        {
            return _context.SousLocalisations.Any(e => e.NumSousLocalisation == id);
        }*/
    }
}
