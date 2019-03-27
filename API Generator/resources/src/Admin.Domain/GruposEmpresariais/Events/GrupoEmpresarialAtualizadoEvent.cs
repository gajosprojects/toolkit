using System;

namespace Admin.Domain.GruposEmpresariais.Events
{
    public class GrupoEmpresarialAtualizadoEvent : BaseGrupoEmpresarialEvent
    {
        public GrupoEmpresarialAtualizadoEvent(Guid id, string codigo, string descricao, DateTime dataCadastro, DateTime dataUltimaAtualizacao)
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