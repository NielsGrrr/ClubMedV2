using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ClubMed.Models.DataManager
{
    public class LieuRestaurationManager : IDataRepository<LieuRestauration>
    {
        readonly ClubMedDbContext? clubMedDbContext;

        public LieuRestaurationManager() { }

        public LieuRestaurationManager(ClubMedDbContext? context)
        {
            clubMedDbContext = context;
        }

        public async Task AddAsync(LieuRestauration entity)
        {
            await clubMedDbContext!.LieuxRestauration.AddAsync(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(LieuRestauration entity)
        {
            clubMedDbContext!.LieuxRestauration.Remove(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task<IEnumerable<LieuRestauration>> GetAllAsync()
        {
            return await clubMedDbContext!.LieuxRestauration.ToListAsync();
        }

        public async Task<LieuRestauration?> GetByIdAsync(int id)
        {
            return await clubMedDbContext!.LieuxRestauration.FirstOrDefaultAsync(l => l.NumRestauration == id);
        }

        public async Task<LieuRestauration?> GetByStringAsync(string str)
        {
            // Recherche par le nom du lieu (à vérifier selon ton modèle)
            return await clubMedDbContext!.LieuxRestauration.FirstOrDefaultAsync(l => l.Nom == str);
        }

        public async Task UpdateAsync(LieuRestauration entityToUpdate, LieuRestauration entity)
        {
            clubMedDbContext!.Entry(entityToUpdate).State = EntityState.Modified;

            // Mapping manuel des données comme dans ton AvisManager
            entityToUpdate.NumRestauration = entity.NumRestauration;
            entityToUpdate.Nom = entity.Nom;
            entityToUpdate.Description = entity.Description;
            entityToUpdate.Presentation = entity.Presentation;
            entityToUpdate.EstBar = entity.EstBar;
            entityToUpdate.NumPhoto = entity.NumPhoto;

            await clubMedDbContext.SaveChangesAsync();
        }
    }
}