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
    public class LocalisationsControllerTests
    {
        private LocalisationsController controller;
        private Mock<IDataRepository<Localisation>> mockRepository;

        [TestInitialize()]
        public void TestInitialize()
        {
            mockRepository = new Mock<IDataRepository<Localisation>>();
            controller = new LocalisationsController(mockRepository.Object);
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
        public async Task GetLocalisationsTest()
        {
            // Arrange
            var fausseListe = new List<Localisation> { new Localisation { NumLocalisation = 1 }, new Localisation { NumLocalisation = 2 } };
            mockRepository.Setup(repo => repo.GetAllAsync()).ReturnsAsync(fausseListe);

            // Act
            var result = await controller.GetLocalisations();

            // Assert
            Assert.IsInstanceOfType(result.Value, typeof(IEnumerable<Localisation>));
            var liste = result.Value as IEnumerable<Localisation>;
            Assert.AreEqual(2, liste.Count());
        }

        // ==========================================================
        // 2. TESTS GET BY ID
        // ==========================================================
        [TestMethod()]
        public async Task GetLocalisationById_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((Localisation)null);

            // Act
            var result = await controller.GetLocalisationById(99);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task GetLocalisationById_ExistingId_ReturnsLocalisation()
        {
            // Arrange
            var fausseLocalisation = new Localisation { NumLocalisation = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(fausseLocalisation);

            // Act
            var result = await controller.GetLocalisationById(1);

            // Assert
            Assert.IsInstanceOfType(result.Value, typeof(Localisation));
            var localisationRecuperee = result.Value as Localisation;
            Assert.AreEqual(1, localisationRecuperee.NumLocalisation);
        }

        // ==========================================================
        // 3. TESTS PUT
        // ==========================================================
        [TestMethod()]
        public async Task PutLocalisation_IdMismatch_ReturnsBadRequest()
        {
            // Arrange
            var localisation = new Localisation { NumLocalisation = 2 };

            // Act
            var result = await controller.PutLocalisation(1, localisation);

            // Assert
            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

        [TestMethod()]
        public async Task PutLocalisation_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            var localisation = new Localisation { NumLocalisation = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync((Localisation)null);

            // Act
            var result = await controller.PutLocalisation(1, localisation);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task PutLocalisation_ValidRequest_ReturnsNoContent()
        {
            // Arrange
            var existant = new Localisation { NumLocalisation = 1 };
            var modifie = new Localisation { NumLocalisation = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(existant);
            mockRepository.Setup(repo => repo.UpdateAsync(existant, modifie)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.PutLocalisation(1, modifie);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.UpdateAsync(existant, modifie), Times.Once);
        }

        // ==========================================================
        // 4. TESTS POST
        // ==========================================================
        [TestMethod()]
        public async Task PostLocalisation_InvalidModel_ReturnsBadRequest()
        {
            // Arrange
            controller.ModelState.AddModelError("CategorieLocalisation", "Requis"); // Simule une erreur de validation
            var localisation = new Localisation();
            

            // Act
            var result = await controller.PostLocalisation(localisation); // if (!ModelState.IsValid)

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(BadRequestObjectResult));
        }

        [TestMethod()]
        public async Task PostLocalisation_ExistingId_ReturnsConflict()
        {
            // Arrange
            var localisationExistante = new Localisation { NumLocalisation = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(localisationExistante);

            // Act
            var result = await controller.PostLocalisation(localisationExistante);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(ConflictObjectResult));
        }

        [TestMethod()]
        public async Task PostLocalisation_ValidNewObject_ReturnsCreatedAtAction()
        {
            // Arrange
            var nouvelleLocalisation = new Localisation { NumLocalisation = 2 };
            mockRepository.Setup(repo => repo.GetByIdAsync(2)).ReturnsAsync((Localisation)null);
            mockRepository.Setup(repo => repo.AddAsync(nouvelleLocalisation)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.PostLocalisation(nouvelleLocalisation);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(CreatedAtActionResult));
            var actionResult = result.Result as CreatedAtActionResult;
            Assert.AreEqual("GetLocalisationById", actionResult.ActionName);
            mockRepository.Verify(repo => repo.AddAsync(nouvelleLocalisation), Times.Once);
        }

        // ==========================================================
        // 5. TESTS DELETE
        // ==========================================================
        [TestMethod()]
        public async Task DeleteLocalisation_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((Localisation)null);

            // Act
            var result = await controller.DeleteLocalisation(99);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task DeleteLocalisation_ExistingId_ReturnsNoContent()
        {
            // Arrange
            var localisation = new Localisation { NumLocalisation = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(localisation);
            mockRepository.Setup(repo => repo.DeleteAsync(localisation)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.DeleteLocalisation(1);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.DeleteAsync(localisation), Times.Once);
        }
    }
}