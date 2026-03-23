using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;

namespace ClubMed.Models.DataManager
{
    public class PhotoManager : IDataRepository<Photo>
    {
        readonly ClubMedDbContext clubMedDbContext;
        public PhotoManager(ClubMedDbContext context) { clubMedDbContext = context; }

        public async Task<IEnumerable<Photo>> GetAllAsync()
        {
            return await clubMedDbContext.Photos.ToListAsync();
        }
        public async Task<Photo?> GetByIdAsync(int id)
        {
            return await clubMedDbContext.Photos.FindAsync(id);
        }
        public async Task<Photo?> GetByStringAsync(string str) => null;

        public async Task AddAsync(Photo entity)
        {
            await clubMedDbContext.Photos.AddAsync(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task UpdateAsync(Photo entityToUpdate, Photo entity)
        {
            clubMedDbContext.Entry(entityToUpdate).CurrentValues.SetValues(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(Photo entity)
        {
            clubMedDbContext.Photos.Remove(entity);
            await clubMedDbContext.SaveChangesAsync();
        }
    }
}