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
  System.Classes, System.SysUtils;

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
  t_NomeSingularClasse: string;
  t_NomePluralClasse: string;
  t_NomeSingularSnkClasse: string;
  t_NomePluralSnkClasse: string;
begin
  t_Arquivo := TStringList.Create();

  try
    t_NomeSingularClasse := pEntidade.nomeClasseSingular;
    t_NomePluralClasse := pEntidade.nomeClassePlural;
    t_NomeSingularSnkClasse := LowerCase(Copy(t_NomeSingularClasse, 1, 1)) + Copy(t_NomeSingularClasse, 2, Length(t_NomeSingularClasse));
    t_NomePluralSnkClasse := LowerCase(Copy(t_NomePluralClasse, 1, 1)) + Copy(t_NomePluralClasse, 2, Length(t_NomePluralClasse));

    t_Arquivo.Add('using AutoMapper;');
    t_Arquivo.Add('using ERP.Domain.Core.Bus;');
    t_Arquivo.Add('using ERP.Domain.Core.Contracts;');
    t_Arquivo.Add('using ERP.Domain.Core.Notifications;');
    t_Arquivo.Add(Format('using ERP.%s.Domain.%s.Commands;', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao]));
    t_Arquivo.Add(Format('using ERP.%s.Domain.%s.Repositories;', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao]));
    t_Arquivo.Add(Format('using ERP.Services.API.ViewModels.%s.%s;', [pEntidade.NomeModulo, t_NomeSingularClasse]));
    t_Arquivo.Add('using MediatR;');
    t_Arquivo.Add('using Microsoft.AspNetCore.Authorization;');
    t_Arquivo.Add('using Microsoft.AspNetCore.Mvc;');
    t_Arquivo.Add('using System;');
    t_Arquivo.Add('using System.Collections.Generic;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.Services.API.Controllers.%s', [pEntidade.nomeModulo]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class %sController: BaseController', [t_NomePluralClasse]));
    t_Arquivo.Add('    {');
    t_Arquivo.Add(Format('        private readonly I%sRepository _%sRepository;', [t_NomePluralClasse, t_NomePluralSnkClasse]));
    t_Arquivo.Add('        private readonly IMapper _mapper;');
    t_Arquivo.Add('        private readonly IMediatorHandler _mediator;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('        public %sController(INotificationHandler<DomainNotification> notifications, IUser user, IMediatorHandler mediator, I%sRepository %sRepository, IMapper mapper) : base(notifications, user, mediator)', [t_NomePluralClasse, t_NomePluralClasse, t_NomePluralSnkClasse]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add(Format('            _%sRepository = %sRepository;', [t_NomePluralSnkClasse, t_NomePluralSnkClasse]));
    t_Arquivo.Add('            _mapper = mapper;');
    t_Arquivo.Add('            _mediator = mediator;');
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add('        [HttpPost]');
    t_Arquivo.Add(Format('        [Route("%s")]', [LowerCase(t_NomePluralClasse)]));
    t_Arquivo.Add(Format('        [Authorize(Policy = "Save%s")]', [t_NomeSingularClasse]));
    t_Arquivo.Add(Format('        public IActionResult Post([FromBody]Save%sViewModel %sViewModel)', [t_NomeSingularClasse, t_NomeSingularSnkClasse]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add('            if (!IsModelStateValid()) return Response();');
    t_Arquivo.Add(Format('            var %sCommand = _mapper.Map<Save%sCommand>(%sViewModel);', [t_NomeSingularSnkClasse, t_NomeSingularClasse, t_NomeSingularSnkClasse]));
    t_Arquivo.Add(Format('            _mediator.SendCommand(%sCommand);', [t_NomeSingularSnkClasse]));
    t_Arquivo.Add(Format('            return Response(%sCommand);', [t_NomeSingularSnkClasse]));
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add('        [HttpPut]');
    t_Arquivo.Add(Format('        [Route("%s")]', [LowerCase(t_NomePluralClasse)]));
    t_Arquivo.Add(Format('        [Authorize(Policy = "Update%s")]', [t_NomeSingularClasse]));
    t_Arquivo.Add(Format('        public IActionResult Put([FromBody]Update%sViewModel %sViewModel)', [t_NomeSingularClasse, t_NomeSingularSnkClasse]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add('            if (!IsModelStateValid()) return Response();');
    t_Arquivo.Add(Format('            var %sCommand = _mapper.Map<Update%sCommand>(%sViewModel);', [t_NomeSingularSnkClasse, t_NomeSingularClasse, t_NomeSingularSnkClasse]));
    t_Arquivo.Add(Format('            _mediator.SendCommand(%sCommand);', [t_NomeSingularSnkClasse]));
    t_Arquivo.Add(Format('            return Response(%sCommand);', [t_NomeSingularSnkClasse]));
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add('        [HttpDelete]');
    t_Arquivo.Add(Format('        [Route("%s/{id:guid}")]', [LowerCase(t_NomePluralClasse)]));
    t_Arquivo.Add(Format('        [Authorize(Policy = "Delete%s")]', [t_NomeSingularClasse]));
    t_Arquivo.Add('        public IActionResult Delete(Guid id)');
    t_Arquivo.Add('        {');
    t_Arquivo.Add(Format('            var %sCommand = _mapper.Map<Delete%sCommand>(new Delete%sViewModel { Id = id });', [t_NomeSingularSnkClasse, t_NomeSingularClasse, t_NomeSingularClasse]));
    t_Arquivo.Add(Format('            _mediator.SendCommand(%sCommand);', [t_NomeSingularSnkClasse]));
    t_Arquivo.Add(Format('            return Response(%sCommand);', [t_NomeSingularSnkClasse]));
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add('        [HttpGet]');
    t_Arquivo.Add(Format('        [Route("%s")]', [LowerCase(t_NomePluralClasse)]));
    t_Arquivo.Add(Format('        [Authorize(Policy = "View%s")]', [t_NomeSingularClasse]));
    t_Arquivo.Add(Format('        public IEnumerable<%sViewModel> Get()', [t_NomeSingularClasse]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add(Format('            return _mapper.Map<IEnumerable<%sViewModel>>(_%sRepository.GetAll());', [t_NomeSingularClasse, t_NomePluralSnkClasse]));
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add('        [HttpGet]');
    t_Arquivo.Add(Format('        [Route("%s/{id:guid}")]', [LowerCase(t_NomePluralClasse)]));
    t_Arquivo.Add(Format('        [Authorize(Policy = "View%s")]', [t_NomeSingularClasse]));
    t_Arquivo.Add(Format('        public %sViewModel Get(Guid id)', [t_NomeSingularClasse]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add(Format('            return _mapper.Map<%sViewModel>(_%sRepository.GetById(id));', [t_NomeSingularClasse, t_NomePluralSnkClasse]));
    t_Arquivo.Add('        }');
    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TServiceApiControllerGenerator.getFileDirectory(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('ERP.Services.API\Controllers\%s\', [pEntidade.NomeModulo]);
end;

function TServiceApiControllerGenerator.getFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('%sController.cs', [pEntidade.NomeClassePlural]);
end;

end.
