using Microsoft.AspNetCore.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using ClubMed.Controllers;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ClubMed.Controllers.Tests
{
    [TestClass()]
    public class TransactionsControllerTests
    {
        private Mock<IDataRepository<Transaction>> mockRepository;
        private TransactionsController controller;

        [TestInitialize()]
        public void TestInitialize()
        {
            mockRepository = new Mock<IDataRepository<Transaction>>();
            controller = new TransactionsController(mockRepository.Object);
        }

        // --- GET ALL ---
        [TestMethod()]
        public async Task GetTransactions_ReturnsAll()
        {
            // Arrange
            var mockData = new List<Transaction> { new Transaction { TransactionId = 1 } };
            mockRepository.Setup(repo => repo.GetAllAsync()).ReturnsAsync(mockData);

            // Act
            var result = await controller.GetTransactions();

            // Assert
            Assert.IsInstanceOfType(result.Value, typeof(IEnumerable<Transaction>));
        }

        // --- GET BY ID ---
        [TestMethod()]
        public async Task GetById_Existing_ReturnsItem()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(new Transaction { TransactionId = 1 });

            // Act
            var result = await controller.GetById(1);

            // Assert
            Assert.IsInstanceOfType(result.Value, typeof(Transaction));
        }

        [TestMethod()]
        public async Task GetById_NotExisting_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((Transaction)null);

            // Act
            var result = await controller.GetById(99);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        // --- POST ---
        [TestMethod()]
        public async Task PostTransaction_Valid_ReturnsCreated()
        {
            // Arrange
            var entity = new Transaction { TransactionId = 1 };

            // Act
            var actionResult = await controller.PostTransaction(entity);

            // Assert
            Assert.IsInstanceOfType(actionResult.Result, typeof(CreatedAtActionResult));
        }

        [TestMethod()]
        public async Task PostTransaction_Invalid_ReturnsBadRequest()
        {
            // Arrange
            controller.ModelState.AddModelError("Erreur", "Test");

            // Act
            var result = await controller.PostTransaction(new Transaction());

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(BadRequestObjectResult));
        }

        // --- PUT ---
        [TestMethod()]
        public async Task PutTransaction_IdMismatch_ReturnsBadRequest()
        {
            // Arrange
            var entity = new Transaction { TransactionId = 2 };

            // Act
            var result = await controller.PutTransaction(1, entity);

            // Assert
            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

        [TestMethod()]
        public async Task PutTransaction_NotFound_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync((Transaction)null);

            // Act
            var result = await controller.PutTransaction(1, new Transaction { TransactionId = 1 });

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task PutTransaction_Valid_ReturnsNoContent()
        {
            // Arrange
            var existing = new Transaction { TransactionId = 1 };
            var updated = new Transaction { TransactionId = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(existing);

            // Act
            var result = await controller.PutTransaction(1, updated);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.UpdateAsync(existing, updated), Times.Once);
        }

        // --- DELETE ---
        [TestMethod()]
        public async Task DeleteTransaction_NotFound_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((Transaction)null);

            // Act
            var result = await controller.DeleteTransaction(99);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task DeleteTransaction_Found_ReturnsNoContent()
        {
            // Arrange
            var entity = new Transaction { TransactionId = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(entity);

            // Act
            var result = await controller.DeleteTransaction(1);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
        }
    }
}