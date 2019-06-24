unit domain_repositories_generator;

interface

uses
  uEntidadeDTO;

type
  TDomainRepositoriesGenerator = class

  public
    procedure generate(var pEntidade: TEntidadeDTO);

  end;

implementation

uses
  System.Classes, System.SysUtils;

{ TDomainRepositoriesGenerator }

procedure TDomainRepositoriesGenerator.generate(var pEntidade: TEntidadeDTO);
var
  t_arquivo: TStringList;
  t_diretorio: string;
begin
  try
    t_diretorio := EmptyStr;

    t_arquivo := TStringList.Create();

    t_arquivo.Add('using ERP.Domain.Core.Contracts;');
    t_arquivo.Add('');

    t_arquivo.Add(Format('namespace ERP.%s.Domain.%s.Repositories', [pEntidade.NomeModulo, pEntidade.NomeClassePlural]));
    t_arquivo.Add('{');
    t_arquivo.Add(Format('    public interface I%sRepository : IRepository<%s>', [pEntidade.NomeClassePlural, pEntidade.NomeClasseSingular]));
    t_arquivo.Add('    {');
    t_arquivo.Add('');
    t_arquivo.Add('    }');
    t_arquivo.Add('}');

    t_diretorio := GetCurrentDir() + Format('\ERP.%s.Domain', [pEntidade.NomeModulo]);

    if (not DirectoryExists(t_diretorio)) then
    begin
      ForceDirectories(t_diretorio);
    end;

    t_diretorio := Format('%s\%s', [t_diretorio, pEntidade.NomeClassePlural]);

    if (not DirectoryExists(t_diretorio)) then
    begin
      ForceDirectories(t_diretorio);
    end;

    t_diretorio := Format('%s\Repositories', [t_diretorio]);

    if (not DirectoryExists(t_diretorio)) then
    begin
      ForceDirectories(t_diretorio);
    end;

    t_arquivo.SaveToFile(Format('%s\I%sRepository.cs', [t_diretorio, pEntidade.NomeClassePlural]));

  finally
    FreeAndNil(t_arquivo);
  end;
end;

end.
