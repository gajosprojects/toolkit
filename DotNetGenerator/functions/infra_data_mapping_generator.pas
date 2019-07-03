unit infra_data_mapping_generator;

interface

uses
  uEntidadeDTO;

type
  TInfraDataMappingGenerator = class

  public
    procedure generate(var pEntidade: TEntidadeDTO);

  end;

implementation

uses
  System.Classes, System.Contnrs, System.SysUtils, uAtributoDTO;

{ TInfraDataMappingGenerator }

procedure TInfraDataMappingGenerator.generate(var pEntidade: TEntidadeDTO);
var
  t_arquivo: TStringList;
  t_aux: Integer;
  t_nome_atributo: string;
  t_diretorio: string;
  t_builder_atributo: TStringList;
  t_atributo_aux: string;
  t_AtributoDTO: TAtributoDTO;
begin
  try
    t_diretorio := EmptyStr;

    t_arquivo := TStringList.Create();

    t_arquivo.Add('');

    t_arquivo.Add(Format('using ERP.%s.Domain.%s;', [pEntidade.NomeModulo, pEntidade.NomeClassePlural]));
    t_arquivo.Add('using Microsoft.EntityFrameworkCore;');
    t_arquivo.Add('using Microsoft.EntityFrameworkCore.Metadata.Builders;');
    t_arquivo.Add('');
    t_arquivo.Add(Format('namespace ERP.Infra.Data.Mappings.%s', [pEntidade.NomeModulo]));
    t_arquivo.Add('{');
    t_arquivo.Add(Format('    public class %sMapping : IEntityTypeConfiguration<%s>', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
    t_arquivo.Add('    {');
    t_arquivo.Add(Format('        public void Configure(EntityTypeBuilder<%s> builder)', [pEntidade.NomeClasseSingular]));
    t_arquivo.Add('        {');
    t_arquivo.Add(Format('            builder.ToTable("%s");', [LowerCase(pEntidade.NomeTabela)]));
    t_arquivo.Add('');
    t_arquivo.Add(Format('            builder.Property(%s => %s.Id)', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular)]));
    t_arquivo.Add('                   .HasColumnName("id");');
    t_arquivo.Add('');
    t_arquivo.Add(Format('            builder.HasKey(%s => %s.Id)', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular)]));
    t_arquivo.Add(Format('                   .HasName("pk_%s_id");', [LowerCase(pEntidade.NomeClasseSingular)]));
    t_arquivo.Add('');

    for t_aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_aux]);
      t_nome_atributo := t_AtributoDTO.Nome;

      try
        t_builder_atributo := TStringList.Create();

        t_builder_atributo.Add(Format('            builder.Property(%s => %s.%s)', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular), t_nome_atributo]));
        t_builder_atributo.Add(Format('                   .HasColumnName("%s")', [LowerCase(t_nome_atributo)]));

        if (t_AtributoDTO.Requerido) then
        begin
          t_builder_atributo.Add('                   .IsRequired()');
        end;

        //if (False) then
        //begin
        //  t_builder_atributo.Add('            builder.HasDefaultValue(false);');
        //end;

        //validacao de tamanho de campo
        //if (False) then
        //begin
        //  t_builder_atributo.Add('            builder.HasMaxLength(7);');');
        //end;

        if (t_builder_atributo.Count > 1) then
        begin
          t_atributo_aux := t_builder_atributo.Text;
          Delete(t_atributo_aux, Length(t_atributo_aux) - 1, 2);
          t_arquivo.Add(t_atributo_aux + ';');
          t_builder_atributo.Clear();
        end;

        if (t_AtributoDTO.ChaveUnica) then
        begin
          t_builder_atributo.Add('');
          t_builder_atributo.Add(Format('            builder.HasIndex(%s => %s.%s)', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular), t_nome_atributo]));
          t_builder_atributo.Add('                   .IsUnique()');
          t_builder_atributo.Add(Format('                   .HasName("uk_%s_%s")', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(t_nome_atributo)]));
        end;

        if (t_builder_atributo.Count > 1) then
        begin
          t_atributo_aux := t_builder_atributo.Text;
          Delete(t_atributo_aux, Length(t_atributo_aux) - 1, 2);
          t_arquivo.Add(t_atributo_aux + ';');
        end;
      finally
        FreeAndNil(t_builder_atributo);
      end;

      t_arquivo.Add('');
    end;

    t_arquivo.Add(Format('            builder.Property(%s => %s.Desativado)', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular)]));
    t_arquivo.Add('                   .HasColumnName("desativado")');
    t_arquivo.Add('                   .IsRequired()');
    t_arquivo.Add('                   .HasDefaultValue(false);');
    t_arquivo.Add('');
    t_arquivo.Add(Format('            builder.Property(%s => %s.DataCadastro)', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular)]));
    t_arquivo.Add('                .HasColumnName("data_cadastro")');
    t_arquivo.Add('                .IsRequired();');
    t_arquivo.Add('');
    t_arquivo.Add(Format('            builder.Property(%s => %s.DataUltimaAtualizacao)', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular)]));
    t_arquivo.Add('                .HasColumnName("data_ultima_atualizacao");');
    t_arquivo.Add('');
    t_arquivo.Add(Format('            builder.Property(%s => %s.UsuarioId)', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular)]));
    t_arquivo.Add('                .HasColumnName("usuario_id");');
    t_arquivo.Add('');
    t_arquivo.Add(Format('            builder.HasOne(%s => %s.Usuario)', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular)]));
    t_arquivo.Add(Format('                .WithMany(usuario => usuario.GruposEmpresariais)', [pEntidade.NomeClassePlural]));
    t_arquivo.Add(Format('                .HasForeignKey(%s => %s.UsuarioId)', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular)]));
    t_arquivo.Add(Format('                .HasConstraintName("fk_usuario_id_%s")', [LowerCase(pEntidade.NomeClasseSingular)]));
    t_arquivo.Add('                .OnDelete(DeleteBehavior.Restrict);');
    t_arquivo.Add('');
    t_arquivo.Add(Format('            builder.Ignore(%s => %s.ValidationResult);', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular)]));
    t_arquivo.Add(Format('            builder.Ignore(%s => %s.CascadeMode);', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular)]));
    t_arquivo.Add('        }');
    t_arquivo.Add('    }');
    t_arquivo.Add('}');

    t_diretorio := GetCurrentDir() + '\ERP.Infra.Data\Mappings';

    if (not DirectoryExists(t_diretorio)) then
    begin
      ForceDirectories(t_diretorio);
    end;

    t_diretorio := Format('%s\%s', [t_diretorio, pEntidade.NomeModulo]);

    if (not DirectoryExists(t_diretorio)) then
    begin
      ForceDirectories(t_diretorio);
    end;

    t_arquivo.SaveToFile(Format('%s\%sMapping.cs', [t_diretorio, pEntidade.NomeClasseSingular]));
  finally
    FreeAndNil(t_arquivo);
  end;
end;

end.
