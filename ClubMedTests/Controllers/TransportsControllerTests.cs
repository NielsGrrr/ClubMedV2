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
    public class TransportsControllerTests
    {
        private Mock<IDataRepository<Transport>> mockRepository;
        private TransportsController controller;

        [TestInitialize()]
        public void TestInitialize()
        {
            mockRepository = new Mock<IDataRepository<Transport>>();
            controller = new TransportsController(mockRepository.Object);
        }

        // --- GET ALL ---
        [TestMethod()]
        public async Task GetTransports_ReturnsAll()
        {
            // Arrange
            var mockData = new List<Transport> { new Transport { TransportId = 1 } };
            mockRepository.Setup(repo => repo.GetAllAsync()).ReturnsAsync(mockData);

            // Act
            var result = await controller.GetTransports();

            // Assert
            Assert.IsInstanceOfType(result.Value, typeof(IEnumerable<Transport>));
        }

        // --- GET BY ID ---
        [TestMethod()]
        public async Task GetById_Existing_ReturnsItem()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(new Transport { TransportId = 1 });

            // Act
            var result = await controller.GetById(1);

            // Assert
            Assert.IsInstanceOfType(result.Value, typeof(Transport));
        }

        [TestMethod()]
        public async Task GetById_NotExisting_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((Transport)null);

            // Act
            var result = await controller.GetById(99);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        // --- POST ---
        [TestMethod()]
        public async Task PostTransport_Valid_ReturnsCreated()
        {
            // Arrange
            var entity = new Transport { TransportId = 1 };

            // Act
            var actionResult = await controller.PostTransport(entity);

            // Assert
            Assert.IsInstanceOfType(actionResult.Result, typeof(CreatedAtActionResult));
        }

        [TestMethod()]
        public async Task PostTransport_Invalid_ReturnsBadRequest()
        {
            // Arrange
            controller.ModelState.AddModelError("Erreur", "Test");

            // Act
            var result = await controller.PostTransport(new Transport());

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(BadRequestObjectResult));
        }

        // --- PUT ---
        [TestMethod()]
        public async Task PutTransport_IdMismatch_ReturnsBadRequest()
        {
            // Arrange
            var entity = new Transport { TransportId = 2 };

            // Act
            var result = await controller.PutTransport(1, entity);

            // Assert
            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

        [TestMethod()]
        public async Task PutTransport_NotFound_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync((Transport)null);

            // Act
            var result = await controller.PutTransport(1, new Transport { TransportId = 1 });

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task PutTransport_Valid_ReturnsNoContent()
        {
            // Arrange
            var existing = new Transport { TransportId = 1 };
            var updated = new Transport { TransportId = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(existing);

            // Act
            var result = await controller.PutTransport(1, updated);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.UpdateAsync(existing, updated), Times.Once);
        }

        // --- DELETE ---
        [TestMethod()]
        public async Task DeleteTransport_NotFound_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((Transport)null);

            // Act
            var result = await controller.DeleteTransport(99);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task DeleteTransport_Found_ReturnsNoContent()
        {
            // Arrange
            var entity = new Transport { TransportId = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(entity);

            // Act
            var result = await controller.DeleteTransport(1);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
        }
    }
}