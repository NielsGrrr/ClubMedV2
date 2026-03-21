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
    public class ServicesController : ControllerBase
    {
        private readonly IDataRepository<Service> dataRepository;

        public ServicesController(IDataRepository<Service> dataRepo)
        {
            dataRepository = dataRepo;
        }

        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<IEnumerable<Service>>> GetServices()
        {
            var liste = await dataRepository.GetAllAsync();
            return Ok(liste);
        }

        [HttpGet("{id:int}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<Service>> GetService(int id)
        {
            var service = await dataRepository.GetByIdAsync(id);
            if (service == null) return NotFound();
            return Ok(service);
        }

        [HttpPut("{id:int}")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> PutService(int id, Service service)
        {
            if (id != service.NumService) return BadRequest();

            var existing = await dataRepository.GetByIdAsync(id);
            if (existing == null) return NotFound();

            await dataRepository.UpdateAsync(existing, service);
            return NoContent();
        }

        [HttpPost]
        [ProducesResponseType(StatusCodes.Status201Created)]
        public async Task<ActionResult<Service>> PostService(Service service)
        {
            await dataRepository.AddAsync(service);
            return CreatedAtAction(nameof(GetService), new { id = service.NumService }, service);
        }

        [HttpDelete("{id:int}")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> DeleteService(int id)
        {
            var service = await dataRepository.GetByIdAsync(id);
            if (service == null) return NotFound();

            await dataRepository.DeleteAsync(service);
            return NoContent();
        }
    }
}