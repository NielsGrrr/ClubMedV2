using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;

namespace ClubMed.Models.DataManager
{
    public class ServiceManager : IDataRepository<Service>
    {
        readonly ClubMedDbContext clubMedDbContext;
        public ServiceManager(ClubMedDbContext context) { clubMedDbContext = context; }

        public async Task<IEnumerable<Service>> GetAllAsync()
        {
            return await clubMedDbContext.Services.ToListAsync();
        }
        public async Task<Service?> GetByIdAsync(int id)
        {
            return await clubMedDbContext.Services.FindAsync(id);
        }
        public async Task<Service?> GetByStringAsync(string str) => null;

        public async Task AddAsync(Service entity)
        {
            await clubMedDbContext.Services.AddAsync(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task UpdateAsync(Service entityToUpdate, Service entity)
        {
            clubMedDbContext.Entry(entityToUpdate).CurrentValues.SetValues(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(Service entity)
        {
            clubMedDbContext.Services.Remove(entity);
            await clubMedDbContext.SaveChangesAsync();
        }
    }
}