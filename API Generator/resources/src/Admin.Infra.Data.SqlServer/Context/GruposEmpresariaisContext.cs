using Admin.Domain.GruposEmpresariais;
using Admin.Infra.Data.SqlServer.Mappings;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace Admin.Infra.Data.SqlServer.Context
{
    public class GruposEmpresariaisContext : DbContext
    {
        public DbSet<GrupoEmpresarial> GruposEmpresariais { get; set; }
        public DbSet<Empresa> Empresas { get; set; }
        public DbSet<Estabelecimento> Estabelecimentos { get; set; }
        public DbSet<Cnae> Cnaes { get; set; }
        
        private readonly IHostingEnvironment _hostingEnviroment;

        public GruposEmpresariaisContext(IHostingEnvironment hostingEnviroment)
        {
            _hostingEnviroment = hostingEnviroment;
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfiguration(new GruposEmpresariaisMapping());
            modelBuilder.ApplyConfiguration(new EmpresasMapping());
            modelBuilder.ApplyConfiguration(new EstabelecimentosMapping());
            modelBuilder.ApplyConfiguration(new CnaesMapping());
            base.OnModelCreating(modelBuilder);
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            var config = new ConfigurationBuilder().SetBasePath(_hostingEnviroment.ContentRootPath).AddJsonFile("appsettings.json", optional: false, reloadOnChange: true).AddJsonFile($"appsettings.{_hostingEnviroment.EnvironmentName}.json", optional: true).Build();
            optionsBuilder.UseSqlServer(config.GetConnectionString("DefaultConnection"));
        }
    }
}