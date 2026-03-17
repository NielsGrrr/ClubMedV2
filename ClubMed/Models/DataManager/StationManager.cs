using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualStudio.Web.CodeGenerators.Mvc.Templates.BlazorIdentity.Pages.Manage;

namespace ClubMed.Models.DataManager
{
    public class StationManager : IDataRepository<Station>
    {
        readonly ClubMedDbContext clubMedDbContext;

        public StationManager(ClubMedDbContext context)
        {
            clubMedDbContext = context;
        }

        public async Task AddAsync(Station entity)
        {
            await clubMedDbContext.Stations.AddAsync(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(Station entity)
        {
            clubMedDbContext.Stations.Remove(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task<IEnumerable<Station>> GetAllAsync()
        {
            return await clubMedDbContext.Stations.ToListAsync();
        }

        public async Task<Station?> GetByIdAsync(int id)
        {
            return await clubMedDbContext.Stations.FirstOrDefaultAsync(s => s.IdStation == id);
        }

        public async Task<Station?> GetByStringAsync(string nomSta)
        {
            return await clubMedDbContext.Stations.FirstOrDefaultAsync(s => s.NomStation.ToUpper() == nomSta.ToUpper());
        }

        public Task UpdateAsync(Station entityToUpdate, Station entity)
        {
            throw new NotImplementedException();
        }
    }
}
