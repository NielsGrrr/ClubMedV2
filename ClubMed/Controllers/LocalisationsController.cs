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
    public class LocalisationsController : ControllerBase
    {

        private readonly IDataRepository<Localisation> dataRepository;

        public LocalisationsController(IDataRepository<Localisation> dataRepo)
        {
            dataRepository = dataRepo;
        }

        // GET: api/Localisations
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Localisation>>> GetLocalisations()
        {
            var localisations = await dataRepository.GetAllAsync();
            return localisations.ToList();
        }

        // GET: api/Localisations/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Localisation>> GetLocalisationById(int id)
        {
            var localisation = await dataRepository.GetByIdAsync(id);

            if (localisation == null)
            {
                return NotFound();
            }

            return localisation;
        }

        // PUT: api/Localisations/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutLocalisation(int id, Localisation localisation)
        {
            if (id != localisation.NumLocalisation)
            {
                return BadRequest();
            }

            var localisationToUpdate = await dataRepository.GetByIdAsync(id);

            if (localisationToUpdate == null)
            {
                return NotFound();
            }
            else
            {
                await dataRepository.UpdateAsync(localisationToUpdate, localisation);
                return NoContent();
            }
        }

        // POST: api/Localisations
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Localisation>> PostLocalisation(Localisation localisation)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            await dataRepository.AddAsync(localisation);

            return CreatedAtAction("GetLocalisation", new { id = localisation.NumLocalisation }, localisation);
        }

        // DELETE: api/Localisations/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteLocalisation(int id)
        {
            var localisation = await dataRepository.GetByIdAsync(id);
            if (localisation == null)
            {
                return NotFound();
            }

            await dataRepository.DeleteAsync(localisation);

            return NoContent();
        }
    }
}
