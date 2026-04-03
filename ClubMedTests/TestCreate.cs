using System;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.DataManager;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace ClubMedTests
{
    public class TestCreate
    {
        public static async Task Run()
        {
            var options = new DbContextOptionsBuilder<ClubMedDbContext>()
                .UseInMemoryDatabase(databaseName: "TestDB")
                .Options;

            using (var context = new ClubMedDbContext(options))
            {
                var repo = new ClubManager(context);
                var club = new Club {
                    Titre = "Test",
                    Description = "Test",
                    TypeChambres = new List<TypeChambre> {
                        new TypeChambre { NomType = "Suite", CapaciteMax = 2 }
                    }
                };
                
                try {
                    await repo.AddAsync(club);
                    Console.WriteLine("SUCCESS!");
                } catch (Exception ex) {
                    Console.WriteLine("ERROR: " + ex.Message);
                    if (ex.InnerException != null) Console.WriteLine("INNER: " + ex.InnerException.Message);
                }
            }
        }
    }
}
