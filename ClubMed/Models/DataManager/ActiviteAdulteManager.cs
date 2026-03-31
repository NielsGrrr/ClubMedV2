using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using Microsoft.EntityFrameworkCore;

namespace ClubMed.Models.DataManager
{
    public class ActiviteAdulteManager : IDataRepository<ActiviteAdulte>
    {
        readonly ClubMedDbContext? clubMedDbContext;

        public ActiviteAdulteManager() { }

        public ActiviteAdulteManager(ClubMedDbContext? context)
        {
            clubMedDbContext = context;
        }

        public async Task AddAsync(ActiviteAdulte entity)
        {
            await clubMedDbContext!.ActivitesAdultes.AddAsync(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(ActiviteAdulte entity)
        {
            clubMedDbContext!.ActivitesAdultes.Remove(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task<IEnumerable<ActiviteAdulte>> GetAllAsync()
        {
            return await clubMedDbContext!.ActivitesAdultes.ToListAsync();
        }

        public async Task<ActiviteAdulte?> GetByIdAsync(int id)
        {
            return await clubMedDbContext!.ActivitesAdultes.FirstOrDefaultAsync(a => a.ActiAdulteId == id);
        }

        public async Task<ActiviteAdulte?> GetByStringAsync(string str)
        {
            return await clubMedDbContext!.ActivitesAdultes.FirstOrDefaultAsync(a => a.ActiAdulteTitre == str);
        }

        public async Task UpdateAsync(ActiviteAdulte entityToUpdate, ActiviteAdulte entity)
        {
            clubMedDbContext!.Entry(entityToUpdate).State = EntityState.Modified;

            entityToUpdate.ActiAdulteNumType = entity.ActiAdulteNumType;
            entityToUpdate.ActiAdulteTitre = entity.ActiAdulteTitre;
            entityToUpdate.ActiAdulteDescription = entity.ActiAdulteDescription;
            entityToUpdate.ActiAdultePrixMin = entity.ActiAdultePrixMin;
            entityToUpdate.ActiAdulteDuree = entity.ActiAdulteDuree;
            entityToUpdate.ActiAdulteAgeMin = entity.ActiAdulteAgeMin;
            entityToUpdate.ActiAdulteFrequence = entity.ActiAdulteFrequence;

            await clubMedDbContext.SaveChangesAsync();
        }
    }
}
