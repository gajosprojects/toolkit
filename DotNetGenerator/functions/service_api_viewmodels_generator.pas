unit service_api_viewmodels_generator;

interface

uses
  uEntidadeDTO, Vcl.Dialogs, uArquivoDTO;

type
  TServiceApiViewModelsGenerator = class

  private
    function getBaseFileName(const pEntidade: TEntidadeDTO): string;
    function getBaseFileContent(const pEntidade: TEntidadeDTO): WideString;

    function getSaveFileName(const pEntidade: TEntidadeDTO): string;
    function getSaveFileContent(const pEntidade: TEntidadeDTO): WideString;

    function getUpdateFileName(const pEntidade: TEntidadeDTO): string;
    function getUpdateFileContent(const pEntidade: TEntidadeDTO): WideString;

    function getDeleteFileName(const pEntidade: TEntidadeDTO): string;
    function getDeleteFileContent(const pEntidade: TEntidadeDTO): WideString;

    function getFileDirectory(const pEntidade: TEntidadeDTO): string;

  public
    function getBaseFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
    function getSaveFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
    function getUpdateFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
    function getDeleteFile(const pEntidade: TEntidadeDTO): TArquivoDTO;

  end;

implementation

uses
  System.Classes, System.Contnrs, System.SysUtils, uAtributoDTO;

{ clAdminDomainClassCommands }

function TServiceApiViewModelsGenerator.getBaseFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
  t_Aux: Integer;
  t_AtributoDTO: TAtributoDTO;
begin
  t_Arquivo := TStringList.Create();

  try
    t_Arquivo.Add('using ERP.Services.API.ViewModels.Gerencial.Usuario;');
    //se tiver chave estrangeira, incluir o uses da classe
    t_Arquivo.Add('using System;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.Services.API.ViewModels.%s.%s', [pEntidade.nomeModulo, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class %sViewModel', [pEntidade.nomeClasseSingular]));
    t_Arquivo.Add('    {');

    //atributo identificador
    t_Arquivo.Add('        public Guid Id { get; set; }');

    //demais atributos
    for t_Aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_Aux]);
      //se for chave estrangeira, incluir o objeto e nao o atributo, igual ao UsuarioViewModel abaixo
      t_Arquivo.Add(Format('        public %s %s { get; set; }', [t_AtributoDTO.Tipo, t_AtributoDTO.NomeAtributo]));
    end;

    t_Arquivo.Add('        public DateTime DataCadastro { get; set; }');
    t_Arquivo.Add('        public DateTime DataUltimaAtualizacao { get; set; }');
    t_Arquivo.Add('        public bool Desativado { get; set; }');
    //se for chave estrangeira, incluir o objeto e nao o atributo, igual ao UsuarioViewModel abaixo
    t_Arquivo.Add('        public UsuarioViewModel Usuario { get; set; }');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('    public %sViewModel()', [pEntidade.nomeClasseSingular]));
    t_Arquivo.Add('        {');
    //se for chave estrangeira, incluir o objeto e nao o atributo, igual ao UsuarioViewModel abaixo
    t_Arquivo.Add('            Usuario = new UsuarioViewModel();');
    t_Arquivo.Add('        }');
    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TServiceApiViewModelsGenerator.getBaseFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('%sViewModel.cs', [pEntidade.NomeClasseSingular]);
end;

function TServiceApiViewModelsGenerator.getDeleteFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileDirectory(pEntidade);
  Result.Nome      := getDeleteFileName(pEntidade);
  Result.Conteudo  := getDeleteFileContent(pEntidade);
end;

function TServiceApiViewModelsGenerator.getDeleteFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
begin
  t_Arquivo := TStringList.Create();

  try
    t_Arquivo.Add('using ERP.Services.API.Utils.Validation;');
    t_Arquivo.Add('using System;');
    t_Arquivo.Add('using System.ComponentModel.DataAnnotations;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.Services.API.ViewModels.%s.%s', [pEntidade.nomeModulo, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class Delete%sViewModel', [pEntidade.nomeClasseSingular]));
    t_Arquivo.Add('    {');

    //atributo identificador
    t_Arquivo.Add('        [Required(ErrorMessage = "Campo obrigatório")]');
    t_Arquivo.Add('        public Guid Id { get; set; }');
    t_Arquivo.Add('');
    t_Arquivo.Add('        [NotEmptyGuid(ErrorMessage = "Campo obrigatório")]');
    t_Arquivo.Add('        public Guid UsuarioId { get; set; }');
    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TServiceApiViewModelsGenerator.getDeleteFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('Delete%sViewModel.cs', [pEntidade.NomeClasseSingular]);
end;

function TServiceApiViewModelsGenerator.getBaseFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileDirectory(pEntidade);
  Result.Nome      := getBaseFileName(pEntidade);
  Result.Conteudo  := getBaseFileContent(pEntidade);
end;

function TServiceApiViewModelsGenerator.getFileDirectory(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('ERP.Services.API\ViewModels\%s\%s\', [pEntidade.NomeModulo, pEntidade.NomeClasseSingular]);
end;

function TServiceApiViewModelsGenerator.getSaveFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileDirectory(pEntidade);
  Result.Nome      := getSaveFileName(pEntidade);
  Result.Conteudo  := getSaveFileContent(pEntidade);
end;

function TServiceApiViewModelsGenerator.getSaveFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
  t_Aux: Integer;
  t_AtributoDTO: TAtributoDTO;
begin
  t_Arquivo := TStringList.Create();

  try
    t_Arquivo.Add('using ERP.Services.API.Utils.Validation;');
    t_Arquivo.Add('using System;');
    t_Arquivo.Add('using System.ComponentModel.DataAnnotations;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.Services.API.ViewModels.%s.%s', [pEntidade.nomeModulo, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class Save%sViewModel', [pEntidade.nomeClasseSingular]));
    t_Arquivo.Add('    {');

    //atributo identificador
    t_Arquivo.Add('        [Key]');
    t_Arquivo.Add('        public Guid Id { get; set; }');
    t_Arquivo.Add('');

    //demais atributos
    for t_Aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_Aux]);

      t_Arquivo.Add(Format('        [Display(Name = "%s")]', [t_AtributoDTO.NomeExibicao]));

      //requerimento de campo
      if (t_AtributoDTO.Requerido) then
      begin
        //se for chave estrangeira utilizar o NotEmptyGuid ao inves do Required
        t_Arquivo.Add('        [Required(ErrorMessage = "Campo obrigatório")]');
      end;

      t_Arquivo.Add(Format('        public %s %s { get; set; }', [t_AtributoDTO.Tipo, t_AtributoDTO.NomeAtributo]));
      t_Arquivo.Add('');
    end;

    t_Arquivo.Add('        [Display(Name = "Data cadastro")]');
    t_Arquivo.Add('        public DateTime DataCadastro { get; set; }');
    t_Arquivo.Add('');
    t_Arquivo.Add('        [Display(Name = "Data última atualização")]');
    t_Arquivo.Add('        public DateTime DataUltimaAtualizacao { get; set; }');
    t_Arquivo.Add('');
    t_Arquivo.Add('        [NotEmptyGuid(ErrorMessage = "Campo obrigatório")]');
    t_Arquivo.Add('        public Guid UsuarioId { get; set; }');
    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TServiceApiViewModelsGenerator.getSaveFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('Save%sViewModel.cs', [pEntidade.NomeClasseSingular]);
end;

function TServiceApiViewModelsGenerator.getUpdateFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileDirectory(pEntidade);
  Result.Nome      := getUpdateFileName(pEntidade);
  Result.Conteudo  := getUpdateFileContent(pEntidade);
end;

function TServiceApiViewModelsGenerator.getUpdateFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
  t_Aux: Integer;
  t_AtributoDTO: TAtributoDTO;
begin
  t_Arquivo := TStringList.Create();

  try
    t_Arquivo.Add('using ERP.Services.API.Utils.Validation;');
    t_Arquivo.Add('using System;');
    t_Arquivo.Add('using System.ComponentModel.DataAnnotations;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.Services.API.ViewModels.%s.%s', [pEntidade.nomeModulo, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class Update%sViewModel', [pEntidade.nomeClasseSingular]));
    t_Arquivo.Add('    {');

    //atributo identificador
    t_Arquivo.Add('        [Key]');
    t_Arquivo.Add('        public Guid Id { get; set; }');
    t_Arquivo.Add('');

    //demais atributos
    for t_Aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_Aux]);

      t_Arquivo.Add(Format('        [Display(Name = "%s")]', [t_AtributoDTO.NomeExibicao]));

      //requerimento de campo
      if (t_AtributoDTO.Requerido) then
      begin
        //se for chave estrangeira utilizar o NotEmptyGuid ao inves do Required
        t_Arquivo.Add('        [Required(ErrorMessage = "Campo obrigatório")]');
      end;

      t_Arquivo.Add(Format('        public %s %s { get; set; }', [t_AtributoDTO.Tipo, t_AtributoDTO.NomeAtributo]));
      t_Arquivo.Add('');
    end;

    t_Arquivo.Add('        [Display(Name = "Data última atualização")]');
    t_Arquivo.Add('        public DateTime DataUltimaAtualizacao { get; set; }');
    t_Arquivo.Add('');
    t_Arquivo.Add('        [NotEmptyGuid(ErrorMessage = "Campo obrigatório")]');
    t_Arquivo.Add('        public Guid UsuarioId { get; set; }');
    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TServiceApiViewModelsGenerator.getUpdateFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('Update%sViewModel.cs', [pEntidade.NomeClasseSingular]);
end;

end.
