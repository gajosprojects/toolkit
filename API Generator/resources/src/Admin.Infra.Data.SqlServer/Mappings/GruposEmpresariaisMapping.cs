using Admin.Domain.GruposEmpresariais;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Admin.Infra.Data.SqlServer.Mappings
{
    public class GruposEmpresariaisMapping : IEntityTypeConfiguration<GrupoEmpresarial>
    {
        public void Configure(EntityTypeBuilder<GrupoEmpresarial> builder)
        {
            builder.ToTable("grupos_empresariais");

            builder.HasKey(grupoempresarial => grupoempresarial.Id);            
            builder.Property(grupoempresarial => grupoempresarial.Id)
                .HasColumnName("id");

            builder.HasAlternateKey(grupoempresarial => grupoempresarial.Codigo);
            builder.Property(grupoempresarial => grupoempresarial.Codigo)
                .HasColumnName("codigo")
                .IsRequired()
                .HasMaxLength(30);
            
            builder.Property(grupoempresarial => grupoempresarial.Descricao)
                .HasColumnName("descricao")
                .IsRequired()
                .HasMaxLength(150);
            
            builder.Property(grupoempresarial => grupoempresarial.Desativado)
                .HasColumnName("desativado")
                .IsRequired()
                .HasDefaultValue(false);
            
            builder.Property(grupoempresarial => grupoempresarial.DataCadastro)
                .HasColumnName("data_cadastro")
                .IsRequired();
            
            builder.Property(grupoempresarial => grupoempresarial.DataUltimaAtualizacao)
                .HasColumnName("data_ultima_atualizacao");

            builder.Ignore(grupoempresarial => grupoempresarial.ValidationResult);
            builder.Ignore(grupoempresarial => grupoempresarial.CascadeMode);
        }
    }
}