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
    public class ClubsController : ControllerBase
    {
        private readonly IDataRepository<Club> dataRepository;

        public ClubsController(IDataRepository<Club> dataRepo)
        {
            dataRepository = dataRepo;
        }

        // GET: api/Clubs
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Club>>> GetClubs()
        {
            var localisations = await dataRepository.GetAllAsync();
            return localisations.ToList();
        }

        // GET: api/Clubs/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Club>> GetClubById(int id)
        {
            var club = await dataRepository.GetByIdAsync(id);

            if (club == null)
            {
                return NotFound();
            }

            return club;
        }

        // PUT: api/Clubs/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutClub(int id, Club club)
        {
            if (id != club.IdClub)
            {
                return BadRequest();
            }

            var clubToUpdate = await dataRepository.GetByIdAsync(id);

            if (clubToUpdate == null)
            {
                return NotFound();
            }
            else
            {
                await dataRepository.UpdateAsync(clubToUpdate, club);
                return NoContent();
            }
        }

        // POST: api/Clubs
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Club>> PostClub(Club club)
        {
            var existant = await dataRepository.GetByIdAsync(club.IdClub);

            if (existant != null)
            {
                return Conflict("Cet élément existe déjà en base de données.");
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            await dataRepository.AddAsync(club);

            return CreatedAtAction("GetClubByID", new { id = club.IdClub }, club);
        }

        // DELETE: api/Clubs/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteClub(int id)
        {
            var club = await dataRepository.GetByIdAsync(id);
            if (club == null)
            {
                return NotFound();
            }

            await dataRepository.DeleteAsync(club);

            return NoContent();
        }
        /*
        private bool ClubExists(int id)
        {
            return _context.Clubs.Any(e => e.IdClub == id);
        }*/
    }
}
