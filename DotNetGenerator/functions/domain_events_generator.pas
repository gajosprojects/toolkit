unit domain_events_generator;

interface

uses
  uEntidadeDTO;

type
  TDomainEventsGenerator = class

  public
    procedure generateBaseEvent(var pEntidade: TEntidadeDTO);
    procedure generateEventHandler(var pEntidade: TEntidadeDTO);
    procedure generateSavedEvent(var pEntidade: TEntidadeDTO);
    procedure generateUpdatedEvent(var pEntidade: TEntidadeDTO);
    procedure generateDeletedEvent(var pEntidade: TEntidadeDTO);

  end;

implementation

uses
  System.Classes, System.Contnrs, System.SysUtils, uAtributoDTO;

{ TDomainEventsGenerator }

procedure TDomainEventsGenerator.generateBaseEvent(var pEntidade: TEntidadeDTO);
var
  t_arquivo: TStringList;
  t_aux: Integer;
  t_nome_atributo: string;
  t_tipo_atributo: string;
  t_diretorio: string;
  t_AtributoDTO: TAtributoDTO;
begin
  try
    t_diretorio := EmptyStr;

    t_arquivo := TStringList.Create();

    t_arquivo.Add('using System;');
    t_arquivo.Add('using ERP.Domain.Core.Events;');
    t_arquivo.Add('');
    t_arquivo.Add(Format('namespace ERP.%s.Domain.%s.Events', [pEntidade.NomeModulo, pEntidade.NomeClassePlural]));
    t_arquivo.Add('{');
    t_arquivo.Add(Format('    public class Base%sEvent : Event', [pEntidade.NomeClasseSingular]));
    t_arquivo.Add('    {');

    t_arquivo.Add('        public Guid Id { get; protected set; }');

    for t_aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_aux]);
      t_nome_atributo := t_AtributoDTO.Nome;
      t_tipo_atributo := t_AtributoDTO.Tipo;

      t_arquivo.Add(Format('        public %s %s { get; protected set; }', [t_tipo_atributo, t_nome_atributo]));
    end;

    t_arquivo.Add('        public DateTime DataCadastro { get; protected set; }');
    t_arquivo.Add('        public DateTime DataUltimaAtualizacao { get; protected set; }');
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

    t_diretorio := Format('%s\Events', [t_diretorio]);

    if (not DirectoryExists(t_diretorio)) then
    begin
      ForceDirectories(t_diretorio);
    end;

    t_arquivo.SaveToFile(Format('%s\Base%sEvent.cs', [t_diretorio, pEntidade.NomeClasseSingular]));
  finally
    FreeAndNil(t_arquivo);
  end;
end;

procedure TDomainEventsGenerator.generateEventHandler(var pEntidade: TEntidadeDTO);
var
  t_arquivo: TStringList;
  t_nome_singular_classe: string;
  t_nome_plural_classe: string;
  t_diretorio: string;
begin
  try
    t_diretorio := EmptyStr;

    t_nome_singular_classe := pEntidade.nomeClasseSingular;
    t_nome_plural_classe := pEntidade.nomeClassePlural;

    t_arquivo := TStringList.Create();

    t_arquivo.Add('using System.Threading;');
    t_arquivo.Add('using System.Threading.Tasks;');
    t_arquivo.Add('using MediatR;');
    t_arquivo.Add('');
    t_arquivo.Add(Format('namespace ERP.%s.Domain.%s.Events', [pEntidade.NomeModulo, t_nome_plural_classe]));
    t_arquivo.Add('{');
    t_arquivo.Add(Format('    public class %sEventHandler : INotificationHandler<Saved%sEvent>, INotificationHandler<Updated%sEvent>, INotificationHandler<Deleted%sEvent>', [t_nome_singular_classe, t_nome_singular_classe, t_nome_singular_classe, t_nome_singular_classe]));
    t_arquivo.Add('    {');
    t_arquivo.Add(Format('        public Task Handle(Saved%sEvent notification, CancellationToken cancellationToken)', [t_nome_singular_classe]));
    t_arquivo.Add('        {');
    t_arquivo.Add('            return Task.CompletedTask;');
    t_arquivo.Add('        }');
    t_arquivo.Add('');
    t_arquivo.Add(Format('        public Task Handle(Updated%sEvent notification, CancellationToken cancellationToken)', [t_nome_singular_classe]));
    t_arquivo.Add('        {');
    t_arquivo.Add('            return Task.CompletedTask;');
    t_arquivo.Add('        }');
    t_arquivo.Add('');
    t_arquivo.Add(Format('        public Task Handle(Deleted%sEvent notification, CancellationToken cancellationToken)', [t_nome_singular_classe]));
    t_arquivo.Add('        {');
    t_arquivo.Add('            return Task.CompletedTask;');
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

    t_diretorio := Format('%s\Events', [t_diretorio]);

    if (not DirectoryExists(t_diretorio)) then
    begin
      ForceDirectories(t_diretorio);
    end;

    t_arquivo.SaveToFile(Format('%s\%sEventHandler.cs', [t_diretorio, pEntidade.NomeClasseSingular]));
  finally
    FreeAndNil(t_arquivo);
  end;
end;

procedure TDomainEventsGenerator.generateDeletedEvent(var pEntidade: TEntidadeDTO);
var
  t_arquivo: TStringList;
  t_diretorio: string;
begin
  try
    t_diretorio := EmptyStr;

    t_arquivo := TStringList.Create();

    t_arquivo.Add('using System;');
    t_arquivo.Add('');
    t_arquivo.Add(Format('namespace ERP.%s.Domain.%s.Events', [pEntidade.NomeModulo, pEntidade.NomeClassePlural]));
    t_arquivo.Add('{');
    t_arquivo.Add(Format('    public class Deleted%sEvent : Base%sEvent', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
    t_arquivo.Add('    {');
    t_arquivo.Add(Format('        public Deleted%sEvent(Guid id)', [pEntidade.NomeClasseSingular]));
    t_arquivo.Add('        {');
    t_arquivo.Add('            Id = id;');
    t_arquivo.Add('            AggregateId = Id;');
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

    t_diretorio := Format('%s\Events', [t_diretorio]);

    if (not DirectoryExists(t_diretorio)) then
    begin
      ForceDirectories(t_diretorio);
    end;

    t_arquivo.SaveToFile(Format('%s\Deleted%sEvent.cs', [t_diretorio, pEntidade.NomeClasseSingular]));
  finally
    FreeAndNil(t_arquivo);
  end;
end;

procedure TDomainEventsGenerator.generateSavedEvent(var pEntidade: TEntidadeDTO);
var
  t_arquivo: TStringList;
  t_aux: Integer;
  t_nome_atributo: string;
  t_nome_snk_atributo: string;
  t_tipo_atributo: string;
  t_parametros_saved_entidade_event: string;
  t_corpo_saved_entidade_event: TStringList;
  t_corpo_saved_entidade_event_aux: string;
  t_diretorio: string;
  t_AtributoDTO: TAtributoDTO;
begin
  try
    t_diretorio := EmptyStr;

    t_arquivo := TStringList.Create();

    t_arquivo.Add('using System;');
    t_arquivo.Add('');
    t_arquivo.Add(Format('namespace ERP.%s.Domain.%s.Events', [pEntidade.NomeModulo, pEntidade.NomeClassePlural]));
    t_arquivo.Add('{');
    t_arquivo.Add(Format('    public class Saved%sEvent : Base%sEvent', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
    t_arquivo.Add('    {');

    try
      t_parametros_saved_entidade_event := EmptyStr;
      t_corpo_saved_entidade_event := TStringList.Create();

      t_parametros_saved_entidade_event := 'Guid id';
      t_corpo_saved_entidade_event.Add('            Id = id;');

      for t_aux := 0 to pEntidade.Atributos.Count - 1 do
      begin
        t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_aux]);
        t_nome_atributo := t_AtributoDTO.Nome;
        t_nome_snk_atributo := LowerCase(Copy(t_nome_atributo, 1, 1)) + Copy(t_nome_atributo, 2, Length(t_nome_atributo));
        t_tipo_atributo := t_AtributoDTO.Tipo;

        t_parametros_saved_entidade_event := t_parametros_saved_entidade_event + Format(', %s %s', [t_tipo_atributo, t_nome_snk_atributo]);

        t_corpo_saved_entidade_event.Add(Format('            %s = %s;', [t_nome_atributo, t_nome_snk_atributo]));
      end;

      t_parametros_saved_entidade_event := t_parametros_saved_entidade_event + ', DateTime dataCadastro, DateTime dataUltimaAtualizacao';

      t_corpo_saved_entidade_event.Add('            DataCadastro = dataCadastro;');
      t_corpo_saved_entidade_event.Add('            DataUltimaAtualizacao = dataUltimaAtualizacao;');
      t_corpo_saved_entidade_event.Add('            AggregateId = Id;');

      t_corpo_saved_entidade_event_aux := t_corpo_saved_entidade_event.Text;
      Delete(t_corpo_saved_entidade_event_aux, Length(t_corpo_saved_entidade_event_aux) - 1, 2);
    finally
      FreeAndNil(t_corpo_saved_entidade_event);
    end;

    t_arquivo.Add(Format('        public Saved%sEvent(%s)', [pEntidade.NomeClasseSingular, t_parametros_saved_entidade_event]));
    t_arquivo.Add('        {');
    t_arquivo.Add(Format('%s', [t_corpo_saved_entidade_event_aux]));
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

    t_diretorio := Format('%s\Events', [t_diretorio]);

    if (not DirectoryExists(t_diretorio)) then
    begin
      ForceDirectories(t_diretorio);
    end;

    t_arquivo.SaveToFile(Format('%s\Saved%sEvent.cs', [t_diretorio, pEntidade.NomeClasseSingular]));
  finally
    FreeAndNil(t_arquivo);
  end;
end;

procedure TDomainEventsGenerator.generateUpdatedEvent(var pEntidade: TEntidadeDTO);
var
  t_arquivo: TStringList;
  t_aux: Integer;
  t_nome_atributo: string;
  t_nome_snk_atributo: string;
  t_tipo_atributo: string;
  t_parametros_updated_entidade_event: string;
  t_corpo_updated_entidade_event: TStringList;
  t_corpo_updated_entidade_event_aux: string;
  t_diretorio: string;
  t_AtributoDTO: TAtributoDTO;
begin
  try
    t_diretorio := EmptyStr;

    t_arquivo := TStringList.Create();

    t_arquivo.Add('using System;');
    t_arquivo.Add('');
    t_arquivo.Add(Format('namespace ERP.%s.Domain.%s.Events', [pEntidade.NomeModulo, pEntidade.NomeClassePlural]));
    t_arquivo.Add('{');
    t_arquivo.Add(Format('    public class Updated%sEvent : Base%sEvent', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
    t_arquivo.Add('    {');

    try
      t_parametros_updated_entidade_event := EmptyStr;
      t_corpo_updated_entidade_event := TStringList.Create();

      t_parametros_updated_entidade_event := 'Guid id';
      t_corpo_updated_entidade_event.Add('            Id = id;');

      for t_aux := 0 to pEntidade.Atributos.Count - 1 do
      begin
        t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_aux]);
        t_nome_atributo := t_AtributoDTO.Nome;
        t_nome_snk_atributo := LowerCase(Copy(t_nome_atributo, 1, 1)) + Copy(t_nome_atributo, 2, Length(t_nome_atributo));
        t_tipo_atributo := t_AtributoDTO.Tipo;

        t_parametros_updated_entidade_event := t_parametros_updated_entidade_event + Format(', %s %s', [t_tipo_atributo, t_nome_snk_atributo]);

        t_corpo_updated_entidade_event.Add(Format('            %s = %s;', [t_nome_atributo, t_nome_snk_atributo]));
      end;

      t_parametros_updated_entidade_event := t_parametros_updated_entidade_event + ', DateTime dataUltimaAtualizacao';

      t_corpo_updated_entidade_event.Add('            DataUltimaAtualizacao = dataUltimaAtualizacao;');
      t_corpo_updated_entidade_event.Add('            AggregateId = Id;');

      t_corpo_updated_entidade_event_aux := t_corpo_updated_entidade_event.Text;
      Delete(t_corpo_updated_entidade_event_aux, Length(t_corpo_updated_entidade_event_aux) - 1, 2);
    finally
      FreeAndNil(t_corpo_updated_entidade_event);
    end;

    t_arquivo.Add(Format('        public Updated%sEvent(%s)', [pEntidade.NomeClasseSingular, t_parametros_updated_entidade_event]));
    t_arquivo.Add('        {');
    t_arquivo.Add(Format('%s', [t_corpo_updated_entidade_event_aux]));
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

    t_diretorio := Format('%s\Events', [t_diretorio]);

    if (not DirectoryExists(t_diretorio)) then
    begin
      ForceDirectories(t_diretorio);
    end;

    t_arquivo.SaveToFile(Format('%s\Updated%sEvent.cs', [t_diretorio, pEntidade.NomeClasseSingular]));
  finally
    FreeAndNil(t_arquivo);
  end;
end;

end.
