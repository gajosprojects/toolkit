using System;

namespace Admin.Domain.GruposEmpresariais.Commands
{
    public class ExcluirGrupoEmpresarialCommand : BaseGrupoEmpresarialCommand
    {
        public ExcluirGrupoEmpresarialCommand(Guid id)
        {
            Id = id;
            AggregateId = Id;
        }
    }
}