using ClubMed.Models.EntityFramework;
using ClubMed.Models.EntityFramework.Configurations;
using ClubMed.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualStudio.Web.CodeGenerators.Mvc.Templates.BlazorIdentity.Pages.Manage;

namespace ClubMed.Models.DataManager
{
    public class SousLocalisationManager : IDataRepository<SousLocalisation>
    {
        readonly ClubMedDbContext clubMedDbContext;

        public SousLocalisationManager(ClubMedDbContext context)
        {
            clubMedDbContext = context;
        }

        public async Task AddAsync(SousLocalisation entity)
        {
            await clubMedDbContext.SousLocalisations.AddAsync(entity);
            await clubMedDbContext.SaveChangesAsync();

        }

        public async Task DeleteAsync(SousLocalisation entity)
        {
            clubMedDbContext.SousLocalisations.Remove(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task<IEnumerable<SousLocalisation>> GetAllAsync()
        {
            return await clubMedDbContext.SousLocalisations.ToListAsync();
        }

        public async Task<SousLocalisation?> GetByIdAsync(int id)
        {
            return await clubMedDbContext.SousLocalisations.FirstOrDefaultAsync(l => l.NumPays == id);
        }

        public async Task<SousLocalisation?> GetByStringAsync(string nomLoc)
        {
            return await clubMedDbContext.SousLocalisations.FirstOrDefaultAsync(l => l.NomPays.ToUpper() == nomLoc.ToUpper());
        }

        public async Task UpdateAsync(Localisation entityToUpdate, Localisation entity)
        {
            clubMedDbContext.Entry(entityToUpdate).CurrentValues.SetValues(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public Task UpdateAsync(SousLocalisation entityToUpdate, SousLocalisation entity)
        {
            throw new NotImplementedException();
        }
    }
}
