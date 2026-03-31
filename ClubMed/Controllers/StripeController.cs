using Microsoft.AspNetCore.Mvc;
using Stripe.Checkout;
using Stripe;
using ClubMed.Models.DataManager;
using Microsoft.Extensions.Configuration;

namespace ClubMed.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StripeController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly IStripeManager _stripeManager;

        public StripeController(IConfiguration configuration, IStripeManager stripeManager)
        {
            _configuration = configuration;
            _stripeManager = stripeManager;
            // On configure ici la clé secrète. Dans un vrai projet, elle vient de secrets.json ou des variables d'environnement.
            StripeConfiguration.ApiKey = _configuration["Stripe:SecretKey"] ?? "sk_test_VOTRE_VRAIE_CLE_STRIPE_ICI"; 
            // Note: Si la clé est "sk_test_VOTRE_VRAIE_CLE...", Stripe plantera en 401 Unauthorized. Vous DEVEZ la remplacer.
        }

        public class CheckoutSessionRequest
        {
            public decimal TotalAmount { get; set; }
            public string Description { get; set; } = "Votre séjour ClubMed";
        }

        [HttpPost("CreateCheckoutSession")]
        public ActionResult CreateCheckoutSession([FromBody] CheckoutSessionRequest req)
        {
            try
            {
                var url = _stripeManager.CreateCheckoutSession(req.TotalAmount, req.Description);
                return Ok(new { url });
            }
            catch (System.Exception ex)
            {
                return BadRequest(new { error = ex.Message });
            }
        }
    }
}
