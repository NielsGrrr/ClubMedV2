using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class TransactionConfig : IEntityTypeConfiguration<Transaction>
    {
        public void Configure(EntityTypeBuilder<Transaction> builder)
        {
            builder.ToTable("t_e_transaction_trs");

            builder.HasKey(t => t.TransactionId)
                   .HasName("pk_transaction");

            builder.Property(t => t.TransactionId)
                   .HasColumnName("trs_id")
                   .ValueGeneratedOnAdd();

            builder.Property(t => t.ResaNum)
                   .IsRequired()
                   .HasColumnName("trs_numreservation");

            builder.Property(t => t.TransactionMontant)
                   .IsRequired()
                   .HasColumnName("trs_montant")
                   .HasColumnType("decimal(18,2)");

            builder.Property(t => t.TransactionDate)
                   .IsRequired()
                   .HasColumnName("trs_datetransaction")
                   .HasDefaultValueSql("GETDATE()");

            builder.Property(t => t.TransactionMoyenPaiement)
                   .IsRequired()
                   .HasMaxLength(50)
                   .HasColumnName("trs_moyenpaiement");

            builder.Property(t => t.TransactionStatut)
                   .IsRequired()
                   .HasMaxLength(50)
                   .HasColumnName("trs_statutpaiement");

            builder.HasOne(t => t.Reservation)
                   .WithMany(r => r.Transactions)
                   .HasForeignKey(t => t.ResaNum)
                   .OnDelete(DeleteBehavior.Cascade)
                   .HasConstraintName("fk_transaction_reservation");
        }
    }
}
