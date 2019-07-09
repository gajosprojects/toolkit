unit domain_commands_generator;

interface

uses
  uEntidadeDTO, uArquivoDTO;

type
  TDomainCommandsGenerator = class

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

{ TDomainCommandsGenerator }

function TDomainCommandsGenerator.generateBaseFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileDirectory(pEntidade);
  Result.Nome      := getBaseFileName(pEntidade);
  Result.Conteudo  := getBaseFileContent(pEntidade);
end;

function TDomainCommandsGenerator.generateDeleteFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileDirectory(pEntidade);
  Result.Nome      := getDeleteFileName(pEntidade);
  Result.Conteudo  := getDeleteFileContent(pEntidade);
end;

function TDomainCommandsGenerator.generateHandlerFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileDirectory(pEntidade);
  Result.Nome      := getHandlerFileName(pEntidade);
  Result.Conteudo  := getHandlerFileContent(pEntidade);
end;

function TDomainCommandsGenerator.generateSaveFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileDirectory(pEntidade);
  Result.Nome      := getSaveFileName(pEntidade);
  Result.Conteudo  := getSaveFileContent(pEntidade);
end;

function TDomainCommandsGenerator.generateUpdateFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileDirectory(pEntidade);
  Result.Nome      := getUpdateFileName(pEntidade);
  Result.Conteudo  := getUpdateFileContent(pEntidade);
end;

function TDomainCommandsGenerator.getBaseFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
  t_Aux: Integer;
  t_NomeAtributo: string;
  t_TipoAtributo: string;
  t_AtributoDTO: TAtributoDTO;
begin
  t_Arquivo := TStringList.Create();

  try
    t_Arquivo.Add('using System;');
    t_Arquivo.Add('using ERP.Domain.Core.Commands;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.%s.Domain.%s.Commands', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class Base%sCommand : Command', [pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('    {');

    t_Arquivo.Add('        public Guid Id { get; protected set; }');

    for t_Aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_Aux]);
      t_NomeAtributo := t_AtributoDTO.NomeAtributo;
      t_TipoAtributo := t_AtributoDTO.Tipo;

      t_Arquivo.Add(Format('        public %s %s { get; protected set; }', [t_TipoAtributo, t_NomeAtributo]));
    end;

    t_Arquivo.Add('        public DateTime DataCadastro { get; protected set; }');
    t_Arquivo.Add('        public DateTime DataUltimaAtualizacao { get; protected set; }');
    t_Arquivo.Add('        public Guid UsuarioId { get; protected set; }');
    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TDomainCommandsGenerator.getBaseFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('Base%sCommand.cs', [pEntidade.NomeClasseSingular]);
end;

function TDomainCommandsGenerator.getDeleteFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
begin
  t_Arquivo := TStringList.Create();

  try
    t_Arquivo.Add('using System;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.%s.Domain.%s.Commands', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class Delete%sCommand : Base%sCommand', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('    {');
    t_Arquivo.Add(Format('        public Delete%sCommand(Guid id, Guid usuarioId)', [pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add('            Id = id;');
    t_Arquivo.Add('            DataUltimaAtualizacao = DateTime.Now;');
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

function TDomainCommandsGenerator.getDeleteFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('Delete%sCommand.cs', [pEntidade.NomeClasseSingular]);
end;

function TDomainCommandsGenerator.getFileDirectory(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('\ERP.%s.Domain\%s\Commands\', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao]);
end;

function TDomainCommandsGenerator.getHandlerFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
  t_Aux: Integer;
  t_NomeSingularClasse: string;
  t_NomePluralClasse: string;
  t_NomeSingularSnkClasse: string;
  t_NomePluralSnkClasse: string;
  t_NomeExibicaoClasse: string;
  t_NomeAtributo: string;
  t_ParametrosNewEntidade: string;
  t_ParametrosUpdateEntidade: string;
  t_ParametrosSavedEntidadeEvent: string;
  t_ParametrosUpdatedEntidadeEvent: string;
  t_AtributoDTO: TAtributoDTO;
begin
  t_Arquivo := TStringList.Create();

  try
    t_NomeSingularClasse := pEntidade.nomeClasseSingular;
    t_NomePluralClasse := pEntidade.nomeClassePlural;
    t_NomeSingularSnkClasse := LowerCase(Copy(t_NomeSingularClasse, 1, 1)) + Copy(t_NomeSingularClasse, 2, Length(t_NomeSingularClasse));
    t_NomePluralSnkClasse := LowerCase(Copy(t_NomePluralClasse, 1, 1)) + Copy(t_NomePluralClasse, 2, Length(t_NomePluralClasse));
    t_NomeExibicaoClasse := LowerCase(pEntidade.nomeClasseExibicao);

    t_ParametrosNewEntidade := EmptyStr;
    t_ParametrosUpdateEntidade := EmptyStr;

    t_Arquivo.Add('using System.Threading;');
    t_Arquivo.Add('using System.Threading.Tasks;');
    t_Arquivo.Add(Format('using ERP.%s.Domain.%s.Events;', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao]));
    t_Arquivo.Add(Format('using ERP.%s.Domain.%s.Repositories;', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao]));
    t_Arquivo.Add('using ERP.Domain.Core.Bus;');
    t_Arquivo.Add('using ERP.Domain.Core.Commands;');
    t_Arquivo.Add('using ERP.Domain.Core.Contracts;');
    t_Arquivo.Add('using ERP.Domain.Core.Notifications;');
    t_Arquivo.Add('using MediatR;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.%s.Domain.%s.Commands', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class %sCommandHandler : CommandHandler, IRequestHandler<Save%sCommand, bool>, IRequestHandler<Update%sCommand, bool>, IRequestHandler<Delete%sCommand, bool>', [t_NomeSingularClasse, t_NomeSingularClasse, t_NomeSingularClasse, t_NomeSingularClasse]));
    t_Arquivo.Add('    {');
    t_Arquivo.Add(Format('        private readonly I%sRepository _%sRepository;', [t_NomePluralClasse, t_NomeSingularSnkClasse]));
    t_Arquivo.Add('        private readonly IMediatorHandler _mediator;');
    t_Arquivo.Add('        private readonly IUser _user;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('        public %sCommandHandler(IUnitOfWork uow, IMediatorHandler mediator, INotificationHandler<DomainNotification> notifications, I%sRepository %sRepository, IUser user) : base(uow, mediator, notifications)', [t_NomeSingularClasse, t_NomePluralClasse, t_NomeSingularSnkClasse]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add(Format('            _%sRepository = %sRepository;', [t_NomeSingularSnkClasse, t_NomeSingularSnkClasse]));
    t_Arquivo.Add('            _mediator = mediator;');
    t_Arquivo.Add('            _user = user;');
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('        private bool IsValid(%s %s)', [t_NomeSingularClasse, t_NomeSingularSnkClasse]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add(Format('            if (%s.IsValid()) return true;', [t_NomeSingularSnkClasse]));
    t_Arquivo.Add(Format('            NotificarErrosValidacao(%s.ValidationResult);', [t_NomeSingularSnkClasse]));
    t_Arquivo.Add('            return false;');
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('        public Task<bool> Handle(Save%sCommand request, CancellationToken cancellationToken)', [t_NomeSingularClasse]));
    t_Arquivo.Add('        {');

    t_ParametrosNewEntidade := 'request.Id';
    t_ParametrosUpdateEntidade := Format('%sExistente.Id', [t_NomeSingularSnkClasse]);
    t_ParametrosSavedEntidadeEvent := Format('%s.Id', [t_NomeSingularSnkClasse]);
    t_ParametrosUpdatedEntidadeEvent := Format('%s.Id', [t_NomeSingularSnkClasse]);

    for t_Aux := 0 to pEntidade.Atributos.Count - 1 do
    begin
      t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_Aux]);
      t_NomeAtributo := t_AtributoDTO.NomeAtributo;

      t_ParametrosNewEntidade := t_ParametrosNewEntidade + Format(', request.%s', [t_NomeAtributo]);
      t_ParametrosUpdateEntidade := t_ParametrosUpdateEntidade + Format(', request.%s', [t_NomeAtributo]);

      t_ParametrosSavedEntidadeEvent := t_ParametrosSavedEntidadeEvent + Format(', %s.%s', [t_NomeSingularSnkClasse, t_NomeAtributo]);
      t_ParametrosUpdatedEntidadeEvent := t_ParametrosUpdatedEntidadeEvent + Format(', %s.%s', [t_NomeSingularSnkClasse, t_NomeAtributo]);
    end;

    t_ParametrosNewEntidade := t_ParametrosNewEntidade + ', request.DataCadastro, request.DataUltimaAtualizacao, request.UsuarioId';
    t_ParametrosUpdateEntidade := t_ParametrosUpdateEntidade + Format(', %sExistente.DataCadastro, request.DataUltimaAtualizacao, request.UsuarioId', [t_NomeSingularSnkClasse]);

    t_ParametrosSavedEntidadeEvent := t_ParametrosSavedEntidadeEvent + Format(', %s.DataCadastro, %s.DataUltimaAtualizacao', [t_NomeSingularSnkClasse, t_NomeSingularSnkClasse]);
    t_ParametrosUpdatedEntidadeEvent := t_ParametrosUpdatedEntidadeEvent + Format(', %s.DataUltimaAtualizacao', [t_NomeSingularSnkClasse]);

    t_Arquivo.Add(Format('            var %s = %s.%sFactory.New%s(%s);', [t_NomeSingularSnkClasse, t_NomeSingularClasse, t_NomeSingularClasse, t_NomeSingularClasse, t_ParametrosNewEntidade]));
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('            if (IsValid(%s))', [t_NomeSingularSnkClasse]));
    t_Arquivo.Add('            {');
    t_Arquivo.Add(Format('                _%sRepository.Save(%s);', [t_NomeSingularSnkClasse, t_NomeSingularSnkClasse]));
    t_Arquivo.Add('');
    t_Arquivo.Add('                if (Commit())');
    t_Arquivo.Add('                {');
    t_Arquivo.Add(Format('                    _mediator.RaiseEvent(new Saved%sEvent(%s));', [t_NomeSingularClasse, t_ParametrosSavedEntidadeEvent]));
    t_Arquivo.Add('                }');
    t_Arquivo.Add('');
    t_Arquivo.Add('                return Task.FromResult(true);');
    t_Arquivo.Add('            }');
    t_Arquivo.Add('            else');
    t_Arquivo.Add('            {');
    t_Arquivo.Add('                return Task.FromResult(false);');
    t_Arquivo.Add('            }');
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('        public Task<bool> Handle(Update%sCommand request, CancellationToken cancellationToken)', [t_NomeSingularClasse]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add(Format('            var %sExistente = _%sRepository.GetById(request.Id);', [t_NomeSingularSnkClasse, t_NomeSingularSnkClasse]));
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('            if (%sExistente == null)', [t_NomeSingularSnkClasse]));
    t_Arquivo.Add('            {');
    t_Arquivo.Add(Format('                _mediator.RaiseEvent(new DomainNotification(request.MessageType, "Este %s não existe"));', [t_NomeExibicaoClasse]));
    t_Arquivo.Add('                return Task.FromResult(false);');
    t_Arquivo.Add('            }');
    t_Arquivo.Add('            else');
    t_Arquivo.Add('            {');
    t_Arquivo.Add(Format('                var %s = %s.%sFactory.New%s(%s);', [t_NomeSingularSnkClasse, t_NomeSingularClasse, t_NomeSingularClasse, t_NomeSingularClasse, t_ParametrosUpdateEntidade]));
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('                if (IsValid(%s))', [t_NomeSingularSnkClasse]));
    t_Arquivo.Add('                {');
    t_Arquivo.Add(Format('                    _%sRepository.Update(%s);', [t_NomeSingularSnkClasse, t_NomeSingularSnkClasse]));
    t_Arquivo.Add('');
    t_Arquivo.Add('                    if (Commit())');
    t_Arquivo.Add('                    {');
    t_Arquivo.Add(Format('                        _mediator.RaiseEvent(new Updated%sEvent(%s));', [t_NomeSingularClasse, t_ParametrosUpdatedEntidadeEvent]));
    t_Arquivo.Add('                    }');
    t_Arquivo.Add('');
    t_Arquivo.Add('                    return Task.FromResult(true);');
    t_Arquivo.Add('                }');
    t_Arquivo.Add('                else');
    t_Arquivo.Add('                {');
    t_Arquivo.Add('                    return Task.FromResult(false);');
    t_Arquivo.Add('                }');
    t_Arquivo.Add('            }');
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('        public Task<bool> Handle(Delete%sCommand request, CancellationToken cancellationToken)', [t_NomeSingularClasse]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add(Format('            var %sExistente = _%sRepository.GetById(request.Id);', [t_NomeSingularSnkClasse, t_NomeSingularSnkClasse]));
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('            if (%sExistente == null)', [t_NomeSingularSnkClasse]));
    t_Arquivo.Add('            {');
    t_Arquivo.Add(Format('                _mediator.RaiseEvent(new DomainNotification(request.MessageType, "Este %s não existe"));', [t_NomeExibicaoClasse]));
    t_Arquivo.Add('                return Task.FromResult(false);');
    t_Arquivo.Add('            }');
    t_Arquivo.Add('            else');
    t_Arquivo.Add('            {');
    t_Arquivo.Add(Format('                %sExistente.Desativar(request.UsuarioId);', [t_NomeSingularSnkClasse]));
    t_Arquivo.Add(Format('                _%sRepository.Update(%sExistente);', [t_NomeSingularSnkClasse, t_NomeSingularSnkClasse]));
    t_Arquivo.Add('');
    t_Arquivo.Add('                if (Commit())');
    t_Arquivo.Add('                {');
    t_Arquivo.Add(Format('                    _mediator.RaiseEvent(new Deleted%sEvent(request.Id));', [t_NomeSingularClasse]));
    t_Arquivo.Add('                }');
    t_Arquivo.Add('');
    t_Arquivo.Add('                return Task.FromResult(true);');
    t_Arquivo.Add('            }');
    t_Arquivo.Add('        }');
    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TDomainCommandsGenerator.getHandlerFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('%sCommandHandler.cs', [pEntidade.NomeClasseSingular]);
end;

function TDomainCommandsGenerator.getSaveFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
  t_Aux: Integer;
  t_NomeAtributo: string;
  t_NomeSnkAtributo: string;
  t_TipoAtributo: string;
  t_ParametrosSaveEntidadeCommand: string;
  t_CorpoSaveEntidadeCommand: TStringList;
  t_CorpoSaveEntidadeCommandAux: string;
  t_AtributoDTO: TAtributoDTO;
begin
  t_Arquivo := TStringList.Create();

  try
    t_Arquivo.Add('using System;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.%s.Domain.%s.Commands', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class Save%sCommand : Base%sCommand', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('    {');

    try
      t_CorpoSaveEntidadeCommand := TStringList.Create();

      for t_Aux := 0 to pEntidade.Atributos.Count - 1 do
      begin
        t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_Aux]);
        t_NomeAtributo := t_AtributoDTO.NomeAtributo;
        t_NomeSnkAtributo := LowerCase(Copy(t_NomeAtributo, 1, 1)) + Copy(t_NomeAtributo, 2, Length(t_NomeAtributo));
        t_TipoAtributo := t_AtributoDTO.Tipo;

        if SameText(t_ParametrosSaveEntidadeCommand, EmptyStr) then
        begin
          t_ParametrosSaveEntidadeCommand := Format('%s %s', [t_TipoAtributo, t_NomeSnkAtributo])
        end
        else
        begin
          t_ParametrosSaveEntidadeCommand := t_ParametrosSaveEntidadeCommand + Format(', %s %s', [t_TipoAtributo, t_NomeSnkAtributo])
        end;

        t_CorpoSaveEntidadeCommand.Add(Format('            %s = %s;', [t_NomeAtributo, t_NomeSnkAtributo]));
      end;

      t_ParametrosSaveEntidadeCommand := t_ParametrosSaveEntidadeCommand + ', Guid usuarioId';

      t_CorpoSaveEntidadeCommand.Add('            DataCadastro = DateTime.Now;');
      t_CorpoSaveEntidadeCommand.Add('            UsuarioId = usuarioId;');

      t_CorpoSaveEntidadeCommandAux := t_CorpoSaveEntidadeCommand.Text;
      Delete(t_CorpoSaveEntidadeCommandAux, Length(t_CorpoSaveEntidadeCommandAux) - 1, 2);
    finally
      FreeAndNil(t_CorpoSaveEntidadeCommand);
    end;

    t_Arquivo.Add(Format('        public Save%sCommand(%s)', [pEntidade.NomeClasseSingular, t_ParametrosSaveEntidadeCommand]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add(Format('%s', [t_CorpoSaveEntidadeCommandAux]));
    t_Arquivo.Add('        }');
    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TDomainCommandsGenerator.getSaveFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('Save%sCommand.cs', [pEntidade.NomeClasseSingular]);
end;

function TDomainCommandsGenerator.getUpdateFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
  t_Aux: Integer;
  t_NomeAtributo: string;
  t_NomeSnkAtributo: string;
  t_TipoAtributo: string;
  t_ParametrosUpdateEntidadeCommand: string;
  t_CorpoUpdateEntidadeCommand: TStringList;
  t_CorpoUpdateEntidadeCommandAux: string;
  t_AtributoDTO: TAtributoDTO;
begin
  t_Arquivo := TStringList.Create();

  try
    t_Arquivo.Add('using System;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.%s.Domain.%s.Commands', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class Update%sCommand : Base%sCommand', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('    {');

    try
      t_ParametrosUpdateEntidadeCommand := EmptyStr;
      t_CorpoUpdateEntidadeCommand := TStringList.Create();

      t_ParametrosUpdateEntidadeCommand := 'Guid id';
      t_CorpoUpdateEntidadeCommand.Add('            Id = id;');

      for t_Aux := 0 to pEntidade.Atributos.Count - 1 do
      begin
        t_AtributoDTO := TAtributoDTO(pEntidade.Atributos.Items[t_Aux]);
	      t_NomeAtributo := t_AtributoDTO.NomeAtributo;
        t_NomeSnkAtributo := LowerCase(Copy(t_NomeAtributo, 1, 1)) + Copy(t_NomeAtributo, 2, Length(t_NomeAtributo));
        t_TipoAtributo := t_AtributoDTO.Tipo;

        t_ParametrosUpdateEntidadeCommand := t_ParametrosUpdateEntidadeCommand + Format(', %s %s', [t_TipoAtributo, t_NomeSnkAtributo]);

        t_CorpoUpdateEntidadeCommand.Add(Format('            %s = %s;', [t_NomeAtributo, t_NomeSnkAtributo]));
      end;

      t_CorpoUpdateEntidadeCommand.Add('            DataUltimaAtualizacao = DateTime.Now;');
      t_CorpoUpdateEntidadeCommand.Add('            UsuarioId = usuarioId;');

      t_CorpoUpdateEntidadeCommandAux := t_CorpoUpdateEntidadeCommand.Text;
      Delete(t_CorpoUpdateEntidadeCommandAux, Length(t_CorpoUpdateEntidadeCommandAux) - 1, 2);

      t_ParametrosUpdateEntidadeCommand := t_ParametrosUpdateEntidadeCommand + ', Guid usuarioId';
    finally
      FreeAndNil(t_CorpoUpdateEntidadeCommand);
    end;

    t_Arquivo.Add(Format('        public Update%sCommand(%s)', [pEntidade.NomeClasseSingular, t_ParametrosUpdateEntidadeCommand]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add(Format('%s', [t_CorpoUpdateEntidadeCommandAux]));
    t_Arquivo.Add('        }');
    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TDomainCommandsGenerator.getUpdateFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('Update%sCommand.cs', [pEntidade.NomeClasseSingular]);
end;

end.
