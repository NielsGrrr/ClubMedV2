using Microsoft.EntityFrameworkCore;

namespace ClubMed.Models.EntityFramework
{
    public partial class ClubMedDbContext : DbContext
    {
        public ClubMedDbContext()
        {
        }

        public ClubMedDbContext(DbContextOptions<ClubMedDbContext> options)
            : base(options)
        {
        }

        // Tables
        // --- Cœur du métier (Réservations & Clients) ---
        public virtual DbSet<Reservation> Reservations { get; set; } = null!;
        public virtual DbSet<Client> Clients { get; set; } = null!;
        public virtual DbSet<AutreVoyageur> AutresVoyageurs { get; set; } = null!;
        public virtual DbSet<Transaction> Transactions { get; set; } = null!;
        public virtual DbSet<Transport> Transports { get; set; } = null!;

        // --- Clubs & Hébergement ---
        public virtual DbSet<Club> Clubs { get; set; } = null!;
        public virtual DbSet<TypeClub> TypesClubs { get; set; } = null!;
        public virtual DbSet<TypeChambre> TypesChambres { get; set; } = null!;
        public virtual DbSet<Chambre> Chambres { get; set; } = null!;
        public virtual DbSet<Disponibilite> Disponibilites { get; set; } = null!;

        // --- Localisation & Géographie ---
        public virtual DbSet<PaysRegion> PaysRegions { get; set; } = null!;
        public virtual DbSet<Localisation> Localisations { get; set; } = null!;
        public virtual DbSet<SousLocalisation> SousLocalisations { get; set; } = null!;
        public virtual DbSet<Adresse> Adresses { get; set; } = null!;
        public virtual DbSet<Station> Stations { get; set; } = null!;

        // --- Activités ---
        public virtual DbSet<Activite> Activites { get; set; } = null!;
        public virtual DbSet<ActiviteAdulte> ActivitesAdultes { get; set; } = null!;
        public virtual DbSet<ActiviteEnfant> ActivitesEnfants { get; set; } = null!;
        public virtual DbSet<TypeActivite> TypesActivites { get; set; } = null!;
        public virtual DbSet<TrancheAge> TranchesAges { get; set; } = null!;
        public virtual DbSet<Partenaire> Partenaires { get; set; } = null!;

        // --- Caractéristiques, Équipements & Services ---
        public virtual DbSet<Equipement> Equipements { get; set; } = null!;
        public virtual DbSet<EquipementSalleDeBain> EquipementsSalleDeBain { get; set; } = null!;
        public virtual DbSet<Service> Services { get; set; } = null!;
        public virtual DbSet<PointFort> PointForts { get; set; } = null!;
        public virtual DbSet<Icon> Icons { get; set; } = null!;
        public virtual DbSet<Categorie> Categories { get; set; } = null!;
        public virtual DbSet<Regroupement> Regroupements { get; set; } = null!;
        public virtual DbSet<LieuRestauration> LieuxRestauration { get; set; } = null!;

        // --- Médias & Avis ---
        public virtual DbSet<Photo> Photos { get; set; } = null!;
        public virtual DbSet<Avis> Avis { get; set; } = null!;
        public virtual DbSet<PhotoClub> PhotosClubs { get; set; } = null!;
        public virtual DbSet<PhotoAvis> PhotosAvis { get; set; } = null!;

        // --- Périodes & Tarification ---
        public virtual DbSet<Periode> Periodes { get; set; } = null!;
        public virtual DbSet<PrixPeriode> PrixPeriodes { get; set; } = null!;
        public virtual DbSet<Calendrier> Calendriers { get; set; } = null!;

        // --- Tables de liaison (N-M) ---
        public virtual DbSet<ClubActivite> ClubActivites { get; set; } = null!;
        public virtual DbSet<ClubChambre> ClubChambres { get; set; } = null!;
        public virtual DbSet<ClubCategorie> ClubCategories { get; set; } = null!;
        public virtual DbSet<ClubRegroupement> ClubRegroupements { get; set; } = null!;
        public virtual DbSet<ClubRestauration> ClubRestaurations { get; set; } = null!;
        public virtual DbSet<ClubStation> ClubStations { get; set; } = null!;
        public virtual DbSet<ActiviteReservation> ActivitesReservations { get; set; } = null!;
        public virtual DbSet<CategorieLocalisation> CategorieLocalisations { get; set; } = null!;
        public virtual DbSet<CategorieTypeClub> CategorieTypesClubs { get; set; } = null!;

        // --- Liaisons TypeChambre ---
        public virtual DbSet<TypeChambreEquipement> TypeChambreEquipements { get; set; } = null!;
        public virtual DbSet<TypeChambrePointFort> TypeChambrePointForts { get; set; } = null!;
        public virtual DbSet<TypeChambreSdb> TypeChambreSdbs { get; set; } = null!;
        public virtual DbSet<TypeChambreService> TypeChambreServices { get; set; } = null!;

        // Configurations
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfigurationsFromAssembly(typeof(ClubMedDbContext).Assembly);

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);

        // Config Postgres
        public static readonly ILoggerFactory MyLoggerFactory
            = LoggerFactory.Create(builder => { builder.AddConsole(); });
        

    }
}
