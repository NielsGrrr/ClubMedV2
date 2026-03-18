using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using Microsoft.EntityFrameworkCore;

namespace ClubMed.Models.DataManager
{
    public class ClubManager : IDataRepository<Club>
    {
        readonly ClubMedDbContext? clubMedDbContext;

        public ClubManager(ClubMedDbContext context)
        {
            clubMedDbContext = context;
        }

        public async Task AddAsync(Club entity)
        {
            await clubMedDbContext.Clubs.AddAsync(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(Club entity)
        {
            clubMedDbContext.Clubs.Remove(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task<IEnumerable<Club>> GetAllAsync()
        {
            return await clubMedDbContext.Clubs.ToListAsync();
        }

        public async Task<Club?> GetByIdAsync(int id)
        {
            return await clubMedDbContext.Clubs.FirstOrDefaultAsync(c => c.IdClub == id);
        }

        public Task<Club?> GetByStringAsync(string str)
        {
            throw new NotImplementedException();
        }

        public async Task UpdateAsync(Club entityToUpdate, Club entity)
        {
            clubMedDbContext.Entry(entityToUpdate).CurrentValues.SetValues(entity);
            await clubMedDbContext.SaveChangesAsync();
        }
    }
}
