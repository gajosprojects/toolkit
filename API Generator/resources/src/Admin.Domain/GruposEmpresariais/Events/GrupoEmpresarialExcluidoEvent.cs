using System;

namespace Admin.Domain.GruposEmpresariais.Events
{
    public class GrupoEmpresarialExcluidoEvent : BaseGrupoEmpresarialEvent
    {
        public GrupoEmpresarialExcluidoEvent(Guid id)
        {
            Id = id;
            AggregateId = Id;
        }
    }
}