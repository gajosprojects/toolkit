unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ImgList, System.ImageList, Vcl.DBCtrls,
  Vcl.ExtCtrls, uEntidadeDTO, MidasLib;

type
  TMain = class(TForm)
    cdsAtributos: TClientDataSet;
    cdsAtributosNome: TStringField;
    cdsAtributosSelecionado: TStringField;
    dsAtributos: TDataSource;
    pnlOrigem: TPanel;
    btnGerar: TButton;
    gbxAtributos: TGroupBox;
    dbgAtributos: TDBGrid;
    cdsAtributosTipo: TStringField;
    dbnAtributos: TDBNavigator;
    pnlEntidade: TPanel;
    gbxNomeEntidade: TGroupBox;
    lblNomeSingular: TLabel;
    lblNomePlural: TLabel;
    txtNomeSingular: TEdit;
    txtNomePlural: TEdit;
    gbxModulo: TGroupBox;
    txtNomeModulo: TEdit;
    cdsAtributosChavePrimaria: TStringField;
    cdsAtributosNomeExibicao: TStringField;
    cdsAtributosRequerido: TStringField;
    cdsAtributosChaveUnica: TStringField;
    procedure dbgAtributosDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgAtributosCellClick(Column: TColumn);
    procedure dbgAtributosColEnter(Sender: TObject);
    procedure cdsAtributosSelecionadoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure dbnAtributosClick(Sender: TObject; Button: TNavigateBtn);
    procedure FormCreate(Sender: TObject);
    procedure btnGerarClick(Sender: TObject);
    procedure cdsAtributosChavePrimariaGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure cdsAtributosRequeridoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    { Private declarations }
    procedure CriarDataSetAtributos();

    function IsColunaBoolean(pNomeColuna: string): Boolean;
    function IsValidacaoOk(): Boolean;

    function GetViewToEntidade(): TEntidadeDTO;

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

var
  Main: TMain;

implementation

{$R *.dfm}

uses
  uAtributoDTO, service_api_view_model_generator, service_api_controller_generator,
  infra_data_repository_generator, infra_data_mapping_generator, infra_data_context_generator,
  domain_entity_generator, domain_commands_generator, domain_events_generator;

procedure TMain.btnGerarClick(Sender: TObject);
begin
  if IsValidacaoOk() then
    GerarArquivos();
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

procedure TMain.CriarDataSetAtributos();
begin
  cdsAtributos.Close();

  cdsAtributos.CreateDataSet();

  cdsAtributos.Open();

  with TStringList.Create() do
  begin
    Add('TO-DO:');
    Add('');
    Add('Commands: flag para preencher data de cadastro no save e data de modificacao no update/delete');
    ShowMessage('')
  end;

end;

procedure TMain.dbgAtributosCellClick(Column: TColumn);
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
    cdsAtributos.Edit;
    cdsAtributos.FieldByName(sNomeColuna).AsString := sValorColuna;
    cdsAtributos.Post;
  end;
end;

procedure TMain.dbgAtributosColEnter(Sender: TObject);
var
  sNomeColuna: string;
begin
  sNomeColuna := dbgAtributos.SelectedField.FieldName;
  // controla a edição da célula
  if (IsColunaBoolean(sNomeColuna)) then
    dbgAtributos.Options := dbgAtributos.Options - [dgEditing]
  else
    dbgAtributos.Options := dbgAtributos.Options + [dgEditing];
end;

procedure TMain.dbgAtributosDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  nMarcar: word;
  oRetangulo: TRect;
  sNomeColuna: string;
begin
  // verifica se o registro está inativo
  if (cdsAtributos.FieldByName('Selecionado').AsString = 'N') then
  begin
    dbgAtributos.Canvas.Font.Style := [fsStrikeOut];

    // pinta a linha
    dbgAtributos.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;

  sNomeColuna := Column.FieldName;

  if (IsColunaBoolean(sNomeColuna)) then
  begin
    dbgAtributos.Canvas.FillRect(Rect);

    if SameText(Column.Field.AsString, cSim) then
      nMarcar := DFCS_CHECKED
    else
      nMarcar := DFCS_BUTTONCHECK;

    // ajusta o tamanho do CheckBox
    oRetangulo := Rect;
    InflateRect(oRetangulo, -2, -2);

    // desenha o CheckBox na célula conforme a condição acima
    DrawFrameControl(dbgAtributos.Canvas.Handle, oRetangulo, DFC_BUTTON, nMarcar);
  end;
end;

procedure TMain.dbnAtributosClick(Sender: TObject; Button: TNavigateBtn);
begin
  if (Button = nbInsert) then
  begin
    cdsAtributos.Append();
    cdsAtributos.FieldByName('Selecionado').AsString := cSim;
    cdsAtributos.FieldByName('ChavePrimaria').AsString := cNao;
    cdsAtributos.FieldByName('ChaveUnica').AsString := cNao;
    cdsAtributos.FieldByName('Requerido').AsString := cNao;
    cdsAtributos.Post;
    dbgAtributos.SelectedIndex := 0;
  end
  else if (Button = nbEdit) then
  begin
    cdsAtributos.Edit();
    dbgAtributos.SelectedIndex := 0;
  end;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  CriarDataSetAtributos();
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

function TMain.GetViewToEntidade(): TEntidadeDTO;
var
  Atributo: TAtributoDTO;
begin
  //preenchimento do objeto entidade e seus atributos
  Result                    := TEntidadeDTO.Create();
  Result.NomeModulo         := txtNomeModulo.Text;
  Result.NomeClasseSingular := txtNomeSingular.Text;
  Result.NomeClassePlural   := txtNomePlural.Text;

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

function TMain.IsColunaBoolean(pNomeColuna: string): Boolean;
var
  t_indice: Integer;
begin
  Result := False;

  for t_Indice := Low(aColunasBoolean) to High(aColunasBoolean) do
  begin
    Result := SameText(AnsiUpperCase(pNomeColuna), AnsiUpperCase(aColunasBoolean[t_Indice]));

    if Result then
      Break;
  end;
end;

function TMain.IsValidacaoOk(): Boolean;
begin
  Result := False;
  //validacao
      //verificar se exista algum atributo marcado
      //verificar se os tipos informados sao validos
      //verificar se existe apenas uma pk marcada

  Result := True;
end;

end.
