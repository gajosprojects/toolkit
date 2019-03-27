using System;

namespace Admin.Domain.GruposEmpresariais.Commands
{
    public class AtualizarGrupoEmpresarialCommand : BaseGrupoEmpresarialCommand
    {
        public AtualizarGrupoEmpresarialCommand(Guid id, string codigo, string descricao)
        {
            Id = id;
            Codigo = codigo;
            Descricao = descricao;
            DataUltimaAtualizacao = DateTime.Now;
        }
    }
}