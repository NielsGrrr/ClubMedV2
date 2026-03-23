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
    public class PhotosControllerTests
    {
        private PhotosController controller;
        private Mock<IDataRepository<Photo>> mockRepository;

        [TestInitialize()]
        public void TestInitialize()
        {
            mockRepository = new Mock<IDataRepository<Photo>>();
            controller = new PhotosController(mockRepository.Object);
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
        public async Task GetPhotosTest()
        {
            // Arrange
            var fausseListe = new List<Photo> { new Photo { NumPhoto = 1 }, new Photo { NumPhoto = 2 } };
            mockRepository.Setup(repo => repo.GetAllAsync()).ReturnsAsync(fausseListe);

            // Act
            var result = await controller.GetPhotos();

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(OkObjectResult));
            var okResult = result.Result as OkObjectResult;
            var liste = okResult.Value as IEnumerable<Photo>;
            Assert.AreEqual(2, liste.Count());
        }

        // ==========================================================
        // 2. TESTS GET BY ID
        // ==========================================================
        [TestMethod()]
        public async Task GetPhoto_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(9999)).ReturnsAsync((Photo)null);

            // Act
            var result = await controller.GetPhoto(9999);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task GetPhoto_ExistingId_ReturnsOk()
        {
            // Arrange
            var faussePhoto = new Photo { NumPhoto = 1, Url = "https://img.com/1.jpg" };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(faussePhoto);

            // Act
            var result = await controller.GetPhoto(1);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(OkObjectResult));
            var okResult = result.Result as OkObjectResult;
            var photoRecuperee = okResult.Value as Photo;
            Assert.AreEqual("https://img.com/1.jpg", photoRecuperee.Url);
        }

        // ==========================================================
        // 3. TESTS PUT
        // ==========================================================
        [TestMethod()]
        public async Task PutPhoto_IdMismatch_ReturnsBadRequest()
        {
            // Arrange
            var photo = new Photo { NumPhoto = 2 };

            // Act
            var result = await controller.PutPhoto(1, photo);

            // Assert
            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

        [TestMethod()]
        public async Task PutPhoto_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            var photo = new Photo { NumPhoto = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync((Photo)null);

            // Act
            var result = await controller.PutPhoto(1, photo);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task PutPhoto_ValidRequest_ReturnsNoContent()
        {
            // Arrange
            var existant = new Photo { NumPhoto = 1 };
            var modifie = new Photo { NumPhoto = 1, Url = "nouveau.jpg" };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(existant);
            mockRepository.Setup(repo => repo.UpdateAsync(existant, modifie)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.PutPhoto(1, modifie);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.UpdateAsync(existant, modifie), Times.Once);
        }

        // ==========================================================
        // 4. TESTS POST
        // ==========================================================
        [TestMethod()]
        public async Task PostPhoto_ValidObject_ReturnsCreatedAtAction()
        {
            // Arrange
            var photo = new Photo { NumPhoto = 1, Url = "test.jpg" };
            mockRepository.Setup(repo => repo.AddAsync(photo)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.PostPhoto(photo);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(CreatedAtActionResult));
            mockRepository.Verify(repo => repo.AddAsync(photo), Times.Once);
        }

        // ==========================================================
        // 5. TESTS DELETE
        // ==========================================================
        [TestMethod()]
        public async Task DeletePhoto_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(9999)).ReturnsAsync((Photo)null);

            // Act
            var result = await controller.DeletePhoto(9999);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task DeletePhoto_ExistingId_ReturnsNoContent()
        {
            // Arrange
            var photo = new Photo { NumPhoto = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(photo);
            mockRepository.Setup(repo => repo.DeleteAsync(photo)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.DeletePhoto(1);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.DeleteAsync(photo), Times.Once);
        }
    }
}