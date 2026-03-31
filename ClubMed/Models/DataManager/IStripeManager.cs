namespace ClubMed.Models.DataManager
{
    public interface IStripeManager
    {
        string CreateCheckoutSession(decimal totalAmount, string description);
    }
}
