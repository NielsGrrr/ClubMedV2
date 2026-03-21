using Microsoft.AspNetCore.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using ClubMed.Controllers;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ClubMed.Tests.Controllers
{
    [TestClass()]
    public class ClientsControllerTests
    {
        private Mock<IDataRepository<Client>> mockRepository;
        private ClientsController controller;

        [TestInitialize()]
        public void TestInitialize()
        {
            mockRepository = new Mock<IDataRepository<Client>>();
            controller = new ClientsController(mockRepository.Object);
        }

        // --- GET ALL ---
        [TestMethod()]
        public async Task GetClients_ReturnsAll()
        {
            // Arrange
            var fauxClients = new List<Client> { new Client { NumClient = 1 }, new Client { NumClient = 2 } };
            mockRepository.Setup(repo => repo.GetAllAsync()).ReturnsAsync(fauxClients);

            // Act
            var result = await controller.GetClients();

            // Assert
            Assert.IsInstanceOfType(result.Value, typeof(IEnumerable<Client>));
            var liste = result.Value as List<Client>;
            Assert.AreEqual(2, liste.Count);
        }

        // --- GET BY ID ---
        [TestMethod()]
        public async Task GetById_ExistingId_ReturnsClient()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(new Client { NumClient = 1 });

            // Act
            var result = await controller.GetById(1);

            // Assert
            Assert.IsInstanceOfType(result.Value, typeof(Client));
            Assert.AreEqual(1, result.Value.NumClient);
        }

        [TestMethod()]
        public async Task GetById_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((Client)null);

            // Act
            var result = await controller.GetById(99);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        // --- GET BY EMAIL ---
        [TestMethod()]
        public async Task GetByEmail_ExistingEmail_ReturnsClient()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByStringAsync("test@test.com")).ReturnsAsync(new Client { Email = "test@test.com" });

            // Act
            var result = await controller.GetByEmail("test@test.com");

            // Assert
            Assert.IsInstanceOfType(result.Value, typeof(Client));
            Assert.AreEqual("test@test.com", result.Value.Email);
        }

        [TestMethod()]
        public async Task GetByEmail_NonExistingEmail_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByStringAsync("inconnu@test.com")).ReturnsAsync((Client)null);

            // Act
            var result = await controller.GetByEmail("inconnu@test.com");

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        // --- POST ---
        [TestMethod()]
        public async Task PostClient_ValidObject_ReturnsCreatedAtAction()
        {
            // Arrange
            var clientAEnvoyer = new Client { NumClient = 3 };
            mockRepository.Setup(repo => repo.AddAsync(clientAEnvoyer)).Returns(Task.CompletedTask);

            // Act
            var actionResult = await controller.PostClient(clientAEnvoyer);

            // Assert
            Assert.IsInstanceOfType(actionResult.Result, typeof(CreatedAtActionResult));
            var result = actionResult.Result as CreatedAtActionResult;
            Assert.AreEqual("GetById", result.ActionName);
        }

        [TestMethod()]
        public async Task PostClient_InvalidModel_ReturnsBadRequest()
        {
            // Arrange
            controller.ModelState.AddModelError("Nom", "Le nom est requis");
            var clientInvalide = new Client();

            // Act
            var result = await controller.PostClient(clientInvalide);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(BadRequestObjectResult));
        }

        // --- PUT ---
        [TestMethod()]
        public async Task PutClient_IdMismatch_ReturnsBadRequest()
        {
            // Arrange
            var clientModifie = new Client { NumClient = 2 };

            // Act
            var result = await controller.PutClient(1, clientModifie);

            // Assert
            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

        [TestMethod()]
        public async Task PutClient_ClientNotFound_ReturnsNotFound()
        {
            // Arrange
            var clientModifie = new Client { NumClient = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync((Client)null);

            // Act
            var result = await controller.PutClient(1, clientModifie);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task PutClient_Valid_ReturnsNoContent()
        {
            // Arrange
            var clientExistant = new Client { NumClient = 1, Nom = "AncienNom" };
            var clientModifie = new Client { NumClient = 1, Nom = "NouveauNom" };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(clientExistant);
            mockRepository.Setup(repo => repo.UpdateAsync(clientExistant, clientModifie)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.PutClient(1, clientModifie);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.UpdateAsync(clientExistant, clientModifie), Times.Once);
        }

        // --- DELETE ---
        [TestMethod()]
        public async Task DeleteClient_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((Client)null);

            // Act
            var result = await controller.DeleteClient(99);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task DeleteClient_ExistingId_ReturnsNoContent()
        {
            // Arrange
            var clientASupprimer = new Client { NumClient = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(clientASupprimer);
            mockRepository.Setup(repo => repo.DeleteAsync(clientASupprimer)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.DeleteClient(1);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.DeleteAsync(clientASupprimer), Times.Once);
        }
    }
}