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
  System.Classes, System.Contnrs, System.SysUtils, uAtributoDTO, uStringHelper;

{ TDomainEntityGenerator }

function TDomainEntityGenerator.getFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
  t_Aux: Integer;
  t_ValidacaoAtributo: TStringList;
  t_AtributoAux: string;
  t_ParametrosNewConstrutor: string;
  t_ParametrosUpdateConstrutor: string;
  t_CorpoNewConstrutor: TStringList;
  t_CorpoUpdateConstrutor: TStringList;
  t_CorpoNewConstrutorAux: string;
  t_CorpoUpdateConstrutorAux: string;
  t_Diretorio: string;
  t_AtributoDTO: TAtributoDTO;
begin
  try
    t_Diretorio := EmptyStr;

    t_Arquivo := TStringList.Create();

    t_Arquivo.Add('using ERP.Domain.Core.Models;');
    t_Arquivo.Add('using ERP.Gerencial.Domain.Usuarios;');
    t_Arquivo.Add('using FluentValidation;');
    t_Arquivo.Add('using System;');
    t_Arquivo.Add('using System.Collections.Generic;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.%s.Domain.%s', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacaoPlural]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class %s : Entity<%s>', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('    {');

    for t_Aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_Aux]);

      if (not SameText(t_AtributoDTO.NomeCampo, EmptyStr)) then
      begin
        if (not t_AtributoDTO.EntidadeBase) then
        begin
            t_Arquivo.Add(Format('        public %s %s { get; private set; }', [t_AtributoDTO.Tipo, t_AtributoDTO.NomeAtributo]));
        end
        else
        begin
          if (SameText(t_AtributoDTO.NomeCampo, 'usuario_id')) then
          begin
            t_Arquivo.Add(Format('        public virtual %s %s { get; private set; }', [t_AtributoDTO.Tipo, t_AtributoDTO.Tipo]));
          end;
        end;
      end
      else
      begin
          t_Arquivo.Add(Format('        public virtual %s %s { get; private set; }', [t_AtributoDTO.Tipo, t_AtributoDTO.NomeAtributo]));
      end;
    end;

    t_Arquivo.Add('');
    t_Arquivo.Add(Format('        private %s() { }', [pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('');
    t_Arquivo.Add('        public override bool IsValid()');
    t_Arquivo.Add('        {');

    for t_Aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_Aux]);

      if (not t_AtributoDTO.EntidadeBase) then
      begin
        try
          if (t_AtributoDTO.Requerido) then
          begin
            t_ValidacaoAtributo := TStringList.Create();

            t_ValidacaoAtributo.Add(Format('            RuleFor(%s => %s.%s)', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter(), pEntidade.NomeClasseSingular.DecapitalizeFirstLetter(), t_AtributoDTO.NomeAtributo]));
            t_ValidacaoAtributo.Add(Format('                .NotEmpty().WithMessage("%s obrigatório(a)")', [t_AtributoDTO.NomeExibicao]));

            t_AtributoAux := t_ValidacaoAtributo.Text;
            Delete(t_AtributoAux, Length(t_AtributoAux) - 1, 2);
            t_Arquivo.Add(t_AtributoAux + ';');
            t_Arquivo.Add('');
          end;
        finally
          FreeAndNil(t_ValidacaoAtributo);
        end;
      end;
    end;

    t_Arquivo.Add('            ValidationResult = Validate(this);');
    t_Arquivo.Add('            return ValidationResult.IsValid;');
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add('        public void AtribuirUsuario(Usuario usuario)');
    t_Arquivo.Add('        {');
    t_Arquivo.Add('            Usuario = usuario;');
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('        public static class %sFactory', [pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('        {');

    try
      t_ParametrosNewConstrutor := EmptyStr;
      t_ParametrosUpdateConstrutor := EmptyStr;
      t_CorpoNewConstrutor := TStringList.Create();
      t_CorpoUpdateConstrutor := TStringList.Create();

      for t_Aux := 0 to pEntidade.Atributos.Count - 1 do
      begin
        t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_Aux]);

        if (not SameText(t_AtributoDTO.NomeCampo, EmptyStr)) then
        begin
          if (SameText(t_AtributoDTO.NomeCampo, 'usuario_id')) then
          begin
            if (SameText(t_ParametrosNewConstrutor, EmptyStr)) then
              t_ParametrosNewConstrutor := Format('Guid %s', [t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()])
            else
              t_ParametrosNewConstrutor := t_ParametrosNewConstrutor + Format(', Guid %s', [t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()]);

            if (SameText(t_ParametrosUpdateConstrutor, EmptyStr)) then
              t_ParametrosUpdateConstrutor := Format('Guid %s', [t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()])
            else
              t_ParametrosUpdateConstrutor := t_ParametrosUpdateConstrutor + Format(', Guid %s', [t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()]);

            if (t_CorpoNewConstrutor.Count = pEntidade.Atributos.Count) then
              t_CorpoNewConstrutor.Add(Format('                    %s = %s', [t_AtributoDTO.NomeAtributo, t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()]))
            else
              t_CorpoNewConstrutor.Add(Format('                    %s = %s,', [t_AtributoDTO.NomeAtributo, t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()]));

            if (t_CorpoUpdateConstrutor.Count = pEntidade.Atributos.Count) then
              t_CorpoUpdateConstrutor.Add(Format('                    %s = %s', [t_AtributoDTO.NomeAtributo, t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()]))
            else
              t_CorpoUpdateConstrutor.Add(Format('                    %s = %s,', [t_AtributoDTO.NomeAtributo, t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()]));
          end
          else if (SameText(t_AtributoDTO.NomeCampo, 'ativo')) then
          begin
            if (SameText(t_ParametrosUpdateConstrutor, EmptyStr)) then
              t_ParametrosUpdateConstrutor := Format('%s %s', [t_AtributoDTO.Tipo, t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()])
            else
              t_ParametrosUpdateConstrutor := t_ParametrosUpdateConstrutor + Format(', %s %s', [t_AtributoDTO.Tipo, t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()]);

            if (t_CorpoNewConstrutor.Count = pEntidade.Atributos.Count) then
              t_CorpoNewConstrutor.Add(Format('                    %s = true', [t_AtributoDTO.NomeAtributo]))
            else
              t_CorpoNewConstrutor.Add(Format('                    %s = true,', [t_AtributoDTO.NomeAtributo]));

            if (t_CorpoUpdateConstrutor.Count = pEntidade.Atributos.Count) then
              t_CorpoUpdateConstrutor.Add(Format('                    %s = %s', [t_AtributoDTO.NomeAtributo, t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()]))
            else
              t_CorpoUpdateConstrutor.Add(Format('                    %s = %s,', [t_AtributoDTO.NomeAtributo, t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()]));
          end
          else
          begin
            if (SameText(t_ParametrosNewConstrutor, EmptyStr)) then
              t_ParametrosNewConstrutor := Format('%s %s', [t_AtributoDTO.Tipo, t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()])
            else
              t_ParametrosNewConstrutor := t_ParametrosNewConstrutor + Format(', %s %s', [t_AtributoDTO.Tipo, t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()]);

            if (SameText(t_ParametrosUpdateConstrutor, EmptyStr)) then
              t_ParametrosUpdateConstrutor := Format('%s %s', [t_AtributoDTO.Tipo, t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()])
            else
              t_ParametrosUpdateConstrutor := t_ParametrosUpdateConstrutor + Format(', %s %s', [t_AtributoDTO.Tipo, t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()]);

            if (t_CorpoNewConstrutor.Count = pEntidade.Atributos.Count) then
              t_CorpoNewConstrutor.Add(Format('                    %s = %s', [t_AtributoDTO.NomeAtributo, t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()]))
            else
              t_CorpoNewConstrutor.Add(Format('                    %s = %s,', [t_AtributoDTO.NomeAtributo, t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()]));

            if (t_CorpoUpdateConstrutor.Count = pEntidade.Atributos.Count) then
              t_CorpoUpdateConstrutor.Add(Format('                    %s = %s', [t_AtributoDTO.NomeAtributo, t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()]))
            else
              t_CorpoUpdateConstrutor.Add(Format('                    %s = %s,', [t_AtributoDTO.NomeAtributo, t_AtributoDTO.NomeAtributo.DecapitalizeFirstLetter()]));
          end;
        end;
      end;

      t_CorpoNewConstrutorAux := t_CorpoNewConstrutor.Text;
      Delete(t_CorpoNewConstrutorAux, Length(t_CorpoNewConstrutorAux) - 1, 2);

      t_CorpoUpdateConstrutorAux := t_CorpoUpdateConstrutor.Text;
      Delete(t_CorpoUpdateConstrutorAux, Length(t_CorpoUpdateConstrutorAux) - 1, 2);
    finally
      FreeAndNil(t_CorpoNewConstrutor);
      FreeAndNil(t_CorpoUpdateConstrutor);
    end;

    t_Arquivo.Add(Format('            public static %s New%s(%s)', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular, t_ParametrosNewConstrutor]));
    t_Arquivo.Add('            {');
    t_Arquivo.Add(Format('                var %s = new %s()', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter(), pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('                {');
    t_Arquivo.Add(Format('%s', [t_CorpoNewConstrutorAux]));
    t_Arquivo.Add('                };');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('                return %s;', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter()]));
    t_Arquivo.Add('            }');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('            public static %s Update%s(%s)', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular, t_ParametrosUpdateConstrutor]));
    t_Arquivo.Add('            {');
    t_Arquivo.Add(Format('                var %s = new %s()', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter(), pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('                {');
    t_Arquivo.Add(Format('%s', [t_CorpoUpdateConstrutorAux]));
    t_Arquivo.Add('                };');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('                return %s;', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter()]));
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
  Result := Format('\src\ERP.%s.Domain\%s\', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacaoPlural]);
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
