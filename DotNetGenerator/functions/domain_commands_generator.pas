unit domain_commands_generator;

interface

uses
  uEntidadeDTO;

type
  TDomainCommandsGenerator = class

  public
    procedure generateBaseCommand(var pEntidade: TEntidadeDTO);
    procedure generateCommandHandler(var pEntidade: TEntidadeDTO);
    procedure generateSaveCommand(var pEntidade: TEntidadeDTO);
    procedure generateUpdateCommand(var pEntidade: TEntidadeDTO);
    procedure generateDeleteCommand(var pEntidade: TEntidadeDTO);

  end;

implementation

uses
  System.Classes, System.SysUtils;

{ TDomainCommandsGenerator }

procedure TDomainCommandsGenerator.generateBaseCommand(var pEntidade: TEntidadeDTO);
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
    t_arquivo.Add('using ERP.Domain.Core.Commands;');
    t_arquivo.Add('');
    t_arquivo.Add(Format('namespace ERP.%s.Domain.%s.Commands', [pEntidade.NomeModulo, pEntidade.NomeClassePlural]));
    t_arquivo.Add('{');
    t_arquivo.Add(Format('    public class Base%sCommand : Command', [pEntidade.NomeClasseSingular]));
    t_arquivo.Add('    {');

    t_arquivo.Add('        public Guid Id { get; protected set; }');

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

    t_diretorio := Format('%s\Commands', [t_diretorio]);

    if (not DirectoryExists(t_diretorio)) then
    begin
      ForceDirectories(t_diretorio);
    end;

    t_arquivo.SaveToFile(Format('%s\Base%sCommand.cs', [t_diretorio, pEntidade.NomeClasseSingular]));
  finally
    FreeAndNil(t_arquivo);
  end;
end;

procedure TDomainCommandsGenerator.generateCommandHandler(var pEntidade: TEntidadeDTO);
var
  t_arquivo: TStringList;
  t_aux: Integer;
  t_nome_singular_classe: string;
  t_nome_plural_classe: string;
  t_nome_singular_snk_classe: string;
  t_nome_plural_snk_classe: string;
  t_nome_atributo: string;
  t_parametros_new_entidade: string;
  t_parametros_saved_updated_entidade_event: string;
  t_diretorio: string;
begin
  try
    t_diretorio := EmptyStr;

    t_nome_singular_classe := pEntidade.nomeClasseSingular;
    t_nome_plural_classe := pEntidade.nomeClassePlural;
    t_nome_singular_snk_classe := LowerCase(Copy(t_nome_singular_classe, 1, 1)) + Copy(t_nome_singular_classe, 2, Length(t_nome_singular_classe));
    t_nome_plural_snk_classe := LowerCase(Copy(t_nome_plural_classe, 1, 1)) + Copy(t_nome_plural_classe, 2, Length(t_nome_plural_classe));

    t_arquivo := TStringList.Create();
    t_parametros_new_entidade := EmptyStr;

    t_arquivo.Add('using System.Threading;');
    t_arquivo.Add('using System.Threading.Tasks;');
    t_arquivo.Add(Format('using ERP.%s.Domain.%s.Events;', [pEntidade.NomeModulo, t_nome_plural_classe]));
    t_arquivo.Add(Format('using ERP.%s.Domain.%s.Repositories;', [pEntidade.NomeModulo, t_nome_plural_classe]));
    t_arquivo.Add('using ERP.Domain.Core.Bus;');
    t_arquivo.Add('using ERP.Domain.Core.Commands;');
    t_arquivo.Add('using ERP.Domain.Core.Contracts;');
    t_arquivo.Add('using ERP.Domain.Core.Notifications;');
    t_arquivo.Add('using MediatR;');
    t_arquivo.Add('');
    t_arquivo.Add(Format('namespace ERP.%s.Domain.%s.Commands', [pEntidade.NomeModulo, t_nome_plural_classe]));
    t_arquivo.Add('{');
    t_arquivo.Add(Format('    public class %sCommandHandler : CommandHandler, IRequestHandler<Save%sCommand, bool>, IRequestHandler<Update%sCommand, bool>, IRequestHandler<Delete%sCommand, bool>', [t_nome_singular_classe, t_nome_singular_classe, t_nome_singular_classe, t_nome_singular_classe]));
    t_arquivo.Add('    {');
    t_arquivo.Add(Format('        private readonly I%sRepository _%sRepository;', [t_nome_plural_classe, t_nome_singular_snk_classe]));
    t_arquivo.Add('        private readonly IMediatorHandler _mediator;');
    t_arquivo.Add('');
    t_arquivo.Add(Format('        public %sCommandHandler(IUnitOfWork uow, IMediatorHandler mediator, INotificationHandler<DomainNotification> notifications, I%sRepository %sRepository) : base(uow, mediator, notifications)', [t_nome_singular_classe, t_nome_plural_classe, t_nome_singular_snk_classe]));
    t_arquivo.Add('        {');
    t_arquivo.Add(Format('            _%sRepository = %sRepository;', [t_nome_singular_snk_classe, t_nome_singular_snk_classe]));
    t_arquivo.Add('            _mediator = mediator;');
    t_arquivo.Add('        }');
    t_arquivo.Add('');
    t_arquivo.Add(Format('        private bool IsValid(%s %s)', [t_nome_singular_classe, t_nome_singular_snk_classe]));
    t_arquivo.Add('        {');
    t_arquivo.Add(Format('            if (%s.IsValid()) return true;', [t_nome_singular_snk_classe]));
    t_arquivo.Add(Format('            NotificarErrosValidacao(%s.ValidationResult);', [t_nome_singular_snk_classe]));
    t_arquivo.Add('            return false;');
    t_arquivo.Add('        }');
    t_arquivo.Add('');
    t_arquivo.Add(Format('        public Task<bool> Handle(Save%sCommand request, CancellationToken cancellationToken)', [t_nome_singular_classe]));
    t_arquivo.Add('        {');

    t_parametros_new_entidade := 'request.Id';
    t_parametros_saved_updated_entidade_event := Format('%s.Id', [t_nome_singular_snk_classe]);

    for t_aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      t_nome_atributo := pEntidade.Atributos.Items[t_aux].Nome;

      t_parametros_new_entidade := t_parametros_new_entidade + Format(', request.%s', [t_nome_atributo]);

      t_parametros_saved_updated_entidade_event := t_parametros_saved_updated_entidade_event + Format(', %s.%s', [t_nome_singular_snk_classe, t_nome_atributo]);
    end;

    t_arquivo.Add(Format('            var %s = %s.%sFactory.New%s(%s);', [t_nome_singular_snk_classe, t_nome_singular_classe, t_nome_singular_classe, t_nome_singular_classe, t_parametros_new_entidade, t_parametros_saved_updated_entidade_event]));
    t_arquivo.Add('');
    t_arquivo.Add(Format('            if (IsValid(%s))', [t_nome_singular_snk_classe]));
    t_arquivo.Add('            {');
    t_arquivo.Add(Format('                _%sRepository.Save(%s);', [t_nome_singular_snk_classe, t_nome_singular_snk_classe]));
    t_arquivo.Add('');
    t_arquivo.Add('                if (Commit())');
    t_arquivo.Add('                {');
    t_arquivo.Add(Format('                    _mediator.RaiseEvent(new Saved%sEvent(%s));', [t_nome_singular_classe, t_parametros_saved_updated_entidade_event]));
    t_arquivo.Add('                }');
    t_arquivo.Add('');
    t_arquivo.Add('                return Task.FromResult(true);');
    t_arquivo.Add('            }');
    t_arquivo.Add('            else');
    t_arquivo.Add('            {');
    t_arquivo.Add('                return Task.FromResult(false);');
    t_arquivo.Add('            }');
    t_arquivo.Add('        }');
    t_arquivo.Add('');
    t_arquivo.Add(Format('        public Task<bool> Handle(Update%sCommand request, CancellationToken cancellationToken)', [t_nome_singular_classe]));
    t_arquivo.Add('        {');
    t_arquivo.Add(Format('            var %sExistente = _%sRepository.GetById(request.Id);', [t_nome_singular_snk_classe, t_nome_singular_snk_classe]));
    t_arquivo.Add('');
    t_arquivo.Add(Format('            if (%sExistente == null)', [t_nome_singular_snk_classe]));
    t_arquivo.Add('            {');
    t_arquivo.Add(Format('                _mediator.RaiseEvent(new DomainNotification(request.MessageType, "Este %s não existe"));', [LowerCase(t_nome_singular_classe)]));
    t_arquivo.Add('                return Task.FromResult(false);');
    t_arquivo.Add('            }');
    t_arquivo.Add('            else');
    t_arquivo.Add('            {');
    t_arquivo.Add(Format('                var %s = %s.%sFactory.New%s(%s);', [t_nome_singular_snk_classe, t_nome_singular_classe, t_nome_singular_classe, t_nome_singular_classe, t_parametros_new_entidade]));
    t_arquivo.Add('');
    t_arquivo.Add(Format('                if (IsValid(%s))', [t_nome_singular_snk_classe]));
    t_arquivo.Add('                {');
    t_arquivo.Add(Format('                    _%sRepository.Update(%s);', [t_nome_singular_snk_classe, t_nome_singular_snk_classe]));
    t_arquivo.Add('');
    t_arquivo.Add('                    if (Commit())');
    t_arquivo.Add('                    {');
    t_arquivo.Add(Format('                        _mediator.RaiseEvent(new Updated%sEvent(%s));', [t_nome_singular_classe, t_parametros_saved_updated_entidade_event]));
    t_arquivo.Add('                    }');
    t_arquivo.Add('');
    t_arquivo.Add('                    return Task.FromResult(true);');
    t_arquivo.Add('                }');
    t_arquivo.Add('                else');
    t_arquivo.Add('                {');
    t_arquivo.Add('                    return Task.FromResult(false);');
    t_arquivo.Add('                }');
    t_arquivo.Add('            }');
    t_arquivo.Add('        }');
    t_arquivo.Add('');
    t_arquivo.Add(Format('        public Task<bool> Handle(Delete%sCommand request, CancellationToken cancellationToken)', [t_nome_singular_classe]));
    t_arquivo.Add('        {');
    t_arquivo.Add(Format('            var %sExistente = _%sRepository.GetById(request.Id);', [t_nome_singular_snk_classe, t_nome_singular_snk_classe]));
    t_arquivo.Add('');
    t_arquivo.Add(Format('            if (%sExistente == null)', [t_nome_singular_snk_classe]));
    t_arquivo.Add('            {');
    t_arquivo.Add(Format('                _mediator.RaiseEvent(new DomainNotification(request.MessageType, "Este %s não existe"));', [LowerCase(t_nome_singular_classe)]));
    t_arquivo.Add('                return Task.FromResult(false);');
    t_arquivo.Add('            }');
    t_arquivo.Add('            else');
    t_arquivo.Add('            {');
    t_arquivo.Add(Format('                %sExistente.Desativar();', [t_nome_singular_snk_classe]));
    t_arquivo.Add(Format('                _%sRepository.Update(%sExistente);', [t_nome_singular_snk_classe, t_nome_singular_snk_classe]));
    t_arquivo.Add('');
    t_arquivo.Add('                if (Commit())');
    t_arquivo.Add('                {');
    t_arquivo.Add(Format('                    _mediator.RaiseEvent(new Deleted%sEvent(request.Id));', [t_nome_singular_classe]));
    t_arquivo.Add('                }');
    t_arquivo.Add('');
    t_arquivo.Add('                return Task.FromResult(true);');
    t_arquivo.Add('            }');
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

    t_diretorio := Format('%s\Commands', [t_diretorio]);

    if (not DirectoryExists(t_diretorio)) then
    begin
      ForceDirectories(t_diretorio);
    end;

    t_arquivo.SaveToFile(Format('%s\%sCommandHandler.cs', [t_diretorio, pEntidade.NomeClasseSingular]));
  finally
    FreeAndNil(t_arquivo);
  end;
end;

procedure TDomainCommandsGenerator.generateDeleteCommand(var pEntidade: TEntidadeDTO);
var
  t_arquivo: TStringList;
  t_diretorio: string;
begin
  try
    t_diretorio := EmptyStr;

    t_arquivo := TStringList.Create();

    t_arquivo.Add('using System;');
    t_arquivo.Add('');
    t_arquivo.Add(Format('namespace ERP.%s.Domain.%s.Commands', [pEntidade.NomeModulo, pEntidade.NomeClassePlural]));
    t_arquivo.Add('{');
    t_arquivo.Add(Format('    public class Delete%sCommand : Base%sCommand', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
    t_arquivo.Add('    {');
    t_arquivo.Add(Format('        public Delete%sCommand(Guid id)', [pEntidade.NomeClasseSingular]));
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

    t_diretorio := Format('%s\Commands', [t_diretorio]);

    if (not DirectoryExists(t_diretorio)) then
    begin
      ForceDirectories(t_diretorio);
    end;

    t_arquivo.SaveToFile(Format('%s\Delete%sCommand.cs', [t_diretorio, pEntidade.NomeClasseSingular]));
  finally
    FreeAndNil(t_arquivo);
  end;
end;

procedure TDomainCommandsGenerator.generateSaveCommand(var pEntidade: TEntidadeDTO);
var
  t_arquivo: TStringList;
  t_aux: Integer;
  t_nome_atributo: string;
  t_nome_snk_atributo: string;
  t_tipo_atributo: string;
  t_parametros_save_entidade_command: string;
  t_corpo_save_entidade_command: TStringList;
  t_diretorio: string;
begin
  try
    t_diretorio := EmptyStr;

    t_arquivo := TStringList.Create();

    t_arquivo.Add('using System;');
    t_arquivo.Add('');
    t_arquivo.Add(Format('namespace ERP.%s.Domain.%s.Commands', [pEntidade.NomeModulo, pEntidade.NomeClassePlural]));
    t_arquivo.Add('{');
    t_arquivo.Add(Format('    public class Save%sCommand : Base%sCommand', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
    t_arquivo.Add('    {');

    try
      t_corpo_save_entidade_command := TStringList.Create();

      for t_aux := 0 to pEntidade.Atributos.Count - 1 do
      begin
        t_nome_atributo := pEntidade.Atributos.Items[t_aux].Nome;
        t_nome_snk_atributo := LowerCase(Copy(t_nome_atributo, 1, 1)) + Copy(t_nome_atributo, 2, Length(t_nome_atributo));
        t_tipo_atributo := pEntidade.Atributos.Items[t_aux].Tipo;

        if SameText(t_parametros_save_entidade_command, EmptyStr) then
        begin
          t_parametros_save_entidade_command := Format('%s %s', [t_tipo_atributo, t_nome_snk_atributo])
        end
        else
        begin
          t_parametros_save_entidade_command := t_parametros_save_entidade_command + Format(', %s %s', [t_tipo_atributo, t_nome_snk_atributo])
        end;

        t_corpo_save_entidade_command.Add(Format('            %s = %s;', [t_nome_atributo, t_nome_snk_atributo]));
      end;

      t_arquivo.Add(Format('        public Save%sCommand(%s)', [pEntidade.NomeClasseSingular, t_parametros_save_entidade_command]));
      t_arquivo.Add('        {');
      t_arquivo.Add(Format('%s', [t_corpo_save_entidade_command.Text]));
      t_arquivo.Add('        }');
    finally
      FreeAndNil(t_corpo_save_entidade_command);
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

    t_diretorio := Format('%s\Commands', [t_diretorio]);

    if (not DirectoryExists(t_diretorio)) then
    begin
      ForceDirectories(t_diretorio);
    end;

    t_arquivo.SaveToFile(Format('%s\Save%sCommand.cs', [t_diretorio, pEntidade.NomeClasseSingular]));
  finally
    FreeAndNil(t_arquivo);
  end;
end;

procedure TDomainCommandsGenerator.generateUpdateCommand(var pEntidade: TEntidadeDTO);
var
  t_arquivo: TStringList;
  t_aux: Integer;
  t_nome_atributo: string;
  t_nome_snk_atributo: string;
  t_tipo_atributo: string;
  t_parametros_update_entidade_command: string;
  t_corpo_update_entidade_command: TStringList;
  t_diretorio: string;
begin
  try
    t_diretorio := EmptyStr;

    t_arquivo := TStringList.Create();

    t_arquivo.Add('using System;');
    t_arquivo.Add('');
    t_arquivo.Add(Format('namespace ERP.%s.Domain.%s.Commands', [pEntidade.NomeModulo, pEntidade.NomeClassePlural]));
    t_arquivo.Add('{');
    t_arquivo.Add(Format('    public class Update%sCommand : Base%sCommand', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
    t_arquivo.Add('    {');

    try
      t_parametros_update_entidade_command := EmptyStr;
      t_corpo_update_entidade_command := TStringList.Create();

      t_parametros_update_entidade_command := 'Guid id';
      t_corpo_update_entidade_command.Add('            Id = id;');

      for t_aux := 0 to pEntidade.Atributos.Count - 1 do
      begin
        t_nome_atributo := pEntidade.Atributos.Items[t_aux].Nome;
        t_nome_snk_atributo := LowerCase(Copy(t_nome_atributo, 1, 1)) + Copy(t_nome_atributo, 2, Length(t_nome_atributo));
        t_tipo_atributo := pEntidade.Atributos.Items[t_aux].Tipo;

        t_parametros_update_entidade_command := t_parametros_update_entidade_command + Format(', %s %s', [t_tipo_atributo, t_nome_snk_atributo]);

        t_corpo_update_entidade_command.Add(Format('            %s = %s;', [t_nome_atributo, t_nome_snk_atributo]));
      end;

      t_arquivo.Add(Format('        public Update%sCommand(%s)', [pEntidade.NomeClasseSingular, t_parametros_update_entidade_command]));
      t_arquivo.Add('        {');
      t_arquivo.Add(Format('%s', [t_corpo_update_entidade_command.Text]));
      t_arquivo.Add('        }');
    finally
      FreeAndNil(t_corpo_update_entidade_command);
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

    t_diretorio := Format('%s\Commands', [t_diretorio]);

    if (not DirectoryExists(t_diretorio)) then
    begin
      ForceDirectories(t_diretorio);
    end;

    t_arquivo.SaveToFile(Format('%s\Update%sCommand.cs', [t_diretorio, pEntidade.NomeClasseSingular]));
  finally
    FreeAndNil(t_arquivo);
  end;
end;

end.
