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
    public class AvisController : ControllerBase
    {
        private readonly IDataRepository<Avis> dataRepository;

        public AvisController(IDataRepository<Avis> dataRepo)
        {
            dataRepository = dataRepo;
        }

        // GET: api/Avis
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<IEnumerable<Avis>>> GetAvis()
        {
            var avis = await dataRepository.GetAllAsync();
            return avis.ToList();
        }

        // GET: api/Avis/5
        [HttpGet("{id:int}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<Avis>> GetAvis(int id)
        {
            var avis = await dataRepository.GetByIdAsync(id);

            if (avis == null || avis == null )
            {
                return NotFound();
            }

            return avis;
        }

        [HttpGet("{titre}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<Avis>> GetUtilisateurByEmail(string titre)
        {
            /* var utilisateur = await _context.Utilisateurs
                .FirstOrDefaultAsync(u => u.Mail == email); */
            var avis = await dataRepository.GetByStringAsync(titre);
            if (avis == null || avis == null)
            {
                return NotFound();
            }
            return avis;
        }

        // PUT: api/Avis/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        public async Task<IActionResult> PutAvis(int id, Avis avis)
        {
            if (id != avis.NumAvis)
            {
                return BadRequest();
            }

            var avisToUpdate = await dataRepository.GetByIdAsync(id);

            if (avisToUpdate == null)
            {
                return NotFound();
            }
            else
            {
                await dataRepository.UpdateAsync(avisToUpdate, avis);
                return NoContent();
            }

        }

        // POST: api/Avis
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<Avis>> PostAvis(Avis avis)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            await dataRepository.AddAsync(avis);

            return CreatedAtAction("GetAvis", new { id = avis.NumAvis }, avis);
        }

        // DELETE: api/Avis/5
        [HttpDelete("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        public async Task<IActionResult> DeleteAvis(int id)
        {
            var avis = await dataRepository.GetByIdAsync(id);
            if (avis == null)
            {
                return NotFound();
            }

            await dataRepository.DeleteAsync(avis);

            return NoContent();
        }

        /*private bool AvisExists(int id)
        {
            return _context.Avis.Any(e => e.NumAvis == id);
        }*/
    }
}
