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
    public class ReservationsControllerTests
    {
        private Mock<IDataRepository<Reservation>> mockRepository;
        private ReservationsController controller;

        [TestInitialize()]
        public void TestInitialize()
        {
            mockRepository = new Mock<IDataRepository<Reservation>>();
            controller = new ReservationsController(mockRepository.Object);
        }

        // --- GET ALL ---
        [TestMethod()]
        public async Task GetReservations_ReturnsAll()
        {
            // Arrange
            var mockData = new List<Reservation> { new Reservation { ResaNum = 1 }, new Reservation { ResaNum = 2 } };
            mockRepository.Setup(repo => repo.GetAllAsync()).ReturnsAsync(mockData);

            // Act
            var result = await controller.GetReservations();

            // Assert
            Assert.IsInstanceOfType(result.Value, typeof(IEnumerable<Reservation>));
            Assert.AreEqual(2, (result.Value as List<Reservation>).Count);
        }

        // --- GET BY ID ---
        [TestMethod()]
        public async Task GetById_Existing_ReturnsItem()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(new Reservation { ResaNum = 1 });

            // Act
            var result = await controller.GetById(1);

            // Assert
            Assert.IsInstanceOfType(result.Value, typeof(Reservation));
        }

        [TestMethod()]
        public async Task GetById_NotExisting_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((Reservation)null);

            // Act
            var result = await controller.GetById(99);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        // --- POST ---
        [TestMethod()]
        public async Task PostReservation_Valid_ReturnsCreated()
        {
            // Arrange
            var entity = new Reservation { ResaNum = 1 };
            mockRepository.Setup(repo => repo.AddAsync(entity)).Returns(Task.CompletedTask);

            // Act
            var actionResult = await controller.PostReservation(entity);

            // Assert
            Assert.IsInstanceOfType(actionResult.Result, typeof(CreatedAtActionResult));
        }

        [TestMethod()]
        public async Task PostReservation_Invalid_ReturnsBadRequest()
        {
            // Arrange
            controller.ModelState.AddModelError("Erreur", "Test");

            // Act
            var result = await controller.PostReservation(new Reservation());

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(BadRequestObjectResult));
        }

        // --- PUT ---
        [TestMethod()]
        public async Task PutReservation_IdMismatch_ReturnsBadRequest()
        {
            // Arrange
            var updatedEntity = new Reservation { ResaNum = 2 };

            // Act
            var result = await controller.PutReservation(1, updatedEntity);

            // Assert
            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

        [TestMethod()]
        public async Task PutReservation_NotFound_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync((Reservation)null);

            // Act
            var result = await controller.PutReservation(1, new Reservation { ResaNum = 1 });

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task PutReservation_Valid_ReturnsNoContent()
        {
            // Arrange
            var existing = new Reservation { ResaNum = 1 };
            var updated = new Reservation { ResaNum = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(existing);

            // Act
            var result = await controller.PutReservation(1, updated);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.UpdateAsync(existing, updated), Times.Once);
        }

        // --- DELETE ---
        [TestMethod()]
        public async Task DeleteReservation_NotFound_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((Reservation)null);

            // Act
            var result = await controller.DeleteReservation(99);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task DeleteReservation_Found_ReturnsNoContent()
        {
            // Arrange
            var entity = new Reservation { ResaNum = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(entity);

            // Act
            var result = await controller.DeleteReservation(1);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.DeleteAsync(entity), Times.Once);
        }
    }
}