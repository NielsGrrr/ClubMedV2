using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using Microsoft.EntityFrameworkCore;

namespace ClubMed.Models.DataManager
{
    public class SousReservationActivitesManager : IDataRepository<SousReservationActivite>
    {
        readonly ClubMedDbContext _clubMedDbContext;

        public SousReservationActivitesManager(ClubMedDbContext context)
        {
            _clubMedDbContext = context;
        }

        public async Task<IEnumerable<SousReservationActivite>> GetAllAsync()
        {
            return await _clubMedDbContext.SousReservationActivites
                .Include(sa => sa.SousReservation)
                .Include(sa => sa.Activite)
                .ToListAsync();
        }

        public async Task<SousReservationActivite?> GetByIdAsync(int id)
        {
            // Note: La clé est composite (sre_id, act_id), 
            // mais l'interface IDataRepository utilise un int unique.
            // On peut adapter ou lever une exception si non supporté par ID seul.
            return await _clubMedDbContext.SousReservationActivites.FindAsync(id);
        }

        public async Task AddAsync(SousReservationActivite entity)
        {
            await _clubMedDbContext.SousReservationActivites.AddAsync(entity);
            await _clubMedDbContext.SaveChangesAsync();
        }

        public async Task UpdateAsync(SousReservationActivite entityToUpdate, SousReservationActivite entity)
        {
            _clubMedDbContext.Entry(entityToUpdate).State = EntityState.Detached;
            _clubMedDbContext.SousReservationActivites.Update(entity);
            await _clubMedDbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(SousReservationActivite entity)
        {
            _clubMedDbContext.SousReservationActivites.Remove(entity);
            await _clubMedDbContext.SaveChangesAsync();
        }

        public Task<SousReservationActivite?> GetByStringAsync(string str)
        {
            throw new NotImplementedException();
        }
    }
}
