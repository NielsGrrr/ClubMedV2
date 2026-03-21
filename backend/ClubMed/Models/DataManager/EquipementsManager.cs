using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;

namespace ClubMed.Models.DataManager
{
    public class EquipementManager : IDataRepository<Equipement>
    {
        readonly ClubMedDbContext clubMedDbContext;
        public EquipementManager(ClubMedDbContext context) { clubMedDbContext = context; }

        public async Task<IEnumerable<Equipement>> GetAllAsync() 
        { 
            return await clubMedDbContext.Equipements.ToListAsync(); 
        }
        public async Task<Equipement?> GetByIdAsync(int id)
        {
            return await clubMedDbContext.Equipements.FindAsync(id);
        }
        public async Task<Equipement?> GetByStringAsync(string str) => null; // Non utilisé pour l'ID

        public async Task AddAsync(Equipement entity)
        {
            await clubMedDbContext.Equipements.AddAsync(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task UpdateAsync(Equipement entityToUpdate, Equipement entity)
        {
            clubMedDbContext.Entry(entityToUpdate).CurrentValues.SetValues(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(Equipement entity)
        {
            clubMedDbContext.Equipements.Remove(entity);
            await clubMedDbContext.SaveChangesAsync();
        }
    }
}