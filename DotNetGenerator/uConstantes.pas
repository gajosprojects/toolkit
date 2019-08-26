unit uConstantes;

interface

const
  aColunasBoolean: Array [0 .. 3] of string = (
    'Selecionado',
    'ChavePrimaria',
    'ChaveUnica',
    'Requerido');

  cSim = 'S';
  cNao = 'N';

  cOrigemManual       = 0;
  cOrigemTabela       = 1;
  cOrigemInstrucaoSQL = 2;

  cToolkitConfig = 'toolkit_config';

  cModuloDotNetGenerator = 'DOTNETGENERATOR';

  cParametroOrigem = 'Origem';
  cParametroInstancia = 'Instancia';
  cParametroUsuario = 'Usuario';
  cParametroSenha = 'Senha';
  cParametroBaseDados = 'BaseDados';
  cParametroSchema = 'Schema';
  cParametroTabela = 'Tabela';
  cParametroUltimoXMLCarregado = 'UltimoXMLCarregado';
  cParametroDiretorioXML = 'DiretorioXML';
  cParametroDiretorioArquivosDotNet = 'DiretorioArquivosDotNet';

  cCampoId = 'id';
  cCampoDataCadastro = 'data_cadastro';
  cCampoDataUltimaModificacao = 'data_ultima_modificacao';
  cCampoExcluido = 'excluido';
  cCampoUsuarioId = 'usuario_id';

implementation

end.
