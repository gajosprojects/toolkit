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
  System.Classes, System.Contnrs, System.SysUtils, uAtributoDTO;

{ clAdminDomainClassCommands }

procedure TServiceApiViewModelGenerator.generate(var pEntidade: TEntidadeDTO);
var
  t_arquivo: TStringList;
  t_aux: Integer;
  t_diretorio: string;
  t_AtributoDTO: TAtributoDTO;
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

    //atributo identificador
    t_arquivo.Add('        [Key]');
    t_arquivo.Add('        public Guid Id { get; set; }');
    t_arquivo.Add('');

    //demais atributos
    for t_aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_aux]);
	  
      t_arquivo.Add(Format('        [Display(Name = "%s")]', [t_AtributoDTO.NomeExibicao]));

      //requerimento de campo
      if (t_AtributoDTO.Requerido) then
      begin
        t_arquivo.Add('        [Required(ErrorMessage = "Campo obrigatório")]');
      end;

      //validacao de tamanho de campo
  //    if (False) then
  //    begin
  //      t_arquivo.Add(Format('        [MinLength(1, ErrorMessage = "Tamanho mínimo {%s} caracteres")]', [IntToChar(t_AtributoDTO.TamanhoMinimo)]));
  //      t_arquivo.Add(Format('        [MaxLength(7, ErrorMessage = "Tamanho máximo {%s} caracteres")]', [IntToChar(t_AtributoDTO.TamanhoMaximo)]));
  //    end;

      t_arquivo.Add(Format('        public %s %s { get; set; }', [t_AtributoDTO.Tipo, TAtributoDTO(pEntidade.Atributos.Items[t_aux]).Nome]));
      t_arquivo.Add('');
    end;

    t_arquivo.Add(Format('    public %sViewModel()', [pEntidade.nomeClasseSingular]));
    t_arquivo.Add('        {');
    t_arquivo.Add('            Id = new Guid();');
    t_arquivo.Add('        }');
    t_arquivo.Add('    }');
    t_arquivo.Add('}');

    t_diretorio := GetCurrentDir() + '\ERP.Services.API\ViewModels';

    if (not DirectoryExists(t_diretorio)) then
    begin
      ForceDirectories(t_diretorio);
    end;

    t_diretorio := Format('%s\%s', [t_diretorio, pEntidade.NomeModulo]);

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
