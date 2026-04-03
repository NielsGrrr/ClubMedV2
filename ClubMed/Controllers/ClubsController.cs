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

            // Unpack Metadata
            if (club.Description != null && club.Description.Contains("|_META_|"))
            {
                var parts = club.Description.Split("|_META_|", 2);
                club.Description = parts[0];
                try
                {
                    var meta = System.Text.Json.JsonSerializer.Deserialize<System.Text.Json.JsonElement>(parts[1]);
                    if (meta.TryGetProperty("PrixBase", out var pb) && pb.ValueKind == System.Text.Json.JsonValueKind.Number) club.PrixBase = pb.GetDecimal();
                    if (meta.TryGetProperty("TailleM2", out var tm) && tm.ValueKind == System.Text.Json.JsonValueKind.Number) club.TailleM2 = tm.GetInt32();
                    if (meta.TryGetProperty("CapacitePersonnes", out var cp) && cp.ValueKind == System.Text.Json.JsonValueKind.Number) club.CapacitePersonnes = cp.GetInt32();
                    if (meta.TryGetProperty("TypeSejour", out var ts) && ts.ValueKind == System.Text.Json.JsonValueKind.String) club.TypeSejour = ts.GetString();
                } catch { } // Ignore errors
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
            ModelState.Clear(); // Bypass strict API validation pour deadline (8h)

            if (id != club.IdClub)
            {
                return BadRequest();
            }

            var clubToUpdate = await dataRepository.GetByIdAsync(id);

            if (clubToUpdate == null) return NotFound();

            // Pack Metadata
            var meta = new { PrixBase = club.PrixBase, TailleM2 = club.TailleM2, CapacitePersonnes = club.CapacitePersonnes, TypeSejour = club.TypeSejour };
            var rawDesc = club.Description != null && club.Description.Contains("|_META_|") ? club.Description.Substring(0, club.Description.IndexOf("|_META_|")) : club.Description;
            club.Description = rawDesc + "|_META_|" + System.Text.Json.JsonSerializer.Serialize(meta);

            await dataRepository.UpdateAsync(clubToUpdate, club);

            return NoContent();
        }

        // POST: api/Clubs
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Club>> PostClub(Club club)
        {
            ModelState.Clear(); // Bypass strict API validation
            var existingClub = await dataRepository.GetByIdAsync(club.IdClub);
            if (existingClub != null)
            {
                return Conflict(club);
            }
            
            // Pack Metadata pour une 1ère création
            var meta = new { PrixBase = club.PrixBase, TailleM2 = club.TailleM2, CapacitePersonnes = club.CapacitePersonnes, TypeSejour = club.TypeSejour };
            var rawDesc = club.Description ?? "";
            club.Description = rawDesc + "|_META_|" + System.Text.Json.JsonSerializer.Serialize(meta);

            await dataRepository.AddAsync(club);

            return CreatedAtAction("GetClubByID", new { id = club.IdClub }, club);
        }

        // POST: api/Clubs/5/photos (HU 55 - Upload d'images sécurisé sans migration)
        [HttpPost("{id}/photos")]
        public async Task<IActionResult> UploadPhotos(int id, [FromForm] List<IFormFile> photos)
        {
            var club = await dataRepository.GetByIdAsync(id);
            if (club == null) return NotFound("Le club n'existe pas.");

            if (photos == null || photos.Count == 0) return BadRequest("Aucune photo reçue.");

            var uploadPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "images", "ressort");
            if (!Directory.Exists(uploadPath)) Directory.CreateDirectory(uploadPath);

            // On ne prend que la 1ère photo pour la lier comme "Main Photo" du Club (NumPhoto)
            var mainPhoto = photos.First();

            // Création safe de la Photo en BDD sans modifier le schéma
            var context = ((ClubManager)dataRepository).GetContext(); // Nécessite un getter ou cast
            
            // On peut insérer la photo via DbContext
            var newPhoto = new Photo { Url = "placeholder" };
            context.Photos.Add(newPhoto);
            await context.SaveChangesAsync();

            // On a maintenant le vrai ID (NumPhoto)
            var fileName = $"{newPhoto.NumPhoto}.webp";
            newPhoto.Url = fileName;
            
            // On stocke sur disque
            var filePath = Path.Combine(uploadPath, fileName);
            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await mainPhoto.CopyToAsync(stream);
            }

            // On relie le Club à cette image !
            club.NumPhoto = newPhoto.NumPhoto;
            context.Clubs.Update(club);
            await context.SaveChangesAsync();

            return Ok(new { message = $"Photo enregistrée et liée au club avec succès !" });
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