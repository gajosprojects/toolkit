using System.Threading;
using System.Threading.Tasks;
using MediatR;

namespace Admin.Domain.GruposEmpresariais.Events
{
    public class GrupoEmpresarialEventHandler : INotificationHandler<GrupoEmpresarialRegistradoEvent>, INotificationHandler<GrupoEmpresarialAtualizadoEvent>, INotificationHandler<GrupoEmpresarialExcluidoEvent>
    {
        public Task Handle(GrupoEmpresarialRegistradoEvent notification, CancellationToken cancellationToken)
        {
            return Task.CompletedTask;
        }

        public Task Handle(GrupoEmpresarialAtualizadoEvent notification, CancellationToken cancellationToken)
        {
            return Task.CompletedTask;
        }

        public Task Handle(GrupoEmpresarialExcluidoEvent notification, CancellationToken cancellationToken)
        {
            return Task.CompletedTask;
        }
    }
}