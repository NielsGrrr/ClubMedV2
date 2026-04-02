using Stripe.Checkout;
using System.Collections.Generic;

namespace ClubMed.Models.DataManager
{
    public class StripeManager : IStripeManager
    {
        public string CreateCheckoutSession(decimal totalAmount, string description)
        {
            var options = new SessionCreateOptions
            {
                PaymentMethodTypes = new List<string> { "card" },
                LineItems = new List<SessionLineItemOptions>
                {
                    new SessionLineItemOptions
                    {
                        PriceData = new SessionLineItemPriceDataOptions
                        {
                            UnitAmount = (long)System.Math.Round(totalAmount * 100), // Stripe veut le montant en centimes (long)
                            Currency = "eur",
                            ProductData = new SessionLineItemPriceDataProductDataOptions
                            {
                                Name = description,
                            },
                        },
                        Quantity = 1,
                    },
                },
                Mode = "payment",
                // Adaptez les URLs selon l'hébergement (localhost front = http://localhost:8080)
                SuccessUrl = "http://localhost:8080/panier?success=true",
                CancelUrl = "http://localhost:8080/panier?canceled=true",
            };

            var service = new SessionService();
            Session session = service.Create(options);

            return session.Url;
        }
    }
}
