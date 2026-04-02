using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ClubMed.Models.DataManager
{
    public class ReservationManager : IDataRepository<Reservation>
    {
        private readonly ClubMedDbContext _context;

        public ReservationManager(ClubMedDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Reservation>> GetAllAsync()
        {
           return await _context.Reservations.ToListAsync();
        }

        public async Task<Reservation?> GetByIdAsync(int id)
        {
            return await _context.Reservations
                .Include(r => r.SousReservations)
                    .ThenInclude(sr => sr.SousReservationActivites)
                .Include(r => r.SousReservations)
                    .ThenInclude(sr => sr.Transport)
                .FirstOrDefaultAsync(r => r.ResaNum == id);
        }

        public Task<Reservation?> GetByStringAsync(string str)
        { 
            throw new NotImplementedException(); 
        }

        public async Task AddAsync(Reservation entity)
        {
            await _context.Reservations.AddAsync(entity);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(Reservation entityToUpdate, Reservation entity)
        {
            _context.Entry(entityToUpdate).CurrentValues.SetValues(entity);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(Reservation entity)
        {
            // Supprimer d'abord les entités liées pour éviter les violations de contrainte FK
            var activites = _context.ActivitesReservations
                .Where(a => a.ResaNum == entity.ResaNum);
            _context.ActivitesReservations.RemoveRange(activites);

            var voyageurs = _context.AutresVoyageurs
                .Where(v => v.AutreVoyageurNumResa == entity.ResaNum);
            _context.AutresVoyageurs.RemoveRange(voyageurs);

            var transactions = _context.Transactions
                .Where(t => t.ResaNum == entity.ResaNum);
            _context.Transactions.RemoveRange(transactions);

            // Cascade pour les SousReservations et leurs Activites
            var sousResas = _context.SousReservations
                .Include(sr => sr.SousReservationActivites)
                .Where(sr => sr.ResaNum == entity.ResaNum);
            
            foreach(var sr in sousResas) {
                if (sr.SousReservationActivites != null) _context.SousReservationActivites.RemoveRange(sr.SousReservationActivites);
            }
            _context.SousReservations.RemoveRange(sousResas);

            // Supprimer la réservation elle-même
            _context.Reservations.Remove(entity);
            await _context.SaveChangesAsync();
        }
    }
}