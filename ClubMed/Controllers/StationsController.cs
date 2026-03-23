using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ClubMed.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StationsController : ControllerBase
    {
        private readonly IDataRepository<Station> dataRepository;

        public StationsController(IDataRepository<Station> context)
        {
            dataRepository = context;
        }

        // GET: api/Stations
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Station>>> GetStations()
        {
            var stations = await dataRepository.GetAllAsync();
            return stations.ToList();
        }

        // GET: api/Stations/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Station>> GetStationById(int id)
        {
            var station = await dataRepository.GetByIdAsync(id);

            if (station == null)
            {
                return NotFound();
            }

            return station;
        }

        [HttpGet]
        [Route("[action]/{name}")]
        [ActionName("GetByName")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<Station>> GetStationByName(string name)
        {
            var station = await dataRepository.GetByStringAsync(name);

            if (station == null)
            {
                return NotFound();
            }

            return station;
        }
        
        // PUT: api/Stations/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutStation(int id, Station station)
        {
            if (id != station.IdStation)
            {
                return BadRequest();
            }

            var stationToUpdate = await dataRepository.GetByIdAsync(id);

            if (stationToUpdate == null)
            {
                return NotFound();
            }
            else
            {
                await dataRepository.UpdateAsync(stationToUpdate, station);
                return NoContent();
            }
        }

        // POST: api/Stations
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Station>> PostStation(Station station)
        {
            var existant = await dataRepository.GetByIdAsync(station.IdStation);

            if (existant != null)
            {
                return Conflict("Cet élément existe déjà en base de données.");
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            await dataRepository.AddAsync(station);

            return CreatedAtAction("GetStationById", new { id = station.IdStation}, station);
        }

        // DELETE: api/Stations/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteStation(int id)
        {
            var station = await dataRepository.GetByIdAsync(id);
            if (station == null)
            {
                return NotFound();
            }

            await dataRepository.DeleteAsync(station);

            return NoContent();
        }
        /*
        private bool StationExists(int id)
        {
            return _context.Stations.Any(e => e.IdStation == id);
        }*/
    }
}
