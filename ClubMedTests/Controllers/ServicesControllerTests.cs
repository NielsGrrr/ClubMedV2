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
    public class ServicesControllerTests
    {
        private ServicesController controller;
        private Mock<IDataRepository<Service>> mockRepository;

        [TestInitialize()]
        public void TestInitialize()
        {
            mockRepository = new Mock<IDataRepository<Service>>();
            controller = new ServicesController(mockRepository.Object);
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
        public async Task GetServicesTest()
        {
            // Arrange
            var fausseListe = new List<Service> { new Service { NumService = 1 }, new Service { NumService = 2 } };
            mockRepository.Setup(repo => repo.GetAllAsync()).ReturnsAsync(fausseListe);

            // Act
            var result = await controller.GetServices();

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(OkObjectResult));
            var okResult = result.Result as OkObjectResult;
            var liste = okResult.Value as IEnumerable<Service>;
            Assert.AreEqual(2, liste.Count());
        }

        // ==========================================================
        // 2. TESTS GET BY ID
        // ==========================================================
        [TestMethod()]
        public async Task GetService_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(9999)).ReturnsAsync((Service)null);

            // Act
            var result = await controller.GetService(9999);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task GetService_ExistingId_ReturnsOk()
        {
            // Arrange
            var fauxService = new Service { NumService = 1, Nom = "Ménage" };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(fauxService);

            // Act
            var result = await controller.GetService(1);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(OkObjectResult));
            var okResult = result.Result as OkObjectResult;
            var serviceRecupere = okResult.Value as Service;
            Assert.AreEqual("Ménage", serviceRecupere.Nom);
        }

        // ==========================================================
        // 3. TESTS PUT
        // ==========================================================
        [TestMethod()]
        public async Task PutService_IdMismatch_ReturnsBadRequest()
        {
            // Arrange
            var service = new Service { NumService = 2 };

            // Act
            var result = await controller.PutService(1, service);

            // Assert
            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

        [TestMethod()]
        public async Task PutService_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            var service = new Service { NumService = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync((Service)null);

            // Act
            var result = await controller.PutService(1, service);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task PutService_ValidRequest_ReturnsNoContent()
        {
            // Arrange
            var existant = new Service { NumService = 1 };
            var modifie = new Service { NumService = 1, Nom = "Nouveau Service" };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(existant);
            mockRepository.Setup(repo => repo.UpdateAsync(existant, modifie)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.PutService(1, modifie);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.UpdateAsync(existant, modifie), Times.Once);
        }

        // ==========================================================
        // 4. TESTS POST
        // ==========================================================
        [TestMethod()]
        public async Task PostService_ValidObject_ReturnsCreatedAtAction()
        {
            // Arrange
            var service = new Service { NumService = 1, Nom = "Test" };
            mockRepository.Setup(repo => repo.AddAsync(service)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.PostService(service);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(CreatedAtActionResult));
            mockRepository.Verify(repo => repo.AddAsync(service), Times.Once);
        }

        // ==========================================================
        // 5. TESTS DELETE
        // ==========================================================
        [TestMethod()]
        public async Task DeleteService_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(9999)).ReturnsAsync((Service)null);

            // Act
            var result = await controller.DeleteService(9999);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task DeleteService_ExistingId_ReturnsNoContent()
        {
            // Arrange
            var service = new Service { NumService = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(service);
            mockRepository.Setup(repo => repo.DeleteAsync(service)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.DeleteService(1);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.DeleteAsync(service), Times.Once);
        }
    }
}