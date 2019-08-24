unit domain_repository_generator;

interface

uses
  uEntidadeDTO, uArquivoDTO;

type
  TDomainRepositoryGenerator = class

  private
    function getFileName(const pEntidade: TEntidadeDTO): string;
    function getFileDirectory(const pEntidade: TEntidadeDTO): string;
    function getFileContent(const pEntidade: TEntidadeDTO): WideString;

  public
    function getFile(const pEntidade: TEntidadeDTO): TArquivoDTO;

  end;

implementation

uses
  System.Classes, System.SysUtils, uStringHelper;

{ TDomainRepositoryGenerator }

function TDomainRepositoryGenerator.getFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileDirectory(pEntidade);
  Result.Nome      := getFileName(pEntidade);
  Result.Conteudo  := getFileContent(pEntidade);
end;

function TDomainRepositoryGenerator.getFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
begin
  t_Arquivo := TStringList.Create();

  try
    t_Arquivo.Add('using ERP.Domain.Core.Contracts;');
    t_Arquivo.Add('');

    t_Arquivo.Add(Format('namespace ERP.%s.Domain.%s.Repositories', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacaoPlural]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public interface I%sRepository : IRepository<%s>', [pEntidade.NomeClasseAgregacaoPlural, pEntidade.NomeClasseAgregacaoSingular]));
    t_Arquivo.Add('    {');

    if (not SameText(pEntidade.NomeClassePlural, pEntidade.NomeClasseAgregacaoPlural)) then
    begin
      t_Arquivo.Add(Format('        void Save(%s %s);', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular.DecapitalizeFirstLetter()]));
      t_Arquivo.Add('');
      t_Arquivo.Add(Format('        void Update(%s %s);', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular.DecapitalizeFirstLetter()]));
      t_Arquivo.Add('');
      t_Arquivo.Add(Format('        IEnumerable<%s> GetAll%s();', [pEntidade.NomeClasseSingular, pEntidade.NomeClassePlural]));
      t_Arquivo.Add('');
      t_Arquivo.Add(Format('        %s GetBy%sId(Guid id);', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
      t_Arquivo.Add('');
//      t_Arquivo.Add(Format('        int ObterQuantidadeDe%sVinculadasAo%s(Guid id);', [pEntidade.NomeClassePlural, pEntidade.NomeClasseAgregacaoSingular]));
//      t_Arquivo.Add('');
    end;

    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TDomainRepositoryGenerator.getFileDirectory(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('\src\ERP.%s.Domain\%s\Repositories\', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacaoPlural]);
end;

function TDomainRepositoryGenerator.getFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('I%sRepository.cs', [pEntidade.NomeClasseAgregacaoPlural]);
end;

end.
