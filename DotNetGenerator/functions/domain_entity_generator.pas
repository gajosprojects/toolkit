unit domain_entity_generator;

interface

uses
  uEntidadeDTO, uArquivoDTO;

type
  TDomainEntityGenerator = class

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

{ TDomainEntityGenerator }

function TDomainEntityGenerator.getFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
  t_Aux: Integer;
  t_NomeAtributo: string;
  t_NomeSnkAtributo: string;
  t_TipoAtributo: string;
  t_NomeExibicaoAtributo: string;
  t_ValidacaoAtributo: TStringList;
  t_AtributoAux: string;
  t_ParametrosConstrutor: string;
  t_CorpoConstrutor: TStringList;
  t_CorpoConstrutorAux: string;
  t_Diretorio: string;
  t_NomeSnkEntidade: string;
  t_AtributoDTO: TAtributoDTO;
begin
  try
    t_Diretorio := EmptyStr;

    t_NomeSnkEntidade := LowerCase(Copy(pEntidade.NomeClasseSingular, 1, 1)) + Copy(pEntidade.NomeClasseSingular, 2, Length(pEntidade.NomeClasseSingular));

    t_Arquivo := TStringList.Create();

    t_Arquivo.Add('using System;');
    t_Arquivo.Add('using System.Collections.Generic;');
    t_Arquivo.Add('using ERP.Domain.Core.Models;');
    t_Arquivo.Add('using ERP.Gerencial.Domain.Usuarios;');
    t_Arquivo.Add('using FluentValidation;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.%s.Domain.%s', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class %s : Entity<%s>', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('    {');

    for t_Aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_Aux]);
      t_NomeAtributo := t_AtributoDTO.NomeAtributo;
      t_TipoAtributo := t_AtributoDTO.Tipo;

      t_Arquivo.Add(Format('        public %s %s { get; private set; }', [t_TipoAtributo, t_NomeAtributo]));
    end;

    t_Arquivo.Add('        public virtual Usuario Usuario { get; private set; }');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('        private %s() { }', [pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('');
    t_Arquivo.Add('        public override bool IsValid()');
    t_Arquivo.Add('        {');

    for t_Aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_Aux]);
      t_NomeAtributo := t_AtributoDTO.NomeAtributo;
      t_NomeExibicaoAtributo := t_AtributoDTO.NomeExibicao;

      try
        t_ValidacaoAtributo := TStringList.Create();

        t_ValidacaoAtributo.Add(Format('            RuleFor(%s => %s.%s)', [t_NomeSnkEntidade, t_NomeSnkEntidade, t_NomeAtributo]));

        if (t_AtributoDTO.Requerido) then
        begin
          t_ValidacaoAtributo.Add(Format('                .NotEmpty().WithMessage("%s obrigatório(a)")', [t_NomeExibicaoAtributo]));
        end;

        if (t_ValidacaoAtributo.Count > 1) then
        begin
          t_AtributoAux := t_ValidacaoAtributo.Text;
          Delete(t_AtributoAux, Length(t_AtributoAux) - 1, 2);
          t_Arquivo.Add(t_AtributoAux + ';');
          t_Arquivo.Add('');
        end;
      finally
        FreeAndNil(t_ValidacaoAtributo);
      end;
    end;

    t_Arquivo.Add('');
    t_Arquivo.Add('            ValidationResult = Validate(this);');
    t_Arquivo.Add('            return ValidationResult.IsValid;');
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('        public static class %sFactory', [pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('        {');

    try
      t_ParametrosConstrutor := EmptyStr;
      t_CorpoConstrutor := TStringList.Create();

      t_ParametrosConstrutor := 'Guid id';
      t_CorpoConstrutor.Add('                    Id = id,');

      for t_Aux := 0 to pEntidade.Atributos.Count - 1 do
      begin
        t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_Aux]);
	      t_NomeAtributo := t_AtributoDTO.NomeAtributo;
        t_NomeSnkAtributo := LowerCase(Copy(t_NomeAtributo, 1, 1)) + Copy(t_NomeAtributo, 2, Length(t_NomeAtributo));
        t_TipoAtributo := t_AtributoDTO.Tipo;

        t_ParametrosConstrutor := t_ParametrosConstrutor + Format(', %s %s', [t_TipoAtributo, t_NomeSnkAtributo]);

        t_CorpoConstrutor.Add(Format('                    %s = %s,', [t_NomeAtributo, t_NomeSnkAtributo]));
      end;

      t_ParametrosConstrutor := t_ParametrosConstrutor + ', DateTime dataCadastro, DateTime dataUltimaAtualizacao, Guid usuarioId';

      t_CorpoConstrutor.Add('                    DataCadastro = dataCadastro,');
      t_CorpoConstrutor.Add('                    DataUltimaAtualizacao = dataUltimaAtualizacao,');
      t_CorpoConstrutor.Add('                    UsuarioId = usuarioId');

      t_CorpoConstrutorAux := t_CorpoConstrutor.Text;
      Delete(t_CorpoConstrutorAux, Length(t_CorpoConstrutorAux) - 1, 2);
    finally
      FreeAndNil(t_CorpoConstrutor);
    end;

    t_Arquivo.Add(Format('            public static %s New%s(%s)', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular, t_ParametrosConstrutor]));
    t_Arquivo.Add('            {');
    t_Arquivo.Add(Format('                var %s = new %s()', [t_NomeSnkEntidade, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('                {');
    t_Arquivo.Add(Format('%s', [t_CorpoConstrutorAux]));
    t_Arquivo.Add('                };');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('                return %s;', [t_NomeSnkEntidade]));
    t_Arquivo.Add('            }');
    t_Arquivo.Add('        }');
    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TDomainEntityGenerator.getFileDirectory(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('ERP.%s.Domain\%s\', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao]);
end;

function TDomainEntityGenerator.getFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('%s.cs', [pEntidade.NomeClasseSingular]);
end;

function TDomainEntityGenerator.getFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileDirectory(pEntidade);
  Result.Nome      := getFileName(pEntidade);
  Result.Conteudo  := getFileContent(pEntidade);
end;

end.
