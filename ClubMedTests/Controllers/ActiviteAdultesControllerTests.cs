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
    public class ActiviteAdultesControllerTests
    {
        private ActiviteAdultesController controller;
        private Mock<IDataRepository<ActiviteAdulte>> mockRepository;

        [TestInitialize()]
        public void TestInitialize()
        {
            mockRepository = new Mock<IDataRepository<ActiviteAdulte>>();
            controller = new ActiviteAdultesController(mockRepository.Object);
        }

        [TestCleanup]
        public void TestCleanup()
        {
            mockRepository = null;
            controller = null;
        }

        [TestMethod()]
        public async Task GetActivitesAdultesTest()
        {
            List<ActiviteAdulte> fausseListe = new List<ActiviteAdulte> { new ActiviteAdulte { ActiAdulteId = 1 }, new ActiviteAdulte { ActiAdulteId = 2 } };
            mockRepository.Setup(repo => repo.GetAllAsync()).ReturnsAsync(fausseListe);

            var result = await controller.GetActivitesAdultes();

            Assert.IsInstanceOfType(result.Value, typeof(IEnumerable<ActiviteAdulte>));
            Assert.AreEqual(2, result.Value.Count());
        }

        [TestMethod()]
        public async Task GetActiviteAdulte_NonExistingIdPassed_ReturnsNotFoundResult()
        {
            mockRepository.Setup(repo => repo.GetByIdAsync(9999)).ReturnsAsync((ActiviteAdulte)null);
            var result = await controller.GetActiviteAdulte(9999);
            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task GetActiviteAdulte_ExistingIdPassed_ReturnsRightItem()
        {
            var fauxAct = new ActiviteAdulte { ActiAdulteId = 1, ActiAdulteTitre = "Test" };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(fauxAct);

            var result = await controller.GetActiviteAdulte(1);

            Assert.IsInstanceOfType(result.Value, typeof(ActiviteAdulte));
            Assert.AreEqual("Test", result.Value.ActiAdulteTitre);
        }

        [TestMethod()]
        public async Task PutActiviteAdulte_IdMismatch_ReturnsBadRequest()
        {
            var activite = new ActiviteAdulte { ActiAdulteId = 2 };
            var result = await controller.PutActiviteAdulte(1, activite);
            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

        [TestMethod()]
        public async Task PutActiviteAdulte_NonExistingId_ReturnsNotFound()
        {
            var activite = new ActiviteAdulte { ActiAdulteId = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync((ActiviteAdulte)null);

            var result = await controller.PutActiviteAdulte(1, activite);
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task PutActiviteAdulte_ValidRequest_ReturnsNoContent()
        {
            var actExistante = new ActiviteAdulte { ActiAdulteId = 1 };
            var actModifiee = new ActiviteAdulte { ActiAdulteId = 1, ActiAdulteTitre = "Nouveau" };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(actExistante);
            mockRepository.Setup(repo => repo.UpdateAsync(actExistante, actModifiee)).Returns(Task.CompletedTask);

            var result = await controller.PutActiviteAdulte(1, actModifiee);

            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.UpdateAsync(actExistante, actModifiee), Times.Once);
        }

        [TestMethod()]
        public async Task PostActiviteAdulte_InvalidModel_ReturnsBadRequest()
        {
            controller.ModelState.AddModelError("Titre", "Requis");
            var activite = new ActiviteAdulte();

            var result = await controller.PostActiviteAdulte(activite);
            Assert.IsInstanceOfType(result.Result, typeof(BadRequestObjectResult));
        }

        [TestMethod()]
        public async Task PostActiviteAdulte_ValidObject_ReturnsCreatedAtAction()
        {
            var activite = new ActiviteAdulte { ActiAdulteId = 1, ActiAdulteTitre = "Nouveau" };
            mockRepository.Setup(repo => repo.AddAsync(activite)).Returns(Task.CompletedTask);

            var result = await controller.PostActiviteAdulte(activite);

            Assert.IsInstanceOfType(result.Result, typeof(CreatedAtActionResult));
            mockRepository.Verify(repo => repo.AddAsync(activite), Times.Once);
        }

        [TestMethod()]
        public async Task DeleteActiviteAdulte_NonExistingId_ReturnsNotFound()
        {
            mockRepository.Setup(repo => repo.GetByIdAsync(9999)).ReturnsAsync((ActiviteAdulte)null);
            var result = await controller.DeleteActiviteAdulte(9999);
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task DeleteActiviteAdulte_ExistingId_ReturnsNoContent()
        {
            var activite = new ActiviteAdulte { ActiAdulteId = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(activite);
            mockRepository.Setup(repo => repo.DeleteAsync(activite)).Returns(Task.CompletedTask);

            var result = await controller.DeleteActiviteAdulte(1);

            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.DeleteAsync(activite), Times.Once);
        }
    }
}
