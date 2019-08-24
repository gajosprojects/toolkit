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
  System.Classes, System.SysUtils, uStringHelper;

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
begin
  t_Arquivo := TStringList.Create();

  try
    t_Arquivo.Add('using Dapper;');
    t_Arquivo.Add(Format('using ERP.%s.Domain.%s;', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacaoPlural]));
    t_Arquivo.Add(Format('using ERP.%s.Domain.%s.Repositories;', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacaoPlural]));
    t_Arquivo.Add('using ERP.Infra.Data.Context;');
    t_Arquivo.Add('using Microsoft.EntityFrameworkCore;');
    t_Arquivo.Add('using System;');
    t_Arquivo.Add('using System.Collections.Generic;');
    t_Arquivo.Add('using System.Linq;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.Infra.Data.Repositories.%s', [pEntidade.NomeModulo]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class %sRepository : Repository<%s>, I%sRepository', [pEntidade.NomeClasseAgregacaoPlural, pEntidade.NomeClasseAgregacaoSingular, pEntidade.NomeClasseAgregacaoPlural]));
    t_Arquivo.Add('    {');
    t_Arquivo.Add(Format('        public %sRepository(%sContext db) : base(db)', [pEntidade.NomeClasseAgregacaoPlural, pEntidade.NomeClasseAgregacaoPlural]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add('        }');
    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TInfraDataRepositoryGenerator.getFileDirectory(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('\src\ERP.Infra.Data\Repositories\%s\', [pEntidade.NomeModulo]);
end;

function TInfraDataRepositoryGenerator.getFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('%sRepository.cs', [pEntidade.NomeClasseAgregacaoPlural]);
end;

end.
