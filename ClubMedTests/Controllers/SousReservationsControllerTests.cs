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
    public class SousReservationsControllerTests
    {
        private Mock<IDataRepository<SousReservation>> mockRepository;
        private SousReservationsController controller;

        [TestInitialize()]
        public void TestInitialize()
        {
            mockRepository = new Mock<IDataRepository<SousReservation>>();
            controller = new SousReservationsController(mockRepository.Object);
        }

        [TestCleanup]
        public void TestCleanup()
        {
            mockRepository = null;
            controller = null;
        }

        // ==========================================================
        // 1. TESTS GET ALL (1 seul chemin : Succès)
        // ==========================================================
        [TestMethod()]
        public async Task GetSousReservations_ReturnsAll()
        {
            // Arrange
            var mockData = new List<SousReservation>
            {
                new SousReservation { SousReservationId = 1 },
                new SousReservation { SousReservationId = 2 }
            };
            mockRepository.Setup(repo => repo.GetAllAsync()).ReturnsAsync(mockData);

            // Act
            var result = await controller.GetSousReservations();

            // Assert
            // On vérifie result.Value car on retourne directement la liste dans le contrôleur
            Assert.IsNotNull(result.Value);
            Assert.IsInstanceOfType(result.Value, typeof(IEnumerable<SousReservation>));
            Assert.AreEqual(2, result.Value.Count());
        }

        // ==========================================================
        // 2. TESTS GET BY ID (2 chemins : Trouvé / Pas Trouvé)
        // ==========================================================
        [TestMethod()]
        public async Task GetSousReservation_Existing_ReturnsItem()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(1))
                          .ReturnsAsync(new SousReservation { SousReservationId = 1, ResaNum = 100 });

            // Act
            var result = await controller.GetSousReservation(1);

            // Assert
            // On vérifie result.Value car l'objet est retourné directement
            Assert.IsNotNull(result.Value);
            Assert.IsInstanceOfType(result.Value, typeof(SousReservation));
            Assert.AreEqual(100, result.Value.ResaNum);
        }

        [TestMethod()]
        public async Task GetSousReservation_NotExisting_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((SousReservation)null);

            // Act
            var result = await controller.GetSousReservation(99);

            // Assert
            // On vérifie result.Result car NotFound() est renvoyé
            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        // ==========================================================
        // 3. TESTS POST (2 chemins : Modèle Valide / Invalide)
        // ==========================================================
        [TestMethod()]
        public async Task PostSousReservation_Valid_ReturnsCreated()
        {
            // Arrange
            var entity = new SousReservation { SousReservationId = 1 };
            mockRepository.Setup(repo => repo.AddAsync(entity)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.PostSousReservation(entity);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(CreatedAtActionResult));
            mockRepository.Verify(repo => repo.AddAsync(entity), Times.Once);
        }

        [TestMethod()]
        public async Task PostSousReservation_Invalid_ReturnsBadRequest()
        {
            // Arrange
            // On simule une erreur de validation ModelState
            controller.ModelState.AddModelError("ResaNum", "Le numéro de réservation est requis");
            var invalidEntity = new SousReservation();

            // Act
            var result = await controller.PostSousReservation(invalidEntity);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(BadRequestObjectResult));
            // On vérifie que la méthode AddAsync n'a JAMAIS été appelée car le modèle est invalide
            mockRepository.Verify(repo => repo.AddAsync(It.IsAny<SousReservation>()), Times.Never);
        }

        // ==========================================================
        // 4. TESTS PUT (3 chemins : Mauvais ID / Pas trouvé / Succès)
        // ==========================================================
        [TestMethod()]
        public async Task PutSousReservation_IdMismatch_ReturnsBadRequest()
        {
            // Arrange
            var updatedEntity = new SousReservation { SousReservationId = 2 };

            // Act
            var result = await controller.PutSousReservation(1, updatedEntity);

            // Assert
            // Put renvoie IActionResult directement
            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

        [TestMethod()]
        public async Task PutSousReservation_NotFound_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync((SousReservation)null);

            // Act
            var result = await controller.PutSousReservation(1, new SousReservation { SousReservationId = 1 });

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task PutSousReservation_Valid_ReturnsNoContent()
        {
            // Arrange
            var existing = new SousReservation { SousReservationId = 1 };
            var updated = new SousReservation { SousReservationId = 1, ResaNum = 200 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(existing);
            mockRepository.Setup(repo => repo.UpdateAsync(existing, updated)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.PutSousReservation(1, updated);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.UpdateAsync(existing, updated), Times.Once);
        }

        // ==========================================================
        // 5. TESTS DELETE (2 chemins : Pas trouvé / Succès)
        // ==========================================================
        [TestMethod()]
        public async Task DeleteSousReservation_NotFound_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((SousReservation)null);

            // Act
            var result = await controller.DeleteSousReservation(99);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task DeleteSousReservation_Found_ReturnsNoContent()
        {
            // Arrange
            var entity = new SousReservation { SousReservationId = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(entity);
            mockRepository.Setup(repo => repo.DeleteAsync(entity)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.DeleteSousReservation(1);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.DeleteAsync(entity), Times.Once);
        }
    }
}