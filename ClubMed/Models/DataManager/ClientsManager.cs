using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ClubMed.Models.DataManager
{
    public class ClientManager : IDataRepository<Client>
    {
        private readonly ClubMedDbContext _context;

        public ClientManager(ClubMedDbContext context)
        {
            _context = context;
        }

        public async Task<ActionResult<IEnumerable<Client>>> GetAllAsync()
        {
            return await _context.Clients.ToListAsync();
        }

        public async Task<ActionResult<Client?>> GetByIdAsync(int id)
        {
            return await _context.Clients.FindAsync(id);
        }

        public async Task<ActionResult<Client?>> GetByStringAsync(string str)
        {
            return await _context.Clients.FirstOrDefaultAsync(c => c.Email == str);
        }

        public async Task AddAsync(Client entity)
        {
            await _context.Clients.AddAsync(entity);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(Client entityToUpdate, Client entity)
        {
            _context.Entry(entityToUpdate).CurrentValues.SetValues(entity);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(Client entity)
        {
            _context.Clients.Remove(entity);
            await _context.SaveChangesAsync();
        }
    }
}