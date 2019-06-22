unit service_api_controller_generator;

interface

uses
  uEntidadeDTO;

type
  TServiceApiControllerGenerator = class

  public
    procedure generate(var pEntidade: TEntidadeDTO);

  end;

implementation

uses
  System.Classes, System.SysUtils;

{ TControllerGenerator }

procedure TServiceApiControllerGenerator.generate(var pEntidade: TEntidadeDTO);
var
  t_arquivo: TStringList;
  t_nome_singular_classe: string;
  t_nome_plural_classe: string;
  t_nome_singular_snk_classe: string;
  t_nome_plural_snk_classe: string;
  t_diretorio: string;
begin
  try
    t_diretorio := EmptyStr;

    t_nome_singular_classe := pEntidade.nomeClasseSingular;
    t_nome_plural_classe := pEntidade.nomeClassePlural;
    t_nome_singular_snk_classe := LowerCase(Copy(t_nome_singular_classe, 1, 1)) + Copy(t_nome_singular_classe, 2, Length(t_nome_singular_classe));
    t_nome_plural_snk_classe := LowerCase(Copy(t_nome_plural_classe, 1, 1)) + Copy(t_nome_plural_classe, 2, Length(t_nome_plural_classe));

    t_arquivo := TStringList.Create();

    t_arquivo.Add('using System;');
    t_arquivo.Add('using System.Collections.Generic;');
    t_arquivo.Add('using AutoMapper;');
    t_arquivo.Add(Format('using ERP.%s.Domain.%s.Commands;', [pEntidade.NomeModulo, t_nome_plural_classe]));
    t_arquivo.Add(Format('using ERP.%s.Domain.%s.Repositories;', [pEntidade.NomeModulo, t_nome_plural_classe]));
    t_arquivo.Add('using ERP.Domain.Core.Bus;');
    t_arquivo.Add('using ERP.Domain.Core.Notifications;');
    t_arquivo.Add('using ERP.Services.API.ViewModels;');
    t_arquivo.Add('using MediatR;');
    t_arquivo.Add('using Microsoft.AspNetCore.Mvc;');
    t_arquivo.Add('');
    t_arquivo.Add(Format('namespace ERP.Services.API.Controllers', [pEntidade.nomeModulo]));
    t_arquivo.Add('{');
    t_arquivo.Add(Format('    public class %sController: BaseController', [t_nome_plural_classe]));
    t_arquivo.Add('    {');
    t_arquivo.Add(Format('        private readonly I%sRepository _%sRepository;', [t_nome_plural_classe, t_nome_plural_snk_classe]));
    t_arquivo.Add('        private readonly IMapper _mapper;');
    t_arquivo.Add('        private readonly IMediatorHandler _mediator;');
    t_arquivo.Add('');
    t_arquivo.Add(Format('        public %sController(INotificationHandler<DomainNotification> notifications, IMediatorHandler mediator, I%sRepository %sRepository, IMapper mapper) : base(notifications, mediator)', [t_nome_plural_classe, t_nome_plural_classe, t_nome_plural_snk_classe]));
    t_arquivo.Add('        {');
    t_arquivo.Add(Format('            _%sRepository = %sRepository;', [t_nome_plural_snk_classe, t_nome_plural_snk_classe]));
    t_arquivo.Add('            _mapper = mapper;');
    t_arquivo.Add('            _mediator = mediator;');
    t_arquivo.Add('        }');
    t_arquivo.Add('');
    t_arquivo.Add('        [HttpPost]');
    t_arquivo.Add(Format('        [Route("%s")]', [LowerCase(t_nome_plural_classe)]));
    t_arquivo.Add(Format('        public IActionResult Post([FromBody]%sViewModel %sViewModel)', [t_nome_singular_classe, t_nome_singular_snk_classe]));
    t_arquivo.Add('        {');
    t_arquivo.Add('            if (!IsModelStateValid()) return Response();');
    t_arquivo.Add(Format('            var %sCommand = _mapper.Map<Save%sCommand>(%sViewModel);', [t_nome_singular_snk_classe, t_nome_singular_classe, t_nome_singular_snk_classe]));
    t_arquivo.Add(Format('            _mediator.SendCommand(%sCommand);', [t_nome_singular_snk_classe]));
    t_arquivo.Add(Format('            return Response(%sCommand);', [t_nome_singular_snk_classe]));
    t_arquivo.Add('        }');
    t_arquivo.Add('');
    t_arquivo.Add('        [HttpPut]');
    t_arquivo.Add(Format('        [Route("%s")]', [LowerCase(t_nome_plural_classe)]));
    t_arquivo.Add(Format('        public IActionResult Put([FromBody]%sViewModel %sViewModel)', [t_nome_singular_classe, t_nome_singular_snk_classe]));
    t_arquivo.Add('        {');
    t_arquivo.Add('            if (!IsModelStateValid()) return Response();');
    t_arquivo.Add(Format('            var %sCommand = _mapper.Map<Update%sCommand>(%sViewModel);', [t_nome_singular_snk_classe, t_nome_singular_classe, t_nome_singular_snk_classe]));
    t_arquivo.Add(Format('            _mediator.SendCommand(%sCommand);', [t_nome_singular_snk_classe]));
    t_arquivo.Add(Format('            return Response(%sCommand);', [t_nome_singular_snk_classe]));
    t_arquivo.Add('        }');
    t_arquivo.Add('');
    t_arquivo.Add('        [HttpDelete]');
    t_arquivo.Add(Format('        [Route("%s/{id:guid}")]', [LowerCase(t_nome_plural_classe)]));
    t_arquivo.Add('        public IActionResult Delete(Guid id)');
    t_arquivo.Add('        {');
    t_arquivo.Add(Format('            var %sViewModel = new %sViewModel { Id = id };', [t_nome_singular_snk_classe, t_nome_singular_classe]));
    t_arquivo.Add(Format('            var %sCommand = _mapper.Map<Delete%sCommand>(%sViewModel);', [t_nome_singular_snk_classe, t_nome_singular_classe, t_nome_singular_snk_classe]));
    t_arquivo.Add(Format('            _mediator.SendCommand(%sCommand);', [t_nome_singular_snk_classe]));
    t_arquivo.Add(Format('            return Response(%sCommand);', [t_nome_singular_snk_classe]));
    t_arquivo.Add('        }');
    t_arquivo.Add('');
    t_arquivo.Add('        [HttpGet]');
    t_arquivo.Add(Format('        [Route("%s")]', [LowerCase(t_nome_plural_classe)]));
    t_arquivo.Add(Format('        public IEnumerable<%sViewModel> Get()', [t_nome_singular_classe]));
    t_arquivo.Add('        {');
    t_arquivo.Add(Format('            return _mapper.Map<IEnumerable<%sViewModel>>(_%sRepository.GetAll());', [t_nome_singular_classe, t_nome_plural_snk_classe]));
    t_arquivo.Add('        }');
    t_arquivo.Add('');
    t_arquivo.Add('        [HttpGet]');
    t_arquivo.Add(Format('        [Route("%s/{id:guid}")]', [LowerCase(t_nome_plural_classe)]));
    t_arquivo.Add(Format('        public %sViewModel Get(Guid id)', [t_nome_singular_classe]));
    t_arquivo.Add('        {');
    t_arquivo.Add(Format('            return _mapper.Map<%sViewModel>(_%sRepository.GetById(id));', [t_nome_singular_classe, t_nome_plural_snk_classe]));
    t_arquivo.Add('        }');
    t_arquivo.Add('    }');
    t_arquivo.Add('}');

    t_diretorio := GetCurrentDir() + '\ERP.Services.API\Controllers';

    if (not DirectoryExists(t_diretorio)) then
    begin
      ForceDirectories(t_diretorio);
    end;

    t_diretorio := Format('%s\%s', [t_diretorio, pEntidade.NomeModulo]);

    if (not DirectoryExists(t_diretorio)) then
    begin
      ForceDirectories(t_diretorio);
    end;

    t_arquivo.SaveToFile(Format('%s\%sController.cs', [t_diretorio, t_nome_plural_classe]));
  finally
    FreeAndNil(t_arquivo);
  end;
end;

end.
