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
    public class TypeActivitesControllerTests
    {
        private TypeActivitesController controller;
        private Mock<IDataRepository<TypeActivite>> mockRepository;

        [TestInitialize()]
        public void TestInitialize()
        {
            mockRepository = new Mock<IDataRepository<TypeActivite>>();
            controller = new TypeActivitesController(mockRepository.Object);
        }

        [TestCleanup]
        public void TestCleanup()
        {
            mockRepository = null;
            controller = null;
        }

        [TestMethod()]
        public async Task GetTypesActivitesTest()
        {
            List<TypeActivite> fausseListe = new List<TypeActivite> { new TypeActivite { TypeActiviteNum = 1 }, new TypeActivite { TypeActiviteNum = 2 } };
            mockRepository.Setup(repo => repo.GetAllAsync()).ReturnsAsync(fausseListe);

            var result = await controller.GetTypesActivites();

            Assert.IsInstanceOfType(result.Value, typeof(IEnumerable<TypeActivite>));
            Assert.AreEqual(2, result.Value.Count());
        }

        [TestMethod()]
        public async Task GetTypeActivite_NonExistingIdPassed_ReturnsNotFoundResult()
        {
            mockRepository.Setup(repo => repo.GetByIdAsync(9999)).ReturnsAsync((TypeActivite)null);
            var result = await controller.GetTypeActivite(9999);
            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task GetTypeActivite_ExistingIdPassed_ReturnsRightItem()
        {
            // Vérifie si la propriété s'appelle TypeActiviteTitre ou NomType dans ta classe
            var fauxType = new TypeActivite { TypeActiviteNum = 1, TypeActiviteTitre = "Test" };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(fauxType);

            var result = await controller.GetTypeActivite(1);

            Assert.IsInstanceOfType(result.Value, typeof(TypeActivite));
            Assert.AreEqual("Test", result.Value.TypeActiviteTitre);
        }

        [TestMethod()]
        public async Task PutTypeActivite_IdMismatch_ReturnsBadRequest()
        {
            var typeActivite = new TypeActivite { TypeActiviteNum = 2 };
            var result = await controller.PutTypeActivite(1, typeActivite);
            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

        [TestMethod()]
        public async Task PutTypeActivite_NonExistingId_ReturnsNotFound()
        {
            var typeActivite = new TypeActivite { TypeActiviteNum = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync((TypeActivite)null);

            var result = await controller.PutTypeActivite(1, typeActivite);
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task PutTypeActivite_ValidRequest_ReturnsNoContent()
        {
            var typeExistant = new TypeActivite { TypeActiviteNum = 1 };
            var typeModifie = new TypeActivite { TypeActiviteNum = 1, TypeActiviteTitre = "Nouveau" };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(typeExistant);
            mockRepository.Setup(repo => repo.UpdateAsync(typeExistant, typeModifie)).Returns(Task.CompletedTask);

            var result = await controller.PutTypeActivite(1, typeModifie);

            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.UpdateAsync(typeExistant, typeModifie), Times.Once);
        }

        [TestMethod()]
        public async Task PostTypeActivite_InvalidModel_ReturnsBadRequest()
        {
            controller.ModelState.AddModelError("Titre", "Requis");
            var typeActivite = new TypeActivite();

            var result = await controller.PostTypeActivite(typeActivite);
            Assert.IsInstanceOfType(result.Result, typeof(BadRequestObjectResult));
        }

        [TestMethod()]
        public async Task PostTypeActivite_ValidObject_ReturnsCreatedAtAction()
        {
            var typeActivite = new TypeActivite { TypeActiviteNum = 1, TypeActiviteTitre = "Nouveau" };
            mockRepository.Setup(repo => repo.AddAsync(typeActivite)).Returns(Task.CompletedTask);

            var result = await controller.PostTypeActivite(typeActivite);

            Assert.IsInstanceOfType(result.Result, typeof(CreatedAtActionResult));
            mockRepository.Verify(repo => repo.AddAsync(typeActivite), Times.Once);
        }

        [TestMethod()]
        public async Task DeleteTypeActivite_NonExistingId_ReturnsNotFound()
        {
            mockRepository.Setup(repo => repo.GetByIdAsync(9999)).ReturnsAsync((TypeActivite)null);
            var result = await controller.DeleteTypeActivite(9999);
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task DeleteTypeActivite_ExistingId_ReturnsNoContent()
        {
            var typeActivite = new TypeActivite { TypeActiviteNum = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(typeActivite);
            mockRepository.Setup(repo => repo.DeleteAsync(typeActivite)).Returns(Task.CompletedTask);

            var result = await controller.DeleteTypeActivite(1);

            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.DeleteAsync(typeActivite), Times.Once);
        }
    }
}