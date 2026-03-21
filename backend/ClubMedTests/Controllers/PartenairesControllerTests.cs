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
    public class PartenairesControllerTests
    {
        private PartenairesController controller;
        private Mock<IDataRepository<Partenaire>> mockRepository;

        [TestInitialize()]
        public void TestInitialize()
        {
            mockRepository = new Mock<IDataRepository<Partenaire>>();
            controller = new PartenairesController(mockRepository.Object);
        }

        [TestCleanup]
        public void TestCleanup()
        {
            mockRepository = null;
            controller = null;
        }

        [TestMethod()]
        public async Task GetPartenairesTest()
        {
            List<Partenaire> fausseListe = new List<Partenaire> { new Partenaire { PartenaireId = 1 }, new Partenaire { PartenaireId = 2 } };
            mockRepository.Setup(repo => repo.GetAllAsync()).ReturnsAsync(fausseListe);

            var result = await controller.GetPartenaires();

            Assert.IsInstanceOfType(result.Value, typeof(IEnumerable<Partenaire>));
            Assert.AreEqual(2, result.Value.Count());
        }

        [TestMethod()]
        public async Task GetPartenaire_NonExistingIdPassed_ReturnsNotFoundResult()
        {
            mockRepository.Setup(repo => repo.GetByIdAsync(9999)).ReturnsAsync((Partenaire)null);
            var result = await controller.GetPartenaire(9999);
            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task GetPartenaire_ExistingIdPassed_ReturnsRightItem()
        {
            var fauxPartenaire = new Partenaire { PartenaireId = 1, PartenaireNom = "Test" };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(fauxPartenaire);

            var result = await controller.GetPartenaire(1);

            Assert.IsInstanceOfType(result.Value, typeof(Partenaire));
            Assert.AreEqual("Test", result.Value.PartenaireNom);
        }

        [TestMethod()]
        public async Task PutPartenaire_IdMismatch_ReturnsBadRequest()
        {
            var partenaire = new Partenaire { PartenaireId = 2 };
            var result = await controller.PutPartenaire(1, partenaire);
            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

        [TestMethod()]
        public async Task PutPartenaire_NonExistingId_ReturnsNotFound()
        {
            var partenaire = new Partenaire { PartenaireId = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync((Partenaire)null);

            var result = await controller.PutPartenaire(1, partenaire);
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task PutPartenaire_ValidRequest_ReturnsNoContent()
        {
            var partExistant = new Partenaire { PartenaireId = 1 };
            var partModifie = new Partenaire { PartenaireId = 1, PartenaireNom = "Nouveau" };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(partExistant);
            mockRepository.Setup(repo => repo.UpdateAsync(partExistant, partModifie)).Returns(Task.CompletedTask);

            var result = await controller.PutPartenaire(1, partModifie);

            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.UpdateAsync(partExistant, partModifie), Times.Once);
        }

        [TestMethod()]
        public async Task PostPartenaire_InvalidModel_ReturnsBadRequest()
        {
            controller.ModelState.AddModelError("PartenaireNom", "Requis");
            var partenaire = new Partenaire();

            var result = await controller.PostPartenaire(partenaire);
            Assert.IsInstanceOfType(result.Result, typeof(BadRequestObjectResult));
        }

        [TestMethod()]
        public async Task PostPartenaire_ValidObject_ReturnsCreatedAtAction()
        {
            var partenaire = new Partenaire { PartenaireId = 1, PartenaireNom = "Nouveau" };
            mockRepository.Setup(repo => repo.AddAsync(partenaire)).Returns(Task.CompletedTask);

            var result = await controller.PostPartenaire(partenaire);

            Assert.IsInstanceOfType(result.Result, typeof(CreatedAtActionResult));
            mockRepository.Verify(repo => repo.AddAsync(partenaire), Times.Once);
        }

        [TestMethod()]
        public async Task DeletePartenaire_NonExistingId_ReturnsNotFound()
        {
            mockRepository.Setup(repo => repo.GetByIdAsync(9999)).ReturnsAsync((Partenaire)null);
            var result = await controller.DeletePartenaire(9999);
            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task DeletePartenaire_ExistingId_ReturnsNoContent()
        {
            var partenaire = new Partenaire { PartenaireId = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(partenaire);
            mockRepository.Setup(repo => repo.DeleteAsync(partenaire)).Returns(Task.CompletedTask);

            var result = await controller.DeletePartenaire(1);

            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.DeleteAsync(partenaire), Times.Once);
        }
    }
}