using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class ClientConfiguration : IEntityTypeConfiguration<Client>
    {
        public void Configure(EntityTypeBuilder<Client> builder)
        {
            // 1. Nom de la table
            builder.ToTable("t_e_client_cli");

            // 2. Clé primaire
            builder.HasKey(c => c.NumClient).HasName("pk_client");

            // 3. Contraintes et propriétés
            builder.Property(c => c.NumClient).HasColumnName("cli_numclient");
            builder.Property(c => c.NumAdresse).HasColumnName("cli_numadresse");

            builder.Property(c => c.Genre).HasMaxLength(1024).HasColumnName("cli_genre");
            builder.Property(c => c.Prenom).IsRequired().HasMaxLength(1024).HasColumnName("cli_prenom");
            builder.Property(c => c.Nom).IsRequired().HasMaxLength(1024).HasColumnName("cli_nom");
            builder.Property(c => c.DateNaissance).HasColumnType("date").HasColumnName("cli_datenaissance");

            builder.Property(c => c.Email)
                   .IsRequired()
                   .HasMaxLength(1024)
                   .HasColumnName("cli_email");

            builder.Property(c => c.Telephone).HasMaxLength(1024).HasColumnName("cli_telephone");

            builder.Property(c => c.MotDePasseCrypter)
                   .IsRequired()
                   .HasMaxLength(1024)
                   .HasColumnName("cli_motdepasse_crypter");

            builder.Property(c => c.Role)
                   .HasMaxLength(20)
                   .HasDefaultValue("client")
                   .HasColumnName("cli_role");

            builder.Property(c => c.A2fActive)
                   .HasDefaultValue(false)
                   .HasColumnName("cli_a2f_active");

            builder.Property(c => c.StripeId).HasMaxLength(255).HasColumnName("cli_stripe_id");
            builder.Property(c => c.PmType).HasMaxLength(255).HasColumnName("cli_pm_type");
            builder.Property(c => c.PmLastFour).HasColumnType("char(4)").HasMaxLength(4).HasColumnName("cli_pm_last_four");
            builder.Property(c => c.TrialEndsAt).HasColumnName("cli_trial_ends_at");

            // Contrainte CHECK SQL adaptée avec ton trigramme
            builder.ToTable(t => t.HasCheckConstraint("ck_email", "((cli_email)::text ~~ '%_@_%._%'::text)"));

            // Index
            builder.HasIndex(c => c.Email)
                   .IsUnique()
                   .HasDatabaseName("uq_client_email");

            // 4. Relations
            builder.HasOne(c => c.AdresseResidence)
                   .WithMany(a => a.Clients)
                   .HasForeignKey(c => c.NumAdresse)
                   .OnDelete(DeleteBehavior.Restrict)
                   .HasConstraintName("fk_client_adresse");
        }
    }
}