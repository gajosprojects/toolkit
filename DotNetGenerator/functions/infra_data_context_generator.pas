unit infra_data_context_generator;

interface

uses
  uEntidadeDTO, uArquivoDTO;

type
  TInfraDataContextGenerator = class

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

{ TInfraDataContextGenerator }

function TInfraDataContextGenerator.getFile(const pEntidade: TEntidadeDTO): TArquivoDTO;
begin
  Result := TArquivoDTO.Create();

  Result.Diretorio := getFileDirectory(pEntidade);
  Result.Nome      := getFileName(pEntidade);
  Result.Conteudo  := getFileContent(pEntidade);
end;

function TInfraDataContextGenerator.getFileContent(const pEntidade: TEntidadeDTO): WideString;
var
  t_Arquivo: TStringList;
begin
  t_Arquivo := TStringList.Create();

  try
    t_Arquivo.Add('');

    t_Arquivo.Add(Format('using ERP.%s.Domain.%s;', [pEntidade.NomeModulo, pEntidade.NomeClasseAgregacao]));
    t_Arquivo.Add(Format('using ERP.Infra.Data.Mappings.%s;', [pEntidade.NomeModulo]));
    t_Arquivo.Add('using Microsoft.AspNetCore.Hosting;');
    t_Arquivo.Add('using Microsoft.EntityFrameworkCore;');
    t_Arquivo.Add('using Microsoft.Extensions.Configuration;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('namespace ERP.Infra.Data.Context.%s', [pEntidade.NomeModulo]));
    t_Arquivo.Add('{');
    t_Arquivo.Add(Format('    public class %sContext : DbContext', [pEntidade.NomeClasseAgregacao]));
    t_Arquivo.Add('    {');
    t_Arquivo.Add(Format('        public DbSet<%s> %s { get; set; }', [pEntidade.NomeClasseSingular, pEntidade.NomeClassePlural]));
    t_Arquivo.Add('        private readonly IHostingEnvironment _hostingEnvironment;');
    t_Arquivo.Add('');
    t_Arquivo.Add(Format('        public %sContext(IHostingEnvironment hostingEnvironment)', [pEntidade.NomeClasseAgregacao]));
    t_Arquivo.Add('        {');
    t_Arquivo.Add('            _hostingEnvironment = hostingEnvironment;');
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add('        protected override void OnModelCreating(ModelBuilder modelBuilder)');
    t_Arquivo.Add('        {');
    t_Arquivo.Add(Format('            modelBuilder.ApplyConfiguration(new %sMapping());', [pEntidade.NomeClasseSingular]));
    t_Arquivo.Add('            base.OnModelCreating(modelBuilder);');
    t_Arquivo.Add('        }');
    t_Arquivo.Add('');
    t_Arquivo.Add('        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)');
    t_Arquivo.Add('        {');
    t_Arquivo.Add('            var config = new ConfigurationBuilder().SetBasePath(_hostingEnvironment.ContentRootPath)');
    t_Arquivo.Add('                                                   .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)');
    t_Arquivo.Add('                                                   .AddJsonFile($"appsettings.{_hostingEnvironment.EnvironmentName}.json", optional: true)');
    t_Arquivo.Add('                                                   .Build();');
    t_Arquivo.Add('            optionsBuilder.UseSqlServer(config.GetConnectionString("ERP_CONNECTION_STRING"));');
    t_Arquivo.Add('        }');
    t_Arquivo.Add('    }');
    t_Arquivo.Add('}');

    Result := t_Arquivo.Text;
  finally
    FreeAndNil(t_Arquivo);
  end;
end;

function TInfraDataContextGenerator.getFileDirectory(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('ERP.Infra.Data\Context\%s\', [pEntidade.NomeModulo]);
end;

function TInfraDataContextGenerator.getFileName(const pEntidade: TEntidadeDTO): string;
begin
  Result := Format('%sContext.cs', [pEntidade.NomeClasseAgregacao]);
end;

end.
