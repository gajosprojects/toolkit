using System;

namespace Admin.Domain.GruposEmpresariais.Events
{
    public class GrupoEmpresarialRegistradoEvent : BaseGrupoEmpresarialEvent
    {
        public GrupoEmpresarialRegistradoEvent(Guid id, string codigo, string descricao, DateTime dataCadastro, DateTime dataUltimaAtualizacao)
        {
            Id = id;
            Codigo = codigo;
            Descricao = descricao;
            DataCadastro = dataCadastro;
            DataUltimaAtualizacao = dataUltimaAtualizacao;
            AggregateId = Id;
        }
    }
}