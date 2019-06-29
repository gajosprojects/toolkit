unit uDotNetGeneratorSourceCodeFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ImgList, System.ImageList, Vcl.DBCtrls,
  Vcl.ExtCtrls, uEntidadeDTO, MidasLib, Vcl.ComCtrls, ZConnection,
  ZAbstractConnection, Vcl.Mask, ZAbstractRODataset, ZDataset, Datasnap.Provider,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxCustomData,
  cxStyles, cxTL, cxTLdxBarBuiltInMenu,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxSkinsCore,
  cxInplaceContainer, cxTLData, cxDBTL, cxMaskEdit, cxCheckBox, cxDropDownEdit;

type
  TDotNetGeneratorSourceCodeFrame = class(TFrame)
    gbxOrigem: TGroupBox;
    cmbOrigemClasse: TComboBox;
    btnGerar: TButton;
    gbxGenerator: TGroupBox;
    pgcGenerator: TPageControl;
    tsConexao: TTabSheet;
    gbxDadosConexaoSQLServer: TGroupBox;
    edtInstanciaSQLServer: TLabeledEdit;
    edtUsuarioSQLServer: TLabeledEdit;
    edtSenhaSQLServer: TLabeledEdit;
    btnConectarSQLServer: TButton;
    gbxBaseDados: TGroupBox;
    lblBaseDados: TLabel;
    lblSchema: TLabel;
    lblTabela: TLabel;
    cmbBaseDados: TComboBox;
    cmbTabelas: TComboBox;
    cmbSchema: TComboBox;
    btnCarregar: TButton;
    tsInstrucaoSQL: TTabSheet;
    tsDadosClasse: TTabSheet;
    pnlEntidade: TPanel;
    gbxNomeEntidade: TGroupBox;
    lblNomeSingular: TLabel;
    lblNomePlural: TLabel;
    edtNomeSingular: TEdit;
    edtNomePlural: TEdit;
    gbxModulo: TGroupBox;
    edtNomeModulo: TEdit;
    gbxAtributos: TGroupBox;
    tlAtributos: TcxDBTreeList;
    tlAtributosSelecionado: TcxDBTreeListColumn;
    tlAtributosNome: TcxDBTreeListColumn;
    tlAtributosNomeExibicao: TcxDBTreeListColumn;
    tlAtributosTipo: TcxDBTreeListColumn;
    tlAtributosChavePrimaria: TcxDBTreeListColumn;
    tlAtributosChaveUnica: TcxDBTreeListColumn;
    tlAtributosRequerido: TcxDBTreeListColumn;

    procedure btnCarregarClick(Sender: TObject);
    procedure btnConectarSQLServerClick(Sender: TObject);
    procedure btnGerarClick(Sender: TObject);
    procedure cmbBaseDadosSelect(Sender: TObject);
    procedure cmbOrigemClasseChange(Sender: TObject);
    procedure cmbSchemaSelect(Sender: TObject);
    procedure cmbTabelasSelect(Sender: TObject);
    procedure edtInstanciaSQLServerChange(Sender: TObject);
    procedure edtSenhaSQLServerChange(Sender: TObject);
    procedure edtUsuarioSQLServerChange(Sender: TObject);
    procedure tlAtributosNavigatorButtonsButtonClick(Sender: TObject; AButtonIndex: Integer; var ADone: Boolean);

  private
    FNextIdAtributo: Integer;

    FClientDataSetAtributos: TClientDataSet;
    FDataSourceAtributos: TDataSource;

    { Private declarations }
    procedure InicializarFormulario();

    //SQLSERVER
    procedure ListarBaseDadosSQLServer();
    procedure ListarTabelasBaseDadosSQLServer();
    procedure ObterAtributosSQLServer();

    //PREENCHER COMPONNETES
    procedure PopularComboBaseDados(pXMLData: WideString);
    procedure PopularComboTabelasBaseDados(pXMLData: WideString);
    procedure PopularGridAtributos(pXMLData: WideString);
    procedure PopularNomeClasse();

    //HABILITAR COMPONENTES
    procedure HabilitarComboBaseDados();
    procedure HabilitarComboSchemas();
    procedure HabilitarComboTabelas();

    procedure HabilitarBotaoConectar();
    procedure HabilitarBotaoCarregar();

    //CONVERSAO
    function GetTipoAtributoDotNetFromSQLServer(pNomeTipo: string): string;
    function GetViewToEntidade(): TEntidadeDTO;

    //VALIDACOES
    function IsColunaBoolean(pNomeColuna: string): Boolean;
    function IsValidacaoOk(): Boolean;

    //
    procedure GerarArquivos();

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

  end;

implementation

uses
  uAtributoDTO, service_api_view_model_generator, service_api_controller_generator,
  infra_data_repository_generator, infra_data_mapping_generator, infra_data_context_generator,
  domain_entity_generator, domain_commands_generator, domain_events_generator, domain_repositories_generator,
  System.UITypes, uMainDataModule, uConstantes, cxNavigator;

{$R *.dfm}

{ TDotNetGeneratorSourceCodeFrame }

constructor TDotNetGeneratorSourceCodeFrame.Create(AOwner: TComponent);
begin
  inherited;

  FClientDataSetAtributos := TClientDataSet.Create(nil);
  FDataSourceAtributos := TDataSource.Create(nil);

  InicializarFormulario();
end;

procedure TDotNetGeneratorSourceCodeFrame.InicializarFormulario();
begin
  FDataSourceAtributos.DataSet := FClientDataSetAtributos;

  cmbOrigemClasse.ItemIndex := cOrigemManual;

  tlAtributos.DataController.DataSource := FDataSourceAtributos;
  tlAtributos.DataController.KeyField := 'Id';
  tlAtributos.DataController.ParentField := 'ParentId';

  FNextIdAtributo := 1;

  cmbOrigemClasseChange(nil);
end;

procedure TDotNetGeneratorSourceCodeFrame.btnCarregarClick(Sender: TObject);
var
  resposta: Boolean;
begin
  resposta := True;

  if (FClientDataSetAtributos.Active) then
  begin
    if (FClientDataSetAtributos.RecordCount > 0) then
    begin
      resposta := (MessageDlg(Format('Os atributos existentes serão perdidos.%sDeseja continuar?', [sLineBreak]),
                              mtWarning, [mbYes,mbNo], 0, mbNo) = mrYes);
    end;
  end;

  if resposta then
  begin
    try
      if (FClientDataSetAtributos.Active) then
      begin
        FClientDataSetAtributos.EmptyDataSet();
      end;

      MainDataModule.Get().ValidarConexaoSQLServer(edtInstanciaSQLServer.Text, edtUsuarioSQLServer.Text, edtSenhaSQLServer.Text, cmbBaseDados.Text);

      ObterAtributosSQLServer();
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;

    pgcGenerator.ActivePage := tsDadosClasse;
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.btnConectarSQLServerClick(Sender: TObject);
begin
  try
    MainDataModule.Get().ValidarConexaoSQLServer(edtInstanciaSQLServer.Text, edtUsuarioSQLServer.Text, edtSenhaSQLServer.Text);
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

procedure TDotNetGeneratorSourceCodeFrame.btnGerarClick(Sender: TObject);
begin
  if (tlAtributos.IsEditing) then
    tlAtributos.Post();

  if IsValidacaoOk() then
    GerarArquivos();
end;

procedure TDotNetGeneratorSourceCodeFrame.ObterAtributosSQLServer();
var
  t_XMLData: WideString;
begin
  try
    t_XMLData := MainDataModule.Get().GetAtributosSQLServer(cmbTabelas.Text);

    if (not SameText(t_XMLData, EmptyWideStr)) then
    begin
      PopularGridAtributos(t_XMLData);
      PopularNomeClasse();
    end;
  except
    on E: Exception do
    begin
      //
    end;
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.cmbBaseDadosSelect(Sender: TObject);
begin
  MainDataModule.Get().ValidarConexaoSQLServer(edtInstanciaSQLServer.Text, edtUsuarioSQLServer.Text, edtSenhaSQLServer.Text, cmbBaseDados.Text);;

  ListarTabelasBaseDadosSQLServer();

//  cmbSchema.Enabled    := (cmbOrigemClasse.ItemIndex = cOrigemTabela); e banco Postgres
  cmbTabelas.Enabled   := (cmbOrigemClasse.ItemIndex = cOrigemTabela);

  HabilitarComboSchemas();
  HabilitarComboTabelas();
  HabilitarBotaoCarregar();
end;

procedure TDotNetGeneratorSourceCodeFrame.cmbOrigemClasseChange(Sender: TObject);
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

      if (FClientDataSetAtributos.Active) then
      begin
        resposta := True;

        if (FClientDataSetAtributos.RecordCount > 0) then
        begin
          resposta := (MessageDlg(Format('Os atributos existentes serão perdidos.%sDeseja continuar?', [sLineBreak]),
                                  mtWarning, [mbYes,mbNo], 0, mbNo) = mrYes);
        end;

        if resposta then
        begin
          FClientDataSetAtributos.EmptyDataSet();
        end;
      end
      else
      begin
        FClientDataSetAtributos.Close();
        FClientDataSetAtributos.FieldDefs.Add('Id', ftInteger);
        FClientDataSetAtributos.FieldDefs.Add('ParentId', ftInteger);
        FClientDataSetAtributos.FieldDefs.Add('Selecionado', ftWideString, 1);
        FClientDataSetAtributos.FieldDefs.Add('Nome', ftWideString, 100);
        FClientDataSetAtributos.FieldDefs.Add('NomeExibicao', ftWideString, 100);
        FClientDataSetAtributos.FieldDefs.Add('Tipo', ftWideString, 50);
        FClientDataSetAtributos.FieldDefs.Add('ChavePrimaria', ftWideString, 1);
        FClientDataSetAtributos.FieldDefs.Add('ChaveUnica', ftWideString, 1);
        FClientDataSetAtributos.FieldDefs.Add('Requerido', ftWideString, 1);
        FClientDataSetAtributos.CreateDataSet();
        FClientDataSetAtributos.Open();
      end;

      //TransformarColunaTipoAtributoEmComboBox();
    end;

    cOrigemTabela:
    begin
      tsConexao.TabVisible      := True;
      tsInstrucaoSQL.TabVisible := False;
      tsDadosClasse.TabVisible  := True;

      pgcGenerator.ActivePage := tsConexao;

      resposta := True;

      if (FClientDataSetAtributos.RecordCount > 0) then
      begin
        resposta := (MessageDlg(Format('Os atributos existentes serão perdidos.%sDeseja continuar?', [sLineBreak]),
                                mtWarning, [mbYes,mbNo], 0, mbNo) = mrYes);
      end;

      if resposta then
      begin
        FClientDataSetAtributos.EmptyDataSet();
        FClientDataSetAtributos.Close();
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
//      if (FClientDataSetAtributos.RecordCount > 0) then
//      begin
//        resposta := (MessageDlg(Format('Os atributos existentes serão perdidos.%sDeseja continuar?', [sLineBreak]),
//                                mtWarning, [mbYes,mbNo], 0, mbNo) = mrYes);
//      end;
//
//      if resposta then
//      begin
//        FClientDataSetAtributos.EmptyDataSet();
//        FClientDataSetAtributos.Close();
//      end;
//    end;
  else
    begin
      //colocar tudo readonly
    end;
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.cmbSchemaSelect(Sender: TObject);
begin
  HabilitarComboSchemas();
  HabilitarComboTabelas();
  HabilitarBotaoCarregar();
end;

procedure TDotNetGeneratorSourceCodeFrame.cmbTabelasSelect(Sender: TObject);
begin
  HabilitarBotaoCarregar();
end;

destructor TDotNetGeneratorSourceCodeFrame.Destroy();
begin
  if Assigned(FClientDataSetAtributos) then
    FreeAndNil(FClientDataSetAtributos);

  if Assigned(FDataSourceAtributos) then
    FreeAndNil(FDataSourceAtributos);

  inherited;
end;

procedure TDotNetGeneratorSourceCodeFrame.edtInstanciaSQLServerChange(Sender: TObject);
begin
  HabilitarBotaoConectar();
end;

procedure TDotNetGeneratorSourceCodeFrame.edtSenhaSQLServerChange(Sender: TObject);
begin
  HabilitarBotaoConectar();
end;

procedure TDotNetGeneratorSourceCodeFrame.edtUsuarioSQLServerChange(Sender: TObject);
begin
  HabilitarBotaoConectar();
end;

procedure TDotNetGeneratorSourceCodeFrame.GerarArquivos();
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
  DomainRepositoryGenerator: TDomainRepositoriesGenerator;
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

    //domain -> repositories
    DomainRepositoryGenerator := TDomainRepositoriesGenerator.Create();
    DomainRepositoryGenerator.generate(Entidade);

    ShowMessage('Arquivos gerados com sucesso!');
  except
    on E: Exception do
      ShowMessage(Format('Ocorreu um erro ao gerar os arquivos: [%s]', [E.Message]));
  end;

end;

function TDotNetGeneratorSourceCodeFrame.GetTipoAtributoDotNetFromSQLServer(pNomeTipo: string): string;
begin
  //ref: https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/sql-server-data-type-mappings
  if SameText(LowerCase(pNomeTipo), 'bigint') then
    Result := 'Int64'
  else if SameText(LowerCase(pNomeTipo), 'binary ') then
    Result := '	Byte[]'
  else if SameText(LowerCase(pNomeTipo), 'bit') then
    Result := 'Boolean'
  else if SameText(LowerCase(pNomeTipo), 'char') then
    Result := 'String'
  else if SameText(LowerCase(pNomeTipo), 'date') then
    Result := 'DateTime'
  else if SameText(LowerCase(pNomeTipo), 'datetime ') then
    Result := 'DateTime'
  else if SameText(LowerCase(pNomeTipo), 'datetime2') then
    Result := 'DateTime'
  else if SameText(LowerCase(pNomeTipo), 'datetimeoffset ') then
    Result := 'DateTimeOffset'
  else if SameText(LowerCase(pNomeTipo), 'decimal') then
    Result := 'Decimal'
  else if SameText(LowerCase(pNomeTipo), 'float') then
    Result := 'Double'
  else if SameText(LowerCase(pNomeTipo), 'image') then
    Result := 'Byte[]'
  else if SameText(LowerCase(pNomeTipo), 'int') then
    Result := 'Int32'
  else if SameText(LowerCase(pNomeTipo), 'money') then
    Result := 'Decimal'
  else if SameText(LowerCase(pNomeTipo), 'nchar') then
    Result := 'String'
  else if SameText(LowerCase(pNomeTipo), 'ntext') then
    Result := 'String'
  else if SameText(LowerCase(pNomeTipo), 'numeric') then
    Result := 'Decimal'
  else if SameText(LowerCase(pNomeTipo), 'nvarchar ') then
    Result := 'String'
  else if SameText(LowerCase(pNomeTipo), 'real ') then
    Result := 'Single'
  else if SameText(LowerCase(pNomeTipo), 'smalldatetime') then
    Result := 'DateTime'
  else if SameText(LowerCase(pNomeTipo), 'smallint ') then
    Result := 'Int16'
  else if SameText(LowerCase(pNomeTipo), 'smallmoney ') then
    Result := 'Decimal'
  else if SameText(LowerCase(pNomeTipo), 'sql_variant') then
    Result := 'Object'
  else if SameText(LowerCase(pNomeTipo), 'text ') then
    Result := 'String'
  else if SameText(LowerCase(pNomeTipo), 'time ') then
    Result := 'TimeSpan'
  else if SameText(LowerCase(pNomeTipo), 'timestamp') then
    Result := 'Byte[]'
  else if SameText(LowerCase(pNomeTipo), 'tinyint') then
    Result := 'Byte'
  else if SameText(LowerCase(pNomeTipo), 'uniqueidentifier ') then
    Result := 'Guid'
  else if SameText(LowerCase(pNomeTipo), 'varbinary') then
    Result := 'Byte[]'
  else if SameText(LowerCase(pNomeTipo), 'varchar') then
    Result := 'String'
  else if SameText(LowerCase(pNomeTipo), 'xml') then
    Result := 'Xml'
  else
    Result := EmptyStr;
end;

function TDotNetGeneratorSourceCodeFrame.GetViewToEntidade(): TEntidadeDTO;
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
    FClientDataSetAtributos.DisableControls();

    FClientDataSetAtributos.First();

    while (not FClientDataSetAtributos.Eof) do
    begin
      if (SameText(FClientDataSetAtributos.FieldByName('Selecionado').AsString, cSim)) then
      begin
        Atributo := TAtributoDTO.Create();

        Atributo.Nome          := FClientDataSetAtributos.FieldByName('Nome').AsString;
        Atributo.NomeExibicao  := FClientDataSetAtributos.FieldByName('NomeExibicao').AsString;
        Atributo.Tipo          := FClientDataSetAtributos.FieldByName('Tipo').AsString;
//        Atributo.ChavePrimaria := SameText(FClientDataSetAtributos.FieldByName('ChavePrimaria').AsString, cSim);
        Atributo.ChaveUnica    := SameText(FClientDataSetAtributos.FieldByName('ChaveUnica').AsString, cSim);
        Atributo.Requerido     := SameText(FClientDataSetAtributos.FieldByName('Requerido').AsString, cSim);

        Result.Atributos.Add(Atributo);
      end;

      FClientDataSetAtributos.Next;
    end;

  finally
    FClientDataSetAtributos.First();
    FClientDataSetAtributos.EnableControls();
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.HabilitarBotaoCarregar();
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

procedure TDotNetGeneratorSourceCodeFrame.HabilitarBotaoConectar();
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

procedure TDotNetGeneratorSourceCodeFrame.HabilitarComboBaseDados();
begin
  cmbBaseDados.Enabled := (cmbOrigemClasse.ItemIndex <> cOrigemManual);
end;

procedure TDotNetGeneratorSourceCodeFrame.HabilitarComboSchemas();
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

procedure TDotNetGeneratorSourceCodeFrame.HabilitarComboTabelas();
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

function TDotNetGeneratorSourceCodeFrame.IsColunaBoolean(pNomeColuna: string): Boolean;
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

function TDotNetGeneratorSourceCodeFrame.IsValidacaoOk(): Boolean;
var
  selecionados: Integer;
//  pks: Integer;
  tipo_nao_informado: Integer;
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

  if (FClientDataSetAtributos.RecordCount = 0) then
  begin
    ShowMessage('Ao menos um atributo é obrigatório');
    tlAtributos.SetFocus();
    Exit
  end;

  selecionados := 0;
//  pks := 0;
  tipo_nao_informado := 0;

  try
    FClientDataSetAtributos.DisableControls();
    FClientDataSetAtributos.First();

    while not FClientDataSetAtributos.Eof do
    begin
      if SameText(FClientDataSetAtributos.FieldByName('Selecionado').AsString, cSim) then
      begin
        Inc(selecionados);
      end;

//      if SameText(FClientDataSetAtributos.FieldByName('ChavePrimaria').AsString, cSim) then
//      begin
//        Inc(pks);
//      end;

      if SameText(Trim(FClientDataSetAtributos.FieldByName('Tipo').AsString), EmptyStr) then
      begin
        Inc(tipo_nao_informado);
      end;

      FClientDataSetAtributos.Next();
    end;
  finally
    FClientDataSetAtributos.First();

    FClientDataSetAtributos.EnableControls();
  end;

  if (selecionados = 0) then
  begin
    ShowMessage('Ao menos um atributo deve ser selecionado');
    tlAtributos.SetFocus();
    Exit
  end;

//  if (pks = 0) then
//  begin
//    ShowMessage('Ao menos um atributo deve ser chave primária');
//    tlAtributos.SetFocus();
//    Exit
//  end;

  if (tipo_nao_informado > 0) then
  begin
    ShowMessage('Existe(m) atributo(s) sem tipo informado');
    tlAtributos.SetFocus();
    Exit
  end;

  //verificar se os tipos informados sao validos

  Result := True;
end;

procedure TDotNetGeneratorSourceCodeFrame.ListarBaseDadosSQLServer();
var
  t_XMLData: WideString;
begin
  try
    t_XMLData := MainDataModule.Get().GetBasesDeDadosSQLServer();

    if (not SameText(t_XMLData, EmptyWideStr)) then
    begin
      PopularComboBaseDados(t_XMLData);
    end;
  except
    on E: Exception do
    begin
      //
    end;
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.ListarTabelasBaseDadosSQLServer();
var
  t_XMLData: WideString;
begin
  try
    t_XMLData := MainDataModule.Get().GetTabelasSQLServer();

    if (not SameText(t_XMLData, EmptyWideStr)) then
    begin
      PopularComboTabelasBaseDados(t_XMLData);
    end;
  except
    on E: Exception do
    begin
      //
    end;
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.PopularComboBaseDados(pXMLData: WideString);
var
  t_cds: TClientDataSet;
begin
  try
    t_cds := TClientDataSet.Create(nil);
    t_cds.XMLData := pXMLData;

    cmbBaseDados.Items.Clear();

    t_cds.First();

    while not t_cds.Eof do
    begin
      cmbBaseDados.Items.Add(t_cds.FieldByName('NOME').AsString);

      t_cds.Next();
    end;
  finally
    t_cds.Close();

    FreeAndNil(t_cds);
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.PopularComboTabelasBaseDados(pXMLData: WideString);
var
  t_cds: TClientDataSet;
begin
  try
    t_cds := TClientDataSet.Create(nil);
    t_cds.XMLData := pXMLData;

    cmbTabelas.Items.Clear();

    t_cds.First();

    while not t_cds.Eof do
    begin
      cmbTabelas.Items.Add(t_cds.FieldByName('NOME').AsString);

      t_cds.Next();
    end;
  finally
    t_cds.Close();

    FreeAndNil(t_cds);
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.PopularGridAtributos(pXMLData: WideString);
var
  t_cds: TClientDataSet;
  nome_aux: string;
begin
  try
    FNextIdAtributo := 1;

    t_cds := TClientDataSet.Create(nil);
    t_cds.XMLData := pXMLData;

    FClientDataSetAtributos.Close();
    FClientDataSetAtributos.Open();

    FClientDataSetAtributos.DisableControls();

    t_cds.First;

    while not t_cds.Eof do
    begin
      if SameText(t_cds.FieldByName('ChavePrimaria').AsString, cNao) then
      begin
        FClientDataSetAtributos.Append();

        nome_aux := UpperCase(Copy(t_cds.FieldByName('Nome').AsString, 1, 1)) + LowerCase(Copy(t_cds.FieldByName('Nome').AsString, 2, Length(t_cds.FieldByName('Nome').AsString)));

        FClientDataSetAtributos.FieldByName('Id').AsInteger := FNextIdAtributo;
        FClientDataSetAtributos.FieldByName('ParentId').AsInteger := 0;
        FClientDataSetAtributos.FieldByName('Selecionado').AsString := cSim;
        FClientDataSetAtributos.FieldByName('Nome').AsString := nome_aux;
        FClientDataSetAtributos.FieldByName('NomeExibicao').AsString := nome_aux;
        FClientDataSetAtributos.FieldByName('Tipo').AsString := GetTipoAtributoDotNetFromSQLServer(t_cds.FieldByName('Tipo').AsString);
//        FClientDataSetAtributos.FieldByName('ChavePrimaria').AsString := t_cds.FieldByName('ChavePrimaria').AsString;
        FClientDataSetAtributos.FieldByName('ChaveUnica').AsString := t_cds.FieldByName('ChaveUnica').AsString;
        FClientDataSetAtributos.FieldByName('Requerido').AsString := t_cds.FieldByName('Requerido').AsString;

        FClientDataSetAtributos.Post();

        Inc(FNextIdAtributo);
      end;

      t_cds.Next();
    end;
  finally
    FClientDataSetAtributos.EnableControls();

    t_cds.Close();

    FreeAndNil(t_cds);

    tlAtributos.Refresh();
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.PopularNomeClasse();
var
  nome_aux: string;
begin
  nome_aux := UpperCase(Copy(cmbTabelas.Text, 1, 1)) + LowerCase(Copy(cmbTabelas.Text, 2, Length(cmbTabelas.Text)));

  edtNomeSingular.Text := nome_aux;
end;


procedure TDotNetGeneratorSourceCodeFrame.tlAtributosNavigatorButtonsButtonClick(
  Sender: TObject; AButtonIndex: Integer; var ADone: Boolean);
begin
  if (AButtonIndex = NBDI_APPEND) then
  begin
    FClientDataSetAtributos.Append();
    FClientDataSetAtributos.FieldByName('Id').AsInteger := FNextIdAtributo;
    FClientDataSetAtributos.FieldByName('ParentId').AsInteger := 0;
    FClientDataSetAtributos.FieldByName('Selecionado').AsString := cSim;
    FClientDataSetAtributos.FieldByName('ChavePrimaria').AsString := cNao;
    FClientDataSetAtributos.FieldByName('ChaveUnica').AsString := cNao;
    FClientDataSetAtributos.FieldByName('Requerido').AsString := cNao;

    Inc(FNextIdAtributo);

    ADone := True;
  end;
end;

end.
