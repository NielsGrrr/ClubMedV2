using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class AdresseConfiguration : IEntityTypeConfiguration<Adresse>
    {
        public void Configure(EntityTypeBuilder<Adresse> builder)
        {
            // 1. Nom de la table
            builder.ToTable("t_e_adresse_adr");

            // 2. Clé primaire
            builder.HasKey(a => a.NumAdresse).HasName("pk_adresse");

            // 3. Contraintes et propriétés
            builder.Property(a => a.NumAdresse)
                   .HasColumnName("adr_numadresse");

            builder.Property(a => a.NumRue)
                   .IsRequired()
                   .HasColumnName("adr_numrue");

            builder.Property(a => a.NomRue)
                   .IsRequired()
                   .HasMaxLength(1024)
                   .HasColumnName("adr_nomrue");

            builder.Property(a => a.CodePostal)
                   .IsRequired()
                   .HasMaxLength(5)
                   .HasColumnType("char(5)")
                   .HasColumnName("adr_codepostal");

            builder.Property(a => a.Ville)
                   .IsRequired()
                   .HasMaxLength(1024)
                   .HasColumnName("adr_ville");

            builder.Property(a => a.Pays)
                   .IsRequired()
                   .HasMaxLength(1024)
                   .HasColumnName("adr_pays");

            // 4. Relations
            // La relation 1-N (Client -> Adresse) est configurée côté Client (la table qui porte la clé étrangère)
        }
    }
}