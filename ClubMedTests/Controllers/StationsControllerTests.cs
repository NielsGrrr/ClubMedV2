using Microsoft.AspNetCore.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using ClubMed.Controllers;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ClubMed.Tests.Controllers
{
    [TestClass()]
    public class StationsControllerTests
    {
        private StationsController controller;
        private Mock<IDataRepository<Station>> mockRepository;

        [TestInitialize()]
        public void TestInitialize()
        {
            mockRepository = new Mock<IDataRepository<Station>>();
            controller = new StationsController(mockRepository.Object);
        }

        [TestCleanup]
        public void TestCleanup()
        {
            mockRepository = null;
            controller = null;
        }

        // ==========================================================
        // 1. TESTS GET ALL
        // ==========================================================
        [TestMethod()]
        public async Task GetStationsTest()
        {
            // Arrange
            var fausseListe = new List<Station> { new Station { IdStation = 1 }, new Station { IdStation = 2 } };
            mockRepository.Setup(repo => repo.GetAllAsync()).ReturnsAsync(fausseListe);

            // Act
            var result = await controller.GetStations();

            // Assert
            Assert.IsInstanceOfType(result.Value, typeof(IEnumerable<Station>));
            var liste = result.Value as IEnumerable<Station>;
            Assert.AreEqual(2, liste.Count());
        }

        // ==========================================================
        // 2. TESTS GET BY ID / STRING
        // ==========================================================
        [TestMethod()]
        public async Task GetStationById_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((Station)null);

            // Act
            var result = await controller.GetStationById(99);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task GetStationById_ExistingId_ReturnsStation()
        {
            // Arrange
            var fausseStation = new Station { IdStation = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(fausseStation);

            // Act
            var result = await controller.GetStationById(1);

            // Assert
            Assert.IsInstanceOfType(result.Value, typeof(Station));
            var stationRecuperee = result.Value as Station;
            Assert.AreEqual(1, stationRecuperee.IdStation);
        }

        [TestMethod()]
        public async Task GetStationByName_NonExistingName_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByStringAsync("INCONNU")).ReturnsAsync((Station)null);

            // Act
            var result = await controller.GetStationByName("INCONNU");

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task GetStationByName_ExistingName_ReturnsStation()
        {
            // Arrange
            var fausseStation = new Station { NomStation = "Alpes" };
            mockRepository.Setup(repo => repo.GetByStringAsync("Alpes")).ReturnsAsync(fausseStation);

            // Act
            var result = await controller.GetStationByName("Alpes");

            // Assert
            Assert.IsInstanceOfType(result.Value, typeof(Station));
            var stationRecuperee = result.Value as Station;
            Assert.AreEqual("Alpes", stationRecuperee.NomStation);
        }

        // ==========================================================
        // 3. TESTS PUT
        // ==========================================================
        [TestMethod()]
        public async Task PutStation_IdMismatch_ReturnsBadRequest()
        {
            // Arrange
            var station = new Station { IdStation = 2 };

            // Act
            var result = await controller.PutStation(1, station);

            // Assert
            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

        [TestMethod()]
        public async Task PutStation_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            var station = new Station { IdStation = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync((Station)null);

            // Act
            var result = await controller.PutStation(1, station);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task PutStation_ValidRequest_ReturnsNoContent()
        {
            // Arrange
            var existant = new Station { IdStation = 1 };
            var modifie = new Station { IdStation = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(existant);
            mockRepository.Setup(repo => repo.UpdateAsync(existant, modifie)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.PutStation(1, modifie);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.UpdateAsync(existant, modifie), Times.Once);
        }

        // ==========================================================
        // 4. TESTS POST
        // ==========================================================
        [TestMethod()]
        public async Task PostStation_InvalidModel_ReturnsBadRequest()
        {
            // Arrange
            controller.ModelState.AddModelError("NomStation", "Requis"); // Simule une erreur de validation
            var station = new Station();
            // Act
            var result = await controller.PostStation(station); // if (!ModelState.IsValid)

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(BadRequestObjectResult));
        }

        [TestMethod()]
        public async Task PostStation_ExistingId_ReturnsConflict()
        {
            // Arrange
            var stationExistante = new Station { IdStation = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(stationExistante);

            // Act
            var result = await controller.PostStation(stationExistante);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(ConflictObjectResult));
        }

        [TestMethod()]
        public async Task PostStation_ValidNewObject_ReturnsCreatedAtAction()
        {
            // Arrange
            var nouvelleStation = new Station { IdStation = 2 };
            mockRepository.Setup(repo => repo.GetByIdAsync(2)).ReturnsAsync((Station)null);
            mockRepository.Setup(repo => repo.AddAsync(nouvelleStation)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.PostStation(nouvelleStation);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(CreatedAtActionResult));
            var actionResult = result.Result as CreatedAtActionResult;
            Assert.AreEqual("GetStationById", actionResult.ActionName);
            mockRepository.Verify(repo => repo.AddAsync(nouvelleStation), Times.Once);
        }

        // ==========================================================
        // 5. TESTS DELETE
        // ==========================================================
        [TestMethod()]
        public async Task DeleteStation_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((Station)null);

            // Act
            var result = await controller.DeleteStation(99);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task DeleteStation_ExistingId_ReturnsNoContent()
        {
            // Arrange
            var station = new Station { IdStation = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(station);
            mockRepository.Setup(repo => repo.DeleteAsync(station)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.DeleteStation(1);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.DeleteAsync(station), Times.Once);
        }
    }
}