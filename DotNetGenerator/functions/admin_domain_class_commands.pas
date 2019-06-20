unit admin_domain_class_commands;

interface

uses
  System.Generics.Collections,
  System.Classes,
  System.SysUtils,
  System.AnsiStrings,
  uEntidadeDTO;

type
  TDomainClassCommands = class

  public
    procedure generateAtualizarClassCommand(var pEntidade: TEntidadeDTO);
    procedure generateBaseClassCommand(var pEntidade: TEntidadeDTO);
    procedure generateExcluirClassCommand(var pEntidade: TEntidadeDTO);
    procedure generateClassCommandHandler(var pEntidade: TEntidadeDTO);
    procedure generateSalvarClassCommand(var pEntidade: TEntidadeDTO);

  end;

implementation

{ TDomainClassCommands }

uses
  uAtributoDTO;

procedure TDomainClassCommands.generateAtualizarClassCommand(var pEntidade: TEntidadeDTO);
begin

end;

procedure TDomainClassCommands.generateBaseClassCommand(var pEntidade: TEntidadeDTO);
var
  t_arquivo: TStringList;
  t_aux: Integer;
  t_nome_atributo: string;
  t_tipo_atributo: string;
  t_nome_singular_classe: string;
  t_nome_plural_classe: string;
begin
  t_arquivo := TStringList.Create();

  t_nome_singular_classe := pEntidade.nomeClasseSingular;
  t_nome_plural_classe := pEntidade.nomeClassePlural;

  t_arquivo.Add('using System;');
  t_arquivo.Add('using Admin.Domain.Core.Commands;');
  t_arquivo.Add('');
  t_arquivo.Add(Format('namespace Admin.Domain.%s.Commands',[t_nome_plural_classe]));
  t_arquivo.Add('{');
  t_arquivo.Add(Format('    public class Base%sCommand : Command',[t_nome_singular_classe]));
  t_arquivo.Add('    {');

  for t_aux := 0 to Pred(pEntidade.atributos.Count) do
  begin
    t_nome_atributo := pEntidade.atributos.Items[t_aux].nome;
    t_tipo_atributo := pEntidade.atributos.Items[t_aux].tipo;

    t_arquivo.Add(Format('        public %s %s { get; protected set; }',[t_nome_atributo,t_tipo_atributo]));
  end;

  t_arquivo.Add('    }');
  t_arquivo.Add('}');

  t_arquivo.SaveToFile(Format('Base%sCommand.cs', [t_nome_singular_classe]));
end;

procedure TDomainClassCommands.generateClassCommandHandler(var pEntidade: TEntidadeDTO);
var
  t_arquivo: TStringList;
  t_nome_singular_classe: string;
  t_nome_plural_classe: string;
  t_nome_singular_snk_classe: string;
begin
  t_arquivo := TStringList.Create();

  t_nome_singular_classe := pEntidade.nomeClasseSingular;
  t_nome_plural_classe := pEntidade.nomeClassePlural;
  t_nome_singular_snk_classe := LowerCase(Copy(t_nome_singular_classe, 1, 1)) + Copy(t_nome_singular_classe, 2, Length(t_nome_singular_classe));

  t_arquivo.Add('using System.Threading;');
  t_arquivo.Add('using System.Threading.Tasks;');
  t_arquivo.Add('using Admin.Domain.Contracts;');
  t_arquivo.Add('using Admin.Domain.Core.Bus;');
  t_arquivo.Add('using Admin.Domain.Core.Notifications;');
  t_arquivo.Add(Format('using Admin.Domain.%s.Events;',[t_nome_plural_classe]));
  t_arquivo.Add(Format('using Admin.Domain.%s.Repositories;',[t_nome_plural_classe]));
  t_arquivo.Add('using Admin.Domain.Handlers;');
  t_arquivo.Add('using MediatR;');
  t_arquivo.Add('');
  t_arquivo.Add(Format('namespace Admin.Domain.%s.Commands',[t_nome_plural_classe]));
  t_arquivo.Add('{');
  t_arquivo.Add(Format('    public class %sCommandHandler : CommandHandler, IRequestHandler<Salvar%sCommand, bool>, IRequestHandler<Atualizar%sCommand, bool>, IRequestHandler<Excluir%sCommand, bool>',
                [t_nome_singular_classe,
                t_nome_singular_classe,
                t_nome_singular_classe,
                t_nome_singular_classe]));
  t_arquivo.Add('    {');
  t_arquivo.Add(Format('        private readonly I%sRepository _%sRepository;',[t_nome_plural_classe,t_nome_singular_snk_classe]));
  t_arquivo.Add('        private readonly IMediatorHandler _mediator;');
  t_arquivo.Add('');
  t_arquivo.Add(Format('        public %sCommandHandler(IUnitOfWork uow, IMediatorHandler mediator, INotificationHandler<DomainNotification> notifications, I%sRepository %sRepository) : base(uow, mediator, notifications)',[t_nome_singular_classe, t_nome_plural_classe, t_nome_singular_snk_classe]));
  t_arquivo.Add('        {');
  t_arquivo.Add(Format('            _%sRepository = %sRepository;',[t_nome_singular_snk_classe, t_nome_singular_snk_classe]));
  t_arquivo.Add('            _mediator = mediator;');
  t_arquivo.Add('        }');
  t_arquivo.Add('');
  t_arquivo.Add(Format('        private bool IsValid(%s %s)',[t_nome_singular_classe, t_nome_singular_snk_classe]));
  t_arquivo.Add('        {');
  t_arquivo.Add(Format('            if (%s.IsValid()) return true;',[t_nome_singular_snk_classe]));
  t_arquivo.Add(Format('            NotificarErrosValidacao(%s.ValidationResult);',[t_nome_singular_snk_classe]));
  t_arquivo.Add('            return false;');
  t_arquivo.Add('        }');
  t_arquivo.Add('');
  t_arquivo.Add(Format('        public Task<bool> Handle(Salvar%sCommand request, CancellationToken cancellationToken)',[t_nome_singular_classe]));
  t_arquivo.Add('        {');
  t_arquivo.Add('            var grupoEmpresarial = GrupoEmpresarial.GrupoEmpresarialFactory.NovoGrupoEmpresarial(request.Id, request.Codigo, request.Descricao, request.DataCadastro, request.DataUltimaAtualizacao);');
  t_arquivo.Add('');
  t_arquivo.Add('            if (IsValid(grupoEmpresarial))');
  t_arquivo.Add('            {');
  t_arquivo.Add('                _grupoEmpresarialRepository.Salvar(grupoEmpresarial);');
  t_arquivo.Add('');
  t_arquivo.Add('                if (Commit())');
  t_arquivo.Add('                {');
  t_arquivo.Add('                    _mediator.PublicarEvento(new GrupoEmpresarialRegistradoEvent(grupoEmpresarial.Id, grupoEmpresarial.Codigo, grupoEmpresarial.Descricao, grupoEmpresarial.DataCadastro, grupoEmpresarial.DataUltimaAtualizacao));');
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
  t_arquivo.Add('        public Task<bool> Handle(AtualizarGrupoEmpresarialCommand request, CancellationToken cancellationToken)');
  t_arquivo.Add('        {');
  t_arquivo.Add('            var grupoEmpresarialExistente = _grupoEmpresarialRepository.ObterPorId(request.Id);');
  t_arquivo.Add('');
  t_arquivo.Add('            if (grupoEmpresarialExistente == null)');
  t_arquivo.Add('            {');
  t_arquivo.Add('                _mediator.PublicarEvento(new DomainNotification(request.MessageType, "Este grupo empresarial não existe"));');
  t_arquivo.Add('                return Task.FromResult(false);');
  t_arquivo.Add('            }');
  t_arquivo.Add('            else');
  t_arquivo.Add('            {');
  t_arquivo.Add('                var grupoEmpresarial = GrupoEmpresarial.GrupoEmpresarialFactory.NovoGrupoEmpresarial(request.Id, request.Codigo, request.Descricao, request.DataCadastro, request.DataUltimaAtualizacao);');
  t_arquivo.Add('');
  t_arquivo.Add('                if (IsValid(grupoEmpresarial))');
  t_arquivo.Add('                {');
  t_arquivo.Add('                    _grupoEmpresarialRepository.Atualizar(grupoEmpresarial);');
  t_arquivo.Add('');
  t_arquivo.Add('                    if (Commit())');
  t_arquivo.Add('                    {');
  t_arquivo.Add('                        _mediator.PublicarEvento(new GrupoEmpresarialAtualizadoEvent(grupoEmpresarial.Id, grupoEmpresarial.Codigo, grupoEmpresarial.Descricao, grupoEmpresarial.DataCadastro, grupoEmpresarial.DataUltimaAtualizacao));');
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
  t_arquivo.Add('        public Task<bool> Handle(ExcluirGrupoEmpresarialCommand request, CancellationToken cancellationToken)');
  t_arquivo.Add('        {');
  t_arquivo.Add('            var grupoEmpresarialExistente = _grupoEmpresarialRepository.ObterPorId(request.Id);');
  t_arquivo.Add('');
  t_arquivo.Add('            if (grupoEmpresarialExistente == null)');
  t_arquivo.Add('            {');
  t_arquivo.Add('                _mediator.PublicarEvento(new DomainNotification(request.MessageType, "Este grupo empresarial não existe"));');
  t_arquivo.Add('                return Task.FromResult(false);');
  t_arquivo.Add('            }');
  t_arquivo.Add('            else');
  t_arquivo.Add('            {');
  t_arquivo.Add('                grupoEmpresarialExistente.Desativar();');
  t_arquivo.Add('                _grupoEmpresarialRepository.Atualizar(grupoEmpresarialExistente);');
  t_arquivo.Add('');
  t_arquivo.Add('                if (Commit())');
  t_arquivo.Add('                {');
  t_arquivo.Add('                    _mediator.PublicarEvento(new GrupoEmpresarialExcluidoEvent(request.Id));');
  t_arquivo.Add('                }');
  t_arquivo.Add('');
  t_arquivo.Add('                return Task.FromResult(true);');
  t_arquivo.Add('            }');
  t_arquivo.Add('        }');
  t_arquivo.Add('    }');
  t_arquivo.Add('}');
end;

procedure TDomainClassCommands.generateExcluirClassCommand(var pEntidade: TEntidadeDTO);
begin

end;

procedure TDomainClassCommands.generateSalvarClassCommand(var pEntidade: TEntidadeDTO);
begin

end;

end.
