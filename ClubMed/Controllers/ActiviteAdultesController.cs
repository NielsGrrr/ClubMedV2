using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;

namespace ClubMed.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ActiviteAdultesController : ControllerBase
    {
        private readonly IDataRepository<ActiviteAdulte> dataRepository;

        public ActiviteAdultesController(IDataRepository<ActiviteAdulte> dataRepo)
        {
            dataRepository = dataRepo;
        }

        // GET: api/ActiviteAdultes
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ActiviteAdulte>>> GetActivitesAdultes()
        {
            var list = await dataRepository.GetAllAsync();
            return list.ToList();
        }

        // GET: api/ActiviteAdultes/5
        [HttpGet("{id}")]
        public async Task<ActionResult<ActiviteAdulte>> GetActiviteAdulte(int id)
        {
            var activite = await dataRepository.GetByIdAsync(id);

            if (activite == null)
            {
                return NotFound();
            }

            return activite;
        }

        // PUT: api/ActiviteAdultes/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutActiviteAdulte(int id, ActiviteAdulte activite)
        {
            if (id != activite.ActiAdulteId)
            {
                return BadRequest();
            }

            var toUpdate = await dataRepository.GetByIdAsync(id);

            if (toUpdate == null)
            {
                return NotFound();
            }
            else
            {
                await dataRepository.UpdateAsync(toUpdate, activite);
                return NoContent();
            }
        }

        // POST: api/ActiviteAdultes
        [HttpPost]
        public async Task<ActionResult<ActiviteAdulte>> PostActiviteAdulte(ActiviteAdulte activite)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            await dataRepository.AddAsync(activite);

            return CreatedAtAction("GetActiviteAdulte", new { id = activite.ActiAdulteId }, activite);
        }

        // DELETE: api/ActiviteAdultes/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteActiviteAdulte(int id)
        {
            var activite = await dataRepository.GetByIdAsync(id);
            if (activite == null)
            {
                return NotFound();
            }

            await dataRepository.DeleteAsync(activite);

            return NoContent();
        }
    }
}
