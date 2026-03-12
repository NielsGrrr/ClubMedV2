using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ClubMed.Models.EntityFramework.Configurations
{
    public class TypeClubConfig : IEntityTypeConfiguration<TypeClub>
    {
        public void Configure(EntityTypeBuilder<TypeClub> builder)
        {
            builder.ToTable("t_e_typeclub_tcl");

            builder.HasKey(tc => tc.NumType).HasName("pk_typeclub");

            builder.Property(tc => tc.NumType)
                .HasColumnName("tcl_numtype");

            builder.Property(tc => tc.NomType)
                .HasColumnName("tcl_nomtype")
                .HasMaxLength(100);
        }
    }
}
