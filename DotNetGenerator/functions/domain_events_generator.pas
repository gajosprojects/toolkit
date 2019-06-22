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
  System.Classes, System.SysUtils;

{ TDomainEventsGenerator }

procedure TDomainEventsGenerator.generateBaseEvent(var pEntidade: TEntidadeDTO);
var
  t_arquivo: TStringList;
  t_aux: Integer;
  t_nome_atributo: string;
  t_tipo_atributo: string;
  t_diretorio: string;
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

    for t_aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      t_nome_atributo := pEntidade.Atributos.Items[t_aux].Nome;
      t_tipo_atributo := pEntidade.Atributos.Items[t_aux].Tipo;

      t_arquivo.Add(Format('        public %s %s { get; protected set; }', [t_tipo_atributo, t_nome_atributo]));
    end;

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
  t_aux: Integer;
  t_nome_atributo: string;
  t_nome_snk_atributo: string;
  t_tipo_atributo: string;
  t_parametros_deleted_entidade_event: string;
  t_corpo_update_deleted_event: TStringList;
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

    try
      t_corpo_update_deleted_event := TStringList.Create();

      for t_aux := 0 to pEntidade.Atributos.Count - 1 do
      begin
        if (pEntidade.Atributos.Items[t_aux].ChavePrimaria) then
        begin
          t_nome_atributo := pEntidade.Atributos.Items[t_aux].Nome;
          t_nome_snk_atributo := LowerCase(Copy(t_nome_atributo, 1, 1)) + Copy(t_nome_atributo, 2, Length(t_nome_atributo));
          t_tipo_atributo := pEntidade.Atributos.Items[t_aux].Tipo;

          if SameText(t_parametros_deleted_entidade_event, EmptyStr) then
          begin
            t_parametros_deleted_entidade_event := Format('%s %s', [t_tipo_atributo, t_nome_snk_atributo])
          end
          else
          begin
            t_parametros_deleted_entidade_event := t_parametros_deleted_entidade_event + Format(', %s %s', [t_tipo_atributo, t_nome_snk_atributo])
          end;

          t_corpo_update_deleted_event.Add(Format('            %s = %s;', [t_nome_atributo, t_nome_snk_atributo]));
        end;
      end;

      t_corpo_update_deleted_event.Add(Format('            Aggregate%s = %s;', [t_nome_atributo, t_nome_atributo]));

      t_arquivo.Add(Format('        public Deleted%sEvent(%s)', [pEntidade.NomeClasseSingular, t_parametros_deleted_entidade_event]));
      t_arquivo.Add('        {');
      t_arquivo.Add(Format('%s', [t_corpo_update_deleted_event.Text]));
      t_arquivo.Add('        }');
    finally
      FreeAndNil(t_corpo_update_deleted_event);
    end;

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
  t_nome_atributo_pk: string;
  t_nome_snk_atributo_pk: string;
  t_parametros_saved_entidade_event: string;
  t_corpo_saved_entidade_event: TStringList;
  t_diretorio: string;
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
      t_corpo_saved_entidade_event := TStringList.Create();

      for t_aux := 0 to pEntidade.Atributos.Count - 1 do
      begin
        t_nome_atributo := pEntidade.Atributos.Items[t_aux].Nome;
        t_nome_snk_atributo := LowerCase(Copy(t_nome_atributo, 1, 1)) + Copy(t_nome_atributo, 2, Length(t_nome_atributo));
        t_tipo_atributo := pEntidade.Atributos.Items[t_aux].Tipo;

        if (pEntidade.Atributos.Items[t_aux].ChavePrimaria) then
        begin
          t_nome_atributo_pk := t_nome_atributo;
          t_nome_snk_atributo_pk := t_nome_snk_atributo;
        end;

        if SameText(t_parametros_saved_entidade_event, EmptyStr) then
        begin
          t_parametros_saved_entidade_event := Format('%s %s', [t_tipo_atributo, t_nome_snk_atributo])
        end
        else
        begin
          t_parametros_saved_entidade_event := t_parametros_saved_entidade_event + Format(', %s %s', [t_tipo_atributo, t_nome_snk_atributo])
        end;

        t_corpo_saved_entidade_event.Add(Format('            %s = %s;', [t_nome_atributo, t_nome_snk_atributo]));
      end;

      t_corpo_saved_entidade_event.Add(Format('            Aggregate%s = %s;', [t_nome_atributo_pk, t_nome_atributo_pk]));

      t_arquivo.Add(Format('        public Saved%sEvent(%s)', [pEntidade.NomeClasseSingular, t_parametros_saved_entidade_event]));
      t_arquivo.Add('        {');
      t_arquivo.Add(Format('%s', [t_corpo_saved_entidade_event.Text]));
      t_arquivo.Add('        }');
    finally
      FreeAndNil(t_corpo_saved_entidade_event);
    end;

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
  t_nome_atributo_pk: string;
  t_nome_snk_atributo_pk: string;
  t_parametros_updated_entidade_event: string;
  t_corpo_updated_entidade_event: TStringList;
  t_diretorio: string;
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
      t_corpo_updated_entidade_event := TStringList.Create();

      for t_aux := 0 to pEntidade.Atributos.Count - 1 do
      begin
        t_nome_atributo := pEntidade.Atributos.Items[t_aux].Nome;
        t_nome_snk_atributo := LowerCase(Copy(t_nome_atributo, 1, 1)) + Copy(t_nome_atributo, 2, Length(t_nome_atributo));
        t_tipo_atributo := pEntidade.Atributos.Items[t_aux].Tipo;

        if (pEntidade.Atributos.Items[t_aux].ChavePrimaria) then
        begin
          t_nome_atributo_pk := t_nome_atributo;
          t_nome_snk_atributo_pk := t_nome_snk_atributo;
        end;

        if SameText(t_parametros_updated_entidade_event, EmptyStr) then
        begin
          t_parametros_updated_entidade_event := Format('%s %s', [t_tipo_atributo, t_nome_snk_atributo])
        end
        else
        begin
          t_parametros_updated_entidade_event := t_parametros_updated_entidade_event + Format(', %s %s', [t_tipo_atributo, t_nome_snk_atributo])
        end;

        t_corpo_updated_entidade_event.Add(Format('            %s = %s;', [t_nome_atributo, t_nome_snk_atributo]));
      end;

      t_corpo_updated_entidade_event.Add(Format('            Aggregate%s = %s;', [t_nome_atributo_pk, t_nome_atributo_pk]));

      t_arquivo.Add(Format('        public Updated%sEvent(%s)', [pEntidade.NomeClasseSingular, t_parametros_updated_entidade_event]));
      t_arquivo.Add('        {');
      t_arquivo.Add(Format('%s', [t_corpo_updated_entidade_event.Text]));
      t_arquivo.Add('        }');
    finally
      FreeAndNil(t_corpo_updated_entidade_event);
    end;

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
