using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ClubMed.Models.DataManager
{
    public class ReservationManager : IDataRepository<Reservation>
    {
        private readonly ClubMedDbContext _context;

        public ReservationManager(ClubMedDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Reservation>> GetAllAsync()
        {
           return await _context.Reservations.ToListAsync();
        }
        
        public async Task<Reservation?> GetByIdAsync(int id)
        {
            return await _context.Reservations.FindAsync(id);
        }

        public Task<Reservation?> GetByStringAsync(string str)
        { 
            throw new NotImplementedException(); 
        }

        public async Task AddAsync(Reservation entity)
        {
            await _context.Reservations.AddAsync(entity);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(Reservation entityToUpdate, Reservation entity)
        {
            _context.Entry(entityToUpdate).CurrentValues.SetValues(entity);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(Reservation entity)
        {
            _context.Reservations.Remove(entity);
            await _context.SaveChangesAsync();
        }
    }
}