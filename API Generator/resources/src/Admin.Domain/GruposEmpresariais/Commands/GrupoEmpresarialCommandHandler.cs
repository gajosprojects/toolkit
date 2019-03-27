using System.Threading;
using System.Threading.Tasks;
using Admin.Domain.Contracts;
using Admin.Domain.Core.Bus;
using Admin.Domain.Core.Notifications;
using Admin.Domain.GruposEmpresariais.Events;
using Admin.Domain.GruposEmpresariais.Repositories;
using Admin.Domain.Handlers;
using MediatR;

namespace Admin.Domain.GruposEmpresariais.Commands
{
    public class GrupoEmpresarialCommandHandler : CommandHandler, IRequestHandler<SalvarGrupoEmpresarialCommand, bool>, IRequestHandler<AtualizarGrupoEmpresarialCommand, bool>, IRequestHandler<ExcluirGrupoEmpresarialCommand, bool>
    {
        private readonly IGruposEmpresariaisRepository _grupoEmpresarialRepository;
        private readonly IMediatorHandler _mediator;

        public GrupoEmpresarialCommandHandler(IUnitOfWork uow, IMediatorHandler mediator, INotificationHandler<DomainNotification> notifications, IGruposEmpresariaisRepository grupoEmpresarialRepository) : base(uow, mediator, notifications)
        {
            _grupoEmpresarialRepository = grupoEmpresarialRepository;
            _mediator = mediator;
        }

        private bool IsValid(GrupoEmpresarial grupoEmpresarial)
        {
            if (grupoEmpresarial.IsValid()) return true;
            NotificarErrosValidacao(grupoEmpresarial.ValidationResult);
            return false;
        }

        public Task<bool> Handle(SalvarGrupoEmpresarialCommand request, CancellationToken cancellationToken)
        {
            var grupoEmpresarial = GrupoEmpresarial.GrupoEmpresarialFactory.NovoGrupoEmpresarial(request.Id, request.Codigo, request.Descricao, request.DataCadastro, request.DataUltimaAtualizacao);

            if (IsValid(grupoEmpresarial))
            {
                _grupoEmpresarialRepository.Salvar(grupoEmpresarial);

                if (Commit())
                {
                    _mediator.PublicarEvento(new GrupoEmpresarialRegistradoEvent(grupoEmpresarial.Id, grupoEmpresarial.Codigo, grupoEmpresarial.Descricao, grupoEmpresarial.DataCadastro, grupoEmpresarial.DataUltimaAtualizacao));
                }

                return Task.FromResult(true);
            }
            else
            {
                return Task.FromResult(false);
            }
        }

        public Task<bool> Handle(AtualizarGrupoEmpresarialCommand request, CancellationToken cancellationToken)
        {
            var grupoEmpresarialExistente = _grupoEmpresarialRepository.ObterPorId(request.Id);

            if (grupoEmpresarialExistente == null)
            {
                _mediator.PublicarEvento(new DomainNotification(request.MessageType, "Este grupo empresarial não existe"));
                return Task.FromResult(false);
            }
            else 
            {
                var grupoEmpresarial = GrupoEmpresarial.GrupoEmpresarialFactory.NovoGrupoEmpresarial(request.Id, request.Codigo, request.Descricao, request.DataCadastro, request.DataUltimaAtualizacao);
                
                if (IsValid(grupoEmpresarial))
                {
                    _grupoEmpresarialRepository.Atualizar(grupoEmpresarial);

                    if (Commit())
                    {
                        _mediator.PublicarEvento(new GrupoEmpresarialAtualizadoEvent(grupoEmpresarial.Id, grupoEmpresarial.Codigo, grupoEmpresarial.Descricao, grupoEmpresarial.DataCadastro, grupoEmpresarial.DataUltimaAtualizacao));
                    }

                    return Task.FromResult(true);
                }
                else
                {
                    return Task.FromResult(false);
                }
            }
        }

        public Task<bool> Handle(ExcluirGrupoEmpresarialCommand request, CancellationToken cancellationToken)
        {
            var grupoEmpresarialExistente = _grupoEmpresarialRepository.ObterPorId(request.Id);

            if (grupoEmpresarialExistente == null)
            {
                _mediator.PublicarEvento(new DomainNotification(request.MessageType, "Este grupo empresarial não existe"));
                return Task.FromResult(false);
            }
            else 
            {
                grupoEmpresarialExistente.Desativar();
                _grupoEmpresarialRepository.Atualizar(grupoEmpresarialExistente);

                if (Commit())
                {
                    _mediator.PublicarEvento(new GrupoEmpresarialExcluidoEvent(request.Id));
                }

                return Task.FromResult(true);
            }
        }
    }
}