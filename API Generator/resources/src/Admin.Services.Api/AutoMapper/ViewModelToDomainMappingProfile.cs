using Admin.Domain.GruposEmpresariais.Commands;
using Admin.Services.Api.ViewModels;
using AutoMapper;

namespace Admin.Services.Api.AutoMapper
{
    public class ViewModelToDomainMappingProfile : Profile
    {
        public ViewModelToDomainMappingProfile()
        {
            CreateMap<GrupoEmpresarialViewModel, SalvarGrupoEmpresarialCommand>()
                .ConstructUsing(ge => new SalvarGrupoEmpresarialCommand(ge.Codigo, ge.Descricao));
            
            CreateMap<GrupoEmpresarialViewModel, AtualizarGrupoEmpresarialCommand>()
                .ConstructUsing(ge => new AtualizarGrupoEmpresarialCommand(ge.Id, ge.Codigo, ge.Descricao));
            
            CreateMap<GrupoEmpresarialViewModel, ExcluirGrupoEmpresarialCommand>()
                .ConstructUsing(ge => new ExcluirGrupoEmpresarialCommand(ge.Id));
        }
    }
}