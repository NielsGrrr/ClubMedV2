using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using Microsoft.EntityFrameworkCore;

namespace ClubMed.Models.DataManager
{
    public class TypeChambreManager : IDataRepository<TypeChambre>
    {
        readonly ClubMedDbContext clubMedDbContext;

        public TypeChambreManager(ClubMedDbContext context)
        {
            clubMedDbContext = context;
        }
        public async Task AddAsync(TypeChambre entity)
        {
            await clubMedDbContext.TypesChambres.AddAsync(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(TypeChambre entity)
        {
            clubMedDbContext.TypesChambres.Remove(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task<IEnumerable<TypeChambre>> GetAllAsync()
        {
            return await clubMedDbContext.TypesChambres.ToListAsync();
        }

        public async Task<TypeChambre?> GetByIdAsync(int id)
        {
            return await clubMedDbContext.TypesChambres.FirstOrDefaultAsync(tc => tc.IdTypeChambre == id);
        }

        public async Task<TypeChambre?> GetByStringAsync(string str)
        {
            throw new NotImplementedException();
        }

        public Task UpdateAsync(TypeChambre entityToUpdate, TypeChambre entity)
        {
            throw new NotImplementedException();
        }
    }
}
