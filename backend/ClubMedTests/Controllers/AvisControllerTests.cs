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
    public class AvisControllerTests
    {
        private AvisController controller;
        private Mock<IDataRepository<Avis>> mockRepository;

        [TestInitialize()]
        public void TestInitialize()
        {
            mockRepository = new Mock<IDataRepository<Avis>>();
            controller = new AvisController(mockRepository.Object);
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
        public async Task GetAvisTest()
        {
            // Arrange
            List<Avis> fausseListe = new List<Avis> { new Avis { NumAvis = 1 }, new Avis { NumAvis = 2 } };
            mockRepository.Setup(repo => repo.GetAllAsync()).ReturnsAsync(fausseListe);

            // Act
            var result = await controller.GetAvis(); // Méthode du contrôleur

            // Assert
            Assert.IsInstanceOfType(result.Value, typeof(IEnumerable<Avis>));
            Assert.AreEqual(2, result.Value.Count());
        }

        // ==========================================================
        // 2. TESTS GET BY ID (2 chemins : Trouvé / Pas Trouvé)
        // ==========================================================
        [TestMethod()]
        public async Task GetAvis_NonExistingIdPassed_ReturnsNotFoundResult()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(9999)).ReturnsAsync((Avis)null);

            // Act
            var result = await controller.GetAvis(9999); // if (avis == null)

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task GetAvis_ExistingIdPassed_ReturnsRightItem()
        {
            // Arrange
            var fauxAvis = new Avis { NumAvis = 1, Titre = "Test" };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(fauxAvis);

            // Act
            var result = await controller.GetAvis(1); // Retourne l'avis

            // Assert
            Assert.IsInstanceOfType(result.Value, typeof(Avis));
            Assert.AreEqual("Test", result.Value.Titre);
        }

        // ==========================================================
        // 3. TESTS GET BY STRING (2 chemins : Trouvé / Pas Trouvé)
        // ==========================================================
        [TestMethod()]
        public async Task GetUtilisateurByEmail_NonExisting_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByStringAsync("Inconnu")).ReturnsAsync((Avis)null);

            // Act
            var result = await controller.GetUtilisateurByEmail("Inconnu"); // if (avis == null)

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task GetUtilisateurByEmail_Existing_ReturnsAvis()
        {
            // Arrange
            var fauxAvis = new Avis { NumAvis = 1, Titre = "TitreExistant" };
            mockRepository.Setup(repo => repo.GetByStringAsync("TitreExistant")).ReturnsAsync(fauxAvis);

            // Act
            var result = await controller.GetUtilisateurByEmail("TitreExistant"); // Retourne l'avis

            // Assert
            Assert.IsInstanceOfType(result.Value, typeof(Avis));
            Assert.AreEqual("TitreExistant", result.Value.Titre);
        }

        // ==========================================================
        // 4. TESTS PUT (3 chemins : Mauvais ID / Pas trouvé / Succès)
        // ==========================================================
        [TestMethod()]
        public async Task PutAvis_IdMismatch_ReturnsBadRequest()
        {
            // Arrange
            var avis = new Avis { NumAvis = 2 };

            // Act
            var result = await controller.PutAvis(1, avis); // if (id != avis.NumAvis)

            // Assert
            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

        [TestMethod()]
        public async Task PutAvis_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            var avis = new Avis { NumAvis = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync((Avis)null);

            // Act
            var result = await controller.PutAvis(1, avis); // if (avisToUpdate == null)

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task PutAvis_ValidRequest_ReturnsNoContent()
        {
            // Arrange
            var avisExistant = new Avis { NumAvis = 1 };
            var avisModifie = new Avis { NumAvis = 1, Titre = "Nouveau" };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(avisExistant);
            mockRepository.Setup(repo => repo.UpdateAsync(avisExistant, avisModifie)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.PutAvis(1, avisModifie); // UpdateAsync

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.UpdateAsync(avisExistant, avisModifie), Times.Once);
        }

        // ==========================================================
        // 5. TESTS POST (2 chemins : Modèle Invalide / Succès)
        // ==========================================================
        [TestMethod()]
        public async Task PostAvis_InvalidModel_ReturnsBadRequest()
        {
            // Arrange
            controller.ModelState.AddModelError("Titre", "Requis"); // Simule une erreur de validation
            var avis = new Avis();

            // Act
            var result = await controller.PostAvis(avis); // if (!ModelState.IsValid)

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(BadRequestObjectResult));
        }

        [TestMethod()]
        public async Task PostAvis_ValidObject_ReturnsCreatedAtAction()
        {
            // Arrange
            var avis = new Avis { NumAvis = 1, Titre = "Nouveau" };
            mockRepository.Setup(repo => repo.AddAsync(avis)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.PostAvis(avis); // AddAsync

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(CreatedAtActionResult));
            mockRepository.Verify(repo => repo.AddAsync(avis), Times.Once);
        }

        // ==========================================================
        // 6. TESTS DELETE (2 chemins : Pas trouvé / Succès)
        // ==========================================================
        [TestMethod()]
        public async Task DeleteAvis_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(9999)).ReturnsAsync((Avis)null);

            // Act
            var result = await controller.DeleteAvis(9999); // if (avis == null)

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task DeleteAvis_ExistingId_ReturnsNoContent()
        {
            // Arrange
            var avis = new Avis { NumAvis = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(avis);
            mockRepository.Setup(repo => repo.DeleteAsync(avis)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.DeleteAvis(1); // DeleteAsync

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.DeleteAsync(avis), Times.Once);
        }
    }
}