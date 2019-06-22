unit service_api_view_model_generator;

interface

uses
  uEntidadeDTO, Vcl.Dialogs;

type
  TServiceApiViewModelGenerator = class

  public
    procedure generate(var pEntidade: TEntidadeDTO);

  end;

implementation

uses
  System.Classes, System.SysUtils;

{ clAdminDomainClassCommands }

procedure TServiceApiViewModelGenerator.generate(var pEntidade: TEntidadeDTO);
var
  t_arquivo: TStringList;
  t_aux: Integer;
  t_nome_atributo_pk: string;
  t_tipo_atributo_pk: string;
  t_diretorio: string;
begin
  try
    t_diretorio := EmptyStr;

    t_arquivo := TStringList.Create();

    t_arquivo.Add('using System;');
    t_arquivo.Add('using System.ComponentModel.DataAnnotations;');
    t_arquivo.Add('');
    t_arquivo.Add(Format('namespace ERP.Services.API.ViewModels', [pEntidade.nomeModulo]));
    t_arquivo.Add('{');
    t_arquivo.Add(Format('    public class %sViewModel', [pEntidade.nomeClasseSingular]));
    t_arquivo.Add('    {');

    for t_aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      if (pEntidade.Atributos.Items[t_aux].ChavePrimaria) then
      begin
        t_nome_atributo_pk := pEntidade.Atributos.Items[t_aux].Nome;
        t_tipo_atributo_pk := pEntidade.Atributos.Items[t_aux].Tipo;

        t_arquivo.Add('        [Key]');
        t_arquivo.Add(Format('        public %s %s { get; set; }', [t_tipo_atributo_pk, t_nome_atributo_pk]));
        t_arquivo.Add('');

        Break;
      end;
    end;

    for t_aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      if (not pEntidade.Atributos.Items[t_aux].ChavePrimaria) then
      begin
        t_arquivo.Add(Format('        [Display(Name = "%s")]', [pEntidade.Atributos.Items[t_aux].NomeExibicao]));

        //requerimento de campo
        if (pEntidade.Atributos.Items[t_aux].Requerido) then
        begin
          t_arquivo.Add('        [Required(ErrorMessage = "Campo obrigatório")]');
        end;

        //validacao de tamanho de campo
  //      if (False) then
  //      begin
  //        t_arquivo.Add(Format('        [MinLength(1, ErrorMessage = "Tamanho mínimo {%s} caracteres")]', [IntToChar(pEntidade.Atributos.Items[t_aux].TamanhoMinimo)]));
  //        t_arquivo.Add(Format('        [MaxLength(7, ErrorMessage = "Tamanho máximo {%s} caracteres")]', [IntToChar(pEntidade.Atributos.Items[t_aux].TamanhoMaximo)]));
  //      end;

        t_arquivo.Add(Format('        public %s %s { get; set; }', [pEntidade.Atributos.Items[t_aux].Tipo, pEntidade.Atributos.Items[t_aux].Nome]));
        t_arquivo.Add('');
      end;
    end;

    t_arquivo.Add(Format('    public %sViewModel()', [pEntidade.nomeClasseSingular]));
    t_arquivo.Add('        {');
    t_arquivo.Add(Format('            %s = new %s();', [t_nome_atributo_pk, t_tipo_atributo_pk]));
    t_arquivo.Add('        }');
    t_arquivo.Add('    }');
    t_arquivo.Add('}');

    t_diretorio := GetCurrentDir() + '\ERP.Services.API\ViewModels';

    if (not DirectoryExists(t_diretorio)) then
    begin
      ForceDirectories(t_diretorio);
    end;

    t_arquivo.SaveToFile(Format('%s\%sViewModel.cs', [t_diretorio, pEntidade.NomeClasseSingular]));
  finally
    FreeAndNil(t_arquivo);
  end;
end;

end.
