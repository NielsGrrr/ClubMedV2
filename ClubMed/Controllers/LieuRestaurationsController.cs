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
    public class LieuRestaurationsController : ControllerBase
    {
        private readonly IDataRepository<LieuRestauration> dataRepository;

        public LieuRestaurationsController(IDataRepository<LieuRestauration> dataRepo)
        {
            dataRepository = dataRepo;
        }

        // GET: api/LieuRestaurations
        [HttpGet]
        public async Task<ActionResult<IEnumerable<LieuRestauration>>> GetLieuxRestauration()
        {
            return await dataRepository.GetAllAsync();
        }

        // GET: api/LieuRestaurations/5
        [HttpGet("{id}")]
        public async Task<ActionResult<LieuRestauration>> GetLieuRestauration(int id)
        {
            var lieuRestauration = await dataRepository.GetByIdAsync(id);

            if (lieuRestauration == null)
            {
                return NotFound();
            }

            return lieuRestauration;
        }

        // PUT: api/LieuRestaurations/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutLieuRestauration(int id, LieuRestauration lieuRestauration)
        {
            if (id != lieuRestauration.NumRestauration)
            {
                return BadRequest();
            }

            var lieuRestaurationToUpdate = await dataRepository.GetByIdAsync(id);

            if ( lieuRestaurationToUpdate == null)
            {
                return NotFound();
            }
            else
            {
                await dataRepository.UpdateAsync(lieuRestaurationToUpdate.Value, lieuRestauration);
                return NoContent();
            }

            
        }

        // POST: api/LieuRestaurations
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<LieuRestauration>> PostLieuRestauration(LieuRestauration lieuRestauration)
        {
            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
             await dataRepository.AddAsync(lieuRestauration);

            return CreatedAtAction("GetLieuRestauration", new { id = lieuRestauration.NumRestauration }, lieuRestauration);
        }

        // DELETE: api/LieuRestaurations/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteLieuRestauration(int id)
        {
            var lieuRestauration = await dataRepository.GetByIdAsync(id);
            if (lieuRestauration == null)
            {
                return NotFound();
            }

            await dataRepository.DeleteAsync(lieuRestauration.Value);
            

            return NoContent();
        }

    
    }
}
