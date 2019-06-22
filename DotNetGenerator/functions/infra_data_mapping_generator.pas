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
  System.Classes, System.SysUtils;

{ TInfraDataMappingGenerator }

procedure TInfraDataMappingGenerator.generate(var pEntidade: TEntidadeDTO);
var
  t_arquivo: TStringList;
  t_aux: Integer;
  t_nome_atributo_pk: string;
  t_diretorio: string;
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
    t_arquivo.Add(Format('            builder.ToTable("%s");', [LowerCase(pEntidade.NomeClassePlural)]));
    t_arquivo.Add('');

    for t_aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      if (pEntidade.Atributos.Items[t_aux].ChavePrimaria) then
      begin
        t_nome_atributo_pk := pEntidade.Atributos.Items[t_aux].Nome;

        t_arquivo.Add(Format('            builder.HasKey(%s => %s.%s);', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular), t_nome_atributo_pk]));
        t_arquivo.Add(Format('            builder.Property(%s => %s.%s);', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular), t_nome_atributo_pk]));
        t_arquivo.Add(Format('            builder.HasColumnName("%s");', [LowerCase(t_nome_atributo_pk)]));
        t_arquivo.Add('');

        Break;
      end;
    end;

    for t_aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      if (not pEntidade.Atributos.Items[t_aux].ChavePrimaria) then
      begin
        t_nome_atributo_pk := pEntidade.Atributos.Items[t_aux].Nome;

        if (pEntidade.Atributos.Items[t_aux].ChaveUnica) then
        begin
          t_arquivo.Add(Format('            builder.HasAlternateKey(%s => %s.%s);', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular), t_nome_atributo_pk]));
        end;

        t_arquivo.Add(Format('            builder.Property(%s => %s.%s);', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular), t_nome_atributo_pk]));
        t_arquivo.Add(Format('            builder.HasColumnName("%s");', [LowerCase(t_nome_atributo_pk)]));

        if (pEntidade.Atributos.Items[t_aux].Requerido) then
        begin
          t_arquivo.Add('            builder.IsRequired();');
        end;

  //      if (False) then
  //      begin
  //        t_arquivo.Add('            builder.HasDefaultValue(false);');
  //      end;

        //validacao de tamanho de campo
  //      if (False) then
  //      begin
  //        t_arquivo.Add('            builder.HasMaxLength(7);');');
  //      end;

        t_arquivo.Add('');
      end;
    end;

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
