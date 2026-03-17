using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ClubMed.Models.DataManager
{
    public class PartenaireManager : IDataRepository<Partenaire>
    {
        readonly ClubMedDbContext? clubMedDbContext;

        public PartenaireManager() { }

        public PartenaireManager(ClubMedDbContext? context)
        {
            clubMedDbContext = context;
        }

        public async Task AddAsync(Partenaire entity)
        {
            await clubMedDbContext!.Partenaires.AddAsync(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(Partenaire entity)
        {
            clubMedDbContext!.Partenaires.Remove(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task<IEnumerable<Partenaire>> GetAllAsync()
        {
            return await clubMedDbContext!.Partenaires.ToListAsync();
        }

        public async Task<Partenaire?> GetByIdAsync(int id)
        {
            return await clubMedDbContext!.Partenaires.FirstOrDefaultAsync(p => p.PartenaireId == id);
        }

        public async Task<Partenaire?> GetByStringAsync(string str)
        {
            return await clubMedDbContext!.Partenaires.FirstOrDefaultAsync(p => p.PartenaireNom == str);
        }

        public async Task UpdateAsync(Partenaire entityToUpdate, Partenaire entity)
        {
            clubMedDbContext!.Entry(entityToUpdate).State = EntityState.Modified;

            entityToUpdate.PartenaireId = entity.PartenaireId;
            entityToUpdate.PartenaireNom = entity.PartenaireNom;
            entityToUpdate.PartenaireEmail = entity.PartenaireEmail;
            entityToUpdate.PartenaireTelephone = entity.PartenaireTelephone;

            await clubMedDbContext.SaveChangesAsync();
        }
    }
}