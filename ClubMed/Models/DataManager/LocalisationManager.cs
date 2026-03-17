using ClubMed.Models.EntityFramework;
using ClubMed.Models.EntityFramework.Configurations;
using ClubMed.Models.Repository;

namespace ClubMed.Models.DataManager
{
    public class LocalisationManager : IDataRepository<Localisation>
    {
        readonly LocalisationConfiguration? localisationDbContext;

        public LocalisationManager() { }

        public LocalisationManager(LocalisationConfiguration context)
        {
            localisationDbContext = context;
        }

        public Task AddAsync(Localisation entity)
        {
            return await filmsDbContext.Utilisateurs.ToListAsync();
        }

        public Task DeleteAsync(Localisation entity)
        {
            throw new NotImplementedException();
        }

        public Task<IEnumerable<Localisation>> GetAllAsync()
        {
            throw new NotImplementedException();
        }

        public Task<Localisation?> GetByIdAsync(int id)
        {
            throw new NotImplementedException();
        }

        public Task<Localisation?> GetByStringAsync(string str)
        {
            throw new NotImplementedException();
        }

        public Task UpdateAsync(Localisation entityToUpdate, Localisation entity)
        {
            throw new NotImplementedException();
        }
    }
}
