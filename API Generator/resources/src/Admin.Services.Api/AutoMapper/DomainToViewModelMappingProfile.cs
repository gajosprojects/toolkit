using Admin.Domain.GruposEmpresariais;
using Admin.Services.Api.ViewModels;
using AutoMapper;

namespace Admin.Services.Api.AutoMapper
{
    public class DomainToViewModelMappingProfile : Profile
    {
        public DomainToViewModelMappingProfile()
        {
            CreateMap<GrupoEmpresarial, GrupoEmpresarialViewModel>();
            CreateMap<Empresa, EmpresaViewModel>();
            CreateMap<Estabelecimento, EstabelecimentoViewModel>();
            CreateMap<Cnae, CnaeViewModel>();
        }
    }
}