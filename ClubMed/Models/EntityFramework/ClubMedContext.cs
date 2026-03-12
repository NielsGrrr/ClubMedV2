using Microsoft.EntityFrameworkCore;
using System.Reflection;

namespace ClubMed.Models.EntityFramework
{
    public partial class ClubMedContext : DbContext
    {
        public ClubMedContext() { }

        public ClubMedContext(DbContextOptions<ClubMedContext> options) : base(options) { }

        // Déclaration de nos 7 tables
        public virtual DbSet<Adresse> Adresses { get; set; } = null!;
        public virtual DbSet<Client> Clients { get; set; } = null!;
        public virtual DbSet<Localisation> Localisations { get; set; } = null!;
        public virtual DbSet<SousLocalisation> SousLocalisations { get; set; } = null!;
        public virtual DbSet<PaysRegion> PaysRegions { get; set; } = null!;
        public virtual DbSet<Regroupement> Regroupements { get; set; } = null!;
        public virtual DbSet<ClubRegroupement> ClubRegroupements { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Inspiration APIfilms : Forcer le schéma public par défaut de PostgreSQL
            modelBuilder.HasDefaultSchema("public");

            // ARCHITECTURE : On scanne automatiquement tout le dossier Configurations
            modelBuilder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}