using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using static System.Collections.Specialized.BitVector32;

namespace ClubMed.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TypeChambresController : ControllerBase
    {
        private readonly IDataRepository<TypeChambre> dataRepository;

        public TypeChambresController(IDataRepository<TypeChambre> dataRepo)
        {
            dataRepository = dataRepo;
        }

        // GET: api/TypeChambres
        [HttpGet]
        public async Task<ActionResult<IEnumerable<TypeChambre>>> GetTypesChambres()
        {
            var typeChambres = await dataRepository.GetAllAsync();
            return typeChambres.ToList();
        }

        // GET: api/TypeChambres/5
        [HttpGet("{id}")]
        public async Task<ActionResult<TypeChambre>> GetTypeChambreById(int id)
        {
            var typeChambre = await dataRepository.GetByIdAsync(id);

            if (typeChambre == null)
            {
                return NotFound();
            }

            return typeChambre;
        }

        // PUT: api/TypeChambres/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutTypeChambre(int id, TypeChambre typeChambre)
        {
            if (id != typeChambre.IdTypeChambre)
            {
                return BadRequest();
            }

            var typeChambreToUpdate = await dataRepository.GetByIdAsync(id);

            if (typeChambreToUpdate == null)
            {
                return NotFound();
            }
            else
            {
                await dataRepository.UpdateAsync(typeChambreToUpdate, typeChambre);
                return NoContent();
            }
        }

        // POST: api/TypeChambres
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<TypeChambre>> PostTypeChambre(TypeChambre typeChambre)
        {
            var existant = await dataRepository.GetByIdAsync(typeChambre.IdTypeChambre);

            if (existant != null)
            {
                return Conflict("Cet élément existe déjà en base de données.");
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            await dataRepository.AddAsync(typeChambre);

            return CreatedAtAction("GetTypeChambreById", new { id = typeChambre.IdTypeChambre }, typeChambre);
        }

        // DELETE: api/TypeChambres/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTypeChambre(int id)
        {
            var typeChambre = await dataRepository.GetByIdAsync(id);
            if (typeChambre == null)
            {
                return NotFound();
            }

            await dataRepository.DeleteAsync(typeChambre);

            return NoContent();
        }
        /*
        private bool TypeChambreExists(int id)
        {
            return _context.TypesChambres.Any(e => e.IdTypeChambre == id);
        }*/
    }
}
