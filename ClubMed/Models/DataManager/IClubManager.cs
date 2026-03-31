using ClubMed.Models.EntityFramework;

namespace ClubMed.Models.DataManager
{
    public interface IClubManager
    {
        Task<IEnumerable<Club>> GetByLocalisationAsync(int idlocalisation);
        Task<IEnumerable<Club>> GetByTypeChambreAsync(int idtypechambre);
    }
}
