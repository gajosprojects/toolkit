using Admin.Domain.GruposEmpresariais;
using Admin.Domain.GruposEmpresariais.Repositories;
using Admin.Infra.Data.SqlServer.Context;
using Microsoft.EntityFrameworkCore;

namespace Admin.Infra.Data.SqlServer.Repositories
{
    public class GruposEmpresariaisRepository : Repository<GrupoEmpresarial>, IGruposEmpresariaisRepository
    {
        public GruposEmpresariaisRepository(GruposEmpresariaisContext db) : base(db)
        {
        }

        public override void Excluir(GrupoEmpresarial obj) 
        {
            var grupoEmpresarial = ObterPorId(obj.Id);
            grupoEmpresarial.Desativar();
            Atualizar(grupoEmpresarial);
        }
    }
}