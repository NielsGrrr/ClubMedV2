using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;

namespace ClubMed.Models.DataManager
{
    public class PeriodeManager : IDataRepository<Periode>
    {
        readonly ClubMedDbContext clubMedDbContext;
        public PeriodeManager(ClubMedDbContext context) { clubMedDbContext = context; }

        public async Task<IEnumerable<Periode>> GetAllAsync()
        {
            return await clubMedDbContext.Periodes.ToListAsync();
        }
        public async Task<Periode?> GetByIdAsync(int id) => null; // Non utilisé
        public async Task<Periode?> GetByStringAsync(string str)
        {
            return await clubMedDbContext.Periodes.FindAsync(str);
        }

        public async Task AddAsync(Periode entity)
        {
            await clubMedDbContext.Periodes.AddAsync(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task UpdateAsync(Periode entityToUpdate, Periode entity)
        {
            clubMedDbContext.Entry(entityToUpdate).CurrentValues.SetValues(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(Periode entity)
        {
            clubMedDbContext.Periodes.Remove(entity);
            await clubMedDbContext.SaveChangesAsync();
        }
    }
}