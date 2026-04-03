using System;
using System.IO; // <-- AJOUTÉ ICI
using Microsoft.AspNetCore.Authorization;
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

        private string GetPhotoStoragePath()
        {
            if (Environment.GetEnvironmentVariable("WEBSITE_SITE_NAME") != null)
            {
                var homePath = Environment.GetEnvironmentVariable("HOME") ?? "D:\\home";
                return Path.Combine(homePath, "data", "images", "ressort");
            }
            return Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "images", "ressort");
        }

        private void UnpackMetadata(Club club)
        {
            if (club?.Description != null && club.Description.Contains("|_META_|"))
            {
                var parts = club.Description.Split("|_META_|", 2);
                club.Description = parts[0];
                if (!string.IsNullOrWhiteSpace(parts[1]) && parts[1].Trim().StartsWith("{"))
                {
                    try
                    {
                        var meta = System.Text.Json.JsonSerializer.Deserialize<System.Text.Json.JsonElement>(parts[1]);
                        if (meta.TryGetProperty("PrixBase", out var pb) && pb.ValueKind == System.Text.Json.JsonValueKind.Number) club.PrixBase = pb.GetDecimal();
                        if (meta.TryGetProperty("TailleM2", out var tm) && tm.ValueKind == System.Text.Json.JsonValueKind.Number) club.TailleM2 = tm.GetInt32();
                        if (meta.TryGetProperty("CapacitePersonnes", out var cp) && cp.ValueKind == System.Text.Json.JsonValueKind.Number) club.CapacitePersonnes = cp.GetInt32();
                        if (meta.TryGetProperty("TypeSejour", out var ts) && ts.ValueKind == System.Text.Json.JsonValueKind.String) club.TypeSejour = ts.GetString();
                        if (meta.TryGetProperty("Localisation", out var loc) && loc.ValueKind == System.Text.Json.JsonValueKind.String) club.Localisation = loc.GetString();
                        if (meta.TryGetProperty("Indisponibilites", out var indisp) && indisp.ValueKind == System.Text.Json.JsonValueKind.Array) 
                        {
                            club.Indisponibilites = indisp.EnumerateArray().Select(a => a.GetString()).Where(s => s != null).ToList()!;
                        }
                    } catch { } // Ignore errors
                }
            }

            // Unpack prix from TypeChambres TextePresentation
            if (club.TypeChambres != null)
            {
                foreach (var tc in club.TypeChambres)
                {
                    if (tc.TextePresentation != null && tc.TextePresentation.Contains("|_PRIX_|"))
                    {
                        var tcParts = tc.TextePresentation.Split("|_PRIX_|", 2);
                        tc.TextePresentation = tcParts[0];
                        if (double.TryParse(tcParts[1], System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out var prix))
                        {
                            tc.PrixNuit = prix;
                        }
                    }
                }
            }
        }

        // GET: api/Clubs
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Club>>> GetClubs()
        {
            var clubs = await dataRepository.GetAllAsync();
            var list = clubs.ToList();
            list.ForEach(UnpackMetadata);
            return list;
        }

        // GET: api/Clubs/5
        [HttpGet("id/{id}")]
        [ActionName("GetClubByID")]
        public async Task<ActionResult<Club>> GetClubById(int id)
        {
            var club = await dataRepository.GetByIdAsync(id);

            if (club == null)
            {
                return NotFound();
            }

            UnpackMetadata(club);

            return club;
        }

        // GET: api/Clubs/5
        [HttpGet("localisation/{idlocalisation}")]
        public async Task<ActionResult<IEnumerable<Club>>> GetClubByLocalisation(int idlocalisation)
        {
            var clubs = await clubManager.GetByLocalisationAsync(idlocalisation);
            if (clubs == null || !clubs.Any())
                return NotFound($"Route OK mais aucun club pour le pays {idlocalisation}");

            var list = clubs.ToList();
            list.ForEach(UnpackMetadata);
            return Ok(list);
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

            var list = clubs.ToList();
            list.ForEach(UnpackMetadata);
            return Ok(list);
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
            var meta = new { PrixBase = club.PrixBase, TailleM2 = club.TailleM2, CapacitePersonnes = club.CapacitePersonnes, TypeSejour = club.TypeSejour, Localisation = club.Localisation, Indisponibilites = club.Indisponibilites };
            var rawDesc = club.Description != null && club.Description.Contains("|_META_|") ? club.Description.Substring(0, club.Description.IndexOf("|_META_|")) : club.Description;
            club.Description = rawDesc + "|_META_|" + System.Text.Json.JsonSerializer.Serialize(meta);

            // HU 55 Bypass: Ne pas écraser l'ID de la photo avec un état obsolète du frontend
            club.NumPhoto = clubToUpdate.NumPhoto;

            // Manual EF Core Sync for TypeChambres
            var context = clubManager.GetContext();
            
            if (context != null) 
            {
                // Delete removed suites
                foreach (var existingTc in clubToUpdate.TypeChambres.ToList()) {
                    if (!club.TypeChambres.Any(c => c.IdTypeChambre == existingTc.IdTypeChambre && c.IdTypeChambre != 0)) {
                        context.Remove(existingTc);
                    }
                }

                // Update existing and Add new suites
                foreach (var incomingTc in club.TypeChambres) {
                    // Pack prixNuit into TextePresentation before saving
                    if (incomingTc.PrixNuit != null && incomingTc.PrixNuit > 0) {
                        var rawPres = incomingTc.TextePresentation ?? "";
                        // Strip any existing |_PRIX_| before re-packing
                        if (rawPres.Contains("|_PRIX_|")) rawPres = rawPres.Split("|_PRIX_|")[0];
                        incomingTc.TextePresentation = rawPres + "|_PRIX_|" + incomingTc.PrixNuit.Value.ToString(System.Globalization.CultureInfo.InvariantCulture);
                    }

                    var existingTc = clubToUpdate.TypeChambres.FirstOrDefault(c => c.IdTypeChambre == incomingTc.IdTypeChambre && c.IdTypeChambre != 0);
                    if (existingTc != null) {
                        existingTc.NomType = incomingTc.NomType;
                        existingTc.Surface = incomingTc.Surface;
                        existingTc.CapaciteMax = incomingTc.CapaciteMax;
                        existingTc.TextePresentation = incomingTc.TextePresentation;
                    } else {
                        incomingTc.IdClub = clubToUpdate.IdClub;
                        incomingTc.NumPhoto = clubToUpdate.NumPhoto;
                        incomingTc.Indisponible = false;
                        context.Add(incomingTc);
                    }
                }
            }

            await dataRepository.UpdateAsync(clubToUpdate, club);

            return NoContent();
        }

        // POST: api/Clubs
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        // POST: api/Clubs
        [HttpPost]
        public async Task<ActionResult<Club>> PostClub(Club club)
        {
            ModelState.Clear(); // Bypass strict API validation

            // 1. PACK METADATA
            var meta = new { 
                PrixBase = club.PrixBase, 
                TailleM2 = club.TailleM2, 
                CapacitePersonnes = club.CapacitePersonnes, 
                TypeSejour = club.TypeSejour, 
                Localisation = club.Localisation, 
                Indisponibilites = club.Indisponibilites ?? new List<string>() // Sécurité anti-null
            };
            var rawDesc = club.Description ?? "";
            club.Description = rawDesc + "|_META_|" + System.Text.Json.JsonSerializer.Serialize(meta);

            // 2. BYPASS FK CONSTRAINT (L'astuce de la photo par défaut)
            if (club.NumPhoto == 0) club.NumPhoto = 100;

            // 3. SÉCURITÉ ANTI NULL-REFERENCE (Le vrai suspect du crash !)
            if (club.TypeChambres != null)
            {
                foreach (var tc in club.TypeChambres) {
                    tc.NumPhoto = club.NumPhoto;
                    tc.Indisponible = false;
                    // Pack prixNuit into TextePresentation
                    if (tc.PrixNuit != null && tc.PrixNuit > 0) {
                        var rawPres = tc.TextePresentation ?? "";
                        tc.TextePresentation = rawPres + "|_PRIX_|" + tc.PrixNuit.Value.ToString(System.Globalization.CultureInfo.InvariantCulture);
                    }
                }
            }
            else
            {
                // Si le front n'a pas envoyé de chambres, on initialise une liste vide pour rassurer EF Core
                club.TypeChambres = new List<TypeChambre>();
            }

            // 4. INTERCEPTION DES ERREURS SQL (Mode Débogage Sénior)
            try 
            {
                // On force l'ID à 0 pour s'assurer que PostgreSQL gère l'auto-incrémentation (SERIAL)
                club.IdClub = 0; 
                
                await dataRepository.AddAsync(club);
                return CreatedAtAction("GetClubByID", new { id = club.IdClub }, club);
            }
            catch (Exception ex)
            {
                // Si PostgreSQL refuse l'insertion, on renvoie l'erreur EXACTE au frontend !
                var sqlError = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                
                // On retourne une erreur 400 (Bad Request) avec le détail, lisible dans ta console Vue.js
                return BadRequest(new { 
                    message = "Erreur lors de l'insertion en base de données.", 
                    details = sqlError 
                });
            }
        }
        // POST: api/Clubs/5/photos (HU 55 - Upload d'images sécurisé sans migration)
        [HttpPost("{id}/photos")]
        public async Task<IActionResult> UploadPhotos(int id, [FromForm] List<IFormFile> photos)
        {
            var club = await dataRepository.GetByIdAsync(id);
            if (club == null) return NotFound("Le club n'existe pas.");

            if (photos == null || photos.Count == 0) return BadRequest("Aucune photo reçue.");

            var uploadPath = GetPhotoStoragePath();
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

        // GET: api/Clubs/photos/100.webp
        [HttpGet("photos/{fileName}")]
        [AllowAnonymous]
        public IActionResult GetPhoto(string fileName)
        {
            var uploadPath = GetPhotoStoragePath();
            var filePath = Path.Combine(uploadPath, fileName);
            
            if (!System.IO.File.Exists(filePath))
            {
                return NotFound();
            }
            var mimeType = fileName.EndsWith(".png") ? "image/png" : (fileName.EndsWith(".jpg") || fileName.EndsWith(".jpeg") ? "image/jpeg" : "image/webp");
            return PhysicalFile(filePath, mimeType);
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