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
    public class LieuRestaurationsControllerTests
    {
        private LieuRestaurationsController controller;
        private Mock<IDataRepository<LieuRestauration>> mockRepository;

        [TestInitialize()]
        public void TestInitialize()
        {
            mockRepository = new Mock<IDataRepository<LieuRestauration>>();
            controller = new LieuRestaurationsController(mockRepository.Object);
        }

        [TestCleanup]
        public void TestCleanup()
        {
            mockRepository = null;
            controller = null;
        }

        // ==========================================================
        // 1. TESTS GET ALL (1 chemin)
        // ==========================================================
        [TestMethod()]
        public async Task GetLieuxRestaurationTest()
        {
            // Arrange
            List<LieuRestauration> fausseListe = new List<LieuRestauration> { new LieuRestauration { NumRestauration = 1 }, new LieuRestauration { NumRestauration = 2 } };
            mockRepository.Setup(repo => repo.GetAllAsync()).ReturnsAsync(fausseListe);

            // Act
            var result = await controller.GetLieuxRestauration();

            // Assert
            Assert.IsInstanceOfType(result.Value, typeof(IEnumerable<LieuRestauration>));
            Assert.AreEqual(2, result.Value.Count());
        }

        // ==========================================================
        // 2. TESTS GET BY ID (2 chemins : Trouvé / Pas Trouvé)
        // ==========================================================
        [TestMethod()]
        public async Task GetLieuRestauration_NonExistingIdPassed_ReturnsNotFoundResult()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(9999)).ReturnsAsync((LieuRestauration)null);

            // Act
            var result = await controller.GetLieuRestauration(9999);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task GetLieuRestauration_ExistingIdPassed_ReturnsRightItem()
        {
            // Arrange
            var fauxLieu = new LieuRestauration { NumRestauration = 1, Nom = "TestBar" };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(fauxLieu);

            // Act
            var result = await controller.GetLieuRestauration(1);

            // Assert
            Assert.IsInstanceOfType(result.Value, typeof(LieuRestauration));
            Assert.AreEqual("TestBar", result.Value.Nom);
        }

        // ==========================================================
        // 3. TESTS PUT (3 chemins : Mauvais ID / Pas trouvé / Succès)
        // ==========================================================
        [TestMethod()]
        public async Task PutLieuRestauration_IdMismatch_ReturnsBadRequest()
        {
            // Arrange
            var lieu = new LieuRestauration { NumRestauration = 2 };

            // Act
            var result = await controller.PutLieuRestauration(1, lieu);

            // Assert
            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

        [TestMethod()]
        public async Task PutLieuRestauration_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            var lieu = new LieuRestauration { NumRestauration = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync((LieuRestauration)null);

            // Act
            var result = await controller.PutLieuRestauration(1, lieu);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task PutLieuRestauration_ValidRequest_ReturnsNoContent()
        {
            // Arrange
            var lieuExistant = new LieuRestauration { NumRestauration = 1 };
            var lieuModifie = new LieuRestauration { NumRestauration = 1, Nom = "Nouveau" };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(lieuExistant);
            mockRepository.Setup(repo => repo.UpdateAsync(lieuExistant, lieuModifie)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.PutLieuRestauration(1, lieuModifie);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.UpdateAsync(lieuExistant, lieuModifie), Times.Once);
        }

        // ==========================================================
        // 4. TESTS POST (2 chemins : Modèle Invalide / Succès)
        // ==========================================================
        [TestMethod()]
        public async Task PostLieuRestauration_InvalidModel_ReturnsBadRequest()
        {
            // Arrange
            controller.ModelState.AddModelError("Nom", "Requis");
            var lieu = new LieuRestauration();

            // Act
            var result = await controller.PostLieuRestauration(lieu);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(BadRequestObjectResult));
        }

        [TestMethod()]
        public async Task PostLieuRestauration_ValidObject_ReturnsCreatedAtAction()
        {
            // Arrange
            var lieu = new LieuRestauration { NumRestauration = 1, Nom = "Nouveau" };
            mockRepository.Setup(repo => repo.AddAsync(lieu)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.PostLieuRestauration(lieu);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(CreatedAtActionResult));
            mockRepository.Verify(repo => repo.AddAsync(lieu), Times.Once);
        }

        // ==========================================================
        // 5. TESTS DELETE (2 chemins : Pas trouvé / Succès)
        // ==========================================================
        [TestMethod()]
        public async Task DeleteLieuRestauration_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(9999)).ReturnsAsync((LieuRestauration)null);

            // Act
            var result = await controller.DeleteLieuRestauration(9999);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task DeleteLieuRestauration_ExistingId_ReturnsNoContent()
        {
            // Arrange
            var lieu = new LieuRestauration { NumRestauration = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(lieu);
            mockRepository.Setup(repo => repo.DeleteAsync(lieu)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.DeleteLieuRestauration(1);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.DeleteAsync(lieu), Times.Once);
        }
    }
}