unit infra_data_repository_generator;

interface

uses
  uEntidadeDTO;

type
  TInfraDataRepositoryGenerator = class

  public
    procedure generate(var pEntidade: TEntidadeDTO);

  end;

implementation

uses
  System.Classes, System.SysUtils;

{ TInfraDataRepositoryGenerator }

procedure TInfraDataRepositoryGenerator.generate(var pEntidade: TEntidadeDTO);
var
  t_arquivo: TStringList;
  t_nome_singular_classe: string;
  t_nome_plural_classe: string;
  t_nome_singular_snk_classe: string;
  t_aux: Integer;
  t_nome_atributo_pk: string;
  t_diretorio: string;
begin
  try
    t_diretorio := EmptyStr;

    t_nome_singular_classe := pEntidade.nomeClasseSingular;
    t_nome_plural_classe := pEntidade.nomeClassePlural;
    t_nome_singular_snk_classe := LowerCase(Copy(t_nome_singular_classe, 1, 1)) + Copy(t_nome_singular_classe, 2, Length(t_nome_singular_classe));

    t_arquivo := TStringList.Create();

    t_arquivo.Add(Format('using ERP.%s.Domain.%s;', [pEntidade.NomeModulo, t_nome_plural_classe]));
    t_arquivo.Add(Format('using ERP.%s.Domain.%s.Repositories;', [pEntidade.NomeModulo, t_nome_plural_classe]));
    t_arquivo.Add('using ERP.Infra.Data.Context;');
    t_arquivo.Add('');
    t_arquivo.Add(Format('namespace ERP.Infra.Data.Repositories.%s', [pEntidade.NomeModulo]));
    t_arquivo.Add('{');
    t_arquivo.Add(Format('    public class %sRepository : Repository<%s>, I%sRepository', [t_nome_plural_classe, t_nome_singular_classe, t_nome_plural_classe]));
    t_arquivo.Add('    {');
    t_arquivo.Add(Format('        public %sRepository(%sContext db) : base(db)', [t_nome_plural_classe, t_nome_plural_classe]));
    t_arquivo.Add('        {');
    t_arquivo.Add('        }');
    t_arquivo.Add('');

    for t_aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      if (pEntidade.Atributos.Items[t_aux].ChavePrimaria) then
      begin
        t_nome_atributo_pk := pEntidade.Atributos.Items[t_aux].Nome;

        t_arquivo.Add(Format('        public override void Delete(GrupoEmpresarial obj)', [t_nome_singular_classe]));
        t_arquivo.Add('        {');
        t_arquivo.Add(Format('            var %s = GetBy%s(obj.%s);', [t_nome_singular_snk_classe, t_nome_atributo_pk, t_nome_atributo_pk]));
        t_arquivo.Add(Format('            %s.Desativar();', [t_nome_singular_snk_classe]));
        t_arquivo.Add(Format('            Update(%s);', [t_nome_singular_snk_classe]));
        t_arquivo.Add('        }');

        Break;
      end;
    end;

    t_arquivo.Add('    }');
    t_arquivo.Add('}');

    t_diretorio := GetCurrentDir() + '\ERP.Infra.Data\Repositories';

    if (not DirectoryExists(t_diretorio)) then
    begin
      ForceDirectories(t_diretorio);
    end;

    t_arquivo.SaveToFile(Format('%s\%sRepository.cs', [t_diretorio, t_nome_plural_classe]));
  finally
    FreeAndNil(t_arquivo);
  end;
end;

end.
