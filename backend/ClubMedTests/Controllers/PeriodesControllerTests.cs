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
    public class PeriodesControllerTests
    {
        private PeriodesController controller;
        private Mock<IDataRepository<Periode>> mockRepository;

        [TestInitialize()]
        public void TestInitialize()
        {
            mockRepository = new Mock<IDataRepository<Periode>>();
            controller = new PeriodesController(mockRepository.Object);
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
        public async Task GetPeriodesTest()
        {
            var fausseListe = new List<Periode> { new Periode { NumPeriode = "P1" }, new Periode { NumPeriode = "P2" } };
            mockRepository.Setup(repo => repo.GetAllAsync()).ReturnsAsync(fausseListe);

            var result = await controller.GetPeriodes(); //

            Assert.IsInstanceOfType(result.Result, typeof(OkObjectResult));
            var okResult = result.Result as OkObjectResult;
            var liste = okResult.Value as IEnumerable<Periode>;
            Assert.AreEqual(2, liste.Count());
        }

        // ==========================================================
        // 2. TESTS GET BY STRING ID
        // ==========================================================
        [TestMethod()]
        public async Task GetPeriode_NonExistingId_ReturnsNotFound()
        {
            mockRepository.Setup(repo => repo.GetByStringAsync("INCONNU")).ReturnsAsync((Periode)null);

            var result = await controller.GetPeriode("INCONNU"); //

            Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task GetPeriode_ExistingId_ReturnsOk()
        {
            var faussePeriode = new Periode { NumPeriode = "HIVER_2026" };
            mockRepository.Setup(repo => repo.GetByStringAsync("HIVER_2026")).ReturnsAsync(faussePeriode);

            var result = await controller.GetPeriode("HIVER_2026"); //

            Assert.IsInstanceOfType(result.Result, typeof(OkObjectResult));
            var okResult = result.Result as OkObjectResult;
            var periodeRecuperee = okResult.Value as Periode;
            Assert.AreEqual("HIVER_2026", periodeRecuperee.NumPeriode);
        }

        // ==========================================================
        // 3. TESTS PUT
        // ==========================================================
        [TestMethod()]
        public async Task PutPeriode_IdMismatch_ReturnsBadRequest()
        {
            var periode = new Periode { NumPeriode = "P2" };

            var result = await controller.PutPeriode("P1", periode); //

            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

        [TestMethod()]
        public async Task PutPeriode_NonExistingId_ReturnsNotFound()
        {
            var periode = new Periode { NumPeriode = "P1" };
            mockRepository.Setup(repo => repo.GetByStringAsync("P1")).ReturnsAsync((Periode)null);

            var result = await controller.PutPeriode("P1", periode); //

            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task PutPeriode_ValidRequest_ReturnsNoContent()
        {
            var existant = new Periode { NumPeriode = "P1" };
            var modifie = new Periode { NumPeriode = "P1" };
            mockRepository.Setup(repo => repo.GetByStringAsync("P1")).ReturnsAsync(existant);
            mockRepository.Setup(repo => repo.UpdateAsync(existant, modifie)).Returns(Task.CompletedTask);

            var result = await controller.PutPeriode("P1", modifie); //

            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.UpdateAsync(existant, modifie), Times.Once);
        }

        // ==========================================================
        // 4. TESTS POST (Avec le fameux test du Conflict 409 !)
        // ==========================================================
        [TestMethod()]
        public async Task PostPeriode_ExistingId_ReturnsConflict()
        {
            // Arrange : on simule que la période existe déjà
            var periodeExistante = new Periode { NumPeriode = "HIVER_2026" };
            mockRepository.Setup(repo => repo.GetByStringAsync("HIVER_2026")).ReturnsAsync(periodeExistante);

            // Act
            var result = await controller.PostPeriode(periodeExistante);

            // Assert
            Assert.IsInstanceOfType(result.Result, typeof(ConflictObjectResult));
        }

        [TestMethod()]
        public async Task PostPeriode_ValidNewObject_ReturnsCreatedAtAction()
        {
            var nouvellePeriode = new Periode { NumPeriode = "ETE_2026" };
            // Arrange : on simule qu'elle n'existe pas encore
            mockRepository.Setup(repo => repo.GetByStringAsync("ETE_2026")).ReturnsAsync((Periode)null);
            mockRepository.Setup(repo => repo.AddAsync(nouvellePeriode)).Returns(Task.CompletedTask);

            var result = await controller.PostPeriode(nouvellePeriode); //

            Assert.IsInstanceOfType(result.Result, typeof(CreatedAtActionResult));
            mockRepository.Verify(repo => repo.AddAsync(nouvellePeriode), Times.Once);
        }

        // ==========================================================
        // 5. TESTS DELETE
        // ==========================================================
        [TestMethod()]
        public async Task DeletePeriode_NonExistingId_ReturnsNotFound()
        {
            mockRepository.Setup(repo => repo.GetByStringAsync("INCONNU")).ReturnsAsync((Periode)null);

            var result = await controller.DeletePeriode("INCONNU"); //

            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod()]
        public async Task DeletePeriode_ExistingId_ReturnsNoContent()
        {
            var periode = new Periode { NumPeriode = "P1" };
            mockRepository.Setup(repo => repo.GetByStringAsync("P1")).ReturnsAsync(periode);
            mockRepository.Setup(repo => repo.DeleteAsync(periode)).Returns(Task.CompletedTask);

            var result = await controller.DeletePeriode("P1"); //

            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            mockRepository.Verify(repo => repo.DeleteAsync(periode), Times.Once);
        }
    }
}