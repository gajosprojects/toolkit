unit domain_entity_generator;

interface

uses
  uEntidadeDTO;

type
  TDomainEntityGenerator = class

  public
    procedure generate(var pEntidade: TEntidadeDTO);

  end;

implementation

uses
  System.Classes, System.Contnrs, System.SysUtils, uAtributoDTO;

{ TDomainEntityGenerator }

procedure TDomainEntityGenerator.generate(var pEntidade: TEntidadeDTO);
var
  t_arquivo: TStringList;
  t_aux: Integer;
  t_nome_atributo: string;
  t_nome_snk_atributo: string;
  t_tipo_atributo: string;
  t_nome_exibicao_atributo: string;
  t_validacao_atributo: TStringList;
  t_atributo_aux: string;
  t_parametros_construtor: string;
  t_corpo_construtor: TStringList;
  t_diretorio: string;
  t_nome_snk_entidade: string;
  t_AtributoDTO: TAtributoDTO;
begin
  try
    t_diretorio := EmptyStr;

    t_arquivo := TStringList.Create();

    t_arquivo.Add('using System;');
    t_arquivo.Add('using System.Collections.Generic;');
    t_arquivo.Add('using ERP.Domain.Core.Models;');
    t_arquivo.Add('using FluentValidation;');
    t_arquivo.Add('');
    t_arquivo.Add(Format('namespace ERP.%s.Domain.%s', [pEntidade.NomeModulo, pEntidade.NomeClassePlural]));
    t_arquivo.Add('{');
    t_arquivo.Add(Format('    public class %s : Entity<%s>', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
    t_arquivo.Add('    {');

    for t_aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_aux]);
      t_nome_atributo := t_AtributoDTO.Nome;
      t_tipo_atributo := t_AtributoDTO.Tipo;

      t_arquivo.Add(Format('        public %s %s { get; private set; }', [t_tipo_atributo, t_nome_atributo]));
    end;

    t_arquivo.Add('');
    t_arquivo.Add(Format('        private %s() { }', [pEntidade.NomeClasseSingular]));
    t_arquivo.Add('');
    t_arquivo.Add('        public override bool IsValid()');
    t_arquivo.Add('        {');

    for t_aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_aux]);
	  t_nome_atributo := t_AtributoDTO.Nome;
      t_nome_exibicao_atributo := t_AtributoDTO.NomeExibicao;

      try
        t_validacao_atributo := TStringList.Create();

        t_validacao_atributo.Add(Format('            RuleFor(%s => %s.%s)', [LowerCase(pEntidade.NomeClasseSingular), LowerCase(pEntidade.NomeClasseSingular), t_nome_atributo]));

        if (t_AtributoDTO.Requerido) then
        begin
          t_validacao_atributo.Add(Format('                .NotEmpty().WithMessage("%s obrigatório(a)"))', [t_nome_exibicao_atributo]));
        end;

  //      if (False) then
  //      begin
  //        t_validacao_atributo.Add(Format('                .MinimumLength(1).WithMessage("Tamanho mínimo requerido de 1 caracter")', []));
  //        t_validacao_atributo.Add(Format('                .MaximumLength(255).WithMessage("Limite máximo de 255 caracteres atingido");', []));
  //      end;

        if (t_validacao_atributo.Count > 1) then
        begin
          t_atributo_aux := t_validacao_atributo.Text;
          //remover quebra de linha no final do stringlist
          Delete(t_atributo_aux, Length(t_atributo_aux) - 1, 2);
          t_arquivo.Add(t_atributo_aux + ';');
//          t_arquivo.Add(t_validacao_atributo.Text + ';');
        end;
      finally
        FreeAndNil(t_validacao_atributo);
      end;
    end;

    t_arquivo.Add('');
    t_arquivo.Add('            ValidationResult = Validate(this);');
    t_arquivo.Add('            return ValidationResult.IsValid;');
    t_arquivo.Add('        }');
    t_arquivo.Add('');
    t_arquivo.Add(Format('        public static class %sFactory', [pEntidade.NomeClasseSingular]));
    t_arquivo.Add('        {');

    //construtor
    try
      t_parametros_construtor := EmptyStr;
      t_corpo_construtor := TStringList.Create();

      t_parametros_construtor := Format('Guid id', [t_tipo_atributo, t_nome_snk_atributo]);
      t_corpo_construtor.Add(Format('                    Id = id,', [t_nome_atributo, t_nome_snk_atributo]));

      for t_aux := 0 to pEntidade.Atributos.Count - 1 do
      begin
        t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_aux]);
	    t_nome_atributo := t_AtributoDTO.Nome;
        t_nome_snk_atributo := LowerCase(Copy(t_nome_atributo, 1, 1)) + Copy(t_nome_atributo, 2, Length(t_nome_atributo));
        t_tipo_atributo := t_AtributoDTO.Tipo;

        t_parametros_construtor := t_parametros_construtor + Format(', %s %s', [t_tipo_atributo, t_nome_snk_atributo]);

        if (t_aux < pEntidade.Atributos.Count - 1) then
        begin
          t_corpo_construtor.Add(Format('                    %s = %s,', [t_nome_atributo, t_nome_snk_atributo]));
        end
        else
        begin
          t_corpo_construtor.Add(Format('                    %s = %s', [t_nome_atributo, t_nome_snk_atributo]));
        end;
      end;

      t_nome_snk_entidade := LowerCase(Copy(pEntidade.NomeClasseSingular, 1, 1)) + Copy(pEntidade.NomeClasseSingular, 2, Length(pEntidade.NomeClasseSingular));

      t_arquivo.Add(Format('            public static %s New%s(%s)', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular, t_parametros_construtor]));
      t_arquivo.Add('            {');
      t_arquivo.Add(Format('                var %s = new %s()', [t_nome_snk_entidade, pEntidade.NomeClasseSingular]));
      t_arquivo.Add('                {');
      t_arquivo.Add(Format('%s', [t_corpo_construtor.Text]));
      t_arquivo.Add('                };');
      t_arquivo.Add('');
      t_arquivo.Add(Format('                return %s;', [t_nome_snk_entidade]));
      t_arquivo.Add('            }');
    finally
      FreeAndNil(t_corpo_construtor);
    end;

    t_arquivo.Add('        }');
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

    t_arquivo.SaveToFile(Format('%s\%s.cs', [t_diretorio, pEntidade.NomeClasseSingular]));
  finally
    FreeAndNil(t_arquivo);
  end;
end;

end.
