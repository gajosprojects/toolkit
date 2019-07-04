unit infra_data_mapping_generator;

interface

uses
  uEntidadeDTO, uArquivoDTO;

type
  TInfraDataMappingGenerator = class

  private
    function getFileName(const pEntidade: TEntidadeDTO): string;
    function getFileDirectory(const pEntidade: TEntidadeDTO): string;
    function getFileContent(const pEntidade: TEntidadeDTO): WideString;

  public
    function getFile(const pEntidade: TEntidadeDTO): TArquivoDTO;

  end;

implementation

uses
  System.Classes, System.Contnrs, System.SysUtils, uAtributoDTO;

{ TInfraDataMappingGenerator }

{ TInfraDataMappingGenerator }

function TInfraDataMappingGenerator.getFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileDirectory(pEntidade);
  Result.Nome      := getFileName(pEntidade);
  Result.Conteudo  := getFileContent(pEntidade);
end;

function TInfraDataMappingGenerator.getFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
  t_Aux: Integer;
  t_NomeAtributo: string;
  t_BuilderAtributo: TStringList;
  t_AtributoAux: string;
  t_AtributoDTO: TAtributoDTO;
begin
  t_Arquivo := TStringList.Create();

  try
    t_Arquivo.Add('');

    t_Arquivo.Add(Format('using ERP.%s.Domain.%s;', [pEntidade.NomeModulo, pEntidade.NomeClassePlural]));
    t_Arquivo.Add('using Microsoft.EntityFrameworkCore;');
    t_Arquivo.Add('using Microsoft.EntityFrameworkCore.Metadata.Builders;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.Infra.Data.Mappings.%s', [pEntidade.NomeModulo]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class %sMapping : IEntityTypeConfiguration<%s>', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('    {');
    t_Arquivo.Add(Format('        public void Configure(EntityTypeBuilder<%s> builder)', [pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add(Format('            builder.ToTable("%s");', [LowerCase(pEntidade.NomeTabela)]));
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('            builder.Property(%s => %s.Id)', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular)]));
    t_Arquivo.Add('                   .HasColumnName("id");');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('            builder.HasKey(%s => %s.Id)', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular)]));
    t_Arquivo.Add(Format('                   .HasName("pk_%s_id");', [LowerCase(pEntidade.NomeClasseSingular)]));
    t_Arquivo.Add('');

    for t_Aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_Aux]);
      t_NomeAtributo := t_AtributoDTO.Nome;

      try
        t_BuilderAtributo := TStringList.Create();

        t_BuilderAtributo.Add(Format('            builder.Property(%s => %s.%s)', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular), t_NomeAtributo]));
        t_BuilderAtributo.Add(Format('                   .HasColumnName("%s")', [LowerCase(t_NomeAtributo)]));

        if (t_AtributoDTO.Requerido) then
        begin
          t_BuilderAtributo.Add('                   .IsRequired()');
        end;

        //if (False) then
        //begin
        //  t_BuilderAtributo.Add('            builder.HasDefaultValue(false);');
        //end;

        //validacao de tamanho de campo
        //if (False) then
        //begin
        //  t_BuilderAtributo.Add('            builder.HasMaxLength(7);');');
        //end;

        if (t_BuilderAtributo.Count > 1) then
        begin
          t_AtributoAux := t_BuilderAtributo.Text;
          Delete(t_AtributoAux, Length(t_AtributoAux) - 1, 2);
          t_Arquivo.Add(t_AtributoAux + ';');
          t_BuilderAtributo.Clear();
        end;

        if (t_AtributoDTO.ChaveUnica) then
        begin
          t_BuilderAtributo.Add('');
          t_BuilderAtributo.Add(Format('            builder.HasIndex(%s => %s.%s)', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular), t_NomeAtributo]));
          t_BuilderAtributo.Add('                   .IsUnique()');
          t_BuilderAtributo.Add(Format('                   .HasName("uk_%s_%s")', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(t_NomeAtributo)]));
        end;

        if (t_BuilderAtributo.Count > 1) then
        begin
          t_AtributoAux := t_BuilderAtributo.Text;
          Delete(t_AtributoAux, Length(t_AtributoAux) - 1, 2);
          t_Arquivo.Add(t_AtributoAux + ';');
        end;
      finally
        FreeAndNil(t_BuilderAtributo);
      end;

      t_Arquivo.Add('');
    end;

    t_Arquivo.Add(Format('            builder.Property(%s => %s.Desativado)', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular)]));
    t_Arquivo.Add('                   .HasColumnName("desativado")');
    t_Arquivo.Add('                   .IsRequired()');
    t_Arquivo.Add('                   .HasDefaultValue(false);');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('            builder.Property(%s => %s.DataCadastro)', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular)]));
    t_Arquivo.Add('                .HasColumnName("data_cadastro")');
    t_Arquivo.Add('                .IsRequired();');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('            builder.Property(%s => %s.DataUltimaAtualizacao)', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular)]));
    t_Arquivo.Add('                .HasColumnName("data_ultima_atualizacao");');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('            builder.Property(%s => %s.UsuarioId)', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular)]));
    t_Arquivo.Add('                .HasColumnName("usuario_id");');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('            builder.HasOne(%s => %s.Usuario)', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular)]));
    t_Arquivo.Add(Format('                .WithMany(usuario => usuario.GruposEmpresariais)', [pEntidade.NomeClassePlural]));
    t_Arquivo.Add(Format('                .HasForeignKey(%s => %s.UsuarioId)', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular)]));
    t_Arquivo.Add(Format('                .HasConstraintName("fk_usuario_id_%s")', [LowerCase(pEntidade.NomeClasseSingular)]));
    t_Arquivo.Add('                .OnDelete(DeleteBehavior.Restrict);');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('            builder.Ignore(%s => %s.ValidationResult);', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular)]));
    t_Arquivo.Add(Format('            builder.Ignore(%s => %s.CascadeMode);', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular)]));
    t_Arquivo.Add('        }');
    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TInfraDataMappingGenerator.getFileDirectory(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('\ERP.Infra.Data\Mappings\%s', [pEntidade.NomeModulo]);
end;

function TInfraDataMappingGenerator.getFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('%sMapping.cs', [pEntidade.NomeClasseSingular]);
end;

end.
