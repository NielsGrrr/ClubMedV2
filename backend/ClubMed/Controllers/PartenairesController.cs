using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;

namespace ClubMed.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PartenairesController : ControllerBase
    {
        private readonly IDataRepository<Partenaire> dataRepository;

        public PartenairesController(IDataRepository<Partenaire> dataRepo)
        {
            dataRepository = dataRepo;
        }

        // GET: api/Partenaires
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Partenaire>>> GetPartenaires()
        {
            var partenaireList = await dataRepository.GetAllAsync();
            return partenaireList.ToList();
        }

        // GET: api/Partenaires/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Partenaire>> GetPartenaire(int id)
        {
            var partenaire = await dataRepository.GetByIdAsync(id);

            if (partenaire == null)
            {
                return NotFound();
            }

            return partenaire;
        }

        // PUT: api/Partenaires/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutPartenaire(int id, Partenaire partenaire)
        {
            if (id != partenaire.PartenaireId)
            {
                return BadRequest();
            }

            var partenaireToUpdate = await dataRepository.GetByIdAsync(id);

            if (partenaireToUpdate == null)
            {
                return NotFound();
            }
            else
            {
                // Exactement comme ton modèle : on passe l'ancien et le nouveau
                await dataRepository.UpdateAsync(partenaireToUpdate, partenaire);
                return NoContent();
            }
        }

        // POST: api/Partenaires
        [HttpPost]
        public async Task<ActionResult<Partenaire>> PostPartenaire(Partenaire partenaire)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            await dataRepository.AddAsync(partenaire);

            return CreatedAtAction("GetPartenaire", new { id = partenaire.PartenaireId }, partenaire);
        }

        // DELETE: api/Partenaires/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePartenaire(int id)
        {
            var partenaire = await dataRepository.GetByIdAsync(id);
            if (partenaire == null)
            {
                return NotFound();
            }

            await dataRepository.DeleteAsync(partenaire);

            return NoContent();
        }
    }
}