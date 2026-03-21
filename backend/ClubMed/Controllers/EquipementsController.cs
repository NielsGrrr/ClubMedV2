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
    public class EquipementsController : ControllerBase
    {
        private readonly IDataRepository<Equipement> dataRepository;

        public EquipementsController(IDataRepository<Equipement> dataRepo)
        {
            dataRepository = dataRepo;
        }

        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<IEnumerable<Equipement>>> GetEquipements()
        {
            var liste = await dataRepository.GetAllAsync();
            return Ok(liste);
        }

        [HttpGet("{id:int}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<Equipement>> GetEquipement(int id)
        {
            var equipement = await dataRepository.GetByIdAsync(id);
            if (equipement == null) return NotFound();
            return Ok(equipement);
        }

        [HttpPut("{id:int}")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> PutEquipement(int id, Equipement equipement)
        {
            if (id != equipement.NumEquipement) return BadRequest();

            var existing = await dataRepository.GetByIdAsync(id);
            if (existing == null) return NotFound();

            await dataRepository.UpdateAsync(existing, equipement);
            return NoContent();
        }

        [HttpPost]
        [ProducesResponseType(StatusCodes.Status201Created)]
        public async Task<ActionResult<Equipement>> PostEquipement(Equipement equipement)
        {
            await dataRepository.AddAsync(equipement);
            return CreatedAtAction(nameof(GetEquipement), new { id = equipement.NumEquipement }, equipement);
        }

        [HttpDelete("{id:int}")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> DeleteEquipement(int id)
        {
            var equipement = await dataRepository.GetByIdAsync(id);
            if (equipement == null) return NotFound();

            await dataRepository.DeleteAsync(equipement);
            return NoContent();
        }
    }
}