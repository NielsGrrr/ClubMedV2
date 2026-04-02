using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using ClubMed.Controllers;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using System.Collections.Generic;
using System.Security.Claims;
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

        private void SetUserContext(string userId, string role)
        {
            var user = new ClaimsPrincipal(new ClaimsIdentity(new Claim[]
            {
                new Claim(ClaimTypes.NameIdentifier, userId),
                new Claim(ClaimTypes.Role, role)
            }, "mock"));

            controller.ControllerContext = new ControllerContext()
            {
                HttpContext = new DefaultHttpContext() { User = user }
            };
        }

        // --- GET ALL ---
        [TestMethod()]
        public async Task GetClients_ReturnsAll()
        {
            var fauxClients = new List<Client> { new Client { NumClient = 1 }, new Client { NumClient = 2 } };
            mockRepository.Setup(repo => repo.GetAllAsync()).ReturnsAsync(fauxClients);

            var result = await controller.GetClients();

            Assert.IsInstanceOfType(result.Value, typeof(IEnumerable<Client>));
            var liste = result.Value as List<Client>;
            Assert.AreEqual(2, liste.Count);
        }

        // --- GET BY ID ---
        [TestMethod()]
        public async Task GetById_ExistingId_ReturnsClient()
        {
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(new Client { NumClient = 1 });

            var result = await controller.GetById(1);

            Assert.IsInstanceOfType(result.Value, typeof(Client));
            Assert.AreEqual(1, result.Value.NumClient);
        }

        [TestMethod()]
        public async Task GetById_NonExistingId_ReturnsNotFound()
        {
            mockRepository.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((Client)null);
            var result = await controller.GetById(99);
            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        // --- GET BY EMAIL ---
        [TestMethod()]
        public async Task GetByEmail_ExistingEmail_ReturnsClient()
        {
            mockRepository.Setup(repo => repo.GetByStringAsync("test@test.com")).ReturnsAsync(new Client { Email = "test@test.com" });
            var result = await controller.GetByEmail("test@test.com");
            Assert.IsInstanceOfType(result.Value, typeof(Client));
            Assert.AreEqual("test@test.com", result.Value.Email);
        }

        [TestMethod()]
        public async Task GetByEmail_NonExistingEmail_ReturnsNotFound()
        {
            mockRepository.Setup(repo => repo.GetByStringAsync("inconnu@test.com")).ReturnsAsync((Client)null);
            var result = await controller.GetByEmail("inconnu@test.com");
            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        // --- POST ---
        [TestMethod()]
        public async Task PostClient_ValidObject_ReturnsCreatedAtAction()
        {
            var clientAEnvoyer = new Client { NumClient = 3 };
            mockRepository.Setup(repo => repo.AddAsync(clientAEnvoyer)).Returns(Task.CompletedTask);
            var actionResult = await controller.PostClient(clientAEnvoyer);
            Assert.IsInstanceOfType(actionResult.Result, typeof(CreatedAtActionResult));
            var result = actionResult.Result as CreatedAtActionResult;
            Assert.AreEqual("GetById", result.ActionName);
        }

        [TestMethod()]
        public async Task PostClient_InvalidModel_ReturnsBadRequest()
        {
            controller.ModelState.AddModelError("Nom", "Le nom est requis");
            var clientInvalide = new Client();
            var result = await controller.PostClient(clientInvalide);
            Assert.IsInstanceOfType(result.Result, typeof(BadRequestObjectResult));
        }

        // --- PUT ---
        [TestMethod()]
        public async Task PutClient_IdMismatch_ReturnsBadRequest()
        {
            SetUserContext("1", "particulier");
            var result = await controller.PutClient(1, new Client { NumClient = 2 });
            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

        [TestMethod()]
        public async Task PutClient_NonOwnerAndNonAdmin_ReturnsForbid()
        {
            // Utilisateur "2" essaie de modifier l'utilisateur "1"
            SetUserContext("2", "particulier");
            var result = await controller.PutClient(1, new Client { NumClient = 1 });
            Assert.IsInstanceOfType(result, typeof(ForbidResult));
        }

        [TestMethod()]
        public async Task PutClient_Admin_ReturnsNoContent()
        {
            // Admin essaie de modifier l'utilisateur "1"
            SetUserContext("99", "admin");
            var clientExistant = new Client { NumClient = 1, Nom = "AncienNom" };
            var clientModifie = new Client { NumClient = 1, Nom = "NouveauNom" };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(clientExistant);
            mockRepository.Setup(repo => repo.UpdateAsync(clientExistant, clientModifie)).Returns(Task.CompletedTask);

            var result = await controller.PutClient(1, clientModifie);

            Assert.IsInstanceOfType(result, typeof(NoContentResult));
        }

        [TestMethod()]
        public async Task PutClient_ClientNotFound_ReturnsNotFound()
        {
            SetUserContext("1", "particulier");
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync((Client)null);
            var result = await controller.PutClient(1, new Client { NumClient = 1 });
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task PutClient_ValidOwner_ReturnsNoContent()
        {
            SetUserContext("1", "particulier");
            var clientExistant = new Client { NumClient = 1, Nom = "AncienNom", MotDePasseCrypter = "oldhash" };
            var clientModifie = new Client { NumClient = 1, Nom = "NouveauNom", MotDePasseCrypter = "newpass" };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(clientExistant);
            mockRepository.Setup(repo => repo.UpdateAsync(clientExistant, clientModifie)).Returns(Task.CompletedTask);

            var result = await controller.PutClient(1, clientModifie);

            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            Assert.AreNotEqual("newpass", clientModifie.MotDePasseCrypter); // Vérifie que le hachage a eu lieu
            mockRepository.Verify(repo => repo.UpdateAsync(clientExistant, clientModifie), Times.Once);
        }

        // --- DELETE ---
        [TestMethod()]
        public async Task DeleteClient_NonOwnerAndNonAdmin_ReturnsForbid()
        {
            // Utilisateur "2" essaie de supprimer l'utilisateur "1"
            SetUserContext("2", "particulier");
            var result = await controller.DeleteClient(1);
            Assert.IsInstanceOfType(result, typeof(ForbidResult));
        }

        [TestMethod()]
        public async Task DeleteClient_Admin_ReturnsNoContent()
        {
            SetUserContext("99", "admin");
            var clientASupprimer = new Client { NumClient = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(clientASupprimer);
            mockRepository.Setup(repo => repo.DeleteAsync(clientASupprimer)).Returns(Task.CompletedTask);

            var result = await controller.DeleteClient(1);

            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.DeleteAsync(clientASupprimer), Times.Once);
        }

        [TestMethod()]
        public async Task DeleteClient_NonExistingId_ReturnsNotFound()
        {
            SetUserContext("99", "particulier");
            mockRepository.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((Client)null);
            var result = await controller.DeleteClient(99);
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task DeleteClient_ExistingOwnerId_ReturnsNoContent()
        {
            SetUserContext("1", "particulier");
            var clientASupprimer = new Client { NumClient = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(clientASupprimer);
            mockRepository.Setup(repo => repo.DeleteAsync(clientASupprimer)).Returns(Task.CompletedTask);

            var result = await controller.DeleteClient(1);

            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.DeleteAsync(clientASupprimer), Times.Once);
        }
    }
}