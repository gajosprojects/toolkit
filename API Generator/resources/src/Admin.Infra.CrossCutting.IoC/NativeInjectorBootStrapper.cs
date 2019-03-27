using Admin.Domain.Contracts;
using Admin.Domain.Core.Bus;
using Admin.Domain.Core.Events;
using Admin.Domain.Core.Notifications;
using Admin.Domain.GruposEmpresariais.Commands;
using Admin.Domain.GruposEmpresariais.Events;
using Admin.Domain.GruposEmpresariais.Repositories;
using Admin.Infra.CrossCutting.Bus;
using Admin.Infra.Data.SqlServer.Context;
using Admin.Infra.Data.SqlServer.EventSourcing;
using Admin.Infra.Data.SqlServer.Repositories;
using Admin.Infra.Data.SqlServer.Repositories.EventSourcing;
using Admin.Infra.Data.SqlServer.UoW;
using AutoMapper;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;

namespace Admin.Infra.CrossCutting.IoC
{
    public class NativeInjectorBootStrapper
    {
        public static void RegisterServices(IServiceCollection services) 
        {
            // ASPNET
            services.AddSingleton(Mapper.Configuration);
            services.AddScoped<IMapper>(sp => new Mapper(sp.GetRequiredService<IConfigurationProvider>(), sp.GetService));

            // Domain Bus (Mediator)
            services.AddScoped<IMediatorHandler, InMemoryBus>();

            // Domain - Commands
            services.AddScoped<IRequestHandler<SalvarGrupoEmpresarialCommand, bool>, GrupoEmpresarialCommandHandler>();
            services.AddScoped<IRequestHandler<AtualizarGrupoEmpresarialCommand, bool>, GrupoEmpresarialCommandHandler>();
            services.AddScoped<IRequestHandler<ExcluirGrupoEmpresarialCommand, bool>, GrupoEmpresarialCommandHandler>();

            // Domain - GruposEmpresariais
            services.AddScoped<INotificationHandler<DomainNotification>, DomainNotificationHandler>();
            services.AddScoped<INotificationHandler<GrupoEmpresarialRegistradoEvent>, GrupoEmpresarialEventHandler>();
            services.AddScoped<INotificationHandler<GrupoEmpresarialAtualizadoEvent>, GrupoEmpresarialEventHandler>();
            services.AddScoped<INotificationHandler<GrupoEmpresarialExcluidoEvent>, GrupoEmpresarialEventHandler>();

            // Infra - Data
            services.AddScoped<IGruposEmpresariaisRepository, GruposEmpresariaisRepository>();
            services.AddScoped<IUnitOfWork, UnitOfWork>();
            services.AddScoped<GruposEmpresariaisContext>();

            // Infra - Data EventSourcing
            services.AddScoped<IEventStoreRepository, EventStoreSQLRepository>();
            services.AddScoped<IEventStore, EventStore>();
            services.AddScoped<EventStoreSQLContext>();
        }
    }
}