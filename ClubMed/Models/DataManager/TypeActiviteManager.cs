using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ClubMed.Models.DataManager
{
    public class TypeActiviteManager : IDataRepository<TypeActivite>
    {
        readonly ClubMedDbContext? clubMedDbContext;

        public TypeActiviteManager() { }

        public TypeActiviteManager(ClubMedDbContext? context)
        {
            clubMedDbContext = context;
        }

        public async Task AddAsync(TypeActivite entity)
        {
            await clubMedDbContext!.TypesActivites.AddAsync(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(TypeActivite entity)
        {
            clubMedDbContext!.TypesActivites.Remove(entity);
            await clubMedDbContext.SaveChangesAsync();
        }

        public async Task<ActionResult<IEnumerable<TypeActivite>>> GetAllAsync()
        {
            return await clubMedDbContext!.TypesActivites.ToListAsync();
        }

        public async Task<ActionResult<TypeActivite?>> GetByIdAsync(int id)
        {
            return await clubMedDbContext!.TypesActivites.FirstOrDefaultAsync(t => t.TypeActiviteNum == id);
        }

        public async Task<ActionResult<TypeActivite?>> GetByStringAsync(string str)
        {
            // On cherche par le nom du type (à vérifier dans ton modèle TypeActivite)
            return await clubMedDbContext!.TypesActivites.FirstOrDefaultAsync(t => t.TypeActiviteTitre == str); // Remplace NomType par la bonne propriété si besoin
        }

        public async Task UpdateAsync(TypeActivite entityToUpdate, TypeActivite entity)
        {
            clubMedDbContext!.Entry(entityToUpdate).State = EntityState.Modified;

            entityToUpdate.TypeActiviteNum = entity.TypeActiviteNum;
            // Ajoute ici les autres propriétés à mettre à jour (ex: entityToUpdate.Nom = entity.Nom;)

            await clubMedDbContext.SaveChangesAsync();
        }
    }
}