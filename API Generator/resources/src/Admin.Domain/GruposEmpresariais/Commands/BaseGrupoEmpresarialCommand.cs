using System;
using Admin.Domain.Core.Commands;

namespace Admin.Domain.GruposEmpresariais.Commands
{
    public class BaseGrupoEmpresarialCommand : Command
    {
        public Guid Id { get; protected set; }
        public string Codigo { get; protected set; }
        public string Descricao { get; protected set; }
        public DateTime DataCadastro { get; protected set; }
        public DateTime DataUltimaAtualizacao { get; protected set; }
    }
}