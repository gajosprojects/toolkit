unit uDotNetGeneratorSourceCodeFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient,
  Vcl.StdCtrls, Vcl.DBCtrls, Vcl.ExtCtrls, uEntidadeDTO, MidasLib, Vcl.ComCtrls,
  ZAbstractConnection, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxStyles, cxTL, cxTLdxBarBuiltInMenu, cxDataControllerConditionalFormattingRulesManagerDialog, 
  dxSkinsCore, cxInplaceContainer, cxTLData, cxDBTL, cxMaskEdit, cxCheckBox, cxDropDownEdit,
  cxCustomData, Vcl.ExtDlgs, uArquivoDTO, System.Generics.Collections,
  Vcl.Buttons, cxTextEdit;

type
  TDotNetGeneratorSourceCodeFrame = class(TFrame)
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
    gbxModulo: TGroupBox;
    edtNomeModulo: TEdit;
    gbxAtributos: TGroupBox;
    tlAtributos: TcxDBTreeList;
    tlAtributosSelecionado: TcxDBTreeListColumn;
    tlAtributosNomeAtributo: TcxDBTreeListColumn;
    tlAtributosNomeExibicao: TcxDBTreeListColumn;
    tlAtributosTipo: TcxDBTreeListColumn;
    tlAtributosChavePrimaria: TcxDBTreeListColumn;
    tlAtributosChaveUnica: TcxDBTreeListColumn;
    tlAtributosRequerido: TcxDBTreeListColumn;
    gbxNomeTabela: TGroupBox;
    edtNomeTabela: TEdit;
    lblNomeModulo: TLabel;
    lblNomeTabela: TLabel;
    tsPreview: TTabSheet;
    tvArquivos: TTreeView;
    edtConteudo: TMemo;
    pnlAtualizarPreview: TPanel;
    btnAtualizar: TButton;
    Splitter: TSplitter;
    pnlParametros: TPanel;
    gbxTop: TGroupBox;
    btnParametros: TSpeedButton;
    btnCarregarXML: TSpeedButton;
    btnExportarXML: TSpeedButton;
    btnPreview: TSpeedButton;
    btnGerar: TSpeedButton;
    pnlOrigem: TPanel;
    gbxOrigem: TGroupBox;
    pnlDiretorio: TPanel;
    gbxDiretorioArquivos: TGroupBox;
    btnSelecionarDiretorioArquivosDotnet: TSpeedButton;
    edtDiretorioArquivosDotNet: TEdit;
    cmbOrigemClasse: TComboBox;
    gbxDiretorioXML: TGroupBox;
    btnSelecionarDiretorioXML: TSpeedButton;
    edtDiretorioXML: TEdit;
    Panel1: TPanel;
    gbxNomeEntidade: TGroupBox;
    lblNomeSingular: TLabel;
    lblNomePlural: TLabel;
    edtNomeClasseSingular: TEdit;
    edtNomeClassePlural: TEdit;
    gbxNomeClasseExibicao: TGroupBox;
    lblNomeClasseExibicao: TLabel;
    edtNomeClasseExibicao: TEdit;
    gbxNomeClasseAgregadora: TGroupBox;
    lblNomeClasseAgregadora: TLabel;
    edtNomeClasseAgregadora: TEdit;
    tlAtributosNomeCampo: TcxDBTreeListColumn;
    pnlMoverNos: TPanel;
    btnMoverParaBaixo: TSpeedButton;
    btnMoverParaCima: TSpeedButton;
    tlAtributosId: TcxDBTreeListColumn;
    tlAtributosOrdem: TcxDBTreeListColumn;
    tlAtributosLista: TcxDBTreeListColumn;
    tlAtributosChaveEstrangeira: TcxDBTreeListColumn;
    tlAtributosEntidadeBase: TcxDBTreeListColumn;

    procedure btnCarregarAtributosClick(Sender: TObject);
    procedure btnConectarSQLServerClick(Sender: TObject);
    procedure cmbBaseDadosSelect(Sender: TObject);
    procedure cmbOrigemClasseChange(Sender: TObject);
    procedure cmbSchemaSelect(Sender: TObject);
    procedure cmbTabelasSelect(Sender: TObject);
    procedure edtInstanciaSQLServerChange(Sender: TObject);
    procedure edtSenhaSQLServerChange(Sender: TObject);
    procedure edtUsuarioSQLServerChange(Sender: TObject);
    procedure tlAtributosNavigatorButtonsButtonClick(Sender: TObject; AButtonIndex: Integer; var ADone: Boolean);
    procedure tvArquivosChange(Sender: TObject; Node: TTreeNode);
    procedure btnPreviewClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure tvArquivosCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure btnCarregarXMLClick(Sender: TObject);
    procedure btnExportarXMLClick(Sender: TObject);
    procedure btnGerarClick(Sender: TObject);
    procedure btnParametrosClick(Sender: TObject);
    procedure btnSelecionarDiretorioXMLClick(Sender: TObject);
    procedure btnSelecionarDiretorioArquivosDotnetClick(Sender: TObject);
    procedure btnMoverParaBaixoClick(Sender: TObject);
    procedure btnMoverParaCimaClick(Sender: TObject);

  private
    FNextIdAtributo: Integer;
    FUltimoArquivoCarregado: string;
    FOrigemItemIndex: Integer;
    FDiretorioXML: string;
    FDiretorioArquivosDotNet: string;
    FPreviewClicked: Boolean;

    FClientDataSetAtributos: TClientDataSet;
    FDataSourceAtributos: TDataSource;
    FListaArquivos: TObjectList<TArquivoDTO>;

    FProgressBar: TProgressBar;

    { Private declarations }
    procedure InicializarFormulario();

    procedure CarregarComboTiposDotNet();
    procedure CarregarComboTiposXML();

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

    procedure PopularTreeViewPreview();

    function RetornarNoPorTexto(pNode: TTreeNode; pTexto:String; pInclusive: Boolean): TTreeNode;

    //HABILITAR COMPONENTES
    procedure HabilitarComboBaseDados();
    procedure HabilitarComboSchemas();
    procedure HabilitarComboTabelas();

    procedure HabilitarBotaoConectar();
    procedure HabilitarBotaoCarregarAtributos();

    procedure AtualizarStatusBar();

    procedure CriarEstruturaDataSetAtributos();

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
    procedure SalvarArquivos();

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

    procedure ExibirFrame(pProgressBar: TProgressBar);

  end;

implementation

uses
  uAtributoDTO, service_api_viewmodels_generator, service_api_controller_generator,
  infra_data_repository_generator, infra_data_mapping_generator, infra_data_context_generator,
  domain_entity_generator, domain_commands_generator, domain_events_generator, domain_repository_generator,
  System.UITypes, uMainDataModule, uConstantes, cxNavigator, System.IniFiles, uSerializadorXML,
  System.Contnrs, Vcl.FileCtrl;

{$R *.dfm}

{ TDotNetGeneratorSourceCodeFrame }

constructor TDotNetGeneratorSourceCodeFrame.Create(AOwner: TComponent);
begin
  inherited;

  FClientDataSetAtributos := TClientDataSet.Create(nil);
  FDataSourceAtributos := TDataSource.Create(nil);

  FListaArquivos := TObjectList<TArquivoDTO>.Create();

  InicializarFormulario();

  CarregarConfiguracao();
  CarregarComboTiposDotNet();
  CarregarComboTiposXML();
end;

procedure TDotNetGeneratorSourceCodeFrame.CriarEstruturaDataSetAtributos();
begin
  FClientDataSetAtributos.FieldDefs.Clear();
  FClientDataSetAtributos.FieldDefs.Add('Id', ftInteger);
  FClientDataSetAtributos.FieldDefs.Add('ParentId', ftInteger);
  FClientDataSetAtributos.FieldDefs.Add('Ordem', ftInteger);
  FClientDataSetAtributos.FieldDefs.Add('Selecionado', ftWideString, 1);
  FClientDataSetAtributos.FieldDefs.Add('NomeCampo', ftWideString, 100);
  FClientDataSetAtributos.FieldDefs.Add('NomeAtributo', ftWideString, 100);
  FClientDataSetAtributos.FieldDefs.Add('NomeExibicao', ftWideString, 100);
  FClientDataSetAtributos.FieldDefs.Add('Tipo', ftWideString, 50);
  FClientDataSetAtributos.FieldDefs.Add('Lista', ftWideString, 1);
  FClientDataSetAtributos.FieldDefs.Add('ChavePrimaria', ftWideString, 1);
  FClientDataSetAtributos.FieldDefs.Add('ChaveEstrangeira', ftWideString, 1);
  FClientDataSetAtributos.FieldDefs.Add('ChaveUnica', ftWideString, 1);
  FClientDataSetAtributos.FieldDefs.Add('Requerido', ftWideString, 1);
  FClientDataSetAtributos.FieldDefs.Add('EntidadeBase', ftWideString, 1);
  FClientDataSetAtributos.CreateDataSet();
  FClientDataSetAtributos.IndexFieldNames := 'Ordem';
end;

procedure TDotNetGeneratorSourceCodeFrame.InicializarFormulario();
begin
  FDataSourceAtributos.DataSet := FClientDataSetAtributos;

  cmbOrigemClasse.ItemIndex := cOrigemManual;

  tlAtributos.DataController.DataSource := FDataSourceAtributos;
  tlAtributos.DataController.KeyField := 'Id';
  tlAtributos.DataController.ParentField := 'ParentId';

  FNextIdAtributo := 1;

  FOrigemItemIndex := cOrigemManual;

  FDiretorioXML := GetCurrentDir();
  edtDiretorioXML.Text := FDiretorioXML;

  FDiretorioArquivosDotNet := GetCurrentDir();
  edtDiretorioArquivosDotNet.Text := FDiretorioArquivosDotNet;

  FPreviewClicked := False;

  btnParametrosClick(nil);

  cmbOrigemClasseChange(nil);
end;

procedure TDotNetGeneratorSourceCodeFrame.AtualizarStatusBar();
begin
  FProgressBar.Position := FProgressBar.Position + 1;
  TStatusBar(FProgressBar.Parent).Repaint();
end;

procedure TDotNetGeneratorSourceCodeFrame.btnAtualizarClick(Sender: TObject);
begin
  try
    GerarArquivos();
    PopularTreeViewPreview();
  finally

  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.btnCarregarAtributosClick(Sender: TObject);
var
  t_resposta: Boolean;
begin
  t_resposta := True;

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

        CarregarComboTiposXML();

        ShowMessage('Arquivo exportado com sucesso!');
      end;
    finally
      FreeAndNil(t_SaveXMLDialog);
    end;
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.btnGerarClick(Sender: TObject);
begin
  if (tlAtributos.IsEditing) then
    tlAtributos.Post();

  if IsValidacaoOk() then
  begin
    if SelectDirectory('Selecione o diretório', 'C:\', FDiretorioArquivosDotNet) then
    begin
      GerarArquivos();
      SalvarArquivos();
      ShowMessage('Arquivos gerados com sucesso!');
    end;
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.btnMoverParaBaixoClick(Sender: TObject);
var
  t_Id_Old: Integer;
  t_Id_New: Integer;
begin
  if Assigned(tlAtributos.FocusedNode) and (not tlAtributos.FocusedNode.IsLast) then
  begin
    t_Id_Old := tlAtributos.FocusedNode.Values[tlAtributosId.ItemIndex];

    try
      FClientDataSetAtributos.DisableControls();
      tlAtributos.BeginUpdate();

      if tlAtributos.FocusedNode.GetNext.IsLast then
      begin
        t_Id_New := tlAtributos.LastNode.Values[tlAtributosId.ItemIndex];

        if (FClientDataSetAtributos.Locate('Id', t_Id_Old, [])) then
        begin
          FClientDataSetAtributos.Edit();
          FClientDataSetAtributos.FieldByName('Ordem').AsInteger := FClientDataSetAtributos.FieldByName('Ordem').AsInteger + 1;
          FClientDataSetAtributos.Post();
        end;

        if (FClientDataSetAtributos.Locate('Id', t_Id_New, [])) then
        begin
          FClientDataSetAtributos.Edit();
          FClientDataSetAtributos.FieldByName('Ordem').AsInteger := FClientDataSetAtributos.FieldByName('Ordem').AsInteger - 1;
          FClientDataSetAtributos.Post();
        end;

        tlAtributos.FocusedNode.MoveTo(tlAtributos.LastNode,tlamAdd);
      end
      else
      begin
        t_Id_New := tlAtributos.FocusedNode.GetNext.Values[tlAtributosId.ItemIndex];

        if (FClientDataSetAtributos.Locate('Id', t_Id_Old, [])) then
        begin
          FClientDataSetAtributos.Edit();
          FClientDataSetAtributos.FieldByName('Ordem').AsInteger := FClientDataSetAtributos.FieldByName('Ordem').AsInteger + 1;
          FClientDataSetAtributos.Post();
        end;

        if (FClientDataSetAtributos.Locate('Id', t_Id_New, [])) then
        begin
          FClientDataSetAtributos.Edit();
          FClientDataSetAtributos.FieldByName('Ordem').AsInteger := FClientDataSetAtributos.FieldByName('Ordem').AsInteger - 1;
          FClientDataSetAtributos.Post();
        end;

        tlAtributos.FocusedNode.MoveTo( tlAtributos.FocusedNode.GetNext.GetNext, tlamInsert);
      end;

    finally
      FClientDataSetAtributos.Locate('Id', t_Id_Old, []);
      tlAtributos.EndUpdate();
      FClientDataSetAtributos.EnableControls();
    end;
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.btnMoverParaCimaClick(Sender: TObject);
var
  t_Id_Old: integer;
  t_Id_New: integer;
begin
  if Assigned(tlAtributos.FocusedNode) then
  begin
    t_Id_Old := tlAtributos.FocusedNode.Values[tlAtributosId.ItemIndex];
    t_Id_New := tlAtributos.FocusedNode.GetPrev.Values[tlAtributosId.ItemIndex];

    try
      FClientDataSetAtributos.DisableControls();
      tlAtributos.BeginUpdate();

      if (FClientDataSetAtributos.Locate('Id', t_Id_Old, [])) then
      begin
        FClientDataSetAtributos.Edit();
        FClientDataSetAtributos.FieldByName('Ordem').AsInteger := FClientDataSetAtributos.FieldByName('Ordem').AsInteger - 1;
        FClientDataSetAtributos.Post();
      end;

      if (FClientDataSetAtributos.Locate('Id', t_Id_New, [])) then
      begin
        FClientDataSetAtributos.Edit();
        FClientDataSetAtributos.FieldByName('Ordem').AsInteger := FClientDataSetAtributos.FieldByName('Ordem').AsInteger + 1;
        FClientDataSetAtributos.Post();
      end;

      tlAtributos.FocusedNode.MoveTo(tlAtributos.FocusedNode.getPrev, tlamInsert);

    finally
      FClientDataSetAtributos.Locate('Id', t_Id_Old, []);
      tlAtributos.EndUpdate();
      FClientDataSetAtributos.EnableControls();
    end;
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.btnParametrosClick(Sender: TObject);
begin
  if (btnParametros.AllowAllUp) then
  begin
    btnParametros.AllowAllUp := False;
    btnParametros.Down := True;
    btnParametros.Font.Style := [fsItalic];
  end else
  begin
    btnParametros.AllowAllUp := True;
    btnParametros.Down := False;
    btnParametros.Font.Style := [];
  end;

  pnlParametros.Visible := btnParametros.Down;
end;

procedure TDotNetGeneratorSourceCodeFrame.btnPreviewClick(Sender: TObject);
var
  t_PodeContinuar: Boolean;
begin
  if (not FPreviewClicked) then
  begin
    if (tlAtributos.IsEditing) then
      tlAtributos.Post();

    t_PodeContinuar := IsValidacaoOk()
  end
  else
    t_PodeContinuar := True;

  if t_PodeContinuar then
  begin
    if (not FPreviewClicked) then
    begin
      GerarArquivos();
      PopularTreeViewPreview();

      pgcGenerator.ActivePage := tsPreview;
      tsPreview.TabVisible := True;

      btnPreview.AllowAllUp := False;
      btnPreview.Down := True;
      btnPreview.Font.Style := [fsItalic];

      FPreviewClicked := True;
    end
    else
    begin
      edtConteudo.Clear();
      tvArquivos.Items.Clear();
      tsPreview.TabVisible := False;
      FListaArquivos.Clear();

      btnPreview.AllowAllUp := True;
      btnPreview.Down := False;
      btnPreview.Font.Style := [];

      FPreviewClicked := False;
    end;
  end
  else
  begin
    btnPreview.AllowAllUp := True;
    btnPreview.Down := False;
    btnPreview.Font.Style := [];
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.btnSelecionarDiretorioArquivosDotnetClick(Sender: TObject);
begin
  if SelectDirectory('Selecione o diretório', 'C:\', FDiretorioArquivosDotNet) then
  begin
    edtDiretorioArquivosDotNet.Text := FDiretorioArquivosDotNet;
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.btnSelecionarDiretorioXMLClick(Sender: TObject);
begin
  if SelectDirectory('Selecione o diretório', 'C:\', FDiretorioXML) then
  begin
    edtDiretorioXML.Text := FDiretorioXML;
    CarregarComboTiposXML();
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.CarregarComboTiposDotNet();
var
  t_SearchResult : TSearchRec;
  t_Arquivo: TStringList;
  t_Serializador: TSerializadorXML;
  t_Entidade: TEntidadeDTO;
begin
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Clear();

  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('');

  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('byte[]');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('byte');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('bool');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('char');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('decimal');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('double');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('float');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('int');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('long');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('short');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('string');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('uint');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('ulong');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('unshort');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('Boolean');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('Byte');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('Byte[]');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('DateTime');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('DateTimeOffset');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('Decimal');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('Double');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('Guid');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('Int16');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('Int32');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('Int64');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('Object');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('Single');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('String');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('TimeSpan');
  TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('Xml');

  CarregarComboTiposXML()
end;

procedure TDotNetGeneratorSourceCodeFrame.CarregarComboTiposXML();
var
  t_SearchResult : TSearchRec;
  t_Arquivo: TStringList;
  t_Serializador: TSerializadorXML;
  t_Entidade: TEntidadeDTO;
begin
  if FindFirst(Format('%s\*.xml', [FDiretorioXML]), faAnyFile, t_SearchResult) = 0 then
  begin
    TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add('');

    repeat
      t_Arquivo := TStringList.Create();
      t_Serializador := TSerializadorXML.Create();
      t_Entidade := TEntidadeDTO.Create();

      try
        try
          t_Arquivo.LoadFromFile(Format('%s\%s', [FDiretorioXML, t_SearchResult.Name]));

          t_Serializador.FromXML(t_Entidade, t_Arquivo.Text);

          TcxComboBoxProperties(tlAtributosTipo.Properties).Items.Add(t_Entidade.NomeClasseSingular);
        except
          //
        end;
      finally
        FreeAndNil(t_Entidade);
        FreeAndNil(t_Serializador);
        FreeAndNil(t_Arquivo);
      end;
    until FindNext(t_SearchResult) <> 0;

    // Must free up resources used by these successful finds
    FindClose(t_SearchResult);
  end;
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

        FOrigemItemIndex := cmbOrigemClasse.ItemIndex;

        Break;
      end;
    end;

    edtDiretorioArquivosDotNet.Text := t_ArquivoIni.ReadString(cModuloDotNetGenerator, cParametroDiretorioArquivosDotNet, EmptyStr);

    if (not SameText(edtDiretorioArquivosDotNet.Text, EmptyStr)) then
    begin
      FDiretorioArquivosDotNet := edtDiretorioArquivosDotNet.Text;
    end;

    edtDiretorioXML.Text := t_ArquivoIni.ReadString(cModuloDotNetGenerator, cParametroDiretorioXML, EmptyStr);

    if (not SameText(edtDiretorioXML.Text, EmptyStr)) then
    begin
      FDiretorioXML := edtDiretorioXML.Text;
    end;

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
        //
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

  cmbTabelas.Enabled   := (cmbOrigemClasse.ItemIndex = cOrigemTabela);

  HabilitarComboSchemas();
  HabilitarComboTabelas();
  HabilitarBotaoCarregarAtributos();
end;

procedure TDotNetGeneratorSourceCodeFrame.cmbOrigemClasseChange(Sender: TObject);
var
  t_resposta: Boolean;
begin
  case cmbOrigemClasse.ItemIndex of

    cOrigemManual:
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
        HabilitarBotaoConectar();
        HabilitarBotaoCarregarAtributos();

        tsConexao.TabVisible      := False;
        tsInstrucaoSQL.TabVisible := False;
        tsDadosClasse.TabVisible  := True;
        tsPreview.TabVisible      := False;

        pgcGenerator.ActivePage := tsDadosClasse;

        edtNomeModulo.Text           := EmptyStr;
        edtNomeTabela.Text           := EmptyStr;
        edtNomeClasseAgregadora.Text := EmptyStr;
        edtNomeClasseSingular.Text   := EmptyStr;
        edtNomeClassePlural.Text     := EmptyStr;
        edtNomeClasseExibicao.Text   := EmptyStr;

        FClientDataSetAtributos.Close();
        CriarEstruturaDataSetAtributos();
        FClientDataSetAtributos.Open();

        FOrigemItemIndex := cmbOrigemClasse.ItemIndex;
      end
      else
      begin
        cmbOrigemClasse.OnChange := nil;
        cmbOrigemClasse.ItemIndex := FOrigemItemIndex;
        cmbOrigemClasse.OnChange := cmbOrigemClasseChange;
      end;
    end;

    cOrigemTabela:
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
        HabilitarBotaoConectar();
        HabilitarBotaoCarregarAtributos();

        tsConexao.TabVisible      := True;
        tsInstrucaoSQL.TabVisible := False;
        tsDadosClasse.TabVisible  := True;
        tsPreview.TabVisible      := False;

        pgcGenerator.ActivePage := tsConexao;

        edtNomeModulo.Text           := EmptyStr;
        edtNomeTabela.Text           := EmptyStr;
        edtNomeClasseAgregadora.Text := EmptyStr;
        edtNomeClasseSingular.Text   := EmptyStr;
        edtNomeClassePlural.Text     := EmptyStr;
        edtNomeClasseExibicao.Text   := EmptyStr;

        FClientDataSetAtributos.EmptyDataSet();
        FClientDataSetAtributos.Close();

        FOrigemItemIndex := cmbOrigemClasse.ItemIndex;
      end
      else
      begin
        cmbOrigemClasse.OnChange := nil;
        cmbOrigemClasse.ItemIndex := FOrigemItemIndex;
        cmbOrigemClasse.OnChange := cmbOrigemClasseChange;
      end;
    end;
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

  if Assigned(FListaArquivos) then
    FreeAndNil(FListaArquivos);

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
  t_ServiceApiViewModelsGenerator: TServiceApiViewModelsGenerator;
  t_ServiceApiControllerGenerator: TServiceApiControllerGenerator;
  t_InfraDataRepositoryGenerator: TInfraDataRepositoryGenerator;
  t_InfraDataMapppingGenerator: TInfraDataMappingGenerator;
  t_InfraDataContextGenerator: TInfraDataContextGenerator;
  t_DomainEntityGenerator: TDomainEntityGenerator;
  t_DomainCommandsGenerator: TDomainCommandsGenerator;
  t_DomainEventsGenerator: TDomainEventsGenerator;
  t_DomainRepositoryGenerator: TDomainRepositoryGenerator;
begin
  t_ServiceApiViewModelsGenerator := TServiceApiViewModelsGenerator.Create();
  t_ServiceApiControllerGenerator := TServiceApiControllerGenerator.Create();
  t_InfraDataRepositoryGenerator := TInfraDataRepositoryGenerator.Create();
  t_InfraDataMapppingGenerator := TInfraDataMappingGenerator.Create();
  t_InfraDataContextGenerator := TInfraDataContextGenerator.Create();
  t_DomainEntityGenerator := TDomainEntityGenerator.Create();
  t_DomainCommandsGenerator := TDomainCommandsGenerator.Create();
  t_DomainEventsGenerator := TDomainEventsGenerator.Create();
  t_DomainRepositoryGenerator := TDomainRepositoryGenerator.Create();

  FProgressBar.Position := 0;
  FProgressBar.Max      := 20;

  FListaArquivos.Clear();

  try
    try
      //preenchimento do objeto t_Entidade e seus atributos
      AtualizarStatusBar();
      t_Entidade := GetViewToEntidade();

      //entity
      AtualizarStatusBar();
      FListaArquivos.Add(t_DomainEntityGenerator.getFile(t_Entidade));

      //commands
      AtualizarStatusBar();
      FListaArquivos.Add(t_DomainCommandsGenerator.generateBaseFile(t_Entidade));

      AtualizarStatusBar();
      FListaArquivos.Add(t_DomainCommandsGenerator.generateHandlerFile(t_Entidade));

      AtualizarStatusBar();
      FListaArquivos.Add(t_DomainCommandsGenerator.generateSaveFile(t_Entidade));

      AtualizarStatusBar();
      FListaArquivos.Add(t_DomainCommandsGenerator.generateUpdateFile(t_Entidade));

      AtualizarStatusBar();
      FListaArquivos.Add(t_DomainCommandsGenerator.generateDeleteFile(t_Entidade));

      //events
      AtualizarStatusBar();
      FListaArquivos.Add(t_DomainEventsGenerator.generateBaseFile(t_Entidade));

      AtualizarStatusBar();
      FListaArquivos.Add(t_DomainEventsGenerator.generateHandlerFile(t_Entidade));

      AtualizarStatusBar();
      FListaArquivos.Add(t_DomainEventsGenerator.generateSaveFile(t_Entidade));

      AtualizarStatusBar();
      FListaArquivos.Add(t_DomainEventsGenerator.generateUpdateFile(t_Entidade));

      AtualizarStatusBar();
      FListaArquivos.Add(t_DomainEventsGenerator.generateDeleteFile(t_Entidade));

      //irepository
      AtualizarStatusBar();
      FListaArquivos.Add(t_DomainRepositoryGenerator.getFile(t_Entidade));

      //context
      AtualizarStatusBar();
      FListaArquivos.Add(t_InfraDataContextGenerator.getFile(t_Entidade));

      //mapping
      AtualizarStatusBar();
      FListaArquivos.Add(t_InfraDataMapppingGenerator.getFile(t_Entidade));

      //repository
      AtualizarStatusBar();
      FListaArquivos.Add(t_InfraDataRepositoryGenerator.getFile(t_Entidade));

      //controller
      AtualizarStatusBar();
      FListaArquivos.Add(t_ServiceApiControllerGenerator.getFile(t_Entidade));

      //view_model
      AtualizarStatusBar();
      FListaArquivos.Add(t_ServiceApiViewModelsGenerator.getBaseFile(t_Entidade));

      AtualizarStatusBar();
      FListaArquivos.Add(t_ServiceApiViewModelsGenerator.getSaveFile(t_Entidade));

      AtualizarStatusBar();
      FListaArquivos.Add(t_ServiceApiViewModelsGenerator.getUpdateFile(t_Entidade));

      AtualizarStatusBar();
      FListaArquivos.Add(t_ServiceApiViewModelsGenerator.getDeleteFile(t_Entidade));

      FProgressBar.Position := FProgressBar.Min;
    except
      on E: Exception do
        ShowMessage(Format('Ocorreu um erro ao gerar os arquivos: [%s]', [E.Message]));
    end;
  finally
    if Assigned(t_ServiceApiViewModelsGenerator) then
      FreeAndNil(t_ServiceApiViewModelsGenerator);

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
    Result := 'long'
  else if SameText(LowerCase(pNomeTipo), 'binary') then
    Result := '	byte[]'
  else if SameText(LowerCase(pNomeTipo), 'bit') then
    Result := 'bool'
  else if SameText(LowerCase(pNomeTipo), 'char') then
    Result := 'string'
  else if SameText(LowerCase(pNomeTipo), 'date') then
    Result := 'DateTime'
  else if SameText(LowerCase(pNomeTipo), 'datetime') then
    Result := 'DateTime'
  else if SameText(LowerCase(pNomeTipo), 'datetime2') then
    Result := 'DateTime'
  else if SameText(LowerCase(pNomeTipo), 'datetimeoffset') then
    Result := 'DateTimeOffset'
  else if SameText(LowerCase(pNomeTipo), 'decimal') then
    Result := 'decimal'
  else if SameText(LowerCase(pNomeTipo), 'float') then
    Result := 'double'
  else if SameText(LowerCase(pNomeTipo), 'image') then
    Result := 'byte[]'
  else if SameText(LowerCase(pNomeTipo), 'int') then
    Result := 'int'
  else if SameText(LowerCase(pNomeTipo), 'money') then
    Result := 'decimal'
  else if SameText(LowerCase(pNomeTipo), 'nchar') then
    Result := 'string'
  else if SameText(LowerCase(pNomeTipo), 'ntext') then
    Result := 'string'
  else if SameText(LowerCase(pNomeTipo), 'numeric') then
    Result := 'decimal'
  else if SameText(LowerCase(pNomeTipo), 'nvarchar') then
    Result := 'string'
  else if SameText(LowerCase(pNomeTipo), 'real') then
    Result := 'Single'
  else if SameText(LowerCase(pNomeTipo), 'smalldatetime') then
    Result := 'DateTime'
  else if SameText(LowerCase(pNomeTipo), 'smallint') then
    Result := 'short'
  else if SameText(LowerCase(pNomeTipo), 'smallmoney') then
    Result := 'decimal'
  else if SameText(LowerCase(pNomeTipo), 'sql_variant') then
    Result := 'Object'
  else if SameText(LowerCase(pNomeTipo), 'text') then
    Result := 'string'
  else if SameText(LowerCase(pNomeTipo), 'time') then
    Result := 'TimeSpan'
  else if SameText(LowerCase(pNomeTipo), 'timestamp') then
    Result := 'byte[]'
  else if SameText(LowerCase(pNomeTipo), 'tinyint') then
    Result := 'byte'
  else if SameText(LowerCase(pNomeTipo), 'uniqueidentifier') then
    Result := 'Guid'
  else if SameText(LowerCase(pNomeTipo), 'varbinary') then
    Result := 'byte[]'
  else if SameText(LowerCase(pNomeTipo), 'varchar') then
    Result := 'string'
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
  Result                     := TEntidadeDTO.Create();
  Result.NomeModulo          := edtNomeModulo.Text;
  Result.NomeTabela          := edtNomeTabela.Text;
  Result.NomeClasseAgregacao := edtNomeClasseAgregadora.Text;
  Result.NomeClasseSingular  := edtNomeClasseSingular.Text;
  Result.NomeClassePlural    := edtNomeClassePlural.Text;
  Result.NomeClasseExibicao  := edtNomeClasseExibicao.Text;

  if (SameText(Trim(Result.NomeClasseAgregacao), EmptyStr)) then
  begin
    Result.NomeClasseAgregacao := Result.NomeClassePlural;
  end;

  //loop nos atributos
  try
    FClientDataSetAtributos.DisableControls();

    FClientDataSetAtributos.First();

    while (not FClientDataSetAtributos.Eof) do
    begin
      if (SameText(FClientDataSetAtributos.FieldByName('Selecionado').AsString, cSim)) then
      begin
        t_Atributo := TAtributoDTO.Create();

        t_Atributo.Ordem                := FClientDataSetAtributos.FieldByName('Ordem').AsInteger;
        t_Atributo.NomeCampo            := FClientDataSetAtributos.FieldByName('NomeCampo').AsString;
        t_Atributo.NomeAtributo         := FClientDataSetAtributos.FieldByName('NomeAtributo').AsString;
        t_Atributo.NomeExibicao         := FClientDataSetAtributos.FieldByName('NomeExibicao').AsString;
        t_Atributo.Tipo                 := FClientDataSetAtributos.FieldByName('Tipo').AsString;
//        t_Atributo.Lista                := SameText(FClientDataSetAtributos.FieldByName('Lista').AsString, cSim);
        t_Atributo.ChavePrimaria        := SameText(FClientDataSetAtributos.FieldByName('ChavePrimaria').AsString, cSim);
//        t_Atributo.ChaveEstrangeira     := SameText(FClientDataSetAtributos.FieldByName('ChaveEstrangeira').AsString, cSim);
        t_Atributo.ChaveUnica           := SameText(FClientDataSetAtributos.FieldByName('ChaveUnica').AsString, cSim);
        t_Atributo.Requerido            := SameText(FClientDataSetAtributos.FieldByName('Requerido').AsString, cSim);
        t_Atributo.EntidadeBase         := SameText(FClientDataSetAtributos.FieldByName('EntidadeBase').AsString, cSim);

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
  t_Pks: Integer;
  t_TipoNaoInformado: Integer;
begin
  Result := False;

  if SameText(Trim(edtNomeModulo.Text), EmptyStr) then
  begin
    ShowMessage('Nome do módulo é obrigatório');

    if edtNomeModulo.CanFocus() then
      edtNomeModulo.SetFocus();

    Exit
  end;

  if SameText(Trim(edtNomeTabela.Text), EmptyStr) then
  begin
    ShowMessage('Nome da tabela é obrigatório');

    if edtNomeTabela.CanFocus() then
      edtNomeTabela.SetFocus();

    Exit
  end;

  if SameText(Trim(edtNomeClasseSingular.Text), EmptyStr) then
  begin
    ShowMessage('Nome da classe no singular é obrigatório');

    if edtNomeClasseSingular.CanFocus() then
      edtNomeClasseSingular.SetFocus();

    Exit
  end;

  if SameText(Trim(edtNomeClassePlural.Text), EmptyStr) then
  begin
    ShowMessage('Nome da classe no plural é obrigatório');

    if edtNomeClassePlural.CanFocus() then
      edtNomeClassePlural.SetFocus();

    Exit
  end;

  if SameText(Trim(edtNomeClasseExibicao.Text), EmptyStr) then
  begin
    ShowMessage('Nome de exibição da classe é obrigatório');

    if edtNomeClasseExibicao.CanFocus() then
      edtNomeClasseExibicao.SetFocus();

    Exit
  end;

  if (FClientDataSetAtributos.RecordCount = 0) then
  begin
    ShowMessage('Ao menos um atributo é obrigatório');

    if tlAtributos.CanFocus() then
      tlAtributos.SetFocus();

    Exit
  end;

  t_Selecionado := 0;
  t_Pks := 0;
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

      if SameText(FClientDataSetAtributos.FieldByName('ChavePrimaria').AsString, cSim) then
      begin
        Inc(t_Pks);
      end;

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

    if tlAtributos.CanFocus() then
      tlAtributos.SetFocus();

    Exit
  end;

  if (t_Pks = 0) then
  begin
    ShowMessage('Ao menos um atributo deve ser chave primária');

    if tlAtributos.CanFocus() then
      tlAtributos.SetFocus();

    Exit
  end;

  if (t_TipoNaoInformado > 0) then
  begin
    ShowMessage('Existe(m) atributo(s) sem tipo informado');

    if tlAtributos.CanFocus() then
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
  t_AtributoDTO: TAtributoDTO;
begin
  try
    FNextIdAtributo := 1;

    edtNomeModulo.Text           := pEntidadeDTO.NomeModulo;
    edtNomeTabela.Text           := pEntidadeDTO.NomeTabela;
    edtNomeClasseAgregadora.Text := pEntidadeDTO.NomeClasseAgregacao;
    edtNomeClasseSingular.Text   := pEntidadeDTO.NomeClasseSingular;
    edtNomeClassePlural.Text     := pEntidadeDTO.NomeClassePlural;
    edtNomeClasseExibicao.Text   := pEntidadeDTO.NomeClasseExibicao;

    FClientDataSetAtributos.Close();
    FClientDataSetAtributos.Open();

    FClientDataSetAtributos.DisableControls();

    for t_Indice := 0 to pEntidadeDTO.Atributos.Count - 1 do
    begin
      t_AtributoDTO := TAtributoDTO(pEntidadeDTO.Atributos.Items[t_Indice]);

      FClientDataSetAtributos.Append();

      FClientDataSetAtributos.FieldByName('Id').AsInteger := FNextIdAtributo;
      FClientDataSetAtributos.FieldByName('Ordem').AsInteger := t_AtributoDTO.Ordem;
      FClientDataSetAtributos.FieldByName('ParentId').AsInteger := 0;
      FClientDataSetAtributos.FieldByName('Selecionado').AsString := cSim;
      FClientDataSetAtributos.FieldByName('NomeAtributo').AsString := t_AtributoDTO.NomeAtributo;
      FClientDataSetAtributos.FieldByName('NomeExibicao').AsString := t_AtributoDTO.NomeExibicao;
      FClientDataSetAtributos.FieldByName('NomeCampo').AsString := t_AtributoDTO.NomeCampo;
      FClientDataSetAtributos.FieldByName('Tipo').AsString := t_AtributoDTO.Tipo;

//      if (t_AtributoDTO.Lista) then
//        FClientDataSetAtributos.FieldByName('Lista').AsString := cSim
//      else
//        FClientDataSetAtributos.FieldByName('Lista').AsString := cNao;

      if (t_AtributoDTO.ChavePrimaria) then
        FClientDataSetAtributos.FieldByName('ChavePrimaria').AsString := cSim
      else
        FClientDataSetAtributos.FieldByName('ChavePrimaria').AsString := cNao;

//      if (t_AtributoDTO.ChaveEstrangeira) then
//        FClientDataSetAtributos.FieldByName('ChaveEstrangeira').AsString := cSim
//      else
//        FClientDataSetAtributos.FieldByName('ChaveEstrangeira').AsString := cNao;

      if (t_AtributoDTO.ChaveUnica) then
        FClientDataSetAtributos.FieldByName('ChaveUnica').AsString := cSim
      else
        FClientDataSetAtributos.FieldByName('ChaveUnica').AsString := cNao;

      if (t_AtributoDTO.Requerido) then
        FClientDataSetAtributos.FieldByName('Requerido').AsString := cSim
      else
        FClientDataSetAtributos.FieldByName('Requerido').AsString := cNao;

      if (t_AtributoDTO.EntidadeBase) then
        FClientDataSetAtributos.FieldByName('EntidadeBase').AsString := cSim
      else
        FClientDataSetAtributos.FieldByName('EntidadeBase').AsString := cNao;

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
        FClientDataSetAtributos.FieldByName('Ordem').AsInteger := FNextIdAtributo;
        FClientDataSetAtributos.FieldByName('ParentId').AsInteger := 0;
        FClientDataSetAtributos.FieldByName('Selecionado').AsString := cSim;
        FClientDataSetAtributos.FieldByName('NomeCampo').AsString := t_cds.FieldByName('Nome').AsString;
        FClientDataSetAtributos.FieldByName('NomeAtributo').AsString := t_NomeAtributo;
        FClientDataSetAtributos.FieldByName('NomeExibicao').AsString := t_NomeAtributo;
        FClientDataSetAtributos.FieldByName('Tipo').AsString := GetTipoAtributoDotNetFromSQLServer(t_cds.FieldByName('Tipo').AsString);
        FClientDataSetAtributos.FieldByName('Lista').AsString := t_cds.FieldByName('Lista').AsString;
        FClientDataSetAtributos.FieldByName('ChavePrimaria').AsString := t_cds.FieldByName('ChavePrimaria').AsString;
        FClientDataSetAtributos.FieldByName('ChaveEstrangeira').AsString := t_cds.FieldByName('ChaveEstrangeira').AsString;
        FClientDataSetAtributos.FieldByName('TipoChaveEstrangeira').AsString := t_cds.FieldByName('TipoChaveEstrangeira').AsString;
        FClientDataSetAtributos.FieldByName('ChaveUnica').AsString := t_cds.FieldByName('ChaveUnica').AsString;
        FClientDataSetAtributos.FieldByName('Requerido').AsString := t_cds.FieldByName('Requerido').AsString;
        FClientDataSetAtributos.FieldByName('EntidadeBase').AsString := t_cds.FieldByName('EntidadeBase').AsString;
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

procedure TDotNetGeneratorSourceCodeFrame.PopularTreeViewPreview();
var
  t_Arquivo: TArquivoDTO;
  t_Aux: TStringList;
  t_Indice: Integer;
  t_RootLevel: Boolean;
  t_RootNode: TTreeNode;
  t_Node: TTreeNode;
begin
  t_RootNode := nil;

  tvArquivos.Items.Clear();

  for t_Arquivo in FListaArquivos do
  begin
    t_RootLevel := True;

    t_Aux := TStringList.Create();

    try
      t_Aux.Delimiter := '\';
      t_Aux.DelimitedText := t_Arquivo.Diretorio;

      for t_Indice := 0 to t_Aux.Count -1 do
      begin
        if (t_RootLevel) then
        begin
          if (not SameText(Trim(t_Aux[t_Indice]), EmptyStr)) then
          begin
            if Assigned(t_RootNode) then
              t_Node := RetornarNoPorTexto(t_RootNode, t_Aux[t_Indice], True)
            else
              t_Node := RetornarNoPorTexto(nil, t_Aux[t_Indice], False);

            if (not Assigned(t_Node)) then
            begin
              t_Node := tvArquivos.Items.Add(t_RootNode, t_Aux[t_Indice]);
            end;

            t_Node.Selected := True;

            if (not Assigned(t_RootNode)) then
            begin
              t_RootNode := RetornarNoPorTexto(t_Node, t_Aux[t_Indice], True);
            end;

            t_RootLevel := False;
          end;
        end
        else
        begin
          if (not SameText(Trim(t_Aux[t_Indice]), EmptyStr)) then
          begin
            t_Node := RetornarNoPorTexto(tvArquivos.Selected.getFirstChild(), t_Aux[t_Indice], True);

            if (not Assigned(t_Node)) then
            begin
              t_Node := tvArquivos.Items.AddChild(tvArquivos.Selected, t_Aux[t_Indice]);
            end;

            t_Node.Selected := True;
          end;
        end;
      end;

      tvArquivos.Items.AddChildObject(tvArquivos.Selected, t_Arquivo.Nome, t_Arquivo);
    finally
      FreeAndNil(t_Aux);
    end;
  end;

  for t_Indice := 0 to tvArquivos.Items.Count - 1 do
  begin
    tvArquivos.Items.Item[t_Indice].Collapse(True);
    tvArquivos.Items.Item[t_Indice].Selected := False;
  end;

  edtConteudo.Clear();
end;

function TDotNetGeneratorSourceCodeFrame.RetornarNoPorTexto(pNode: TTreeNode; pTexto:String; pInclusive: Boolean): TTreeNode;
var
  t_TestNode: TTreeNode;
begin
  Result := nil;

  if Assigned(pNode) then
  begin
    if (pInclusive) then
    begin
      if (SameText(pNode.Text, pTexto)) then
      begin
        Result := pNode;
        Exit;
      end;
    end;

    t_TestNode := pNode;

    repeat
      t_TestNode := t_TestNode.GetPrevSibling();

      if Assigned(t_TestNode) then
      begin
        if (SameText(t_TestNode.Text, pTexto)) then
        begin
          Result := t_TestNode;
          Exit;
        end;
      end
    until (t_TestNode = nil);

    t_TestNode := pNode;

    repeat
      t_TestNode := t_TestNode.GetNextSibling();

      if Assigned(t_TestNode) then
      begin
        if (SameText(t_TestNode.Text, pTexto)) then
        begin
          Result := t_TestNode;
          Exit;
        end;
      end;
    until (t_TestNode = nil);
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.SalvarArquivos();
var
  t_Arquivo: TArquivoDTO;
  t_SaveFile: TStringList;
  t_Diretorio: string;
begin
  for t_Arquivo in FListaArquivos do
  begin
    t_SaveFile := TStringList.Create();

    try
      t_SaveFile.Add(t_Arquivo.Conteudo);

      t_Diretorio := Format('%s\%s', [FDiretorioArquivosDotNet, t_Arquivo.Diretorio]);

      if (not DirectoryExists(t_Diretorio)) then
      begin
        ForceDirectories(t_Diretorio);
      end;

      t_SaveFile.SaveToFile(Format('%s%s', [t_Diretorio, t_Arquivo.Nome]));
    finally
      FreeAndNil(t_SaveFile);
    end;
  end;
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
    t_ArquivoIni.WriteString(cModuloDotNetGenerator, cParametroDiretorioXML, FDiretorioXML);
    t_ArquivoIni.WriteString(cModuloDotNetGenerator, cParametroDiretorioArquivosDotNet, FDiretorioArquivosDotNet);
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
    FClientDataSetAtributos.FieldByName('Ordem').AsInteger := FNextIdAtributo;
    FClientDataSetAtributos.FieldByName('ParentId').AsInteger := 0;
    FClientDataSetAtributos.FieldByName('Selecionado').AsString := cSim;
    FClientDataSetAtributos.FieldByName('Lista').AsString := cNao;
    FClientDataSetAtributos.FieldByName('ChavePrimaria').AsString := cNao;
    FClientDataSetAtributos.FieldByName('ChaveEstrangeira').AsString := cNao;
    FClientDataSetAtributos.FieldByName('ChaveUnica').AsString := cNao;
    FClientDataSetAtributos.FieldByName('Requerido').AsString := cNao;
    FClientDataSetAtributos.FieldByName('EntidadeBase').AsString := cNao;

    Inc(FNextIdAtributo);

    ADone := True;
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.tvArquivosChange(Sender: TObject; Node: TTreeNode);
var
  t_Arquivo: TArquivoDTO;
begin
  if Assigned(Node) then
  begin
    if (not Node.HasChildren) then
    begin
      if Assigned(Node) then
      begin
        t_Arquivo := Node.Data;

        if Assigned(t_Arquivo) then
        begin
          edtConteudo.Enabled := True;
          edtConteudo.Color := clWindow;
          edtConteudo.Clear();
          edtConteudo.Lines.BeginUpdate();
          edtConteudo.Lines.Add(t_Arquivo.Conteudo);
          edtConteudo.Lines.EndUpdate();
        end;
      end;
    end
    else
    begin
      edtConteudo.Clear();
      edtConteudo.Enabled := False;
      edtConteudo.Color := clBtnFace;
    end;
  end;
end;

procedure TDotNetGeneratorSourceCodeFrame.tvArquivosCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if (not Node.HasChildren) then
  begin
    (Sender as TCustomTreeView).Canvas.Font.Style := [fsBold];
  end;
end;

end.
