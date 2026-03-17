using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;

namespace ClubMed.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReservationsController : ControllerBase
    {
        private readonly IDataRepository<Reservation> dataRepository;

        public ReservationsController(IDataRepository<Reservation> dataRepo)
        {
            dataRepository = dataRepo;
        }

        // GET: api/Reservations
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Reservation>>> GetReservations()
        {
            return await dataRepository.GetAllAsync();
        }

        // GET: api/Reservations/GetById
        [HttpGet]
        [Route("[action]/{id}")]
        [ActionName("GetById")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<Reservation>> GetById(int id)
        {
            var result = await dataRepository.GetByIdAsync(id);

            if (result.Value == null)
            {
                return NotFound();
            }

            return result;
        }

        // PUT: api/Reservations
        [HttpPut("{id}")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> PutReservation(int id, Reservation reservation)
        {
            if (id != reservation.ResaNum)
            {
                return BadRequest();
            }

            var result = await dataRepository.GetByIdAsync(id);

            if (result.Value == null)
            {
                return NotFound();
            }
            else
            {
                await dataRepository.UpdateAsync(result.Value, reservation);
                return NoContent();
            }
        }

        // POST: api/Reservations
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<Reservation>> PostReservation(Reservation reservation)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            await dataRepository.AddAsync(reservation);

            return CreatedAtAction("GetById", new { id = reservation.ResaNum }, reservation);
        }

        // DELETE: api/Reservations
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteReservation(int id)
        {
            var result = await dataRepository.GetByIdAsync(id);
            if (result.Value == null)
            {
                return NotFound();
            }

            await dataRepository.DeleteAsync(result.Value);

            return NoContent();
        }
    }
}