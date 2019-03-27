using System;
using System.Collections.Generic;
using Admin.Domain.Core.Bus;
using Admin.Domain.Core.Notifications;
using Admin.Domain.GruposEmpresariais.Commands;
using Admin.Domain.GruposEmpresariais.Repositories;
using Admin.Services.Api.ViewModels;
using AutoMapper;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace Admin.Services.Api.Controllers
{
    public class GruposEmpresariaisController : BaseController
    {
        private readonly IGruposEmpresariaisRepository _gruposEmpresariaisRepository;
        private readonly IMapper _mapper;
        private readonly IMediatorHandler _mediator;

        public GruposEmpresariaisController(INotificationHandler<DomainNotification> notifications, IMediatorHandler mediator, IGruposEmpresariaisRepository gruposEmpresariaisRepository, IMapper mapper) : base(notifications, mediator)
        {
            _gruposEmpresariaisRepository = gruposEmpresariaisRepository;
            _mapper = mapper;
            _mediator = mediator;
        }

        [HttpPost]
        [Route("gruposempresariais")]
        public IActionResult Post([FromBody]GrupoEmpresarialViewModel grupoEmpresarialViewModel)
        {
            if (!IsModelStateValid()) return Response();
            var grupoEmpresarialCommand = _mapper.Map<SalvarGrupoEmpresarialCommand>(grupoEmpresarialViewModel);
            _mediator.EnviarComando(grupoEmpresarialCommand);
            return Response(grupoEmpresarialCommand);
        }

        [HttpPut]
        [Route("gruposempresariais")]
        public IActionResult Put([FromBody]GrupoEmpresarialViewModel grupoEmpresarialViewModel)
        {
            if (!IsModelStateValid()) return Response();
            var grupoEmpresarialCommand = _mapper.Map<AtualizarGrupoEmpresarialCommand>(grupoEmpresarialViewModel);
            _mediator.EnviarComando(grupoEmpresarialCommand);
            return Response(grupoEmpresarialCommand);
        }

        [HttpDelete]
        [Route("gruposempresariais/{id:guid}")]
        public IActionResult Delete(Guid id)
        {
            var grupoEmpresarialViewModel = new GrupoEmpresarialViewModel { Id = id };
            var grupoEmpresarialCommand = _mapper.Map<ExcluirGrupoEmpresarialCommand>(grupoEmpresarialViewModel);
            _mediator.EnviarComando(grupoEmpresarialCommand);
            return Response(grupoEmpresarialCommand);
        }

        [HttpGet]
        [Route("gruposempresariais")]
        public IEnumerable<GrupoEmpresarialViewModel> Get()
        {
            return _mapper.Map<IEnumerable<GrupoEmpresarialViewModel>>(_gruposEmpresariaisRepository.ObterTodos());
        }

        [HttpGet]
        [Route("gruposempresariais/{id:guid}")]
        public GrupoEmpresarialViewModel Get(Guid id)
        {
            return _mapper.Map<GrupoEmpresarialViewModel>(_gruposEmpresariaisRepository.ObterPorId(id));
        }
    }
}