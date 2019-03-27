using System;

namespace Admin.Domain.GruposEmpresariais.Commands
{
    public class SalvarGrupoEmpresarialCommand : BaseGrupoEmpresarialCommand
    {
        public SalvarGrupoEmpresarialCommand(string codigo, string descricao)
        {
            Codigo = codigo;
            Descricao = descricao;
            DataCadastro = DateTime.Now;
        }
    }
}