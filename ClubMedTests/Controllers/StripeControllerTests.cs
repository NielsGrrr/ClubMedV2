using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using ClubMed.Controllers;
using ClubMed.Models.DataManager;
using System.Threading.Tasks;

namespace ClubMed.Tests.Controllers
{
    [TestClass]
    public class StripeControllerTests
    {
        private StripeController _controller;
        private Mock<IStripeManager> _mockStripeManager;
        private Mock<IConfiguration> _mockConfiguration;

        [TestInitialize]
        public void TestInitialize()
        {
            _mockStripeManager = new Mock<IStripeManager>();
            _mockConfiguration = new Mock<IConfiguration>();

            // Setup d'une fausse configuration
            _mockConfiguration.Setup(c => c["Stripe:SecretKey"]).Returns("sk_test_fake");

            _controller = new StripeController(_mockConfiguration.Object, _mockStripeManager.Object);
        }

        [TestCleanup]
        public void TestCleanup()
        {
            _mockStripeManager = null;
            _mockConfiguration = null;
            _controller = null;
        }

        [TestMethod]
        public void CreateCheckoutSession_ValidRequest_ReturnsOkWithUrl()
        {
            // Arrange
            var req = new StripeController.CheckoutSessionRequest
            {
                TotalAmount = 1000m,
                Description = "Test Séjour"
            };

            var expectedUrl = "https://checkout.stripe.com/c/pay/cs_test_fake123";

            _mockStripeManager.Setup(m => m.CreateCheckoutSession(req.TotalAmount, req.Description))
                              .Returns(expectedUrl);

            // Act
            var result = _controller.CreateCheckoutSession(req);

            // Assert
            Assert.IsInstanceOfType(result, typeof(OkObjectResult));
            var okResult = result as OkObjectResult;
            Assert.IsNotNull(okResult);
            
            // On vérifie que la valeur retournée dynamique contient bien "url"
            var value = okResult.Value;
            var urlProperty = value.GetType().GetProperty("url");
            Assert.IsNotNull(urlProperty);
            Assert.AreEqual(expectedUrl, urlProperty.GetValue(value, null));
        }

        [TestMethod]
        public void CreateCheckoutSession_ManagerThrowsException_ReturnsBadRequest()
        {
            // Arrange
            var req = new StripeController.CheckoutSessionRequest
            {
                TotalAmount = 1000m,
                Description = "Test Séjour Error"
            };

            var errorMessage = "Invalid API Key";
            _mockStripeManager.Setup(m => m.CreateCheckoutSession(req.TotalAmount, req.Description))
                              .Throws(new System.Exception(errorMessage));

            // Act
            var result = _controller.CreateCheckoutSession(req);

            // Assert
            Assert.IsInstanceOfType(result, typeof(BadRequestObjectResult));
            var badRequestResult = result as BadRequestObjectResult;
            Assert.IsNotNull(badRequestResult);

            var value = badRequestResult.Value;
            var errorProperty = value.GetType().GetProperty("error");
            Assert.IsNotNull(errorProperty);
            Assert.AreEqual(errorMessage, errorProperty.GetValue(value, null));
        }
    }
}
