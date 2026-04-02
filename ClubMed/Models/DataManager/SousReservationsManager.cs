using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using Microsoft.EntityFrameworkCore;

namespace ClubMed.Models.DataManager
{
    public class SousReservationsManager : IDataRepository<SousReservation>
    {
        readonly ClubMedDbContext _clubMedDbContext;

        public SousReservationsManager(ClubMedDbContext context)
        {
            _clubMedDbContext = context;
        }

        public async Task<IEnumerable<SousReservation>> GetAllAsync()
        {
            return await _clubMedDbContext.Set<SousReservation>()
                .Include(s => s.SousReservationActivites)
                .ThenInclude(sa => sa.Activite)
                .Include(s => s.Transport)
                .ToListAsync();
        }

        public async Task<SousReservation?> GetByIdAsync(int id)
        {
            return await _clubMedDbContext.Set<SousReservation>()
                .Include(s => s.SousReservationActivites)
                .ThenInclude(sa => sa.Activite)
                .Include(s => s.Transport)
                .FirstOrDefaultAsync(s => s.SousReservationId == id);
        }

        public async Task AddAsync(SousReservation entity)
        {
            await _clubMedDbContext.Set<SousReservation>().AddAsync(entity);
            await _clubMedDbContext.SaveChangesAsync();
        }

        public async Task UpdateAsync(SousReservation entityToUpdate, SousReservation entity)
        {
            _clubMedDbContext.Entry(entityToUpdate).State = EntityState.Detached;
            _clubMedDbContext.Set<SousReservation>().Update(entity);
            await _clubMedDbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(SousReservation entity)
        {
            _clubMedDbContext.Set<SousReservation>().Remove(entity);
            await _clubMedDbContext.SaveChangesAsync();
        }

        public Task<SousReservation?> GetByStringAsync(string str)
        {
            throw new NotImplementedException();
        }
    }
}