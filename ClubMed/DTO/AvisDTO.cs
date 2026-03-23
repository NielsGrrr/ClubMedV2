namespace ClubMed.DTO
{
    public class AvisDTO
    {
        public int NumAvis { get; set; }
        public int Note { get; set; }
        public string Commentaire { get; set; } = null!;
        public int NumClient { get; set; }
        public int NumClub { get; set; }
    }
}
