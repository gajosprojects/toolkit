object Main: TMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '.Net Files Generator - Gajos  Project'
  ClientHeight = 571
  ClientWidth = 794
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object gbxOrigem: TGroupBox
    Left = 0
    Top = 0
    Width = 794
    Height = 52
    Align = alTop
    Caption = 'Origem'
    TabOrder = 0
    object cmbOrigemClasse: TComboBox
      Left = 15
      Top = 22
      Width = 161
      Height = 21
      TabOrder = 0
      TextHint = 'Selecione'
      OnChange = cmbOrigemClasseChange
      Items.Strings = (
        'Manual'
        'Tabela')
    end
    object btnGerar: TButton
      Left = 704
      Top = 20
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Gerar'
      TabOrder = 1
      OnClick = btnGerarClick
    end
  end
  object gbxGenerator: TGroupBox
    Left = 0
    Top = 52
    Width = 794
    Height = 519
    Align = alClient
    TabOrder = 1
    object pgcGenerator: TPageControl
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 784
      Height = 496
      ActivePage = tsDadosClasse
      Align = alClient
      TabOrder = 0
      object tsConexao: TTabSheet
        Caption = 'Conex'#227'o'
        ImageIndex = 1
        object gbxDadosConexaoSQLServer: TGroupBox
          Left = 0
          Top = 0
          Width = 776
          Height = 68
          Align = alTop
          Caption = 'Dados'
          TabOrder = 0
          object edtInstanciaSQLServer: TLabeledEdit
            Left = 8
            Top = 36
            Width = 161
            Height = 21
            EditLabel.Width = 44
            EditLabel.Height = 13
            EditLabel.Caption = 'Inst'#226'ncia'
            TabOrder = 0
            TextHint = 'Exemplo: .\SQLEXPRESS'
            OnChange = edtInstanciaSQLServerChange
          end
          object edtUsuarioSQLServer: TLabeledEdit
            Left = 181
            Top = 36
            Width = 161
            Height = 21
            EditLabel.Width = 36
            EditLabel.Height = 13
            EditLabel.Caption = 'Usu'#225'rio'
            TabOrder = 1
            TextHint = 'Exemplo: sa'
            OnChange = edtUsuarioSQLServerChange
          end
          object edtSenhaSQLServer: TLabeledEdit
            Left = 354
            Top = 36
            Width = 161
            Height = 21
            EditLabel.Width = 30
            EditLabel.Height = 13
            EditLabel.Caption = 'Senha'
            PasswordChar = '*'
            TabOrder = 2
            OnChange = edtSenhaSQLServerChange
          end
          object btnConectarSQLServer: TButton
            Left = 527
            Top = 34
            Width = 75
            Height = 25
            Cancel = True
            Caption = 'Conectar'
            TabOrder = 3
            OnClick = btnConectarSQLServerClick
          end
        end
        object gbxBaseDados: TGroupBox
          Left = 0
          Top = 68
          Width = 776
          Height = 68
          Align = alTop
          Caption = 'Base'
          TabOrder = 1
          object lblBaseDados: TLabel
            Left = 8
            Top = 20
            Width = 71
            Height = 13
            Caption = 'Base de Dados'
          end
          object lblSchema: TLabel
            Left = 181
            Top = 20
            Width = 37
            Height = 13
            Caption = 'Schema'
          end
          object lblTabela: TLabel
            Left = 354
            Top = 20
            Width = 32
            Height = 13
            Caption = 'Tabela'
          end
          object cmbBaseDados: TComboBox
            Left = 8
            Top = 36
            Width = 161
            Height = 21
            TabOrder = 0
            TextHint = 'Selecione'
            OnSelect = cmbBaseDadosSelect
          end
          object cmbTabelas: TComboBox
            Left = 354
            Top = 36
            Width = 161
            Height = 21
            TabOrder = 1
            TextHint = 'Selecione'
            OnSelect = cmbTabelasSelect
          end
          object cmbSchema: TComboBox
            Left = 181
            Top = 36
            Width = 161
            Height = 21
            Enabled = False
            TabOrder = 2
            TextHint = 'Selecione'
            OnSelect = cmbSchemaSelect
          end
          object btnCarregar: TButton
            Left = 527
            Top = 34
            Width = 75
            Height = 25
            Cancel = True
            Caption = 'Carregar'
            TabOrder = 3
            OnClick = btnCarregarClick
          end
        end
      end
      object tsInstrucaoSQL: TTabSheet
        Caption = 'Instru'#231#227'o SQL'
        ImageIndex = 2
      end
      object tsDadosClasse: TTabSheet
        Caption = 'Dados da classe a ser gerada'
        object pnlEntidade: TPanel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 770
          Height = 72
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object gbxNomeEntidade: TGroupBox
            AlignWithMargins = True
            Left = 262
            Top = 3
            Width = 505
            Height = 66
            Align = alClient
            Caption = 'Nome da Entidade'
            TabOrder = 0
            object lblNomeSingular: TLabel
              Left = 8
              Top = 20
              Width = 38
              Height = 13
              Caption = 'Singular'
            end
            object lblNomePlural: TLabel
              Left = 257
              Top = 20
              Width = 26
              Height = 13
              Caption = 'Plural'
            end
            object edtNomeSingular: TEdit
              Left = 8
              Top = 37
              Width = 240
              Height = 21
              TabOrder = 0
              TextHint = 'Ex: GrupoEmpresarial'
            end
            object edtNomePlural: TEdit
              Left = 257
              Top = 37
              Width = 240
              Height = 21
              TabOrder = 1
              TextHint = 'Ex: GruposEmpresariais'
            end
          end
          object gbxModulo: TGroupBox
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 253
            Height = 66
            Align = alLeft
            Caption = 'Nome do M'#243'dulo'
            TabOrder = 1
            object edtNomeModulo: TEdit
              Left = 8
              Top = 37
              Width = 235
              Height = 21
              TabOrder = 0
              TextHint = 'Ex: Admin'
            end
          end
        end
        object gbxAtributos: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 81
          Width = 770
          Height = 384
          Align = alClient
          Caption = 'Atributos'
          TabOrder = 1
          object dbgrdAtributos: TDBGrid
            AlignWithMargins = True
            Left = 5
            Top = 49
            Width = 760
            Height = 330
            Align = alClient
            DataSource = dsAtributos
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            OnCellClick = dbgrdAtributosCellClick
            OnColEnter = dbgrdAtributosColEnter
            OnDrawColumnCell = dbgrdAtributosDrawColumnCell
            Columns = <
              item
                Expanded = False
                FieldName = 'Selecionado'
                Title.Alignment = taCenter
                Title.Caption = ' '
                Width = 21
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'Nome'
                Title.Alignment = taCenter
                Width = 180
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'NomeExibicao'
                Title.Alignment = taCenter
                Width = 180
                Visible = True
              end
              item
                DropDownRows = 15
                Expanded = False
                FieldName = 'Tipo'
                PickList.Strings = (
                  'Boolean'
                  'Byte'
                  'Byte[]'
                  'DateTime'
                  'DateTimeOffset'
                  'Decimal'
                  'Double'
                  'Guid'
                  'Int16'
                  'Int32'
                  'Int64'
                  'Object'
                  'Single'
                  'String'
                  'TimeSpan'
                  'Xml')
                Title.Alignment = taCenter
                Width = 142
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'ChavePrimaria'
                Title.Alignment = taCenter
                Width = 79
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'ChaveUnica'
                Title.Alignment = taCenter
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'Requerido'
                Title.Alignment = taCenter
                Visible = True
              end>
          end
          object dbnvgrAtributos: TDBNavigator
            AlignWithMargins = True
            Left = 5
            Top = 18
            Width = 760
            Height = 25
            DataSource = dsAtributos
            VisibleButtons = [nbInsert, nbDelete, nbEdit, nbPost, nbCancel, nbRefresh]
            Align = alTop
            TabOrder = 1
            OnClick = dbnvgrAtributosClick
          end
        end
      end
    end
  end
  object cdsAtributos: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 120
    Top = 312
    object cdsAtributosSelecionado: TWideStringField
      FieldName = 'Selecionado'
      OnGetText = cdsAtributosSelecionadoGetText
      Size = 1
    end
    object cdsAtributosNome: TWideStringField
      FieldName = 'Nome'
      Size = 100
    end
    object cdsAtributosNomeExibicao: TWideStringField
      DisplayLabel = 'Nome Exibi'#231#227'o'
      FieldName = 'NomeExibicao'
      Size = 255
    end
    object cdsAtributosTipo: TWideStringField
      FieldName = 'Tipo'
      Size = 50
    end
    object cdsAtributosChavePrimaria: TWideStringField
      DisplayLabel = 'Chave Prim'#225'ria'
      FieldName = 'ChavePrimaria'
      OnGetText = cdsAtributosChavePrimariaGetText
      Size = 1
    end
    object cdsAtributosChaveUnica: TWideStringField
      DisplayLabel = 'Chave '#218'nica'
      FieldName = 'ChaveUnica'
      Size = 1
    end
    object cdsAtributosRequerido: TWideStringField
      FieldName = 'Requerido'
      OnGetText = cdsAtributosRequeridoGetText
      Size = 1
    end
  end
  object dsAtributos: TDataSource
    DataSet = cdsAtributos
    Left = 40
    Top = 312
  end
  object conBD: TZConnection
    ControlsCodePage = cCP_UTF16
    Catalog = ''
    HostName = ''
    Port = 0
    Database = 
      'Provider=SQLOLEDB.1;Password=gajos;Persist Security Info=True;Us' +
      'er ID=sa;Initial Catalog=ERP_TESTE;Data Source=.\SQLEXPRESS'
    User = ''
    Password = ''
    Protocol = 'ado'
    Left = 40
    Top = 265
  end
  object dsBaseDados: TDataSource
    DataSet = cdsBaseDados
    Left = 504
    Top = 264
  end
  object qryBaseDados: TZReadOnlyQuery
    Connection = conBD
    Params = <>
    Left = 727
    Top = 264
  end
  object cdsBaseDados: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspBaseDados'
    Left = 576
    Top = 264
    object cdsBaseDadosNome: TWideStringField
      FieldName = 'nome'
      Required = True
      Size = 128
    end
  end
  object dspBaseDados: TDataSetProvider
    DataSet = qryBaseDados
    Left = 651
    Top = 264
  end
  object dsTabelas: TDataSource
    DataSet = cdsTabelas
    Left = 504
    Top = 312
  end
  object cdsTabelas: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspTabelas'
    Left = 576
    Top = 312
    object cdsTabelasNome: TWideStringField
      FieldName = 'nome'
      Required = True
      Size = 128
    end
  end
  object dspTabelas: TDataSetProvider
    DataSet = qryTabelas
    Left = 651
    Top = 312
  end
  object qryTabelas: TZReadOnlyQuery
    Connection = conBD
    Params = <>
    Left = 727
    Top = 312
  end
  object qryAux: TZReadOnlyQuery
    Connection = conBD
    Params = <>
    Left = 727
    Top = 363
  end
  object dspAux: TDataSetProvider
    DataSet = qryAux
    Left = 651
    Top = 363
  end
  object cdsAux: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspAux'
    Left = 576
    Top = 363
    object cdsAuxNome: TWideStringField
      FieldName = 'nome'
      Size = 128
    end
    object cdsAuxTipo: TWideStringField
      FieldName = 'tipo'
      Size = 128
    end
    object cdsAuxChavePrimaria: TWideStringField
      FieldName = 'chaveprimaria'
      Size = 1
    end
    object cdsAuxChaveUNica: TWideStringField
      FieldName = 'chaveunica'
      Size = 1
    end
    object cdsAuxRequerido: TWideStringField
      FieldName = 'requerido'
      Size = 1
    end
  end
end
