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
    public class TypeChambresControllerTests
    {
        private TypeChambresController controller;
        private Mock<IDataRepository<TypeChambre>> mockRepository;

        [TestInitialize()]
        public void TestInitialize()
        {
            mockRepository = new Mock<IDataRepository<TypeChambre>>();
            controller = new TypeChambresController(mockRepository.Object);
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
        public async Task GetTypesChambresTest()
        {
            // Arrange
            var fausseListe = new List<TypeChambre> { new TypeChambre { IdTypeChambre = 1 }, new TypeChambre { IdTypeChambre = 2 } };
            mockRepository.Setup(repo => repo.GetAllAsync()).ReturnsAsync(fausseListe);

            // Act
            var result = await controller.GetTypesChambres();

            // Assert
            Assert.IsInstanceOfType(result.Value, typeof(IEnumerable<TypeChambre>));
            var liste = result.Value as IEnumerable<TypeChambre>;
            Assert.AreEqual(2, liste.Count());
        }

        // ==========================================================
        // 2. TESTS GET BY ID
        // ==========================================================
        [TestMethod()]
        public async Task GetTypeChambre_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((TypeChambre)null);

            // Act
            var result = await controller.GetTypeChambreById(99);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task GetTypeChambre_ExistingId_ReturnsTypeChambre()
        {
            // Arrange
            var fauxType = new TypeChambre { IdTypeChambre = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(fauxType);

            // Act
            var result = await controller.GetTypeChambreById(1);

            // Assert
            Assert.IsInstanceOfType(result.Value, typeof(TypeChambre));
            var typeRecupere = result.Value as TypeChambre;
            Assert.AreEqual(1, typeRecupere.IdTypeChambre);
        }

        // ==========================================================
        // 3. TESTS PUT
        // ==========================================================
        [TestMethod()]
        public async Task PutTypeChambre_IdMismatch_ReturnsBadRequest()
        {
            // Arrange
            var typeChambre = new TypeChambre { IdTypeChambre = 2 };

            // Act
            var result = await controller.PutTypeChambre(1, typeChambre);

            // Assert
            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

        [TestMethod()]
        public async Task PutTypeChambre_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            var typeChambre = new TypeChambre { IdTypeChambre = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync((TypeChambre)null);

            // Act
            var result = await controller.PutTypeChambre(1, typeChambre);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task PutTypeChambre_ValidRequest_ReturnsNoContent()
        {
            // Arrange
            var existant = new TypeChambre { IdTypeChambre = 1 };
            var modifie = new TypeChambre { IdTypeChambre = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(existant);
            mockRepository.Setup(repo => repo.UpdateAsync(existant, modifie)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.PutTypeChambre(1, modifie);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.UpdateAsync(existant, modifie), Times.Once);
        }

        // ==========================================================
        // 4. TESTS POST
        // ==========================================================
        [TestMethod()]
        public async Task PostTypeChambre_InvalidModel_ReturnsBadRequest()
        {
            // Arrange
            controller.ModelState.AddModelError("TextePresentation", "Requis"); // Simule une erreur de validation
            var typeChambre = new TypeChambre();

            // Act
            var result = await controller.PostTypeChambre(typeChambre); // if (!ModelState.IsValid)

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(BadRequestObjectResult));
        }

        [TestMethod()]
        public async Task PostTypeChambre_ExistingId_ReturnsConflict()
        {
            // Arrange
            var typeExistant = new TypeChambre { IdTypeChambre = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(typeExistant);

            // Act
            var result = await controller.PostTypeChambre(typeExistant);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(ConflictObjectResult));
        }

        [TestMethod()]
        public async Task PostTypeChambre_ValidNewObject_ReturnsCreatedAtAction()
        {
            // Arrange
            var nouveauType = new TypeChambre { IdTypeChambre = 2 };
            mockRepository.Setup(repo => repo.GetByIdAsync(2)).ReturnsAsync((TypeChambre)null);
            mockRepository.Setup(repo => repo.AddAsync(nouveauType)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.PostTypeChambre(nouveauType);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(CreatedAtActionResult));
            var actionResult = result.Result as CreatedAtActionResult;

            // Vérification avec le nom exact mis dans ton contrôleur ("GetTypeChambreById")
            Assert.AreEqual("GetTypeChambreById", actionResult.ActionName);
            mockRepository.Verify(repo => repo.AddAsync(nouveauType), Times.Once);
        }

        // ==========================================================
        // 5. TESTS DELETE
        // ==========================================================
        [TestMethod()]
        public async Task DeleteTypeChambre_NonExistingId_ReturnsNotFound()
        {
            // Arrange
            mockRepository.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((TypeChambre)null);

            // Act
            var result = await controller.DeleteTypeChambre(99);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task DeleteTypeChambre_ExistingId_ReturnsNoContent()
        {
            // Arrange
            var typeChambre = new TypeChambre { IdTypeChambre = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(typeChambre);
            mockRepository.Setup(repo => repo.DeleteAsync(typeChambre)).Returns(Task.CompletedTask);

            // Act
            var result = await controller.DeleteTypeChambre(1);

            // Assert
            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.DeleteAsync(typeChambre), Times.Once);
        }
    }
}