unit infra_data_context_generator;

interface

uses
  uEntidadeDTO;

type
  TInfraDataContextGenerator = class

  public
    procedure generate(var pEntidade: TEntidadeDTO);

  end;

implementation

uses
  System.Classes, System.SysUtils;

{ TInfraDataContextGenerator }

procedure TInfraDataContextGenerator.generate(var pEntidade: TEntidadeDTO);
var
  t_arquivo: TStringList;
  t_diretorio: string;
begin
  try
    t_diretorio := EmptyStr;

    t_arquivo := TStringList.Create();

    t_arquivo.Add('');

    t_arquivo.Add(Format('using ERP.%s.Domain.%s;', [pEntidade.NomeModulo, pEntidade.NomeClassePlural]));
    t_arquivo.Add(Format('using ERP.Infra.Data.Mappings.%s;', [pEntidade.NomeModulo]));
    t_arquivo.Add('using Microsoft.AspNetCore.Hosting;');
    t_arquivo.Add('using Microsoft.EntityFrameworkCore;');
    t_arquivo.Add('using Microsoft.Extensions.Configuration;');
    t_arquivo.Add('');
    t_arquivo.Add('namespace ERP.Infra.Data.Context');
    t_arquivo.Add('{');
    t_arquivo.Add(Format('    public class %sContext : DbContext', [pEntidade.NomeClassePlural]));
    t_arquivo.Add('    {');
    t_arquivo.Add(Format('        public DbSet<%s> %s { get; set; }', [pEntidade.NomeClasseSingular, pEntidade.NomeClassePlural]));
    t_arquivo.Add('        private readonly IHostingEnvironment _hostingEnvironment;');
    t_arquivo.Add('');
    t_arquivo.Add(Format('        public %sContext(IHostingEnvironment hostingEnvironment)', [pEntidade.NomeClassePlural]));
    t_arquivo.Add('        {');
    t_arquivo.Add('            _hostingEnvironment = hostingEnvironment;');
    t_arquivo.Add('        }');
    t_arquivo.Add('');
    t_arquivo.Add('        protected override void OnModelCreating(ModelBuilder modelBuilder)');
    t_arquivo.Add('        {');
    t_arquivo.Add(Format('            modelBuilder.ApplyConfiguration(new %sMapping());', [pEntidade.NomeClasseSingular]));
    t_arquivo.Add('            base.OnModelCreating(modelBuilder);');
    t_arquivo.Add('        }');
    t_arquivo.Add('');
    t_arquivo.Add('        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)');
    t_arquivo.Add('        {');
    t_arquivo.Add('            var config = new ConfigurationBuilder().SetBasePath(_hostingEnvironment.ContentRootPath)');
    t_arquivo.Add('                                                   .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)');
    t_arquivo.Add('                                                   .AddJsonFile($"appsettings.{_hostingEnvironment.EnvironmentName}.json", optional: true)');
    t_arquivo.Add('                                                   .Build();');
    t_arquivo.Add('            optionsBuilder.UseSqlServer(config.GetConnectionString("ERP_CONNECTION_STRING"));');
    t_arquivo.Add('        }');
    t_arquivo.Add('    }');
    t_arquivo.Add('}');

    t_diretorio := GetCurrentDir() + '\ERP.Infra.Data\Context';

    if (not DirectoryExists(t_diretorio)) then
    begin
      ForceDirectories(t_diretorio);
    end;

    t_arquivo.SaveToFile(Format('%s\%sContext.cs', [t_diretorio, pEntidade.NomeClassePlural]));
  finally
    FreeAndNil(t_arquivo);
  end;
end;

end.
