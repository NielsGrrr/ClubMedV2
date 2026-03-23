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
    public class EquipementsControllerTests
    {
        private EquipementsController controller;
        private Mock<IDataRepository<Equipement>> mockRepository;

        [TestInitialize()]
        public void TestInitialize()
        {
            mockRepository = new Mock<IDataRepository<Equipement>>();
            controller = new EquipementsController(mockRepository.Object);
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
        public async Task GetEquipementsTest()
        {
            // Arrange
            var fausseListe = new List<Equipement> { new Equipement { NumEquipement = 1 }, new Equipement { NumEquipement = 2 } };
            mockRepository.Setup(repo => repo.GetAllAsync()).ReturnsAsync(fausseListe);

            // Act
            var result = await controller.GetEquipements();

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(OkObjectResult));
            var okResult = result.Result as OkObjectResult;
            var liste = okResult.Value as IEnumerable<Equipement>;
            Assert.AreEqual(2, liste.Count());
        }

        // ==========================================================
        // 2. TESTS GET BY ID
        // ==========================================================
        [TestMethod()]
        public async Task GetEquipement_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(9999)).ReturnsAsync((Equipement)null);

            // Act
            var result = await controller.GetEquipement(9999);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task GetEquipement_ExistingId_ReturnsOk()
        {
            // Arrange
            var fauxEquip = new Equipement { NumEquipement = 1, Nom = "Climatisation" };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(fauxEquip);

            // Act
            var result = await controller.GetEquipement(1);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(OkObjectResult));
            var okResult = result.Result as OkObjectResult;
            var equipementRecupere = okResult.Value as Equipement;
            Assert.AreEqual("Climatisation", equipementRecupere.Nom);
        }

        // ==========================================================
        // 3. TESTS PUT
        // ==========================================================
        [TestMethod()]
        public async Task PutEquipement_IdMismatch_ReturnsBadRequest()
        {
            // Arrange
            var equipement = new Equipement { NumEquipement = 2 };

            // Act
            var result = await controller.PutEquipement(1, equipement);

            // Assert
            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

        [TestMethod()]
        public async Task PutEquipement_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            var equipement = new Equipement { NumEquipement = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync((Equipement)null);

            // Act
            var result = await controller.PutEquipement(1, equipement);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task PutEquipement_ValidRequest_ReturnsNoContent()
        {
            // Arrange
            var existant = new Equipement { NumEquipement = 1 };
            var modifie = new Equipement { NumEquipement = 1, Nom = "Nouveau" };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(existant);
            mockRepository.Setup(repo => repo.UpdateAsync(existant, modifie)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.PutEquipement(1, modifie);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.UpdateAsync(existant, modifie), Times.Once);
        }

        // ==========================================================
        // 4. TESTS POST
        // ==========================================================
        [TestMethod()]
        public async Task PostEquipement_ValidObject_ReturnsCreatedAtAction()
        {
            // Arrange
            var equipement = new Equipement { NumEquipement = 1, Nom = "Test" };
            mockRepository.Setup(repo => repo.AddAsync(equipement)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.PostEquipement(equipement);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(CreatedAtActionResult));
            mockRepository.Verify(repo => repo.AddAsync(equipement), Times.Once);
        }

        // ==========================================================
        // 5. TESTS DELETE
        // ==========================================================
        [TestMethod()]
        public async Task DeleteEquipement_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(9999)).ReturnsAsync((Equipement)null);

            // Act
            var result = await controller.DeleteEquipement(9999);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task DeleteEquipement_ExistingId_ReturnsNoContent()
        {
            // Arrange
            var equipement = new Equipement { NumEquipement = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(equipement);
            mockRepository.Setup(repo => repo.DeleteAsync(equipement)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.DeleteEquipement(1);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.DeleteAsync(equipement), Times.Once);
        }
    }
}