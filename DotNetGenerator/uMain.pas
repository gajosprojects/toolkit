unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ImgList, System.ImageList, Vcl.DBCtrls,
  Vcl.ExtCtrls, uEntidadeDTO, MidasLib, Vcl.ComCtrls, ZConnection,
  ZAbstractConnection, Vcl.Mask, ZAbstractRODataset, ZDataset, Datasnap.Provider;

type
  TMain = class(TForm)
    btnCarregar: TButton;
    btnConectarSQLServer: TButton;
    btnGerar: TButton;
    cdsAtributos: TClientDataSet;
    cdsAtributosChavePrimaria: TWideStringField;
    cdsAtributosChaveUnica: TWideStringField;
    cdsAtributosNome: TWideStringField;
    cdsAtributosNomeExibicao: TWideStringField;
    cdsAtributosRequerido: TWideStringField;
    cdsAtributosSelecionado: TWideStringField;
    cdsAtributosTipo: TWideStringField;
    cdsAux: TClientDataSet;
    cdsAuxChavePrimaria: TWideStringField;
    cdsAuxChaveUnica: TWideStringField;
    cdsAuxNome: TWideStringField;
    cdsAuxRequerido: TWideStringField;
    cdsAuxTipo: TWideStringField;
    cdsAuxTipoId: TSmallintField;
    cdsBaseDados: TClientDataSet;
    cdsBaseDadosNome: TWideStringField;
    cdsTabelas: TClientDataSet;
    cdsTabelasNome: TWideStringField;
    cmbBaseDados: TComboBox;
    cmbOrigemClasse: TComboBox;
    cmbSchema: TComboBox;
    cmbTabelas: TComboBox;
    conBD: TZConnection;
    dbgrdAtributos: TDBGrid;
    dbnvgrAtributos: TDBNavigator;
    dsAtributos: TDataSource;
    dsBaseDados: TDataSource;
    dspAux: TDataSetProvider;
    dspBaseDados: TDataSetProvider;
    dspTabelas: TDataSetProvider;
    dsTabelas: TDataSource;
    edtInstanciaSQLServer: TLabeledEdit;
    edtNomeModulo: TEdit;
    edtNomePlural: TEdit;
    edtNomeSingular: TEdit;
    edtSenhaSQLServer: TLabeledEdit;
    edtUsuarioSQLServer: TLabeledEdit;
    gbxAtributos: TGroupBox;
    gbxBaseDados: TGroupBox;
    gbxDadosConexaoSQLServer: TGroupBox;
    gbxGenerator: TGroupBox;
    gbxModulo: TGroupBox;
    gbxNomeEntidade: TGroupBox;
    gbxOrigem: TGroupBox;
    lblBaseDados: TLabel;
    lblNomePlural: TLabel;
    lblNomeSingular: TLabel;
    lblSchema: TLabel;
    lblTabela: TLabel;
    pgcGenerator: TPageControl;
    pnlEntidade: TPanel;
    qryAux: TZReadOnlyQuery;
    qryBaseDados: TZReadOnlyQuery;
    qryTabelas: TZReadOnlyQuery;
    tsConexao: TTabSheet;
    tsDadosClasse: TTabSheet;
    tsInstrucaoSQL: TTabSheet;
    procedure btnCarregarClick(Sender: TObject);
    procedure btnConectarSQLServerClick(Sender: TObject);
    procedure btnGerarClick(Sender: TObject);
    procedure cdsAtributosChavePrimariaGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure cdsAtributosRequeridoGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure cdsAtributosSelecionadoGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure cmbBaseDadosSelect(Sender: TObject);
    procedure cmbOrigemClasseChange(Sender: TObject);
    procedure cmbSchemaSelect(Sender: TObject);
    procedure cmbTabelasSelect(Sender: TObject);
    procedure dbgrdAtributosCellClick(Column: TColumn);
    procedure dbgrdAtributosColEnter(Sender: TObject);
    procedure dbgrdAtributosDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbnvgrAtributosClick(Sender: TObject; Button: TNavigateBtn);
    procedure edtInstanciaSQLServerChange(Sender: TObject);
    procedure edtSenhaSQLServerChange(Sender: TObject);
    procedure edtUsuarioSQLServerChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    procedure InicializarFormulario();

    //CONEXAO
    procedure AbrirConexao();
    procedure FecharConexao();

    //SQLSERVER
    procedure MontarConexaoSQLServer(pBaseDados: string = 'master');
    procedure ListarBaseDadosSQLServer();
    procedure ListarTabelasBaseDadosSQLServer();
    procedure ObterAtributosSQLServer();

    //PREENCHER COMPONNETES
    procedure PopularComboBaseDados();
    procedure PopularComboTabelasBaseDados();
    procedure PopularGridAtributos();
    procedure PopularNomeClasse();

    procedure HabilitarComboBaseDados();
    procedure HabilitarComboSchemas();
    procedure HabilitarComboTabelas();

    procedure HabilitarBotaoConectar();
    procedure HabilitarBotaoCarregar();

    //CONVERSAO
    function GetTipoAtributoDotNet(pTipoId: Integer; pTipo: string): string;
    function GetViewToEntidade(): TEntidadeDTO;

    //
    function IsColunaBoolean(pNomeColuna: string): Boolean;
    function IsValidacaoOk(): Boolean;

    //
    procedure GerarArquivos();

  public
    { Public declarations }
  end;

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

var
  Main: TMain;

implementation

{$R *.dfm}

uses
  uAtributoDTO, service_api_view_model_generator, service_api_controller_generator,
  infra_data_repository_generator, infra_data_mapping_generator, infra_data_context_generator,
  domain_entity_generator, domain_commands_generator, domain_events_generator,
  System.UITypes;

procedure TMain.btnCarregarClick(Sender: TObject);
var
  resposta: Boolean;
begin
  resposta := True;

  if (cdsAtributos.Active) then
  begin
    if cdsAtributos.RecordCount > 0 then
    begin
      resposta := (MessageDlg(Format('Os atributos existentes serão perdidos.%sDeseja continuar?', [sLineBreak]),
                              mtWarning, [mbYes,mbNo], 0, mbNo) = mrYes);
    end;
  end;

  if resposta then
  begin
    try
      if (cdsAtributos.Active) then
      begin
        cdsAtributos.EmptyDataSet();
      end;

      MontarConexaoSQLServer(cmbBaseDados.Text);

      ObterAtributosSQLServer();
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;

    pgcGenerator.ActivePage := tsDadosClasse;
  end;
end;

procedure TMain.btnConectarSQLServerClick(Sender: TObject);
begin
  try
    MontarConexaoSQLServer();
    ListarBaseDadosSQLServer();

    HabilitarComboBaseDados();
    HabilitarComboSchemas();
    HabilitarComboTabelas();
    HabilitarBotaoCarregar();
//    cmbSchema.Enabled    := False;
//    cmbTabelas.Enabled   := False
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TMain.btnGerarClick(Sender: TObject);
begin
  if IsValidacaoOk() then
    GerarArquivos();
end;

procedure TMain.ObterAtributosSQLServer();
var
  xml_data_aux: WideString;
begin
  if (cdsAux.Active) then
    cdsAux.Close();

  qryAux.SQL.Clear();
  qryAux.SQL.Add('declare @Colunas table(table_qualifier sysname,');
  qryAux.SQL.Add('                       table_owner sysname,');
  qryAux.SQL.Add('                       table_name sysname,');
  qryAux.SQL.Add('                       column_name sysname,');
  qryAux.SQL.Add('                       data_type smallint,');
  qryAux.SQL.Add('                       type_name sysname,');
  qryAux.SQL.Add('                       precision int,');
  qryAux.SQL.Add('                       length int,');
  qryAux.SQL.Add('                       escala smallint,');
  qryAux.SQL.Add('                       radix smallint,');
  qryAux.SQL.Add('                       nullable smallint,');
  qryAux.SQL.Add('                       remarks varchar(254),');
  qryAux.SQL.Add('                       column_def nvarchar(4000),');
  qryAux.SQL.Add('                       sql_data_type smallint,');
  qryAux.SQL.Add('                       sql_datetime_sub smallint,');
  qryAux.SQL.Add('                       char_octet_length	int,');
  qryAux.SQL.Add('                       ordinal_position int,');
  qryAux.SQL.Add('                       is_nullable varchar(254),');
  qryAux.SQL.Add('                       ss_data_type tinyint)');
  qryAux.SQL.Add('insert into @Colunas(table_qualifier,');
  qryAux.SQL.Add('					 table_owner,');
  qryAux.SQL.Add('					 table_name,');
  qryAux.SQL.Add('					 column_name,');
  qryAux.SQL.Add('					 data_type,');
  qryAux.SQL.Add('					 type_name,');
  qryAux.SQL.Add('					 precision,');
  qryAux.SQL.Add('					 length,');
  qryAux.SQL.Add('					 escala,');
  qryAux.SQL.Add('					 radix,');
  qryAux.SQL.Add('					 nullable,');
  qryAux.SQL.Add('					 remarks,');
  qryAux.SQL.Add('					 column_def,');
  qryAux.SQL.Add('					 sql_data_type,');
  qryAux.SQL.Add('					 sql_datetime_sub,');
  qryAux.SQL.Add('					 char_octet_length,');
  qryAux.SQL.Add('					 ordinal_position,');
  qryAux.SQL.Add('					 is_nullable,');
  qryAux.SQL.Add('					 ss_data_type)');
  qryAux.SQL.Add(Format('exec sp_columns %s;', [QuotedStr(cmbTabelas.Text)]));
  qryAux.SQL.Add('');
  qryAux.SQL.Add('declare @ColunasPk table(column_name sysname)');
  qryAux.SQL.Add('insert into @ColunasPk (column_name)');
  qryAux.SQL.Add('select ccu.column_name');
  qryAux.SQL.Add('from information_schema.table_constraints tc');
  qryAux.SQL.Add('inner join information_schema.constraint_column_usage ccu on tc.constraint_name = ccu.constraint_name');
  qryAux.SQL.Add(Format('where tc.constraint_type = %s', [QuotedStr('Primary Key')]));
  qryAux.SQL.Add(Format('  and tc.table_name = %s;', [QuotedStr(cmbTabelas.Text)]));
  qryAux.SQL.Add('');
  qryAux.SQL.Add('declare @ColunasUk table(column_name sysname)');
  qryAux.SQL.Add('insert into @ColunasUk (column_name)');
  qryAux.SQL.Add('select ccu.column_name');
  qryAux.SQL.Add('from information_schema.table_constraints tc');
  qryAux.SQL.Add('inner join information_schema.constraint_column_usage ccu on tc.constraint_name = ccu.constraint_name');
  qryAux.SQL.Add(Format('where tc.constraint_type = %s', [QuotedStr('Unique')]));
  qryAux.SQL.Add(Format('  and tc.table_name = %s;', [QuotedStr(cmbTabelas.Text)]));
  qryAux.SQL.Add('');
  qryAux.SQL.Add('select');
  qryAux.SQL.Add('	col.column_name as nome,');
  qryAux.SQL.Add('	col.data_type as tipoid,');
  qryAux.SQL.Add('	col.type_name as tipo,');
  qryAux.SQL.Add(Format('	 (case len(coalesce(colpk.column_name, %s)) when 0 then cast(%s as char(1)) else cast(%s as char(1)) end) as chaveprimaria,', [QuotedStr(EmptyStr), QuotedStr(cNao), QuotedStr(cSim)]));
  qryAux.SQL.Add(Format('  (case len(coalesce(coluk.column_name, %s)) when 0 then cast(%s as char(1)) else cast(%s as char(1)) end) as chaveunica,', [QuotedStr(EmptyStr), QuotedStr(cNao), QuotedStr(cSim)]));
  qryAux.SQL.Add(Format('	 (case col.is_nullable when %s then (case len(coalesce(colpk.column_name, %s)) when 0 then cast(%s as char(1)) else cast(%s as char(1)) end) else cast(%s as char(1)) end) as requerido', [QuotedStr('NO'), QuotedStr(EmptyStr), QuotedStr(cSim), QuotedStr(cNao), QuotedStr(cNao)]));
  qryAux.SQL.Add('from @Colunas col');
  qryAux.SQL.Add('left join @ColunasPK colpk on colpk.column_name = col.column_name');
  qryAux.SQL.Add('left join @ColunasUK coluk on coluk.column_name = col.column_name');

  try
    try
      xml_data_aux := EmptyWideStr;

      AbrirConexao();

      cdsAux.Open();

      xml_data_aux := cdsAux.XMLData
    except
      on E: Exception do

    end;
  finally
    cdsAux.Close();

    FecharConexao();

    if (not SameText(xml_data_aux, EmptyWideStr)) then
    begin
      cdsAux.XMLData := xml_data_aux;

      PopularGridAtributos();
      PopularNomeClasse();
    end;
  end;
end;

procedure TMain.cdsAtributosChavePrimariaGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := EmptyStr;
end;

procedure TMain.cdsAtributosRequeridoGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := EmptyStr;
end;

procedure TMain.cdsAtributosSelecionadoGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := EmptyStr;
end;

procedure TMain.cmbBaseDadosSelect(Sender: TObject);
begin
  MontarConexaoSQLServer(cmbBaseDados.Text);

  ListarTabelasBaseDadosSQLServer();

//  cmbSchema.Enabled    := (cmbOrigemClasse.ItemIndex = cOrigemTabela); e banco Postgres
  cmbTabelas.Enabled   := (cmbOrigemClasse.ItemIndex = cOrigemTabela);

  HabilitarComboSchemas();
  HabilitarComboTabelas();
  HabilitarBotaoCarregar();
end;

procedure TMain.cmbOrigemClasseChange(Sender: TObject);
var
  resposta: Boolean;
begin
  edtInstanciaSQLServer.Clear();
  edtUsuarioSQLServer.Clear();
  edtSenhaSQLServer.Clear();

  cmbBaseDados.Clear();
  cmbSchema.Clear();
  cmbTabelas.Clear();

  cmbBaseDados.Enabled := False;
  cmbSchema.Enabled    := False;
  cmbTabelas.Enabled   := False;

  HabilitarBotaoConectar();
  HabilitarBotaoCarregar();

  case cmbOrigemClasse.ItemIndex of

    cOrigemManual:
    begin
      tsConexao.TabVisible      := False;
      tsInstrucaoSQL.TabVisible := False;
      tsDadosClasse.TabVisible  := True;

      pgcGenerator.ActivePage := tsDadosClasse;

      edtNomeSingular.Text := EmptyStr;
      edtNomePlural.Text   := EmptyStr;

      if (cdsAtributos.Active) then
      begin
        resposta := True;

        if (cdsAtributos.RecordCount > 0) then
        begin
          resposta := (MessageDlg(Format('Os atributos existentes serão perdidos.%sDeseja continuar?', [sLineBreak]),
                                  mtWarning, [mbYes,mbNo], 0, mbNo) = mrYes);
        end;

        if resposta then
        begin
          cdsAtributos.EmptyDataSet();
        end;
      end
      else
      begin
        cdsAtributos.Close();
        cdsAtributos.CreateDataSet();
        cdsAtributos.Open();
      end;
    end;

    cOrigemTabela:
    begin
      tsConexao.TabVisible      := True;
      tsInstrucaoSQL.TabVisible := False;
      tsDadosClasse.TabVisible  := True;

      pgcGenerator.ActivePage := tsConexao;

      resposta := True;

      if (cdsAtributos.RecordCount > 0) then
      begin
        resposta := (MessageDlg(Format('Os atributos existentes serão perdidos.%sDeseja continuar?', [sLineBreak]),
                                mtWarning, [mbYes,mbNo], 0, mbNo) = mrYes);
      end;

      if resposta then
      begin
        cdsAtributos.EmptyDataSet();
        cdsAtributos.Close();
      end;
    end;

//    cOrigemInstrucaoSQL:
//    begin
//      btnCarregar.Caption := 'Avançar';
//
//      tsConexao.TabVisible      := True;
//      tsInstrucaoSQL.TabVisible := True;
//      tsDadosClasse.TabVisible  := True;
//
//      pgcGenerator.ActivePage := tsConexao;
//
//      resposta := True;
//
//      if (cdsAtributos.RecordCount > 0) then
//      begin
//        resposta := (MessageDlg(Format('Os atributos existentes serão perdidos.%sDeseja continuar?', [sLineBreak]),
//                                mtWarning, [mbYes,mbNo], 0, mbNo) = mrYes);
//      end;
//
//      if resposta then
//      begin
//        cdsAtributos.EmptyDataSet();
//        cdsAtributos.Close();
//      end;
//    end;
  else
    begin
      //colocar tudo readonly
    end;
  end;
end;

procedure TMain.cmbSchemaSelect(Sender: TObject);
begin
  HabilitarComboSchemas();
  HabilitarComboTabelas();
  HabilitarBotaoCarregar();
end;

procedure TMain.cmbTabelasSelect(Sender: TObject);
begin
  HabilitarBotaoCarregar();
end;

procedure TMain.AbrirConexao();
begin
  conBD.Connect();
end;

procedure TMain.MontarConexaoSQLServer(pBaseDados: string);
begin
  FecharConexao();

  conBD.Protocol := 'ado';
  conBD.Database := Format('Provider=SQLOLEDB.1;Persist Security Info=True;Data Source=%s;Initial Catalog=%s;User ID=%s;Password=%s',
                           [edtInstanciaSQLServer.Text, pBaseDados, edtUsuarioSQLServer.Text, edtSenhaSQLServer.Text]);
  try
    try
      AbrirConexao();

      if (not conBD.Connected) then
        ShowMessage(Format('Não foi possível conectar ao banco de dados [%s]', [conBD.Database]));
    except
      on E: Exception do
        raise Exception.CreateFmt('Não foi possível conectar ao banco de dados (%s)%s[%s]',
                                  [conBD.Database, sLineBreak, E.Message]);
    end;
  finally
    FecharConexao();
  end;

end;

procedure TMain.dbgrdAtributosCellClick(Column: TColumn);
var
  sValorColuna: string;
  sNomeColuna: string;
begin
  sNomeColuna := Column.FieldName;

  if (IsColunaBoolean(sNomeColuna)) then
  begin
    if SameText(cdsAtributos.FieldByName(sNomeColuna).AsString, cSim) then
      sValorColuna := cNao
    else
      sValorColuna := cSim;

    // edita o DataSet, alterna o status e grava os dados
    cdsAtributos.Edit();
    cdsAtributos.FieldByName(sNomeColuna).AsString := sValorColuna;
    cdsAtributos.Post();
  end;
end;

procedure TMain.dbgrdAtributosColEnter(Sender: TObject);
var
  sNomeColuna: string;
begin
  sNomeColuna := dbgrdAtributos.SelectedField.FieldName;
  // controla a edição da célula
  if (IsColunaBoolean(sNomeColuna)) then
    dbgrdAtributos.Options := dbgrdAtributos.Options - [dgEditing]
  else
    dbgrdAtributos.Options := dbgrdAtributos.Options + [dgEditing];
end;

procedure TMain.dbgrdAtributosDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  nMarcar: word;
  oRetangulo: TRect;
  sNomeColuna: string;
begin
  // verifica se o registro está inativo
  if (cdsAtributos.FieldByName('Selecionado').AsString = 'N') then
  begin
    dbgrdAtributos.Canvas.Font.Style := [fsStrikeOut];

    // pinta a linha
    dbgrdAtributos.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;

  sNomeColuna := Column.FieldName;

  if (IsColunaBoolean(sNomeColuna)) then
  begin
    dbgrdAtributos.Canvas.FillRect(Rect);

    if SameText(Column.Field.AsString, cSim) then
      nMarcar := DFCS_CHECKED
    else
      nMarcar := DFCS_BUTTONCHECK;

    // ajusta o tamanho do CheckBox
    oRetangulo := Rect;
    InflateRect(oRetangulo, -2, -2);

    // desenha o CheckBox na célula conforme a condição acima
    DrawFrameControl(dbgrdAtributos.Canvas.Handle, oRetangulo, DFC_BUTTON, nMarcar);
  end;
end;

procedure TMain.dbnvgrAtributosClick(Sender: TObject; Button: TNavigateBtn);
begin
  if (Button = nbInsert) then
  begin
    cdsAtributos.Append();
    cdsAtributos.FieldByName('Selecionado').AsString := cSim;
    cdsAtributos.FieldByName('ChavePrimaria').AsString := cNao;
    cdsAtributos.FieldByName('ChaveUnica').AsString := cNao;
    cdsAtributos.FieldByName('Requerido').AsString := cNao;
    cdsAtributos.Post;
    dbgrdAtributos.SelectedIndex := 0;
  end
  else if (Button = nbEdit) then
  begin
    cdsAtributos.Edit();
    dbgrdAtributos.SelectedIndex := 0;
  end;
end;

procedure TMain.edtInstanciaSQLServerChange(Sender: TObject);
begin
  HabilitarBotaoConectar();
end;

procedure TMain.edtSenhaSQLServerChange(Sender: TObject);
begin
  HabilitarBotaoConectar();
end;

procedure TMain.edtUsuarioSQLServerChange(Sender: TObject);
begin
  HabilitarBotaoConectar();
end;

procedure TMain.FecharConexao();
begin
  if (conBD.Connected) then
    conBD.Disconnect();
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  InicializarFormulario();
end;

procedure TMain.GerarArquivos();
var
  Entidade: TEntidadeDTO;
  ServiceApiViewModelGenerator: TServiceApiViewModelGenerator;
  ServiceApiControllerGenerator: TServiceApiControllerGenerator;
  InfraDataRepositoryGenerator: TInfraDataRepositoryGenerator;
  InfraDataMapppingGenerator: TInfraDataMappingGenerator;
  InfraDataContextGenerator: TInfraDataContextGenerator;
  DomainEntityGenerator: TDomainEntityGenerator;
  DomainCommandsGenerator: TDomainCommandsGenerator;
  DomainEventsGenerator: TDomainEventsGenerator;
begin
  try
    //preenchimento do objeto entidade e seus atributos
    Entidade := GetViewToEntidade();

    //view_model
    ServiceApiViewModelGenerator := TServiceApiViewModelGenerator.Create();
    ServiceApiViewModelGenerator.generate(Entidade);

    //controller
    ServiceApiControllerGenerator := TServiceApiControllerGenerator.Create();
    ServiceApiControllerGenerator.generate(Entidade);

    //repository
    InfraDataRepositoryGenerator := TInfraDataRepositoryGenerator.Create();
    InfraDataRepositoryGenerator.generate(Entidade);

    //mapping
    InfraDataMapppingGenerator := TInfraDataMappingGenerator.Create();
    InfraDataMapppingGenerator.generate(Entidade);

    //context
    InfraDataContextGenerator := TInfraDataContextGenerator.Create();
    InfraDataContextGenerator.generate(Entidade);

    //entity
    DomainEntityGenerator := TDomainEntityGenerator.Create();
    DomainEntityGenerator.generate(Entidade);

    //commands
    DomainCommandsGenerator := TDomainCommandsGenerator.Create();
    DomainCommandsGenerator.generateBaseCommand(Entidade);
    DomainCommandsGenerator.generateCommandHandler(Entidade);
    DomainCommandsGenerator.generateSaveCommand(Entidade);
    DomainCommandsGenerator.generateUpdateCommand(Entidade);
    DomainCommandsGenerator.generateDeleteCommand(Entidade);

    //events
    DomainEventsGenerator := TDomainEventsGenerator.Create();
    DomainEventsGenerator.generateBaseEvent(Entidade);
    DomainEventsGenerator.generateEventHandler(Entidade);
    DomainEventsGenerator.generateSavedEvent(Entidade);
    DomainEventsGenerator.generateUpdatedEvent(Entidade);
    DomainEventsGenerator.generateDeletedEvent(Entidade);

    ShowMessage('Arquivos gerados com sucesso!');
  except
    on E: Exception do
      ShowMessage(Format('Ocorreu um erro ao gerar os arquivos: [%s]', [E.Message]));
  end;

end;

function TMain.GetTipoAtributoDotNet(pTipoId: Integer; pTipo: string): string;
begin
  case pTipoId of
    //12 - varchar
    //1  - char
    //-1 - text
    //-8 - nchar
    12, 1, -1, -8: Result := 'String';

    //11 - smalldatetime, datetime
    11: Result := 'DateTime';

    //7 - real
    //6 - float,
    //3 - decimal, money, smallmoney, decimal identity, numeric() identity,
    //2 - numeric() identity
    7, 6, 3, 2: Result := 'Double';

  else
    Result := EmptyStr;
  end;


{
sql_variant	-150
uniqueidentifier	-11
ntext	-10
xml	-10
nvarchar	-9
sysname	-9
date	-9
time	-9
datetime2	-9
datetimeoffset	-9
	-8
bit	-7
tinyint	-6
tinyint identity	-6
bigint	-5
bigint identity	-5
image	-4
varbinary	-3
binary	-2
timestamp	-2
	-1
	1
	2
	2
	3
	3
	3
	3
int	4
int identity	4
smallint	5
smallint identity	5
	6
	7
	11
	11
	12
}
end;

function TMain.GetViewToEntidade(): TEntidadeDTO;
var
  Atributo: TAtributoDTO;
begin
  //preenchimento do objeto entidade e seus atributos
  Result                    := TEntidadeDTO.Create();
  Result.NomeModulo         := edtNomeModulo.Text;
  Result.NomeClasseSingular := edtNomeSingular.Text;
  Result.NomeClassePlural   := edtNomePlural.Text;

  //loop nos atributos
  try
    cdsAtributos.DisableControls();

    cdsAtributos.First();

    while (not cdsAtributos.Eof) do
    begin
      if (SameText(cdsAtributos.FieldByName('Selecionado').AsString, cSim)) then
      begin
        Atributo := TAtributoDTO.Create();

        Atributo.Nome          := cdsAtributos.FieldByName('Nome').AsString;
        Atributo.NomeExibicao  := cdsAtributos.FieldByName('NomeExibicao').AsString;
        Atributo.Tipo          := cdsAtributos.FieldByName('Tipo').AsString;
        Atributo.ChavePrimaria := SameText(cdsAtributos.FieldByName('ChavePrimaria').AsString, cSim);
        Atributo.ChaveUnica    := SameText(cdsAtributos.FieldByName('ChaveUnica').AsString, cSim);
        Atributo.Requerido     := SameText(cdsAtributos.FieldByName('Requerido').AsString, cSim);

        Result.Atributos.Add(Atributo);
      end;

      cdsAtributos.Next;
    end;

  finally
    cdsAtributos.First();
    cdsAtributos.EnableControls();
  end;
end;

procedure TMain.HabilitarBotaoCarregar();
begin
  case cmbOrigemClasse.ItemIndex of
    cOrigemTabela:
    begin
      if (cmbBaseDados.ItemIndex >= 0) and
         (cmbTabelas.ItemIndex >= 0) {and
         base de dados sqlserver} then
      begin
        btnCarregar.Enabled := True;
      end
      else if (cmbBaseDados.ItemIndex >= 0) and
              (cmbSchema.ItemIndex >= 0) and
              (cmbTabelas.ItemIndex >= 0) {and
              base de dados postgres} then
      begin
        btnCarregar.Enabled := True;
      end
      else
      begin
        btnCarregar.Enabled := False;
      end;
    end;

    cOrigemInstrucaoSQL:
    begin
      if (cmbBaseDados.ItemIndex >= 0) then
      begin
        btnCarregar.Enabled := True;
      end
      else
      begin
        btnCarregar.Enabled := False;
      end;
    end;
  else
    begin
      btnCarregar.Enabled := False;
    end;
  end;
end;

procedure TMain.HabilitarBotaoConectar();
begin
  case cmbOrigemClasse.ItemIndex of
    cOrigemTabela, cOrigemInstrucaoSQL:
    begin
      if (not SameText(Trim(edtInstanciaSQLServer.Text), EmptyStr)) and
         (not SameText(Trim(edtUsuarioSQLServer.Text), EmptyStr)) and
         (not SameText(Trim(edtSenhaSQLServer.Text), EmptyStr)) {and
         base de dados sqlserver} then
      begin
        btnConectarSQLServer.Enabled := True;
      end
//      else if (not SameText(Trim(edtHostPostgreSQL.Text), EmptyStr)) and
//              (not SameText(Trim(edtPortaPostgreSQL.Text), EmptyStr)) and
//              (not SameText(Trim(edtUsuarioPostgresSQL.Text), EmptyStr)) and
//              (not SameText(Trim(edtSenhaPostgreSQLSQL.Text), EmptyStr)) {and
//              base de dados postgres} then
//      begin
//        btnConectarPostgreSQL.Enabled := True;
//      end
      else
      begin
        btnConectarSQLServer.Enabled := False;
//        btnConectarPostgreSQL.Enabled := False;
      end;
    end;
  else
    begin
      btnConectarSQLServer.Enabled := False;
//      btnConectarPostgreSQL.Enabled := False;
    end;
  end;
end;

procedure TMain.HabilitarComboBaseDados();
begin
  cmbBaseDados.Enabled := (cmbOrigemClasse.ItemIndex <> cOrigemManual);
end;

procedure TMain.HabilitarComboSchemas();
begin
  case cmbOrigemClasse.ItemIndex of
    cOrigemTabela:
    begin
//      if (cmbBaseDados.ItemIndex >= 0) {and
//         base de dados postgresql} then
//      begin
//        cmbSchema.Enabled := True;
//      end
//      else
//      begin
        cmbSchema.Enabled := False;
//      end;
    end;
  else
    begin
      cmbSchema.Enabled := False;
    end;
  end;
end;

procedure TMain.HabilitarComboTabelas();
begin
  case cmbOrigemClasse.ItemIndex of
    cOrigemTabela:
    begin
      if (cmbBaseDados.ItemIndex >= 0) {and
         base de dados sqlserver} then
      begin
        cmbTabelas.Enabled := True;
      end
      else {if (cmbSchema.ItemIndex >= 0) and
         base de dados postgresql then
      begin
        cmbTabelas.Enabled := True;
      end
      else}
      begin
        cmbTabelas.Enabled := False;
      end;
    end;
  else
    begin
      cmbTabelas.Enabled := False;
    end;
  end;
end;

procedure TMain.InicializarFormulario();
begin
  cmbOrigemClasse.ItemIndex := cOrigemManual;

  cmbOrigemClasseChange(Self);
end;

function TMain.IsColunaBoolean(pNomeColuna: string): Boolean;
var
  t_indice: Integer;
begin
  Result := False;

  for t_Indice := Low(aColunasBoolean) to High(aColunasBoolean) do
  begin
    Result := SameText(AnsiUpperCase(pNomeColuna), AnsiUpperCase(aColunasBoolean[t_Indice]));

    if (Result) then
      Break;
  end;
end;

function TMain.IsValidacaoOk(): Boolean;
var
  indice: Integer;
  selecionados: Integer;
  pks: Integer;
begin
  Result := False;

  if SameText(Trim(edtNomeModulo.Text), EmptyStr) then
  begin
    ShowMessage('Nome do módulo é obrigatório');
    edtNomeModulo.SetFocus();
    Exit
  end;

  if SameText(Trim(edtNomeSingular.Text), EmptyStr) then
  begin
    ShowMessage('Nome da classe no singular é obrigatório');
    edtNomeSingular.SetFocus();
    Exit
  end;

  if SameText(Trim(edtNomePlural.Text), EmptyStr) then
  begin
    ShowMessage('Nome da classe no plural é obrigatório');
    edtNomePlural.SetFocus();
    Exit
  end;

  if (cdsAtributos.RecordCount = 0) then
  begin
    ShowMessage('Ao menos um atributo é obrigatório');
    dbgrdAtributos.SetFocus();
    Exit
  end;

  selecionados := 0;
  pks := 0;

  for indice := 0 to cdsAtributos.RecordCount -1 do
  begin
    if SameText(cdsAtributos.FieldByName('Selecionado').AsString, cSim) then
      Inc(selecionados);

    if SameText(cdsAtributos.FieldByName('ChavePrimaria').AsString, cSim) then
      Inc(pks);
  end;

  if (selecionados = 0) then
  begin
    ShowMessage('Ao menos um atributo deve ser selecionado');
    dbgrdAtributos.SetFocus();
    Exit
  end;

  if (pks = 0) then
  begin
    ShowMessage('Ao menos um atributo deve ser chave primária');
    dbgrdAtributos.SetFocus();
    Exit
  end;

  //verificar se os tipos informados sao validos

  Result := True;
end;

procedure TMain.ListarBaseDadosSQLServer();
var
  xml_data_aux: WideString;
begin
  if (cdsBaseDados.Active) then
    cdsBaseDados.Close();

  qryBaseDados.SQL.Clear();
  qryBaseDados.SQL.Add('SELECT NAME AS NOME');
  qryBaseDados.SQL.Add('FROM SYS.DATABASES');
  qryBaseDados.SQL.Add('ORDER BY NAME');

  try
    try
      xml_data_aux := EmptyWideStr;

      AbrirConexao();

      cdsBaseDados.Open();

      xml_data_aux := cdsBaseDados.XMLData
    except
      on E: Exception do

    end;
  finally
    cdsBaseDados.Close();

    FecharConexao();

    if (not SameText(xml_data_aux, EmptyWideStr)) then
    begin
      cdsBaseDados.XMLData := xml_data_aux;

      PopularComboBaseDados();
    end;
  end;
end;

procedure TMain.ListarTabelasBaseDadosSQLServer();
var
  xml_data_aux: WideString;
begin
  if (cdsTabelas.Active) then
    cdsTabelas.Close();

  qryTabelas.SQL.Clear();

  qryTabelas.SQL.Add('SELECT TABLE_NAME AS NOME');
  qryTabelas.SQL.Add('FROM INFORMATION_SCHEMA.TABLES');
  qryTabelas.SQL.Add('WHERE TABLE_TYPE = ' + QuotedStr('BASE TABLE'));
  qryTabelas.SQL.Add('  AND Objectproperty(Object_id(Table_name), ' + QuotedStr('IsMsShipped') + ') = 0');
  qryTabelas.SQL.Add('ORDER BY TABLE_NAME');

  try
    try
      xml_data_aux := EmptyWideStr;

      AbrirConexao();

      cdsTabelas.Open();

      xml_data_aux := cdsTabelas.XMLData
    except
      on E: Exception do

    end;
  finally
    cdsTabelas.Close();

    FecharConexao();

    if (not SameText(xml_data_aux, EmptyWideStr)) then
    begin
      cdsTabelas.XMLData := xml_data_aux;

      PopularComboTabelasBaseDados();
    end;
  end;
end;

procedure TMain.PopularComboBaseDados();
begin
  cmbBaseDados.Items.Clear();

  cdsBaseDados.First();

  while not cdsBaseDados.Eof do
  begin
    cmbBaseDados.Items.Add(cdsBaseDados.FieldByName('NOME').AsString);

    cdsBaseDados.Next();
  end;
end;

procedure TMain.PopularComboTabelasBaseDados();
begin
  cmbTabelas.Items.Clear();

  cdsTabelas.First();

  while not cdsTabelas.Eof do
  begin
    cmbTabelas.Items.Add(cdsTabelas.FieldByName('NOME').AsString);

    cdsTabelas.Next();
  end;
end;

procedure TMain.PopularGridAtributos();
var
  nome_aux: string;
begin
  try
    cdsAtributos.Close();
    cdsAtributos.Open();

    cdsAtributos.DisableControls();

    cdsAux.First;

    while not cdsAux.Eof do
    begin
      cdsAtributos.Append();

      nome_aux := UpperCase(Copy(cdsAux.FieldByName('Nome').AsString, 1, 1)) + LowerCase(Copy(cdsAux.FieldByName('Nome').AsString, 2, Length(cdsAux.FieldByName('Nome').AsString)));

      cdsAtributos.FieldByName('Selecionado').AsString := cSim;
      cdsAtributos.FieldByName('Nome').AsString := nome_aux;
      cdsAtributos.FieldByName('NomeExibicao').AsString := nome_aux;
      cdsAtributos.FieldByName('Tipo').AsString := GetTipoAtributoDotNet(cdsAux.FieldByName('TipoId').AsInteger, cdsAux.FieldByName('Tipo').AsString);
      cdsAtributos.FieldByName('ChavePrimaria').AsString := cdsAux.FieldByName('ChavePrimaria').AsString;
      cdsAtributos.FieldByName('ChaveUnica').AsString := cdsAux.FieldByName('ChaveUnica').AsString;
      cdsAtributos.FieldByName('Requerido').AsString := cdsAux.FieldByName('Requerido').AsString;

      cdsAtributos.Post();

      cdsAux.Next();
    end;
  finally
    cdsAtributos.EnableControls();
  end;
end;

procedure TMain.PopularNomeClasse();
var
  nome_aux: string;
begin
  nome_aux := UpperCase(Copy(cmbTabelas.Text, 1, 1)) + LowerCase(Copy(cmbTabelas.Text, 2, Length(cmbTabelas.Text)));

  edtNomeSingular.Text := nome_aux;
end;

end.
