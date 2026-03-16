using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ClubMed.Models.EntityFramework;

namespace ClubMed.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LocalisationsController : ControllerBase
    {
        private readonly ClubMedDbContext _context;

        public LocalisationsController(ClubMedDbContext context)
        {
            _context = context;
        }

        // GET: api/Localisations
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Localisation>>> GetLocalisations()
        {
            return await _context.Localisations.ToListAsync();
        }

        // GET: api/Localisations/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Localisation>> GetLocalisation(int id)
        {
            var localisation = await _context.Localisations.FindAsync(id);

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

            _context.Entry(localisation).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!LocalisationExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Localisations
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Localisation>> PostLocalisation(Localisation localisation)
        {
            _context.Localisations.Add(localisation);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetLocalisation", new { id = localisation.NumLocalisation }, localisation);
        }

        // DELETE: api/Localisations/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteLocalisation(int id)
        {
            var localisation = await _context.Localisations.FindAsync(id);
            if (localisation == null)
            {
                return NotFound();
            }

            _context.Localisations.Remove(localisation);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool LocalisationExists(int id)
        {
            return _context.Localisations.Any(e => e.NumLocalisation == id);
        }
    }
}
