unit tests_integration_generator;

interface

uses
  uEntidadeDTO, uArquivoDTO;

type
  TTestsIntegrationGenerator = class

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

{ TTestsIntegrationGenerator }

function TTestsIntegrationGenerator.getFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileDirectory(pEntidade);
  Result.Nome      := getFileName(pEntidade);
  Result.Conteudo  := getFileContent(pEntidade);
end;

function TTestsIntegrationGenerator.getFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
begin
  t_Arquivo := TStringList.Create();

  try
    t_Arquivo.Add(Format('using ERP.Tests.Integration.%s.DTO;', [pEntidade.NomeModulo]));
    t_Arquivo.Add('using FluentAssertions;');
    t_Arquivo.Add('using Newtonsoft.Json;');
    t_Arquivo.Add('using System.Collections.Generic;');
    t_Arquivo.Add('using System.Linq;');
    t_Arquivo.Add('using System.Threading.Tasks;');
    t_Arquivo.Add('using Xunit;');
    t_Arquivo.Add('using Xunit.Extensions.Ordering;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.Tests.Integration.%s', [pEntidade.NomeModulo]));
    t_Arquivo.Add('{');
    t_Arquivo.Add('    [Order()]');
    t_Arquivo.Add(Format('    public class %sControllerIntegrationTests', [pEntidade.NomeClasseAgregacaoPlural]));
    t_Arquivo.Add('    {');
    t_Arquivo.Add(Format('        public %sControllerIntegrationTests() => Environment.CreateServer();', [pEntidade.NomeClasseAgregacaoPlural]));
    t_Arquivo.Add('');
    t_Arquivo.Add('        [Fact, Order()]');
    t_Arquivo.Add(Format('        public async Task %sController_Post_%s_RetornarSucesso()', [pEntidade.NomeClasseAgregacaoPlural, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add(Format('            var response = await Environment.CreateRequest("POST", "api/v1/%s", ViewModelGen.GenerateSave%sViewModel());', [pEntidade.NomeClassePlural.ToLowerCase(), pEntidade.NomeClasseSingular]));
    t_Arquivo.Add(Format('            var %sDTO = JsonConvert.DeserializeObject<%sDTO>(await response.Content.ReadAsStringAsync());', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter(), pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('');
    t_Arquivo.Add('            response.EnsureSuccessStatusCode();');
    t_Arquivo.Add(Format('            Assert.IsType<%sDataResponse>(%sDTO.data);', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular.DecapitalizeFirstLetter()]));
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add('        [Fact, Order()]');
    t_Arquivo.Add(Format('        public async Task %sController_Put_%s_RetornarSucesso()', [pEntidade.NomeClasseAgregacaoPlural, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add(Format('            var response = await Environment.CreateGetRequest("api/v1/%s");', [pEntidade.NomeClassePlural.ToLowerCase()]));
    t_Arquivo.Add(Format('            var %sDTO = JsonConvert.DeserializeObject<IEnumerable<Get%sDTO>>(await response.Content.ReadAsStringAsync()).FirstOrDefault();', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter(), pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('            response = await Environment.CreateRequest("PUT", "api/v1/%s", ViewModelGen.ConvertViewModelToStringContent(ConvertDTOTo.Update%sViewModel(%SDTO)));', [pEntidade.NomeClassePlural.ToLowerCase(), pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular.DecapitalizeFirstLetter()]));
    t_Arquivo.Add(Format('            var updated%sDTO = JsonConvert.DeserializeObject<%sDTO>(await response.Content.ReadAsStringAsync());', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('');
    t_Arquivo.Add('            response.EnsureSuccessStatusCode();');
    t_Arquivo.Add(Format('            Assert.IsType<%sDataResponse>(updated%sDTO.data);', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add(Format('            Assert.NotEqual(%sDTO.dataUltimaAtualizacao, updated%sDTO.data.dataUltimaAtualizacao);', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter(), pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add('        [Fact, Order()]');
    t_Arquivo.Add(Format('        public async Task %sController_GetAll_%s_RetornarSucesso()', [pEntidade.NomeClasseAgregacaoPlural, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add(Format('            var response = await Environment.CreateGetRequest("api/v1/%s");', [pEntidade.NomeClassePlural.ToLowerCase()]));
    t_Arquivo.Add(Format('            var %sDTO = JsonConvert.DeserializeObject<IEnumerable<Get%sDTO>>(await response.Content.ReadAsStringAsync());', [pEntidade.NomeClassePlural.DecapitalizeFirstLetter(), pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('');
    t_Arquivo.Add('            response.EnsureSuccessStatusCode();');
    t_Arquivo.Add(Format('            %sDTO.Should().HaveCountGreaterThan(0);', [pEntidade.NomeClassePlural.DecapitalizeFirstLetter()]));
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add('        [Fact, Order()]');
    t_Arquivo.Add(Format('        public async Task %sController_Get_%s_RetornarSucesso()', [pEntidade.NomeClasseAgregacaoPlural, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add(Format('            var response = await Environment.CreateGetRequest("api/v1/%s");', [pEntidade.NomeClassePlural.ToLowerCase()]));
    t_Arquivo.Add(Format('            var %sDTO = JsonConvert.DeserializeObject<IEnumerable<Get%sDTO>>(await response.Content.ReadAsStringAsync());', [pEntidade.NomeClassePlural.DecapitalizeFirstLetter(), pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('            response = await Environment.CreateGetRequest("api/v1/%s/" + %sDTO.FirstOrDefault().id);', [pEntidade.NomeClassePlural.ToLowerCase(), pEntidade.NomeClassePlural.DecapitalizeFirstLetter()]));
    t_Arquivo.Add(Format('            var %sDTO = JsonConvert.DeserializeObject<Get%sDTO>(await response.Content.ReadAsStringAsync());', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter(), pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('');
    t_Arquivo.Add('            response.EnsureSuccessStatusCode();');
    t_Arquivo.Add(Format('            %sDTO.Should().BeEquivalentTo(%sDTO.FirstOrDefault());', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter(), pEntidade.NomeClassePlural.DecapitalizeFirstLetter()]));
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add('        [Fact, Order()]');
    t_Arquivo.Add(Format('        public async Task %sController_Delete_%s_RetornarSucesso()', [pEntidade.NomeClasseAgregacaoPlural, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add(Format('            var response = await Environment.CreateGetRequest("api/v1/%s");', [pEntidade.NomeClassePlural.ToLowerCase()]));
    t_Arquivo.Add(Format('            var %sDTO = JsonConvert.DeserializeObject<IEnumerable<Get%sDTO>>(await response.Content.ReadAsStringAsync()).FirstOrDefault();', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter(), pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('            response = await Environment.CreateRequest("DELETE", "api/v1/%s/" + %sDTO.id, null);', [pEntidade.NomeClassePlural.ToLowerCase(), pEntidade.NomeClasseSingular.DecapitalizeFirstLetter()]));
    t_Arquivo.Add(Format('            var deleted%sDTO = JsonConvert.DeserializeObject<%sDTO>(await response.Content.ReadAsStringAsync());', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('');
    t_Arquivo.Add('            response.EnsureSuccessStatusCode();');
    t_Arquivo.Add(Format('            Assert.IsType<%sDataResponse>(deleted%sDTO.data);', [pEntidade.NomeClasseSingular, pEntidade.NomeClasseSingular]));
    t_Arquivo.Add(Format('            Assert.False(deleted%sDTO.data.ativo);', [pEntidade.NomeClasseSingular]));
    t_Arquivo.Add(Format('            Assert.NotEqual(%sDTO.dataUltimaAtualizacao, deleted%sDTO.data.dataUltimaAtualizacao);', [pEntidade.NomeClasseSingular.DecapitalizeFirstLetter(), pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('        }');
    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TTestsIntegrationGenerator.getFileDirectory(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('\tests\ERP.Tests.Integration\%s\', [pEntidade.NomeModulo]);
end;

function TTestsIntegrationGenerator.getFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('%sControllerIntegrationTests.cs', [pEntidade.NomeClasseAgregacaoPlural]);
end;

end.
