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
    public class TypeActivitesController : ControllerBase
    {
        private readonly IDataRepository<TypeActivite> dataRepository;

        public TypeActivitesController(IDataRepository<TypeActivite> dataRepo)
        {
            dataRepository = dataRepo;
        }

        // GET: api/TypeActivites
        [HttpGet]
        public async Task<ActionResult<IEnumerable<TypeActivite>>> GetTypesActivites()
        {
            var typeActiviteList = await dataRepository.GetAllAsync();
            return typeActiviteList.ToList();
        }

        // GET: api/TypeActivites/5
        [HttpGet("{id}")]
        public async Task<ActionResult<TypeActivite>> GetTypeActivite(int id)
        {
            var typeActivite = await dataRepository.GetByIdAsync(id);

            if (typeActivite == null)
            {
                return NotFound();
            }

            return typeActivite;
        }

        // PUT: api/TypeActivites/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutTypeActivite(int id, TypeActivite typeActivite)
        {
            if (id != typeActivite.TypeActiviteNum)
            {
                return BadRequest();
            }

            var typeActiviteToUpdate = await dataRepository.GetByIdAsync(id);

            if (typeActiviteToUpdate == null)
            {
                return NotFound();
            }
            else
            {
                await dataRepository.UpdateAsync(typeActiviteToUpdate, typeActivite);
                return NoContent();
            }
        }

        // POST: api/TypeActivites
        [HttpPost]
        public async Task<ActionResult<TypeActivite>> PostTypeActivite(TypeActivite typeActivite)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            await dataRepository.AddAsync(typeActivite);

            return CreatedAtAction("GetTypeActivite", new { id = typeActivite.TypeActiviteNum }, typeActivite);
        }

        // DELETE: api/TypeActivites/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTypeActivite(int id)
        {
            var typeActivite = await dataRepository.GetByIdAsync(id);
            if (typeActivite == null)
            {
                return NotFound();
            }

            await dataRepository.DeleteAsync(typeActivite);

            return NoContent();
        }
    }
}