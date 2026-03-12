using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class TransportConfig : IEntityTypeConfiguration<Transport>
    {
        public void Configure(EntityTypeBuilder<Transport> builder)
        {
            builder.ToTable("t_e_transport_tra");

            builder.HasKey(t => t.TransportId)
                   .HasName("pk_transport");

            builder.Property(t => t.TransportId)
                   .HasColumnName("tra_id")
                   .ValueGeneratedOnAdd();

            builder.Property(t => t.TransportLieuDepart)
                   .IsRequired()
                   .HasMaxLength(1024)
                   .HasColumnName("tra_lieudepart");

            builder.Property(t => t.TransportPrix)
                   .IsRequired()
                   .HasColumnName("tra_prix")
                   .HasColumnType("decimal(18,2)");
        }
    }
}
