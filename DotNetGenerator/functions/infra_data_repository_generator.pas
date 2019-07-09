unit infra_data_repository_generator;

interface

uses
  uEntidadeDTO, uArquivoDTO;

type
  TInfraDataRepositoryGenerator = class

  private
    function getFileName(const pEntidade: TEntidadeDTO): string;
    function getFileDirectory(const pEntidade: TEntidadeDTO): string;
    function getFileContent(const pEntidade: TEntidadeDTO): WideString;

  public
    function getFile(const pEntidade: TEntidadeDTO): TArquivoDTO;

  end;

implementation

uses
  System.Classes, System.SysUtils;

{ TInfraDataRepositoryGenerator }

{ TInfraDataRepositoryGenerator }

function TInfraDataRepositoryGenerator.getFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileDirectory(pEntidade);
  Result.Nome      := getFileName(pEntidade);
  Result.Conteudo  := getFileContent(pEntidade);
end;

function TInfraDataRepositoryGenerator.getFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
  t_NomeSingularClasse: string;
  t_NomePluralClasse: string;
  t_NomeSingularSnkClasse: string;
begin
  t_Arquivo := TStringList.Create();

  try
    t_NomeSingularClasse := pEntidade.nomeClasseSingular;
    t_NomePluralClasse := pEntidade.nomeClassePlural;
    t_NomeSingularSnkClasse := LowerCase(Copy(t_NomeSingularClasse, 1, 1)) + Copy(t_NomeSingularClasse, 2, Length(t_NomeSingularClasse));

    t_Arquivo.Add(Format('using ERP.%s.Domain.%s;', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao]));
    t_Arquivo.Add(Format('using ERP.%s.Domain.%s.Repositories;', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao]));
    t_Arquivo.Add('using ERP.Infra.Data.Context;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.Infra.Data.Repositories.%s', [pEntidade.NomeModulo]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class %sRepository : Repository<%s>, I%sRepository', [t_NomePluralClasse, t_NomeSingularClasse, t_NomePluralClasse]));
    t_Arquivo.Add('    {');
    t_Arquivo.Add(Format('        public %sRepository(%sContext db) : base(db)', [t_NomePluralClasse, pEntidade.NomeClasseAgregacao]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add('        }');
//    t_Arquivo.Add('');
//    t_Arquivo.Add(Format('        public override void Delete(%s obj)', [t_NomeSingularClasse]));
//    t_Arquivo.Add('        {');
//    t_Arquivo.Add(Format('            var %s = GetById(obj.Id);', [t_NomeSingularSnkClasse]));
//    t_Arquivo.Add(Format('            %s.Desativar();', [t_NomeSingularSnkClasse]));
//    t_Arquivo.Add(Format('            Update(%s);', [t_NomeSingularSnkClasse]));
//    t_Arquivo.Add('        }');
    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TInfraDataRepositoryGenerator.getFileDirectory(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('\ERP.Infra.Data\Repositories\%s\', [pEntidade.NomeModulo]);
end;

function TInfraDataRepositoryGenerator.getFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('%sRepository.cs', [pEntidade.NomeClassePlural]);
end;

end.
