using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;

namespace ClubMed.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TransportsController : ControllerBase
    {
        private readonly IDataRepository<Transport> dataRepository;

        public TransportsController(IDataRepository<Transport> dataRepo)
        {
            dataRepository = dataRepo;
        }

        // GET: api/Transports
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Transport>>> GetTransports()
        {
            var transports = await dataRepository.GetAllAsync();
            return transports.ToList();
        }

        // GET: api/Transports/GetById/5
        [HttpGet]
        [Route("[action]/{id}")]
        [ActionName("GetById")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<Transport>> GetById(int id)
        {
            var transport = await dataRepository.GetByIdAsync(id);

            if (transport == null)
            {
                return NotFound();
            }

            return transport;
        }

        // PUT: api/Transports/5
        [HttpPut("{id}")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> PutTransport(int id, Transport transport)
        {
            if (id != transport.TransportId)
            {
                return BadRequest();
            }

            var transportToUpdate = await dataRepository.GetByIdAsync(id);

            if (transportToUpdate == null)
            {
                return NotFound();
            }
            else
            {
                await dataRepository.UpdateAsync(transportToUpdate, transport);
                return NoContent();
            }
        }

        // POST: api/Transports
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<Transport>> PostTransport(Transport transport)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            await dataRepository.AddAsync(transport);

            return CreatedAtAction("GetById", new { id = transport.TransportId }, transport);
        }

        // DELETE: api/Transports/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTransport(int id)
        {
            var transport = await dataRepository.GetByIdAsync(id);
            if (transport == null)
            {
                return NotFound();
            }

            await dataRepository.DeleteAsync(transport);

            return NoContent();
        }
    }
}