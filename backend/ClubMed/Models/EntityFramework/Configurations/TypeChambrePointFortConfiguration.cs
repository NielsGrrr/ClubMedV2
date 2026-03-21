using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class TypeChambrePointFortConfiguration : IEntityTypeConfiguration<TypeChambrePointFort>
    {
        public void Configure(EntityTypeBuilder<TypeChambrePointFort> builder)
        {
            // 1. Cl� Primaire
            builder.HasKey(tcpf => new { tcpf.NumPointFort, tcpf.IdTypeChambre })
                .HasName("pk_type_chambre_pointfort");

            // 2. Contraintes et Propri�t�s

            // 3. Relations
            builder.HasOne(tcpf => tcpf.PointFortNav)
                .WithMany(p => p.TypeChambrePointForts)
                .HasForeignKey(tcpf => tcpf.NumPointFort)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_type_chambre_pointfort_pointfort");

            builder.HasOne(tcpf => tcpf.TypeChambreNav)
                .WithMany(tc => tc.TypeChambrePointForts)
                .HasForeignKey(tcpf => tcpf.IdTypeChambre)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_type_chambre_pointfort_typechambre");
        }
    }
}

