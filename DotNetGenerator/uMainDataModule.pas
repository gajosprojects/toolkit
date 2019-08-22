unit uMainDataModule;

interface

uses
  System.SysUtils, System.Classes, ZAbstractRODataset, ZDataset,
  Datasnap.Provider, Data.DB, Datasnap.DBClient, ZAbstractConnection,
  ZConnection;

type
  TMainDataModule = class(TDataModule)
    conBD: TZConnection;
    dsAtributos: TDataSource;
    cdsAtributos: TClientDataSet;
    cdsAtributosSelecionado: TWideStringField;
    cdsAtributosNome: TWideStringField;
    cdsAtributosNomeExibicao: TWideStringField;
    cdsAtributosTipo: TWideStringField;
    cdsAtributosChavePrimaria: TWideStringField;
    cdsAtributosChaveUnica: TWideStringField;
    cdsAtributosRequerido: TWideStringField;
    dsBaseDados: TDataSource;
    cdsBaseDados: TClientDataSet;
    cdsBaseDadosNome: TWideStringField;
    dspBaseDados: TDataSetProvider;
    qryBaseDados: TZReadOnlyQuery;
    qryTabelas: TZReadOnlyQuery;
    dspTabelas: TDataSetProvider;
    cdsTabelas: TClientDataSet;
    cdsTabelasNome: TWideStringField;
    dsTabelas: TDataSource;
    cdsAux: TClientDataSet;
    cdsAuxNome: TWideStringField;
    cdsAuxTipo: TWideStringField;
    cdsAuxChavePrimaria: TWideStringField;
    cdsAuxChaveUNica: TWideStringField;
    cdsAuxRequerido: TWideStringField;
    dspAux: TDataSetProvider;
    qryAux: TZReadOnlyQuery;
    cdsAtributosNomeAtributo: TStringField;
    cdsAtributosLista: TWideStringField;
    cdsAtributosChaveEstrangeira: TWideStringField;
    cdsAtributosTipoChaveEstrangeira: TWideStringField;
  private
    { Private declarations }
  public
    { Public declarations }

    function Get(): TMainDataModule;

    procedure OpenConnection();
    procedure CloseConnection();

    function ValidarConexaoSQLServer(p_Instancia: string; p_Usuario: string; p_Senha: string; p_BaseDados: string = 'master'): Boolean;

    function GetAtributosSQLServer(pNomeTabela: string): WideString;
    function GetTabelasSQLServer(): WideString;
    function GetBasesDeDadosSQLServer(): WideString;
  end;

var
  MainDataModule: TMainDataModule;

implementation

uses
  uConstantes;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModule2 }

function TMainDataModule.Get(): TMainDataModule;
begin
  if not Assigned(MainDataModule) then
  begin
    MainDataModule := TMainDataModule.Create(nil);
  end;

  Result := MainDataModule;

end;

function TMainDataModule.GetAtributosSQLServer(pNomeTabela: string): WideString;
begin
  Result := EmptyWideStr;

  if (cdsAux.Active) then
    cdsAux.Close();

  qryAux.SQL.Clear();

  qryAux.SQL.Add('declare @Colunas table(column_id int,');
  qryAux.SQL.Add('                       column_name sysname,');
  qryAux.SQL.Add('                       type_name sysname,');
  qryAux.SQL.Add('                       precision int,');
  qryAux.SQL.Add('                       max_length int,');
  qryAux.SQL.Add('                       is_nullable smallint)');
  qryAux.SQL.Add('insert into @Colunas(column_id,');
  qryAux.SQL.Add('                     column_name,');
  qryAux.SQL.Add('                     type_name,');
  qryAux.SQL.Add('                     precision,');
  qryAux.SQL.Add('                     max_length,');
  qryAux.SQL.Add('                     is_nullable)');
  qryAux.SQL.Add('select');
  qryAux.SQL.Add('	  col.column_id,');
  qryAux.SQL.Add('    col.name as column_name,');
  qryAux.SQL.Add('    t.name as type_name,');
  qryAux.SQL.Add('    col.precision,');
  qryAux.SQL.Add('  	col.max_length,');
  qryAux.SQL.Add('  	col.is_nullable');
  qryAux.SQL.Add('from sys.tables as tab');
  qryAux.SQL.Add('inner join sys.columns as col on tab.object_id = col.object_id');
  qryAux.SQL.Add('left join sys.types as t on col.user_type_id = t.user_type_id');
  qryAux.SQL.Add(Format('where tab.name = %s', [QuotedStr(pNomeTabela)]));
  qryAux.SQL.Add('  order by column_id;');
  qryAux.SQL.Add('');
  qryAux.SQL.Add('declare @ColunasPk table(column_name sysname)');
  qryAux.SQL.Add('insert into @ColunasPk (column_name)');
  qryAux.SQL.Add('select ccu.column_name');
  qryAux.SQL.Add('from information_schema.table_constraints tc');
  qryAux.SQL.Add('inner join information_schema.constraint_column_usage ccu on tc.constraint_name = ccu.constraint_name');
  qryAux.SQL.Add(Format('where tc.constraint_type = %s', [QuotedStr('Primary Key')]));
  qryAux.SQL.Add(Format('  and tc.table_name = %s;', [QuotedStr(pNomeTabela)]));
  qryAux.SQL.Add('');
  qryAux.SQL.Add('declare @ColunasUk table(column_name sysname)');
  qryAux.SQL.Add('insert into @ColunasUk (column_name)');
  qryAux.SQL.Add('select ccu.column_name');
  qryAux.SQL.Add('from information_schema.table_constraints tc');
  qryAux.SQL.Add('inner join information_schema.constraint_column_usage ccu on tc.constraint_name = ccu.constraint_name');
  qryAux.SQL.Add(Format('where tc.constraint_type = %s', [QuotedStr('Unique')]));
  qryAux.SQL.Add(Format('  and tc.table_name = %s;', [QuotedStr(pNomeTabela)]));
  qryAux.SQL.Add('');
  qryAux.SQL.Add('select');
  qryAux.SQL.Add('	col.column_name as nome,');
  qryAux.SQL.Add('	col.type_name as tipo,');
  qryAux.SQL.Add(Format('	 (case len(coalesce(colpk.column_name, %s)) when 0 then cast(%s as char(1)) else cast(%s as char(1)) end) as chaveprimaria,', [QuotedStr(EmptyStr), QuotedStr(cNao), QuotedStr(cSim)]));
  qryAux.SQL.Add(Format('  (case len(coalesce(coluk.column_name, %s)) when 0 then cast(%s as char(1)) else cast(%s as char(1)) end) as chaveunica,', [QuotedStr(EmptyStr), QuotedStr(cNao), QuotedStr(cSim)]));
  qryAux.SQL.Add(Format('	 (case col.is_nullable when 0 then cast(%s as char(1)) else cast(%s as char(1)) end) as requerido,', [QuotedStr(cSim), QuotedStr(cNao)]));
  qryAux.SQL.Add(Format('	 cast(%s as char(1)) as chaveestrangeira,', [QuotedStr(cNao)]));
  qryAux.SQL.Add(Format('	 cast(%s as char(1)) as lista,', [QuotedStr(cNao)]));
qryAux.SQL.Add(Format('  %s as tipochaveestrangeira', [QuotedStr(EmptyStr)]));
  qryAux.SQL.Add('from @Colunas col');
  qryAux.SQL.Add('left join @ColunasPK colpk on colpk.column_name = col.column_name');
  qryAux.SQL.Add('left join @ColunasUK coluk on coluk.column_name = col.column_name');

  try
    try
      OpenConnection();

      cdsAux.Open();

      Result := cdsAux.XMLData;
    except
      on E: Exception do
      begin

      end
    end;
  finally
    cdsAux.Close();

    CloseConnection();
  end;
end;

function TMainDataModule.GetBasesDeDadosSQLServer(): WideString;
begin
  Result := EmptyWideStr;

  if (cdsBaseDados.Active) then
    cdsBaseDados.Close();

  qryBaseDados.SQL.Clear();
  qryBaseDados.SQL.Add('SELECT NAME AS NOME');
  qryBaseDados.SQL.Add('FROM SYS.DATABASES');
  qryBaseDados.SQL.Add('ORDER BY NAME');

  try
    try
      OpenConnection();

      cdsBaseDados.Open();

      Result := cdsBaseDados.XMLData
    except
      on E: Exception do
      begin

      end;
    end;
  finally
    cdsBaseDados.Close();

    CloseConnection();
  end;
end;

function TMainDataModule.GetTabelasSQLServer(): WideString;
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
      OpenConnection();

      cdsTabelas.Open();

      Result := cdsTabelas.XMLData
    except
      on E: Exception do
      begin

      end;
    end;
  finally
    cdsTabelas.Close();

    CloseConnection();
  end;
end;

procedure TMainDataModule.OpenConnection();
begin
  conBD.Connect();
end;

procedure TMainDataModule.CloseConnection();
begin
  if conBD.Connected then
  begin
    conBD.Disconnect();
  end;
end;

function TMainDataModule.ValidarConexaoSQLServer(p_Instancia, p_Usuario, p_Senha, p_BaseDados: string): Boolean;
begin
  Result := False;

  CloseConnection();

  conBD.Protocol := 'ado';
  conBD.Database := Format('Provider=SQLOLEDB.1;Persist Security Info=True;Data Source=%s;Initial Catalog=%s;User ID=%s;Password=%s',
                           [p_Instancia, p_BaseDados, p_Usuario, p_Senha]);
  try
    try
      OpenConnection();

      if (conBD.Connected) then
        Result := True;
    except
      on E: Exception do
        raise Exception.CreateFmt('Não foi possível conectar ao banco de dados (%s)%s[%s]',
                                  [conBD.Database, sLineBreak, E.Message]);
    end;
  finally
    CloseConnection();
  end;
end;

end.
