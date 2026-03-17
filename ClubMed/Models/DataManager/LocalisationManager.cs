using ClubMed.Models.EntityFramework;
using ClubMed.Models.EntityFramework.Configurations;
using ClubMed.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualStudio.Web.CodeGenerators.Mvc.Templates.BlazorIdentity.Pages.Manage;

namespace ClubMed.Models.DataManager
{
    public class LocalisationManager : IDataRepository<Localisation>
    {
        readonly ClubMedDbContext? clubMedDbContext;

        public LocalisationManager(ClubMedDbContext context)
        {
            clubMedDbContext = context;
        }

        public async Task AddAsync(Localisation entity)
        {
            await clubMedDbContext.Localisations.AddAsync(entity);
            await clubMedDbContext.SaveChangesAsync();

        }

        public async Task DeleteAsync(Localisation entity)
        {
            clubMedDbContext.Localisations.Remove(entity);
            await clubMedDbContext.SaveChangesAsync();
        }


        public async Task<ActionResult<IEnumerable<Localisation>>> GetAllAsync()
        {
            return await clubMedDbContext.Localisations.ToListAsync();
        }

        public async Task<ActionResult<Localisation?>> GetByIdAsync(int id)
        {
            return await clubMedDbContext.Localisations.FirstOrDefaultAsync(l => l.NumLocalisation == id);
        }

        public async Task<ActionResult<Localisation?>>  GetByStringAsync(string nomLoc)
        {
            return await clubMedDbContext.Localisations.FirstOrDefaultAsync(l => l.NomLocalisation.ToUpper() == nomLoc.ToUpper());
        }

        public Task UpdateAsync(Localisation entityToUpdate, Localisation entity)
        {
            throw new NotImplementedException();
        }
    }
}
