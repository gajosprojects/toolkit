unit tests_integration_dto_generator;

interface

uses
  uEntidadeDTO, uArquivoDTO;

type
  TTestsIntegrationDTOGenerator = class

  private
    function getFileName(const pEntidade: TEntidadeDTO): string;
    function getFileDirectory(const pEntidade: TEntidadeDTO): string;
    function getFileContent(const pEntidade: TEntidadeDTO): WideString;

  public
    function getFile(const pEntidade: TEntidadeDTO): TArquivoDTO;

  end;

implementation

uses
  System.Classes, System.SysUtils, uStringHelper, uAtributoDTO, uConstantes;

{ TTestsIntegrationDTOGenerator }

function TTestsIntegrationDTOGenerator.getFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileDirectory(pEntidade);
  Result.Nome      := getFileName(pEntidade);
  Result.Conteudo  := getFileContent(pEntidade);
end;

function TTestsIntegrationDTOGenerator.getFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
  t_Aux: Integer;
  t_AtributoDTO: TAtributoDTO;
begin
  t_Arquivo := TStringList.Create();

  try
    t_Arquivo.Add('');

    t_Arquivo.Add('using System;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.Tests.Integration.%s.DTO', [pEntidade.NomeModulo]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class Get%sDTO', [pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('    {');

    for t_Aux := 0 to pEntidade.Atributos.Count -1 do
    begin
      t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_Aux]);

      if (SameText(t_AtributoDTO.NomeCampo, cCampoUsuarioId)) then
      begin
        t_Arquivo.Add(Format('        public Get%sDTO %s { get; set; }', [t_AtributoDTO.Tipo, t_AtributoDTO.Tipo.DecapitalizeFirstLetter()]));
      end
      else
      begin
        if (SameText(t_AtributoDTO.Tipo, 'Guid')) then
          t_Arquivo.Add(Format('        public string %s { get; set; }', [t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()]))
        else
          t_Arquivo.Add(Format('        public %s %s { get; set; }', [t_AtributoDTO.Tipo, t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()]));
      end;
    end;

    t_Arquivo.Add('    }');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('    public class %sDTO', [pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('    {');
    t_Arquivo.Add('        public bool success { get; set; }');
    t_Arquivo.Add(Format('        public %sDataResponse data { get; set; }', [pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('    }');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('    public class %sDataResponse', [pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('    {');

    for t_Aux := 0 to pEntidade.Atributos.Count -1 do
    begin
      t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_Aux]);

      if (SameText(t_AtributoDTO.NomeCampo, cCampoUsuarioId)) or (SameText(t_AtributoDTO.Tipo, 'Guid')) then
          t_Arquivo.Add(Format('        public string %s { get; set; }', [t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()]))
      else
        t_Arquivo.Add(Format('        public %s %s { get; set; }', [t_AtributoDTO.Tipo, t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()]));
    end;

    t_Arquivo.Add('        public DateTime timestamp { get; set; }');
    t_Arquivo.Add('        public string messageType { get; set; }');
    t_Arquivo.Add('        public string aggregateId { get; set; }');
    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TTestsIntegrationDTOGenerator.getFileDirectory(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('\tests\ERP.Tests.Integration\%s\DTO\', [pEntidade.NomeModulo]);
end;

function TTestsIntegrationDTOGenerator.getFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('%sDTO.cs', [pEntidade.NomeClasseSingular]);
end;

end.
