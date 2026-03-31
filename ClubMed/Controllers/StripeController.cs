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
            // On récupère la clé via la config pour éviter que Github ne bloque le push
            StripeConfiguration.ApiKey = _configuration["Stripe:SecretKey"]; 
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
