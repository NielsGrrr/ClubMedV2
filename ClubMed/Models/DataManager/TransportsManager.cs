using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ClubMed.Models.DataManager
{
    public class TransportManager : IDataRepository<Transport>
    {
        private readonly ClubMedDbContext _context;

        public TransportManager(ClubMedDbContext context)
        {
            _context = context;
        }

        public async Task<ActionResult<IEnumerable<Transport>>> GetAllAsync()
        {
            return await _context.Transports.ToListAsync();
        }

        public async Task<ActionResult<Transport?>> GetByIdAsync(int id)
        {
            return await _context.Transports.FindAsync(id);
        }

        public Task<ActionResult<Transport?>> GetByStringAsync(string str)
        {
            throw new NotImplementedException();
        }

        public async Task AddAsync(Transport entity)
        {
            await _context.Transports.AddAsync(entity);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(Transport entityToUpdate, Transport entity)
        {
            _context.Entry(entityToUpdate).CurrentValues.SetValues(entity);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(Transport entity)
        {
            _context.Transports.Remove(entity);
            await _context.SaveChangesAsync();
        }
    }
}