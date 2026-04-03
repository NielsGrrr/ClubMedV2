using Microsoft.EntityFrameworkCore; 
using Xunit;
using ClubMed.Models.EntityFramework;
using System.Threading.Tasks;

namespace ClubMedTests
{
    public class TestCreate
    {
        [Fact]
        public async Task PostClub_DevraitAjouterLeClub_QuandLesDonneesSontValides()
        {
            // 1. ARRANGE : Base de données isolée en RAM
            var options = new DbContextOptionsBuilder<ClubMedDbContext>()
                .UseInMemoryDatabase(databaseName: "TestClub_Db_Create") 
                .Options;

            // ⚠️ ATTENTION ICI : Remplace "Nom" et "IdPhoto" par les vrais noms 
            // des variables telles qu'elles sont écrites dans ton fichier Club.cs !
            var testClub = new Club { 
                // Exemple :
                // Nom = "Club Test CI", 
                // PhotoId = 100 
            };

            // 2. ACT
            using (var context = new ClubMedDbContext(options))
            {
                context.Clubs.Add(testClub);
                await context.SaveChangesAsync();
            }

            // 3. ASSERT : Vérification
            using (var context = new ClubMedDbContext(options))
            {
                var clubsInDb = await context.Clubs.CountAsync();
                
                // On utilise explicitement Xunit pour régler l'erreur d'ambiguïté (CS0104)
                Xunit.Assert.Equal(1, clubsInDb); 
            }
        }
    }
}