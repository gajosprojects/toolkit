unit domain_events_generator;

interface

uses
  uEntidadeDTO, uArquivoDTO;

type
  TDomainEventsGenerator = class

  private
    function getBaseFileName(const pEntidade: TEntidadeDTO): string;
    function getBaseFileContent(const pEntidade: TEntidadeDTO): WideString;

    function getHandlerFileName(const pEntidade: TEntidadeDTO): string;
    function getHandlerFileContent(const pEntidade: TEntidadeDTO): WideString;

    function getSaveFileName(const pEntidade: TEntidadeDTO): string;
    function getSaveFileContent(const pEntidade: TEntidadeDTO): WideString;

    function getUpdateFileName(const pEntidade: TEntidadeDTO): string;
    function getUpdateFileContent(const pEntidade: TEntidadeDTO): WideString;

    function getDeleteFileName(const pEntidade: TEntidadeDTO): string;
    function getDeleteFileContent(const pEntidade: TEntidadeDTO): WideString;

    function getFileDirectory(const pEntidade: TEntidadeDTO): string;
    function getFileHandlerDirectory(const pEntidade: TEntidadeDTO): string;

  public
    function generateBaseFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
    function generateHandlerFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
    function generateSaveFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
    function generateUpdateFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
    function generateDeleteFile(const pEntidade: TEntidadeDTO): TArquivoDTO;

  end;

implementation

uses
  System.Classes, System.Contnrs, System.SysUtils, uAtributoDTO;

{ TDomainEventsGenerator }

function TDomainEventsGenerator.generateBaseFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileDirectory(pEntidade);
  Result.Nome      := getBaseFileName(pEntidade);
  Result.Conteudo  := getBaseFileContent(pEntidade);
end;

function TDomainEventsGenerator.generateHandlerFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileHandlerDirectory(pEntidade);
  Result.Nome      := getHandlerFileName(pEntidade);
  Result.Conteudo  := getHandlerFileContent(pEntidade);
end;

function TDomainEventsGenerator.generateDeleteFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileDirectory(pEntidade);
  Result.Nome      := getDeleteFileName(pEntidade);
  Result.Conteudo  := getDeleteFileContent(pEntidade);
end;

function TDomainEventsGenerator.generateSaveFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileDirectory(pEntidade);
  Result.Nome      := getSaveFileName(pEntidade);
  Result.Conteudo  := getSaveFileContent(pEntidade);
end;

function TDomainEventsGenerator.generateUpdateFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileDirectory(pEntidade);
  Result.Nome      := getUpdateFileName(pEntidade);
  Result.Conteudo  := getUpdateFileContent(pEntidade);
end;

function TDomainEventsGenerator.getBaseFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
  t_Aux: Integer;
  t_NomeAtributo: string;
  t_TipoAtributo: string;
  t_AtributoDTO: TAtributoDTO;
begin
  t_Arquivo := TStringList.Create();

  try
    t_Arquivo.Add('using ERP.Domain.Core.Events;');
    t_Arquivo.Add('using System;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.%s.Domain.%s.Events.%s', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao, pEntidade.NomeClassePlural]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class Base%sEvent : Event', [pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('    {');

    for t_Aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_Aux]);
      t_NomeAtributo := t_AtributoDTO.NomeAtributo;
      t_TipoAtributo := t_AtributoDTO.Tipo;

      if (SameText(t_AtributoDTO.NomeCampo, 'usuario_id')) then
        t_Arquivo.Add(Format('        public Guid %s { get; protected set; }', [t_NomeAtributo]))
      else
        t_Arquivo.Add(Format('        public %s %s { get; protected set; }', [t_TipoAtributo, t_NomeAtributo]));
    end;

    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;

end;

function TDomainEventsGenerator.getBaseFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('Base%sEvent.cs', [pEntidade.NomeClasseSingular]);
end;

function TDomainEventsGenerator.getDeleteFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
begin
  t_Arquivo := TStringList.Create();

  try
    t_Arquivo.Add('using System;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.%s.Domain.%s.Events.%s', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao, pEntidade.NomeClassePlural]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class Deleted%sEvent : Base%sEvent', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('    {');
    t_Arquivo.Add(Format('        public Deleted%sEvent(Guid id, Guid usuarioId)', [pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add('            Id = id;');
    t_Arquivo.Add('            UsuarioId = usuarioId;');
    t_Arquivo.Add('            AggregateId = Id;');
    t_Arquivo.Add('        }');
    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TDomainEventsGenerator.getDeleteFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('Deleted%sEvent.cs', [pEntidade.NomeClasseSingular]);
end;

function TDomainEventsGenerator.getFileDirectory(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('\ERP.%s.Domain\%s\Events\%s\', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao, pEntidade.NomeClassePlural]);
end;

function TDomainEventsGenerator.getFileHandlerDirectory(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('\ERP.%s.Domain\%s\Events\', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao]);
end;

function TDomainEventsGenerator.getHandlerFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
  t_NomeSingularClasse: string;
  t_NomePluralClasse: string;
begin
  t_Arquivo := TStringList.Create();

  try
    t_NomeSingularClasse := pEntidade.nomeClasseSingular;
    t_NomePluralClasse := pEntidade.nomeClassePlural;

    t_Arquivo.Add(Format('using ERP.%s.Domain.%s.Events.%s;', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao, pEntidade.NomeClassePlural]));
    t_Arquivo.Add('using MediatR;');
    t_Arquivo.Add('using System.Threading;');
    t_Arquivo.Add('using System.Threading.Tasks;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.%s.Domain.%s.Events', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class %sEventHandler : INotificationHandler<Saved%sEvent>, INotificationHandler<Updated%sEvent>, INotificationHandler<Deleted%sEvent>', [t_NomeSingularClasse, t_NomeSingularClasse, t_NomeSingularClasse, t_NomeSingularClasse]));
    t_Arquivo.Add('    {');
    t_Arquivo.Add(Format('        public Task Handle(Saved%sEvent notification, CancellationToken cancellationToken)', [t_NomeSingularClasse]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add('            return Task.CompletedTask;');
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('        public Task Handle(Updated%sEvent notification, CancellationToken cancellationToken)', [t_NomeSingularClasse]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add('            return Task.CompletedTask;');
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('        public Task Handle(Deleted%sEvent notification, CancellationToken cancellationToken)', [t_NomeSingularClasse]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add('            return Task.CompletedTask;');
    t_Arquivo.Add('        }');
    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TDomainEventsGenerator.getHandlerFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('%sEventHandler.cs', [pEntidade.NomeClasseSingular]);
end;

function TDomainEventsGenerator.getSaveFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
  t_Aux: Integer;
  t_NomeAtributo: string;
  t_NomeSnkAtributo: string;
  t_TipoAtributo: string;
  t_ParametrosSaved_entidade_event: string;
  t_CorpoSavedEntidadeEvent: TStringList;
  t_CorpoSavedEntidadeEventAux: string;
  t_AtributoDTO: TAtributoDTO;
begin
  t_Arquivo := TStringList.Create();

  try
    t_Arquivo.Add('using System;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.%s.Domain.%s.Events.%s', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao, pEntidade.NomeClassePlural]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class Saved%sEvent : Base%sEvent', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('    {');

    try
      t_ParametrosSaved_entidade_event := EmptyStr;
      t_CorpoSavedEntidadeEvent := TStringList.Create();

      for t_Aux := 0 to pEntidade.Atributos.Count - 1 do
      begin
        t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_Aux]);
        t_NomeAtributo := t_AtributoDTO.NomeAtributo;
        t_NomeSnkAtributo := LowerCase(Copy(t_NomeAtributo, 1, 1)) + Copy(t_NomeAtributo, 2, Length(t_NomeAtributo));
        t_TipoAtributo := t_AtributoDTO.Tipo;

        if (SameText(t_ParametrosSaved_entidade_event, EmptyStr)) then
        begin
          if (SameText(t_AtributoDTO.NomeCampo, 'usuario_id')) then
            t_ParametrosSaved_entidade_event := Format('Guid %s', [t_NomeSnkAtributo])
          else
            t_ParametrosSaved_entidade_event := Format('%s %s', [t_TipoAtributo, t_NomeSnkAtributo])
        end
        else
        begin
          if (SameText(t_AtributoDTO.NomeCampo, 'usuario_id')) then
            t_ParametrosSaved_entidade_event := t_ParametrosSaved_entidade_event + Format(', Guid %s', [t_NomeSnkAtributo])
          else
            t_ParametrosSaved_entidade_event := t_ParametrosSaved_entidade_event + Format(', %s %s', [t_TipoAtributo, t_NomeSnkAtributo]);
        end;

        t_CorpoSavedEntidadeEvent.Add(Format('            %s = %s;', [t_NomeAtributo, t_NomeSnkAtributo]));
      end;

      t_CorpoSavedEntidadeEvent.Add('            AggregateId = Id;');

      t_CorpoSavedEntidadeEventAux := t_CorpoSavedEntidadeEvent.Text;
      Delete(t_CorpoSavedEntidadeEventAux, Length(t_CorpoSavedEntidadeEventAux) - 1, 2);
    finally
      FreeAndNil(t_CorpoSavedEntidadeEvent);
    end;

    t_Arquivo.Add(Format('        public Saved%sEvent(%s)', [pEntidade.NomeClasseSingular, t_ParametrosSaved_entidade_event]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add(Format('%s', [t_CorpoSavedEntidadeEventAux]));
    t_Arquivo.Add('        }');
    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TDomainEventsGenerator.getSaveFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('Saved%sEvent.cs', [pEntidade.NomeClasseSingular]);
end;

function TDomainEventsGenerator.getUpdateFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
  t_Aux: Integer;
  t_NomeAtributo: string;
  t_NomeSnkAtributo: string;
  t_TipoAtributo: string;
  t_ParametrosUpdatedEntidadeEvent: string;
  t_CorpoUpdatedEntidadeEvent: TStringList;
  t_CorpoUpdatedEntidadeEventAux: string;
  t_AtributoDTO: TAtributoDTO;
begin
  t_Arquivo := TStringList.Create();

  try
    t_Arquivo.Add('using System;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.%s.Domain.%s.Events.%s', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao, pEntidade.NomeClassePlural]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class Updated%sEvent : Base%sEvent', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('    {');

    try
      t_ParametrosUpdatedEntidadeEvent := EmptyStr;
      t_CorpoUpdatedEntidadeEvent := TStringList.Create();

      for t_Aux := 0 to pEntidade.Atributos.Count - 1 do
      begin
        t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_Aux]);
        t_NomeAtributo := t_AtributoDTO.NomeAtributo;
        t_NomeSnkAtributo := LowerCase(Copy(t_NomeAtributo, 1, 1)) + Copy(t_NomeAtributo, 2, Length(t_NomeAtributo));
        t_TipoAtributo := t_AtributoDTO.Tipo;

        if (SameText(t_ParametrosUpdatedEntidadeEvent, EmptyStr)) then
        begin
          if (SameText(t_AtributoDTO.NomeCampo, 'usuario_id')) then
            t_ParametrosUpdatedEntidadeEvent := Format('Guid %s', [t_NomeSnkAtributo])
          else
            t_ParametrosUpdatedEntidadeEvent := Format('%s %s', [t_TipoAtributo, t_NomeSnkAtributo]);
        end
        else
        begin
          if (SameText(t_AtributoDTO.NomeCampo, 'usuario_id')) then
            t_ParametrosUpdatedEntidadeEvent := t_ParametrosUpdatedEntidadeEvent + Format(', Guid %s', [t_NomeSnkAtributo])
          else
            t_ParametrosUpdatedEntidadeEvent := t_ParametrosUpdatedEntidadeEvent + Format(', %s %s', [t_TipoAtributo, t_NomeSnkAtributo]);
        end;

        t_CorpoUpdatedEntidadeEvent.Add(Format('            %s = %s;', [t_NomeAtributo, t_NomeSnkAtributo]));
      end;

      t_CorpoUpdatedEntidadeEvent.Add('            AggregateId = Id;');

      t_CorpoUpdatedEntidadeEventAux := t_CorpoUpdatedEntidadeEvent.Text;
      Delete(t_CorpoUpdatedEntidadeEventAux, Length(t_CorpoUpdatedEntidadeEventAux) - 1, 2);
    finally
      FreeAndNil(t_CorpoUpdatedEntidadeEvent);
    end;

    t_Arquivo.Add(Format('        public Updated%sEvent(%s)', [pEntidade.NomeClasseSingular, t_ParametrosUpdatedEntidadeEvent]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add(Format('%s', [t_CorpoUpdatedEntidadeEventAux]));
    t_Arquivo.Add('        }');
    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TDomainEventsGenerator.getUpdateFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('Updated%sEvent.cs', [pEntidade.NomeClasseSingular]);
end;

end.
