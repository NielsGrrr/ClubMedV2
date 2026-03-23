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
    public class PhotosController : ControllerBase
    {
        private readonly IDataRepository<Photo> dataRepository;

        public PhotosController(IDataRepository<Photo> dataRepo)
        {
            dataRepository = dataRepo;
        }

        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<IEnumerable<Photo>>> GetPhotos()
        {
            var liste = await dataRepository.GetAllAsync();
            return Ok(liste);
        }

        [HttpGet("{id:int}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<Photo>> GetPhoto(int id)
        {
            var photo = await dataRepository.GetByIdAsync(id);
            if (photo == null) return NotFound();
            return Ok(photo);
        }

        [HttpPut("{id:int}")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> PutPhoto(int id, Photo photo)
        {
            if (id != photo.NumPhoto) return BadRequest();

            var existing = await dataRepository.GetByIdAsync(id);
            if (existing == null) return NotFound();

            await dataRepository.UpdateAsync(existing, photo);
            return NoContent();
        }

        [HttpPost]
        [ProducesResponseType(StatusCodes.Status201Created)]
        public async Task<ActionResult<Photo>> PostPhoto(Photo photo)
        {
            await dataRepository.AddAsync(photo);
            return CreatedAtAction(nameof(GetPhoto), new { id = photo.NumPhoto }, photo);
        }

        [HttpDelete("{id:int}")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> DeletePhoto(int id)
        {
            var photo = await dataRepository.GetByIdAsync(id);
            if (photo == null) return NotFound();

            await dataRepository.DeleteAsync(photo);
            return NoContent();
        }
    }
}