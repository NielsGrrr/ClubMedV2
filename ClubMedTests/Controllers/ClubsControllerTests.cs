using ClubMed.Controllers;
using ClubMed.Models.DataManager;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ClubMed.Tests.Controllers
{
    [TestClass()]
    public class ClubsControllerTests
    {
        private ClubsController controller;
        private Mock<IDataRepository<Club>> mockRepository;
        private Mock<IClubManager> mockManager;

        [TestInitialize()]
        public void TestInitialize()
        {
            mockRepository = new Mock<IDataRepository<Club>>();
            mockManager = new Mock<IClubManager>();
            controller = new ClubsController(mockRepository.Object, mockManager.Object);
        }

        [TestCleanup]
        public void TestCleanup()
        {
            mockRepository = null;
            mockManager = null;
            controller = null;
        }

        // ==========================================================
        // 1. TESTS GET ALL
        // ==========================================================
        [TestMethod()]
        public async Task GetClubsTest()
        {
            var fausseListe = new List<Club> { new Club { IdClub = 1 }, new Club { IdClub = 2 } };
            mockRepository.Setup(repo => repo.GetAllAsync()).ReturnsAsync(fausseListe);

            var result = await controller.GetClubs();

            Assert.IsInstanceOfType(result.Value, typeof(IEnumerable<Club>));
            var liste = result.Value as IEnumerable<Club>;
            Assert.AreEqual(2, liste.Count());
        }

        // ==========================================================
        // 2. TESTS GET BY ID
        // ==========================================================
        [TestMethod()]
        public async Task GetClubById_NonExistingId_ReturnsNotFound()
        {
            mockRepository.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((Club)null);

            var result = await controller.GetClubById(99);

            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task GetClubById_ExistingId_ReturnsClub()
        {
            var fauxClub = new Club { IdClub = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(fauxClub);

            var result = await controller.GetClubById(1);

            Assert.IsInstanceOfType(result.Value, typeof(Club));
            var clubRecupere = result.Value as Club;
            Assert.AreEqual(1, clubRecupere.IdClub);
        }

        // ==========================================================
        // 3. TESTS PUT
        // ==========================================================
        [TestMethod()]
        public async Task PutClub_IdMismatch_ReturnsBadRequest()
        {
            var club = new Club { IdClub = 2 };

            var result = await controller.PutClub(1, club);

            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

        [TestMethod()]
        public async Task PutClub_NonExistingId_ReturnsNotFound()
        {
            var club = new Club { IdClub = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync((Club)null);

            var result = await controller.PutClub(1, club);

            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task PutClub_ValidRequest_ReturnsNoContent()
        {
            var existant = new Club { IdClub = 1 };
            var modifie = new Club { IdClub = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(existant);
            mockRepository.Setup(repo => repo.UpdateAsync(existant, modifie)).Returns(Task.CompletedTask);

            var result = await controller.PutClub(1, modifie);

            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.UpdateAsync(existant, modifie), Times.Once);
        }

        // ==========================================================
        // 4. TESTS POST
        // ==========================================================
        // [TestMethod()]
        // public async Task PostClub_InvalidModel_ReturnsBadRequest()
        // {
        //     controller.ModelState.AddModelError("Titre", "Requis");
        //     var club = new Club();
        //     var result = await controller.PostClub(club);
        //     Assert.IsInstanceOfType(result.Result, typeof(BadRequestObjectResult));
        // }

        [TestMethod()]
        public async Task PostClub_ExistingId_ReturnsConflict()
        {
            var clubExistant = new Club { IdClub = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(clubExistant);

            var result = await controller.PostClub(clubExistant);

            Assert.IsInstanceOfType(result.Result, typeof(ConflictObjectResult));
        }

        [TestMethod()]
        public async Task PostClub_ValidNewObject_ReturnsCreatedAtAction()
        {
            var nouveauClub = new Club { IdClub = 2 };
            mockRepository.Setup(repo => repo.GetByIdAsync(2)).ReturnsAsync((Club)null);
            mockRepository.Setup(repo => repo.AddAsync(nouveauClub)).Returns(Task.CompletedTask);

            var result = await controller.PostClub(nouveauClub);

            Assert.IsInstanceOfType(result.Result, typeof(CreatedAtActionResult));
            var actionResult = result.Result as CreatedAtActionResult;
            Assert.AreEqual("GetClubByID", actionResult.ActionName);
            mockRepository.Verify(repo => repo.AddAsync(nouveauClub), Times.Once);
        }

        // ==========================================================
        // 5. TESTS DELETE
        // ==========================================================
        [TestMethod()]
        public async Task DeleteClub_NonExistingId_ReturnsNotFound()
        {
            mockRepository.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((Club)null);

            var result = await controller.DeleteClub(99);

            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task DeleteClub_ExistingId_ReturnsNoContent()
        {
            var club = new Club { IdClub = 1 };
            mockRepository.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(club);
            mockRepository.Setup(repo => repo.DeleteAsync(club)).Returns(Task.CompletedTask);

            var result = await controller.DeleteClub(1);

            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.DeleteAsync(club), Times.Once);
        }
    }
}