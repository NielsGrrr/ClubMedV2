using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    /*public class ExempleConfiguation : IEntityTypeConfiguration<Exemple>
    {
        public void Configure(EntityTypeBuilder<Exemple> builder)
        {
            // 1. Nom de la table
            builder.ToTable("Exemple");

            // 2. Clé primaire
            builder.HasKey(e => e.Id).HasName("PK_Exemple");

            // 3. Contraintes et propriétés
            builder.Property(e => e.Name)
                   .IsRequired()
                   .HasMaxLength(100)
                   .HasColumnName("ExempleName")
                   .HasComment("Le nom de l'exemple");

            builder.HasIndex(e => e.Name)
                   .IsUnique()
                   .HasDatabaseName("IX_Exemple_Name");

            // 4. Relations
            builder.HasOne(e => e.RelatedEntity)
                   .WithMany(r => r.Exemples)
                   .HasForeignKey(e => e.RelatedEntityId)
                   .OnDelete(DeleteBehavior.Cascade)
                   .HasConstraintName("FK_Exemple_RelatedEntity");

            builder.HasMany(e => e.OtherEntities)
                   .WithOne(o => o.Exemple)
                   .HasForeignKey(o => o.ExempleId)
                   .OnDelete(DeleteBehavior.SetNull)
                   .HasConstraintName("FK_OtherEntity_Exemple");
        }
    }*/
}
