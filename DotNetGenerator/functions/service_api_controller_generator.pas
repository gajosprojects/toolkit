unit service_api_controller_generator;

interface

uses
  uEntidadeDTO, uArquivoDTO;

type
  TServiceApiControllerGenerator = class

  private
    function getFileName(const pEntidade: TEntidadeDTO): string;
    function getFileDirectory(const pEntidade: TEntidadeDTO): string;
    function getFileContent(const pEntidade: TEntidadeDTO): WideString;

  public
    function getFile(const pEntidade: TEntidadeDTO): TArquivoDTO;

  end;

implementation

uses
  System.Classes, System.SysUtils, uStringHelper;

{ TControllerGenerator }

function TServiceApiControllerGenerator.getFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileDirectory(pEntidade);
  Result.Nome      := getFileName(pEntidade);
  Result.Conteudo  := getFileContent(pEntidade);
end;

function TServiceApiControllerGenerator.getFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
begin
  t_Arquivo := TStringList.Create();

  try
    t_Arquivo.Add('using AutoMapper;');
    t_Arquivo.Add('using ERP.Domain.Core.Bus;');
    t_Arquivo.Add('using ERP.Domain.Core.Contracts;');
    t_Arquivo.Add('using ERP.Domain.Core.Notifications;');
    t_Arquivo.Add(Format('using ERP.%s.Domain.%s.Commands.%s;', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacaoPlural, pEntidade.NomeClassePlural]));
    t_Arquivo.Add(Format('using ERP.%s.Domain.%s.Repositories;', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacaoPlural]));
    t_Arquivo.Add(Format('using ERP.Services.API.ViewModels.%s.%s;', [pEntidade.NomeModulo, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('using MediatR;');
    t_Arquivo.Add('using Microsoft.AspNetCore.Authorization;');
    t_Arquivo.Add('using Microsoft.AspNetCore.Mvc;');
    t_Arquivo.Add('using System;');
    t_Arquivo.Add('using System.Collections.Generic;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.Services.API.Controllers.%s', [pEntidade.nomeModulo]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class %sController: BaseController', [pEntidade.NomeClasseAgregacaoPlural]));
    t_Arquivo.Add('    {');
    t_Arquivo.Add(Format('        private readonly I%sRepository _%sRepository;', [pEntidade.NomeClasseAgregacaoPlural, pEntidade.NomeClasseAgregacaoPlural.DecapitalizeFirstLetter()]));
    t_Arquivo.Add('        private readonly IMapper _mapper;');
    t_Arquivo.Add('        private readonly IMediatorHandler _mediator;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('        public %sController(INotificationHandler<DomainNotification> notifications, IUser user, IMediatorHandler mediator, I%sRepository %sRepository, IMapper mapper) : base(notifications, user, mediator)', [pEntidade.NomeClasseAgregacaoPlural, pEntidade.NomeClasseAgregacaoPlural, pEntidade.NomeClasseAgregacaoPlural.DecapitalizeFirstLetter()]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add(Format('            _%sRepository = %sRepository;', [pEntidade.NomeClasseAgregacaoPlural.DecapitalizeFirstLetter(), pEntidade.NomeClasseAgregacaoPlural.DecapitalizeFirstLetter()]));
    t_Arquivo.Add('            _mapper = mapper;');
    t_Arquivo.Add('            _mediator = mediator;');
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add('        /// <summary>');
    t_Arquivo.Add(Format('        /// Salva um novo %s', [pEntidade.NomeClasseExibicaoSingular]));
    t_Arquivo.Add('        /// </summary>');
    t_Arquivo.Add(Format('        /// <param name="%sViewModel"></param>', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter()]));
    t_Arquivo.Add(Format('        /// <returns>%s</returns>', [pEntidade.NomeClasseExibicaoSingular]));
    t_Arquivo.Add(Format('        /// <remarks>Emite um comando que cria uma instancia de um %s, e caso a mesma esteja valida, salva no banco de dados.</remarks>', [pEntidade.NomeClasseExibicaoSingular]));
    t_Arquivo.Add('        [HttpPost]');
    t_Arquivo.Add(Format('        [Route("%s")]', [pEntidade.NomeClassePlural.ToLowerCase()]));
    t_Arquivo.Add(Format('        [Authorize(Policy = "Save%s")]', [pEntidade.NomeClasseSingular]));
    t_Arquivo.Add(Format('        public IActionResult Post([FromBody]Save%sViewModel %sViewModel)', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular.DecapitalizeFirstLetter()]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add('            if (!IsModelStateValid()) return Response();');
    t_Arquivo.Add(Format('            var %sCommand = _mapper.Map<Save%sCommand>(%sViewModel);', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter(), pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular.DecapitalizeFirstLetter()]));
    t_Arquivo.Add(Format('            _mediator.SendCommand(%sCommand);', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter()]));
    t_Arquivo.Add(Format('            return Response(%sCommand);', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter()]));
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add('        /// <summary>');
    t_Arquivo.Add(Format('        /// Atualiza um %s existente', [pEntidade.NomeClasseExibicaoSingular]));
    t_Arquivo.Add('        /// </summary>');
    t_Arquivo.Add(Format('        /// <param name="%sViewModel"></param>', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter()]));
    t_Arquivo.Add(Format('        /// <returns>%s</returns>', [pEntidade.NomeClasseExibicaoSingular]));
    t_Arquivo.Add(Format('        /// <remarks>Emite um comando que obtem por ID uma instancia de um %s ja existente, atualiza os atributos que foram editados pelo usuario, e caso esteja valida, salva no banco de dados.</remarks>', [pEntidade.NomeClasseExibicaoSingular]));
    t_Arquivo.Add('        [HttpPut]');
    t_Arquivo.Add(Format('        [Route("%s")]', [pEntidade.NomeClassePlural.ToLowerCase()]));
    t_Arquivo.Add(Format('        [Authorize(Policy = "Update%s")]', [pEntidade.NomeClasseSingular]));
    t_Arquivo.Add(Format('        public IActionResult Put([FromBody]Update%sViewModel %sViewModel)', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular.DecapitalizeFirstLetter()]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add('            if (!IsModelStateValid()) return Response();');
    t_Arquivo.Add(Format('            var %sCommand = _mapper.Map<Update%sCommand>(%sViewModel);', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter(), pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular.DecapitalizeFirstLetter()]));
    t_Arquivo.Add(Format('            _mediator.SendCommand(%sCommand);', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter()]));
    t_Arquivo.Add(Format('            return Response(%sCommand);', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter()]));
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add('        /// <summary>');
    t_Arquivo.Add(Format('        /// Exclui/Desativa um %s existente', [pEntidade.NomeClasseExibicaoSingular]));
    t_Arquivo.Add('        /// </summary>');
    t_Arquivo.Add('        /// <param name="id"></param>');
    t_Arquivo.Add('        /// <returns>Boolean</returns>');
    t_Arquivo.Add(Format('        /// <remarks>Emite um comando que obtem por ID uma instancia de um %s ja existente, e o exclui/desativa.</remarks>', [pEntidade.NomeClasseExibicaoSingular]));
    t_Arquivo.Add('        [HttpDelete]');
    t_Arquivo.Add(Format('        [Route("%s/{id:guid}")]', [pEntidade.NomeClassePlural.ToLowerCase()]));
    t_Arquivo.Add(Format('        [Authorize(Policy = "Delete%s")]', [pEntidade.NomeClasseSingular]));
    t_Arquivo.Add(Format('        public IActionResult Delete%s(Guid id)', [pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add('            if (!IsModelStateValid()) return Response();');
    t_Arquivo.Add(Format('            var %sCommand = _mapper.Map<Delete%sCommand>(new Delete%sViewModel { Id = id, UsuarioId = usuarioId });', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter(), pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular.DecapitalizeFirstLetter()]));
    t_Arquivo.Add(Format('            _mediator.SendCommand(%sCommand);', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter()]));
    t_Arquivo.Add(Format('            return Response(%sCommand);', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter()]));
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add('        /// <summary>');
    t_Arquivo.Add(Format('        /// Obtem uma lista de %s', [pEntidade.NomeClasseExibicaoPlural]));
    t_Arquivo.Add('        /// </summary>');
    t_Arquivo.Add(Format('        /// <returns>Lista de %s</returns>', [pEntidade.NomeClasseExibicaoPlural]));
    t_Arquivo.Add(Format('        /// <remarks>Lista de %s, ordenada pela descricao e excluindo os inativos.</remarks>', [pEntidade.NomeClasseExibicaoPlural]));
    t_Arquivo.Add('        [HttpGet]');
    t_Arquivo.Add(Format('        [Route("%s")]', [pEntidade.NomeClassePlural.ToLowerCase()]));
    t_Arquivo.Add(Format('        [Authorize(Policy = "View%s")]', [pEntidade.NomeClasseSingular]));

    if (SameText(pEntidade.NomeClasseSingular, pEntidade.NomeClasseAgregacaoSingular)) then
      t_Arquivo.Add(Format('        public IEnumerable<%sViewModel> GetAll() => _mapper.Map<IEnumerable<%sViewModel>>(_%sRepository.GetAll());', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular, pEntidade.NomeClassePlural.DecapitalizeFirstLetter()]))
    else
      t_Arquivo.Add(Format('        public IEnumerable<%sViewModel> GetAll%s() => _mapper.Map<IEnumerable<%sViewModel>>(_%sRepository.GetAll%s());', [pEntidade.NomeClasseSingular, pEntidade.NomeClassePlural, pEntidade.NomeClasseSingular, pEntidade.NomeClasseAgregacaoPlural.DecapitalizeFirstLetter(), pEntidade.NomeClassePlural]));

    t_Arquivo.Add('');
    t_Arquivo.Add('        /// <summary>');
    t_Arquivo.Add(Format('        /// Obtem um %s por ID', [pEntidade.NomeClasseExibicaoSingular]));
    t_Arquivo.Add('        /// </summary>');
    t_Arquivo.Add('        /// <param name="id"></param>');
    t_Arquivo.Add(Format('        /// <returns>%s</returns>', [pEntidade.NomeClasseExibicaoSingular]));
    t_Arquivo.Add('        [HttpGet]');
    t_Arquivo.Add(Format('        [Route("%s/{id:guid}")]', [pEntidade.NomeClassePlural.ToLowerCase()]));
    t_Arquivo.Add(Format('        [Authorize(Policy = "View%s")]', [pEntidade.NomeClasseSingular]));

    if (SameText(pEntidade.NomeClasseSingular, pEntidade.NomeClasseAgregacaoSingular)) then
      t_Arquivo.Add(Format('        public %sViewModel Get(Guid id) => _mapper.Map<%sViewModel>(_%sRepository.GetById(id));', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular, pEntidade.NomeClassePlural.DecapitalizeFirstLetter()]))
    else
      t_Arquivo.Add(Format('        public %sViewModel Get%s(Guid id) => _mapper.Map<%sViewModel>(_%sRepository.GetBy%sId(id));', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular.DecapitalizeFirstLetter(), pEntidade.NomeClasseAgregacaoPlural.DecapitalizeFirstLetter(), pEntidade.NomeClasseSingular.DecapitalizeFirstLetter()]));

    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TServiceApiControllerGenerator.getFileDirectory(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('\src\ERP.Services.API\Controllers\%s\', [pEntidade.NomeModulo]);
end;

function TServiceApiControllerGenerator.getFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('%sController.cs', [pEntidade.NomeClasseAgregacaoPlural]);
end;

end.
