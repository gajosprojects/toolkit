unit uDotNetGeneratorSourceCodeFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient,
  Vcl.StdCtrls, Vcl.DBCtrls, Vcl.ExtCtrls, uEntidadeDTO, MidasLib, Vcl.ComCtrls,
  ZAbstractConnection, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxStyles, cxTL, cxTLdxBarBuiltInMenu, cxDataControllerConditionalFormattingRulesManagerDialog, 
  dxSkinsCore, cxInplaceContainer, cxTLData, cxDBTL, cxMaskEdit, cxCheckBox, cxDropDownEdit,
  cxCustomData, Vcl.ExtDlgs;

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
    btnCarregarAtributos: TButton;
    tsInstrucaoSQL: TTabSheet;
    tsDadosClasse: TTabSheet;
    pnlEntidade: TPanel;
    gbxNomeEntidade: TGroupBox;
    lblNomeSingular: TLabel;
    lblNomePlural: TLabel;
    edtNomeClasseSingular: TEdit;
    edtNomeClassePlural: TEdit;
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
    btnExportarXML: TButton;
    btnCarregarXML: TButton;
    gbxNomeTabela: TGroupBox;
    edtNomeTabela: TEdit;
    gbxNomeClasseExibicao: TGroupBox;
    edtNomeClasseExibicao: TEdit;
    lblNomeClasseExibicao: TLabel;
    lblNomeModulo: TLabel;
    lblNomeTabela: TLabel;

    procedure btnCarregarAtributosClick(Sender: TObject);
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
    procedure btnExportarXMLClick(Sender: TObject);
    procedure btnCarregarXMLClick(Sender: TObject);

  private
    FNextIdAtributo: Integer;
    FUltimoArquivoCarregado: string;

    FClientDataSetAtributos: TClientDataSet;
    FDataSourceAtributos: TDataSource;

    FProgressBar: TProgressBar;

    { Private declarations }
    procedure InicializarFormulario();

    //CONFIGURACAO
    procedure SalvarConfiguracao();
    procedure CarregarConfiguracao();

    //SQLSERVER
    procedure ListarBaseDadosSQLServer();
    procedure ListarTabelasBaseDadosSQLServer();
    procedure ObterAtributosSQLServer();

    //PREENCHER COMPONNETES
    procedure PopularComboBaseDados(pXMLData: WideString);
    procedure PopularComboTabelasBaseDados(pXMLData: WideString);
    procedure PopularClientDataSetAtributos(pXMLData: WideString);
    procedure PopularDadosEntidade(pEntidadeDTO: TEntidadeDTO);
    procedure PopularNomeTabela();

    //HABILITAR COMPONENTES
    procedure HabilitarComboBaseDados();
    procedure HabilitarComboSchemas();
    procedure HabilitarComboTabelas();

    procedure HabilitarBotaoCarregarXML();
    procedure HabilitarBotaoConectar();
    procedure HabilitarBotaoCarregarAtributos();

    procedure AtualizarStatusBar();

    //CONVERSAO
    function GetTipoAtributoDotNetFromSQLServer(pNomeTipo: string): string;
    function GetViewToEntidade(): TEntidadeDTO;

    //VALIDACOES
    function IsColunaBoolean(pNomeColuna: string): Boolean;
    function IsValidacaoOk(): Boolean;

    //
    procedure CarregarXML(pArquivoXML: string);
    procedure ExportarArquivo(pArquivoXML: string);
    procedure GerarArquivos();

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

    procedure ExibirFrame(pProgressBar: TProgressBar);

  end;

implementation

uses
  uAtributoDTO, service_api_view_model_generator, service_api_controller_generator,
  infra_data_repository_generator, infra_data_mapping_generator, infra_data_context_generator,
  domain_entity_generator, domain_commands_generator, domain_events_generator, domain_repositories_generator,
  System.UITypes, uMainDataModule, uConstantes, cxNavigator, System.IniFiles, uSerializadorXML,
  System.Contnrs;

{$R *.dfm}

{ TDotNetGeneratorSourceCodeFrame }

constructor TDotNetGeneratorSourceCodeFrame.Create(AOwner: TComponent);
begin
  inherited;

  FClientDataSetAtributos := TClientDataSet.Create(nil);
  FDataSourceAtributos := TDataSource.Create(nil);

  InicializarFormulario();

  CarregarConfiguracao();
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

procedure TDotNetGeneratorSourceCodeFrame.AtualizarStatusBar();
begin
  FProgressBar.Position := FProgressBar.Position + 1;
  TStatusBar(FProgressBar.Parent).Repaint();
end;

procedure TDotNetGeneratorSourceCodeFrame.btnCarregarAtributosClick(Sender: TObject);
var
  t_resposta: Boolean;
begin
  t_resposta := True;

  if (FClientDataSetAtributos.Active) then
  begin
    if (FClientDataSetAtributos.RecordCount > 0) then
    begin
      t_resposta := (MessageDlg(Format('Os atributos existentes serão perdidos.%sDeseja continuar?', [sLineBreak]),
                              mtWarning, [mbYes,mbNo], 0, mbNo) = mrYes);
    end;
  end;

  if t_resposta then
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

procedure TDotNetGeneratorSourceCodeFrame.btnCarregarXMLClick(Sender: TObject);
var
  t_resposta: Boolean;
  t_OpenXMLDialog: TOpenDialog;
begin
//  if (cmbOrigemClasse.ItemIndex <> cOrigemTabela) then
//  begin
//    ShowMessage('A origem da entidade deve ser Manual');
//    cmbOrigemClasse.SetFocus();
//    Exit
//  end;

  t_resposta := True;

  if (FClientDataSetAtributos.RecordCount > 0) then
  begin
    t_resposta := (MessageDlg(Format('Os atributos existentes serão perdidos.%sDeseja continuar?', [sLineBreak]),
                              mtWarning, [mbYes,mbNo], 0, mbNo) = mrYes);
  end;

  if t_resposta then
  begin
    t_OpenXMLDialog := TOpenDialog.Create(nil);

    try
      t_OpenXMLDialog.Filter := 'XML files (*.xml)|*.XML|Any file (*.*)|*.*';
      t_OpenXMLDialog.InitialDir := ExtractFilePath(Application.ExeName);

      if t_OpenXMLDialog.Execute() then
      begin
        cmbOrigemClasse.ItemIndex := cOrigemManual;
        cmbOrigemClasseChange(nil);

        CarregarXML(t_OpenXMLDialog.FileName);

        ShowMessage('Arquivo carregado com sucesso!');
      end;
    finally
      if Assigned(t_OpenXMLDialog) then
        FreeAndNil(t_OpenXMLDialog);
    end;
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
    HabilitarBotaoCarregarAtributos();
//    cmbSchema.Enabled    := False;
//    cmbTabelas.Enabled   := False
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.btnExportarXMLClick(Sender: TObject);
var
  t_SaveXMLDialog: TSaveDialog;
begin
  if (tlAtributos.IsEditing) then
    tlAtributos.Post();

  if IsValidacaoOk() then
  begin
    t_SaveXMLDialog := TSaveDialog.Create(nil);

    try
      t_SaveXMLDialog.Filter := 'XML files (*.xml)|*.XML|Any file (*.*)|*.*';
      t_SaveXMLDialog.InitialDir := ExtractFilePath(Application.ExeName);
      t_SaveXMLDialog.FileName := Format('%s.%s', [edtNomeModulo.Text, edtNomeClasseSingular.Text]);
      t_SaveXMLDialog.DefaultExt := 'xml';

      if t_SaveXMLDialog.Execute() then
      begin
        ExportarArquivo(t_SaveXMLDialog.FileName);

        ShowMessage('Arquivo exportado com sucesso!');
      end;
    finally
      if Assigned(t_SaveXMLDialog) then
        FreeAndNil(t_SaveXMLDialog);
    end;
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.btnGerarClick(Sender: TObject);
begin
  if (tlAtributos.IsEditing) then
    tlAtributos.Post();

  if IsValidacaoOk() then
    GerarArquivos();
end;

procedure TDotNetGeneratorSourceCodeFrame.CarregarConfiguracao();
var
  t_ArquivoIni: TIniFile;
  t_Indice: Integer;
  t_OrigemAux: string;
  t_BaseDadosAux: string;
  t_SchemasAux: string;
  t_TabelassAux: string;
  t_UltimoArquivoCarregado: string;
begin
  // Cria o objeto do tipo TIniFile
  t_ArquivoIni := TIniFile.Create(Format('%s%s.ini', [ExtractFilePath(Application.ExeName), cToolkitConfig]));

  try
    // Lê o conteúdo gravado no arquivo conforme parametros informados
    t_OrigemAux := t_ArquivoIni.ReadString(cModuloDotNetGenerator, cParametroOrigem, EmptyStr);

    for t_Indice := 0 to cmbOrigemClasse.Items.Count -1 do
    begin
      if SameText(cmbOrigemClasse.Items[t_Indice], t_OrigemAux) then
      begin
        cmbOrigemClasse.ItemIndex := t_Indice;
        cmbOrigemClasseChange(nil);

        Break;
      end;
    end;

    case (cmbOrigemClasse.ItemIndex) of
      cOrigemManual:
      begin
        t_UltimoArquivoCarregado := t_ArquivoIni.ReadString(cModuloDotNetGenerator, cParametroUltimoXMLCarregado, EmptyStr);

        if (not SameText(t_UltimoArquivoCarregado, EmptyStr)) then
        begin
          CarregarXML(t_UltimoArquivoCarregado);
        end;
      end;

      cOrigemTabela:
      begin
        edtInstanciaSQLServer.Text := t_ArquivoIni.ReadString(cModuloDotNetGenerator, cParametroInstancia, EmptyStr);
        edtUsuarioSQLServer.Text   := t_ArquivoIni.ReadString(cModuloDotNetGenerator, cParametroUsuario, EmptyStr);
        edtSenhaSQLServer.Text     := t_ArquivoIni.ReadString(cModuloDotNetGenerator, cParametroSenha, EmptyStr);

        if (btnConectarSQLServer.Enabled) then
        begin
          btnConectarSQLServerClick(nil);

          t_BaseDadosAux := t_ArquivoIni.ReadString(cModuloDotNetGenerator, cParametroBaseDados, EmptyStr);

          for t_Indice := 0 to cmbBaseDados.Items.Count -1 do
          begin
            if SameText(cmbBaseDados.Items[t_Indice], t_BaseDadosAux) then
            begin
              cmbBaseDados.ItemIndex := t_Indice;
              cmbBaseDadosSelect(nil);

              Break;
            end;
          end;

          if (cmbSchema.Enabled) then
          begin
            t_SchemasAux := t_ArquivoIni.ReadString(cModuloDotNetGenerator, cParametroSchema, EmptyStr);

            for t_Indice := 0 to cmbSchema.Items.Count -1 do
            begin
              if SameText(cmbSchema.Items[t_Indice], t_SchemasAux) then
              begin
                cmbSchema.ItemIndex := t_Indice;
                cmbSchemaSelect(nil);

                Break;
              end;
            end;
          end;

          if (cmbTabelas.Enabled) then
          begin
            t_TabelassAux := t_ArquivoIni.ReadString(cModuloDotNetGenerator, cParametroTabela, EmptyStr);

            for t_Indice := 0 to cmbTabelas.Items.Count -1 do
            begin
              if SameText(cmbTabelas.Items[t_Indice], t_TabelassAux) then
              begin
                cmbTabelas.ItemIndex := t_Indice;
                cmbTabelasSelect(nil);

                Break;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    // Liberar a referência do arquivo da memória
    FreeAndNil(t_ArquivoIni);
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.CarregarXML(pArquivoXML: string);
var
  t_Arquivo: TStringList;
  t_Serializador: TSerializadorXML;
  t_Entidade: TEntidadeDTO;
begin
  t_Serializador := TSerializadorXML.Create();
  t_Arquivo := TStringList.Create();
  t_Entidade := nil;

  try
    FClientDataSetAtributos.EmptyDataSet();

    FUltimoArquivoCarregado := pArquivoXML;

    t_Arquivo.LoadFromFile(FUltimoArquivoCarregado);

    t_Entidade := TEntidadeDTO(t_Serializador.ObjectFromXML(t_Arquivo.Text));

    PopularDadosEntidade(t_Entidade);
  finally
    if Assigned(t_Arquivo) then
      FreeAndNil(t_Arquivo);

    if Assigned(t_Serializador) then
      FreeAndNil(t_Serializador);

    if Assigned(t_Entidade) then
      FreeAndNil(t_Entidade);
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.ObterAtributosSQLServer();
var
  t_XMLData: WideString;
begin
  try
    t_XMLData := MainDataModule.Get().GetAtributosSQLServer(cmbTabelas.Text);

    if (not SameText(t_XMLData, EmptyWideStr)) then
    begin
      PopularClientDataSetAtributos(t_XMLData);
      PopularNomeTabela();
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
  HabilitarBotaoCarregarAtributos();
end;

procedure TDotNetGeneratorSourceCodeFrame.cmbOrigemClasseChange(Sender: TObject);
var
  t_resposta: Boolean;
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

//  HabilitarBotaoCarregarXML();
  HabilitarBotaoConectar();
  HabilitarBotaoCarregarAtributos();

  case cmbOrigemClasse.ItemIndex of

    cOrigemManual:
    begin
      tsConexao.TabVisible      := False;
      tsInstrucaoSQL.TabVisible := False;
      tsDadosClasse.TabVisible  := True;

      pgcGenerator.ActivePage := tsDadosClasse;

      edtNomeModulo.Text         := EmptyStr;
      edtNomeTabela.Text         := EmptyStr;
      edtNomeClasseSingular.Text := EmptyStr;
      edtNomeClassePlural.Text   := EmptyStr;
      edtNomeClasseExibicao.Text := EmptyStr;

      if (FClientDataSetAtributos.Active) then
      begin
        FClientDataSetAtributos.EmptyDataSet();
      end
      else
      begin
        FClientDataSetAtributos.Close();
        FClientDataSetAtributos.FieldDefs.Clear();
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

      t_resposta := True;

      if (FClientDataSetAtributos.RecordCount > 0) then
      begin
        t_resposta := (MessageDlg(Format('Os atributos existentes serão perdidos.%sDeseja continuar?', [sLineBreak]),
                                mtWarning, [mbYes,mbNo], 0, mbNo) = mrYes);
      end;

      if t_resposta then
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
//      t_resposta := True;
//
//      if (FClientDataSetAtributos.RecordCount > 0) then
//      begin
//        t_resposta := (MessageDlg(Format('Os atributos existentes serão perdidos.%sDeseja continuar?', [sLineBreak]),
//                                mtWarning, [mbYes,mbNo], 0, mbNo) = mrYes);
//      end;
//
//      if t_resposta then
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
  HabilitarBotaoCarregarAtributos();
end;

procedure TDotNetGeneratorSourceCodeFrame.cmbTabelasSelect(Sender: TObject);
begin
  HabilitarBotaoCarregarAtributos();
end;

destructor TDotNetGeneratorSourceCodeFrame.Destroy();
begin
  if Assigned(FClientDataSetAtributos) then
    FreeAndNil(FClientDataSetAtributos);

  if Assigned(FDataSourceAtributos) then
    FreeAndNil(FDataSourceAtributos);

  SalvarConfiguracao();

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

procedure TDotNetGeneratorSourceCodeFrame.ExibirFrame(pProgressBar: TProgressBar);
begin
  FProgressBar := pProgressBar;
  Show();
end;

procedure TDotNetGeneratorSourceCodeFrame.ExportarArquivo(pArquivoXML: string);
var
  t_Arquivo: TStringList;
  t_Serializador: TSerializadorXML;
  t_XML: WideString;
begin
  t_Serializador := TSerializadorXML.Create();
  t_Arquivo := TStringList.Create();

  try
    t_XML := t_Serializador.ToXML(GetViewToEntidade());

    t_Arquivo.Add(t_XML);
    t_Arquivo.SaveToFile(pArquivoXML);
  finally
    if Assigned(t_Arquivo) then
      FreeAndNil(t_Arquivo);

    if Assigned(t_Serializador) then
      FreeAndNil(t_Serializador);
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.GerarArquivos();
var
  t_Entidade: TEntidadeDTO;
  t_ServiceApiViewModelGenerator: TServiceApiViewModelGenerator;
  t_ServiceApiControllerGenerator: TServiceApiControllerGenerator;
  t_InfraDataRepositoryGenerator: TInfraDataRepositoryGenerator;
  t_InfraDataMapppingGenerator: TInfraDataMappingGenerator;
  t_InfraDataContextGenerator: TInfraDataContextGenerator;
  t_DomainEntityGenerator: TDomainEntityGenerator;
  t_DomainCommandsGenerator: TDomainCommandsGenerator;
  t_DomainEventsGenerator: TDomainEventsGenerator;
  t_DomainRepositoryGenerator: TDomainRepositoriesGenerator;
begin
  t_ServiceApiViewModelGenerator := TServiceApiViewModelGenerator.Create();
  t_ServiceApiControllerGenerator := TServiceApiControllerGenerator.Create();
  t_InfraDataRepositoryGenerator := TInfraDataRepositoryGenerator.Create();
  t_InfraDataMapppingGenerator := TInfraDataMappingGenerator.Create();
  t_InfraDataContextGenerator := TInfraDataContextGenerator.Create();
  t_DomainEntityGenerator := TDomainEntityGenerator.Create();
  t_DomainCommandsGenerator := TDomainCommandsGenerator.Create();
  t_DomainEventsGenerator := TDomainEventsGenerator.Create();
  t_DomainRepositoryGenerator := TDomainRepositoriesGenerator.Create();

  FProgressBar.Position := 0;
  FProgressBar.Max      := 22;

  try
    try
      //preenchimento do objeto t_Entidade e seus atributos
      AtualizarStatusBar();
      t_Entidade := GetViewToEntidade();

      //view_model
      AtualizarStatusBar();
      t_ServiceApiViewModelGenerator.generate(t_Entidade);

      AtualizarStatusBar();
      t_ServiceApiViewModelGenerator.generateSave(t_Entidade);

      AtualizarStatusBar();
      t_ServiceApiViewModelGenerator.generateUpdate(t_Entidade);

      AtualizarStatusBar();
      t_ServiceApiViewModelGenerator.generateDelete(t_Entidade);

      AtualizarStatusBar();
      t_ServiceApiViewModelGenerator.generate(t_Entidade);

      //controller
      AtualizarStatusBar();
      t_ServiceApiControllerGenerator.generate(t_Entidade);

      //repository
      AtualizarStatusBar();
      t_InfraDataRepositoryGenerator.generate(t_Entidade);

      //mapping
      AtualizarStatusBar();
      t_InfraDataMapppingGenerator.generate(t_Entidade);

      //context
      AtualizarStatusBar();
      t_InfraDataContextGenerator.generate(t_Entidade);

      //entity
      AtualizarStatusBar();
      t_DomainEntityGenerator.generate(t_Entidade);

      //commands
      AtualizarStatusBar();
      t_DomainCommandsGenerator.generateBaseCommand(t_Entidade);

      AtualizarStatusBar();
      t_DomainCommandsGenerator.generateCommandHandler(t_Entidade);

      AtualizarStatusBar();
      t_DomainCommandsGenerator.generateSaveCommand(t_Entidade);

      AtualizarStatusBar();
      t_DomainCommandsGenerator.generateUpdateCommand(t_Entidade);

      AtualizarStatusBar();
      t_DomainCommandsGenerator.generateDeleteCommand(t_Entidade);

      //events
      AtualizarStatusBar();
      t_DomainEventsGenerator.generateBaseEvent(t_Entidade);

      AtualizarStatusBar();
      t_DomainEventsGenerator.generateEventHandler(t_Entidade);

      AtualizarStatusBar();
      t_DomainEventsGenerator.generateSavedEvent(t_Entidade);

      AtualizarStatusBar();
      t_DomainEventsGenerator.generateUpdatedEvent(t_Entidade);

      AtualizarStatusBar();
      t_DomainEventsGenerator.generateDeletedEvent(t_Entidade);

      //irepository
      AtualizarStatusBar();
      t_DomainRepositoryGenerator.generate(t_Entidade);

      ShowMessage('Arquivos gerados com sucesso!');

      FProgressBar.Position := FProgressBar.Min;
    except
      on E: Exception do
        ShowMessage(Format('Ocorreu um erro ao gerar os arquivos: [%s]', [E.Message]));
    end;
  finally
    if Assigned(t_ServiceApiViewModelGenerator) then
      FreeAndNil(t_ServiceApiViewModelGenerator);

    if Assigned(t_ServiceApiControllerGenerator) then
      FreeAndNil(t_ServiceApiControllerGenerator);

    if Assigned(t_InfraDataRepositoryGenerator) then
      FreeAndNil(t_InfraDataRepositoryGenerator);

    if Assigned(t_InfraDataMapppingGenerator) then
      FreeAndNil(t_InfraDataMapppingGenerator);

    if Assigned(t_InfraDataContextGenerator) then
      FreeAndNil(t_InfraDataContextGenerator);

    if Assigned(t_DomainEntityGenerator) then
      FreeAndNil(t_DomainEntityGenerator);

    if Assigned(t_DomainCommandsGenerator) then
      FreeAndNil(t_DomainCommandsGenerator);

    if Assigned(t_DomainEventsGenerator) then
      FreeAndNil(t_DomainEventsGenerator);

    if Assigned(t_DomainRepositoryGenerator) then
      FreeAndNil(t_DomainRepositoryGenerator);
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
  t_Atributo: TAtributoDTO;
begin
  //preenchimento do objeto entidade e seus atributos
  Result                    := TEntidadeDTO.Create(Self);
  Result.NomeModulo         := edtNomeModulo.Text;
  REsult.NomeTabela         := edtNomeTabela.Text;
  Result.NomeClasseSingular := edtNomeClasseSingular.Text;
  Result.NomeClassePlural   := edtNomeClassePlural.Text;
  Result.NomeClasseExibicao := edtNomeClasseExibicao.Text;

  //loop nos atributos
  try
    FClientDataSetAtributos.DisableControls();

    FClientDataSetAtributos.First();

    while (not FClientDataSetAtributos.Eof) do
    begin
      if (SameText(FClientDataSetAtributos.FieldByName('Selecionado').AsString, cSim)) then
      begin
//        t_Atributo := Result.Atributos.Add();
        t_Atributo := TAtributoDTO.Create();

        t_Atributo.Nome          := FClientDataSetAtributos.FieldByName('Nome').AsString;
        t_Atributo.NomeExibicao  := FClientDataSetAtributos.FieldByName('NomeExibicao').AsString;
        t_Atributo.Tipo          := FClientDataSetAtributos.FieldByName('Tipo').AsString;
//        t_Atributo.ChavePrimaria := SameText(FClientDataSetAtributos.FieldByName('ChavePrimaria').AsString, cSim);
        t_Atributo.ChaveUnica    := SameText(FClientDataSetAtributos.FieldByName('ChaveUnica').AsString, cSim);
        t_Atributo.Requerido     := SameText(FClientDataSetAtributos.FieldByName('Requerido').AsString, cSim);

        Result.Atributos.Add(t_Atributo);
      end;

      FClientDataSetAtributos.Next;
    end;

  finally
    FClientDataSetAtributos.First();
    FClientDataSetAtributos.EnableControls();
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.HabilitarBotaoCarregarAtributos();
begin
  case cmbOrigemClasse.ItemIndex of
    cOrigemTabela:
    begin
      if (cmbBaseDados.ItemIndex >= 0) and
         (cmbTabelas.ItemIndex >= 0) {and
         base de dados sqlserver} then
      begin
        btnCarregarAtributos.Enabled := True;
      end
      else if (cmbBaseDados.ItemIndex >= 0) and
              (cmbSchema.ItemIndex >= 0) and
              (cmbTabelas.ItemIndex >= 0) {and
              base de dados postgres} then
      begin
        btnCarregarAtributos.Enabled := True;
      end
      else
      begin
        btnCarregarAtributos.Enabled := False;
      end;
    end;

    cOrigemInstrucaoSQL:
    begin
      if (cmbBaseDados.ItemIndex >= 0) then
      begin
        btnCarregarAtributos.Enabled := True;
      end
      else
      begin
        btnCarregarAtributos.Enabled := False;
      end;
    end;
  else
    begin
      btnCarregarAtributos.Enabled := False;
    end;
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.HabilitarBotaoCarregarXML();
begin
  case cmbOrigemClasse.ItemIndex of
    cOrigemTabela:
    begin
      btnCarregarXML.Enabled := True;
    end;
  else
    begin
      btnCarregarXML.Enabled := False;
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
  t_Selecionado: Integer;
//  t_Pks: Integer;
  t_TipoNaoInformado: Integer;
begin
  Result := False;

  if SameText(Trim(edtNomeModulo.Text), EmptyStr) then
  begin
    ShowMessage('Nome do módulo é obrigatório');
    edtNomeModulo.SetFocus();
    Exit
  end;

  if SameText(Trim(edtNomeTabela.Text), EmptyStr) then
  begin
    ShowMessage('Nome da tabela é obrigatório');
    edtNomeTabela.SetFocus();
    Exit
  end;

  if SameText(Trim(edtNomeClasseSingular.Text), EmptyStr) then
  begin
    ShowMessage('Nome da classe no singular é obrigatório');
    edtNomeClasseSingular.SetFocus();
    Exit
  end;

  if SameText(Trim(edtNomeClassePlural.Text), EmptyStr) then
  begin
    ShowMessage('Nome da classe no plural é obrigatório');
    edtNomeClassePlural.SetFocus();
    Exit
  end;

  if SameText(Trim(edtNomeClasseExibicao.Text), EmptyStr) then
  begin
    ShowMessage('Nome de exibição da classe é obrigatório');
    edtNomeClasseExibicao.SetFocus();
    Exit
  end;

  if (FClientDataSetAtributos.RecordCount = 0) then
  begin
    ShowMessage('Ao menos um atributo é obrigatório');
    tlAtributos.SetFocus();
    Exit
  end;

  t_Selecionado := 0;
//  t_Pks := 0;
  t_TipoNaoInformado := 0;

  try
    FClientDataSetAtributos.DisableControls();
    FClientDataSetAtributos.First();

    while not FClientDataSetAtributos.Eof do
    begin
      if SameText(FClientDataSetAtributos.FieldByName('Selecionado').AsString, cSim) then
      begin
        Inc(t_Selecionado);
      end;

//      if SameText(FClientDataSetAtributos.FieldByName('ChavePrimaria').AsString, cSim) then
//      begin
//        Inc(t_Pks);
//      end;

      if SameText(Trim(FClientDataSetAtributos.FieldByName('Tipo').AsString), EmptyStr) then
      begin
        Inc(t_TipoNaoInformado);
      end;

      FClientDataSetAtributos.Next();
    end;
  finally
    FClientDataSetAtributos.First();

    FClientDataSetAtributos.EnableControls();
  end;

  if (t_Selecionado = 0) then
  begin
    ShowMessage('Ao menos um atributo deve ser selecionado');
    tlAtributos.SetFocus();
    Exit
  end;

//  if (t_Pks = 0) then
//  begin
//    ShowMessage('Ao menos um atributo deve ser chave primária');
//    tlAtributos.SetFocus();
//    Exit
//  end;

  if (t_TipoNaoInformado > 0) then
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

procedure TDotNetGeneratorSourceCodeFrame.PopularDadosEntidade(pEntidadeDTO: TEntidadeDTO);
var
  t_Indice: Integer;
  t_NomeAtributo: string;
  t_AtributoDTO: TAtributoDTO;
begin
  try
    FNextIdAtributo := 1;

    edtNomeModulo.Text         := pEntidadeDTO.NomeModulo;
    edtNomeTabela.Text         := pEntidadeDTO.NomeTabela;
    edtNomeClasseSingular.Text := pEntidadeDTO.NomeClasseSingular;
    edtNomeClassePlural.Text   := pEntidadeDTO.NomeClassePlural;
    edtNomeClasseExibicao.Text := pEntidadeDTO.NomeClasseExibicao;

    FClientDataSetAtributos.Close();
    FClientDataSetAtributos.Open();

    FClientDataSetAtributos.DisableControls();

    for t_Indice := 0 to pEntidadeDTO.Atributos.Count - 1 do
    begin
      t_AtributoDTO := TAtributoDTO(pEntidadeDTO.Atributos.Items[t_Indice]);

      FClientDataSetAtributos.Append();

      t_NomeAtributo := UpperCase(Copy(t_AtributoDTO.Nome, 1, 1)) + LowerCase(Copy(t_AtributoDTO.Nome, 2, Length(t_AtributoDTO.Nome)));

      FClientDataSetAtributos.FieldByName('Id').AsInteger := FNextIdAtributo;
      FClientDataSetAtributos.FieldByName('ParentId').AsInteger := 0;
      FClientDataSetAtributos.FieldByName('Selecionado').AsString := cSim;
      FClientDataSetAtributos.FieldByName('Nome').AsString := t_NomeAtributo;
      FClientDataSetAtributos.FieldByName('NomeExibicao').AsString := t_NomeAtributo;
      FClientDataSetAtributos.FieldByName('Tipo').AsString := t_AtributoDTO.Tipo;
//      FClientDataSetAtributos.FieldByName('ChavePrimaria').AsString := t_AtributoDTO.ChavePrimaria;

      if (t_AtributoDTO.ChaveUnica) then
        FClientDataSetAtributos.FieldByName('ChaveUnica').AsString := cSim
      else
        FClientDataSetAtributos.FieldByName('ChaveUnica').AsString := cNao;

      if (t_AtributoDTO.Requerido) then
        FClientDataSetAtributos.FieldByName('Requerido').AsString := cSim
      else
        FClientDataSetAtributos.FieldByName('Requerido').AsString := cNao;

      FClientDataSetAtributos.Post();

      Inc(FNextIdAtributo);
    end;
  finally
    FClientDataSetAtributos.EnableControls();

    tlAtributos.Refresh();
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

procedure TDotNetGeneratorSourceCodeFrame.PopularClientDataSetAtributos(pXMLData: WideString);
var
  t_cds: TClientDataSet;
  t_NomeAtributo: string;
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

        t_NomeAtributo := UpperCase(Copy(t_cds.FieldByName('Nome').AsString, 1, 1)) + LowerCase(Copy(t_cds.FieldByName('Nome').AsString, 2, Length(t_cds.FieldByName('Nome').AsString)));

        FClientDataSetAtributos.FieldByName('Id').AsInteger := FNextIdAtributo;
        FClientDataSetAtributos.FieldByName('ParentId').AsInteger := 0;
        FClientDataSetAtributos.FieldByName('Selecionado').AsString := cSim;
        FClientDataSetAtributos.FieldByName('Nome').AsString := t_NomeAtributo;
        FClientDataSetAtributos.FieldByName('NomeExibicao').AsString := t_NomeAtributo;
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

procedure TDotNetGeneratorSourceCodeFrame.PopularNomeTabela();
begin
  edtNomeTabela.Text := cmbTabelas.Text;
end;


procedure TDotNetGeneratorSourceCodeFrame.SalvarConfiguracao();
var
  t_ArquivoIni: TIniFile;
begin
  // Cria o arquivo ini no mesmo diretório da aplicação
  t_ArquivoIni := TIniFile.Create(Format('%s%s.ini', [ExtractFilePath(Application.ExeName), cToolkitConfig]));

  try
    // Grava os dados no arquivo ini
    t_ArquivoIni.WriteString(cModuloDotNetGenerator, cParametroOrigem, cmbOrigemClasse.Text);
    t_ArquivoIni.WriteString(cModuloDotNetGenerator, cParametroInstancia, edtInstanciaSQLServer.Text);
    t_ArquivoIni.WriteString(cModuloDotNetGenerator, cParametroUsuario, edtUsuarioSQLServer.Text);
    t_ArquivoIni.WriteString(cModuloDotNetGenerator, cParametroSenha, edtSenhaSQLServer.Text);
    t_ArquivoIni.WriteString(cModuloDotNetGenerator, cParametroBaseDados, cmbBaseDados.Text);
    t_ArquivoIni.WriteString(cModuloDotNetGenerator, cParametroSchema, cmbSchema.Text);
    t_ArquivoIni.WriteString(cModuloDotNetGenerator, cParametroTabela, cmbTabelas.Text);
    t_ArquivoIni.WriteString(cModuloDotNetGenerator, cParametroUltimoXMLCarregado, FUltimoArquivoCarregado);
  finally
    // Liberar a referência do arquivo da memória
    t_ArquivoIni.Free;
  end;
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
