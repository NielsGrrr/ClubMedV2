/*using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ClubMed.Models.DataManager
{
    public class AvisManager : IDataRepository<Avis>
    {
        readonly ClubMedDbContext? clubMedDbContext;
        public AvisManager() { }
        public AvisManager(ClubMedDbContext? context)
        {
            clubMedDbContext = context;
        }
        public async Task AddAsync(Avis entity)
        {
            await clubMedDbContext!.Avis.AddAsync(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(Avis entity)
        {
            clubMedDbContext!.Avis.Remove(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task<IEnumerable<Avis>> GetAllAsync()
        {
            return await clubMedDbContext!.Avis.ToListAsync();
        }

        public async Task<Avis?> GetByIdAsync(int id)
        {
            return await clubMedDbContext!.Avis.FirstOrDefaultAsync(a => a.NumAvis == id);
        }

        public async Task<Avis?> GetByStringAsync(string str)
        {
            return await clubMedDbContext!.Avis.FirstOrDefaultAsync(a => a.Titre == str);
        }

        public async Task UpdateAsync(Avis entityToUpdate, Avis entity)
        {
            clubMedDbContext!.Entry(entityToUpdate).State = EntityState.Modified;

            entityToUpdate.NumAvis = entity.NumAvis;
            entityToUpdate.IdClub = entity.IdClub;
            entityToUpdate.NumClient = entity.NumClient;
            entityToUpdate.Titre = entity.Titre;
            entityToUpdate.Commentaire = entity.Commentaire;
            entityToUpdate.Note = entity.Note;
            entityToUpdate.NumReservation = entity.NumReservation;
            entityToUpdate.Reponse = entity.Reponse;

            await clubMedDbContext.SaveChangesAsync();
        }
    }
}
*/