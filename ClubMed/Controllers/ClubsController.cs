using System;
using System.IO; // <-- AJOUTÉ ICI
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using ClubMed.Models.DataManager;

namespace ClubMed.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ClubsController : ControllerBase
    {
        private readonly IDataRepository<Club> dataRepository;
        private readonly IClubManager clubManager;

        public ClubsController(IDataRepository<Club> dataRepo, IClubManager clubMan)
        {
            dataRepository = dataRepo;
            this.clubManager = clubMan;
        }

        // GET: api/Clubs
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Club>>> GetClubs()
        {
            var localisations = await dataRepository.GetAllAsync();
            return localisations.ToList();
        }

        // GET: api/Clubs/5
        [HttpGet("id/{id}")]
        public async Task<ActionResult<Club>> GetClubById(int id)
        {
            var club = await dataRepository.GetByIdAsync(id);

            if (club == null)
            {
                return NotFound();
            }

            return club;
        }

        // GET: api/Clubs/5
        [HttpGet("localisation/{idlocalisation}")]
        public async Task<ActionResult<IEnumerable<Club>>> GetClubByLocalisation(int idlocalisation)
        {
            var clubs = await clubManager.GetByLocalisationAsync(idlocalisation);
            if (clubs == null || !clubs.Any())
                return NotFound($"Route OK mais aucun club pour le pays {idlocalisation}");

            return Ok(clubs);
        }

        // GET: api/Clubs/5
        [HttpGet("typechambre/{idtypechambre}")]
        public async Task<ActionResult<IEnumerable<Club>>> GetClubByTypeChambre(int idtypechambre)
        {
            var clubs = await clubManager.GetByTypeChambreAsync(idtypechambre);

            if (clubs == null)
            {
                return NotFound();
            }

            return Ok(clubs);
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

        // POST: api/Clubs/5/photos (HU 55 - Upload d'images) <-- AJOUTÉ ICI
        [HttpPost("{id}/photos")]
        public async Task<IActionResult> UploadPhotos(int id, [FromForm] List<IFormFile> photos)
        {
            var club = await dataRepository.GetByIdAsync(id);
            if (club == null) return NotFound("Le club n'existe pas.");

            if (photos == null || photos.Count == 0) return BadRequest("Aucune photo reçue.");

            var uploadPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "images", "ressort");
            if (!Directory.Exists(uploadPath)) Directory.CreateDirectory(uploadPath);

            foreach (var photo in photos)
            {
                var fileName = Guid.NewGuid().ToString() + Path.GetExtension(photo.FileName);
                var filePath = Path.Combine(uploadPath, fileName);

                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await photo.CopyToAsync(stream);
                }
            }
            return Ok(new { message = $"{photos.Count} photo(s) enregistrée(s) avec succès !" });
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
    //test
}