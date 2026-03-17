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
    public class TransactionsController : ControllerBase
    {
        private readonly IDataRepository<Transaction> dataRepository;

        public TransactionsController(IDataRepository<Transaction> dataRepo)
        {
            dataRepository = dataRepo;
        }

        // GET: api/Transactions
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Transaction>>> GetTransactions()
        {
            return await dataRepository.GetAllAsync();
        }

        // GET: api/Transactions/GetById
        [HttpGet]
        [Route("[action]/{id}")]
        [ActionName("GetById")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<Transaction>> GetById(int id)
        {
            var result = await dataRepository.GetByIdAsync(id);

            if (result.Value == null)
            {
                return NotFound();
            }

            return result;
        }

        // PUT: api/Transactions
        [HttpPut("{id}")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> PutTransaction(int id, Transaction transaction)
        {
            if (id != transaction.TransactionId)
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
                await dataRepository.UpdateAsync(result.Value, transaction);
                return NoContent();
            }
        }

        // POST: api/Transactions
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<Transaction>> PostTransaction(Transaction transaction)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            await dataRepository.AddAsync(transaction);

            return CreatedAtAction("GetById", new { id = transaction.TransactionId }, transaction);
        }

        // DELETE: api/Transactions
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTransaction(int id)
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