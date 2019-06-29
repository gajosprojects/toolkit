object DotNetGeneratorSourceCodeFrame: TDotNetGeneratorSourceCodeFrame
  AlignWithMargins = True
  Left = 0
  Top = 0
  Width = 800
  Height = 600
  TabOrder = 0
  object gbxOrigem: TGroupBox
    Left = 0
    Top = 0
    Width = 800
    Height = 52
    Align = alTop
    Caption = 'Origem'
    TabOrder = 0
    ExplicitWidth = 794
    object cmbOrigemClasse: TComboBox
      Left = 15
      Top = 22
      Width = 161
      Height = 21
      TabOrder = 1
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
      TabOrder = 0
      OnClick = btnGerarClick
    end
  end
  object gbxGenerator: TGroupBox
    Left = 0
    Top = 52
    Width = 800
    Height = 548
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 794
    ExplicitHeight = 519
    object pgcGenerator: TPageControl
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 790
      Height = 525
      ActivePage = tsDadosClasse
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 784
      ExplicitHeight = 496
      object tsConexao: TTabSheet
        Caption = 'Conex'#227'o'
        ImageIndex = 1
        ExplicitWidth = 776
        ExplicitHeight = 468
        object gbxDadosConexaoSQLServer: TGroupBox
          Left = 0
          Top = 0
          Width = 782
          Height = 68
          Align = alTop
          Caption = 'Dados'
          TabOrder = 0
          ExplicitWidth = 776
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
          Width = 782
          Height = 68
          Align = alTop
          Caption = 'Base'
          TabOrder = 1
          ExplicitWidth = 776
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
            TabOrder = 2
            TextHint = 'Selecione'
            OnSelect = cmbTabelasSelect
          end
          object cmbSchema: TComboBox
            Left = 181
            Top = 36
            Width = 161
            Height = 21
            Enabled = False
            TabOrder = 1
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
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
      end
      object tsDadosClasse: TTabSheet
        Caption = 'Dados da classe a ser gerada'
        ExplicitWidth = 776
        ExplicitHeight = 468
        object pnlEntidade: TPanel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 776
          Height = 72
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          ExplicitWidth = 770
          object gbxNomeEntidade: TGroupBox
            AlignWithMargins = True
            Left = 262
            Top = 3
            Width = 511
            Height = 66
            Align = alClient
            Caption = 'Nome da Entidade'
            TabOrder = 1
            ExplicitWidth = 505
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
            TabOrder = 0
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
          Width = 776
          Height = 413
          Align = alClient
          Caption = 'Atributos'
          TabOrder = 1
          ExplicitWidth = 770
          ExplicitHeight = 384
          object dbgrdAtributos: TDBGrid
            AlignWithMargins = True
            Left = 5
            Top = 49
            Width = 766
            Height = 359
            Align = alClient
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            TabOrder = 1
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
                  'byte[]'
                  'byte'
                  'bool'
                  'decimal'
                  'int'
                  'long'
                  'string'
                  ''
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
                Visible = False
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
            Width = 766
            Height = 25
            VisibleButtons = [nbInsert, nbDelete, nbEdit, nbPost, nbCancel, nbRefresh]
            Align = alTop
            TabOrder = 0
            OnClick = dbnvgrAtributosClick
            ExplicitWidth = 760
          end
        end
      end
    end
  end
end
