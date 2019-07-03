object DotNetGeneratorSourceCodeFrame: TDotNetGeneratorSourceCodeFrame
  AlignWithMargins = True
  Left = 0
  Top = 0
  Width = 1024
  Height = 768
  TabOrder = 0
  object gbxOrigem: TGroupBox
    Left = 0
    Top = 0
    Width = 1024
    Height = 52
    Align = alTop
    Caption = 'Origem'
    TabOrder = 0
    object btnPreview: TSpeedButton
      Left = 848
      Top = 20
      Width = 75
      Height = 25
      AllowAllUp = True
      GroupIndex = 1
      Caption = 'Preview'
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000003C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
        3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF00000000000000003C3C3CFF2D2D
        2DC100000000363636E63C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
        3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF00000000000000002D2D2DBE3C3C
        3CFF2D2D2DC11010104209090926000000000000000000000000000000000000
        000000000000000000003C3C3CFF3C3C3CFF0000000000000000000000002D2D
        2DBE3C3C3CFF333333D82B2B2BB83A3A3AF52B2B2BB817171760000000000000
        000000000000000000003C3C3CFF3C3C3CFF0000000000000000000000000000
        0000333333D73C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3A3A3AF8171717600000
        000000000000000000003C3C3CFF3C3C3CFF0000000000000000000000000000
        00002B2B2BB83C3C3CFF2222228F0707071F2222228F3C3C3CFF2B2B2BB80000
        000000000000000000003C3C3CFF3C3C3CFF0000000000000000000000000000
        00003A3A3AF53C3C3CFF0707071F000000000707071F3C3C3CFF3A3A3AF50000
        000000000000000000003C3C3CFF3C3C3CFF0000000000000000000000000000
        00002B2B2BB83C3C3CFF2222228F0707071F2222228F3C3C3CFF2B2B2BB80000
        000000000000000000003C3C3CFF3C3C3CFF0000000000000000000000000000
        0000171717603A3A3AF83C3C3CFF3C3C3CFF3C3C3CFF3A3A3AF8171717600000
        000000000000000000003C3C3CFF3C3C3CFF0000000000000000000000000000
        000000000000171717602B2B2BB83A3A3AF52B2B2BB817171760000000003C3C
        3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF0000000000000000000000000000
        0000000000001F1F1F840D0D0D39000000000000000000000000000000003C3C
        3CFF3C3C3CFF3C3C3CFF3C3C3CFF1E1E1E7E0000000000000000000000000000
        0000000000003C3C3CFF3C3C3CFF000000000000000000000000000000003C3C
        3CFF3C3C3CFF3C3C3CFF1E1E1E7E000000000000000000000000000000000000
        0000000000003C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
        3CFF3C3C3CFF1E1E1E7E00000000000000000000000000000000000000000000
        0000000000003C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
        3CFF1E1E1E7E0000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000}
      OnClick = btnPreviewClick
    end
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
      Left = 928
      Top = 20
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Gerar'
      TabOrder = 3
      OnClick = btnGerarClick
    end
    object btnExportarXML: TButton
      Left = 768
      Top = 20
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Exportar XML'
      TabOrder = 2
      OnClick = btnExportarXMLClick
    end
    object btnCarregarXML: TButton
      Left = 688
      Top = 20
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Carregar XML'
      TabOrder = 1
      OnClick = btnCarregarXMLClick
    end
  end
  object gbxGenerator: TGroupBox
    Left = 0
    Top = 52
    Width = 1024
    Height = 716
    Align = alClient
    TabOrder = 1
    object pgcGenerator: TPageControl
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 1014
      Height = 693
      ActivePage = tsPreview
      Align = alClient
      TabOrder = 0
      object tsConexao: TTabSheet
        Caption = 'Conex'#227'o'
        ImageIndex = 1
        object gbxDadosConexaoSQLServer: TGroupBox
          Left = 0
          Top = 0
          Width = 1006
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
          Width = 1006
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
          object btnCarregarAtributos: TButton
            Left = 527
            Top = 34
            Width = 75
            Height = 25
            Cancel = True
            Caption = 'Carregar'
            TabOrder = 3
            OnClick = btnCarregarAtributosClick
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
        object pnlEntidade: TPanel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 1000
          Height = 72
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object gbxNomeEntidade: TGroupBox
            AlignWithMargins = True
            Left = 411
            Top = 3
            Width = 382
            Height = 66
            Align = alClient
            Caption = 'Nome da Entidade'
            TabOrder = 2
            DesignSize = (
              382
              66)
            object lblNomeSingular: TLabel
              Left = 8
              Top = 20
              Width = 38
              Height = 13
              Caption = 'Singular'
            end
            object lblNomePlural: TLabel
              Left = 196
              Top = 20
              Width = 26
              Height = 13
              Caption = 'Plural'
            end
            object edtNomeClasseSingular: TEdit
              Left = 8
              Top = 37
              Width = 180
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
              TextHint = 'Ex: GrupoEmpresarial'
            end
            object edtNomeClassePlural: TEdit
              Left = 196
              Top = 37
              Width = 180
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
              TextHint = 'Ex: GruposEmpresariais'
            end
          end
          object gbxModulo: TGroupBox
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 198
            Height = 66
            Align = alLeft
            Caption = 'Nome do M'#243'dulo'
            TabOrder = 0
            DesignSize = (
              198
              66)
            object lblNomeModulo: TLabel
              Left = 8
              Top = 20
              Width = 38
              Height = 13
              Caption = 'Singular'
            end
            object edtNomeModulo: TEdit
              Left = 8
              Top = 37
              Width = 180
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
              TextHint = 'Ex: Admin'
            end
          end
          object gbxNomeTabela: TGroupBox
            AlignWithMargins = True
            Left = 207
            Top = 3
            Width = 198
            Height = 66
            Align = alLeft
            Caption = 'Nome da Tabela'
            TabOrder = 1
            DesignSize = (
              198
              66)
            object lblNomeTabela: TLabel
              Left = 8
              Top = 20
              Width = 26
              Height = 13
              Caption = 'Plural'
            end
            object edtNomeTabela: TEdit
              Left = 8
              Top = 37
              Width = 180
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
              TextHint = 'Ex: grupos_empresariais'
            end
          end
          object gbxNomeClasseExibicao: TGroupBox
            AlignWithMargins = True
            Left = 799
            Top = 3
            Width = 198
            Height = 66
            Align = alRight
            Caption = 'Nome de Exibi'#231#227'o da Entidade'
            TabOrder = 3
            DesignSize = (
              198
              66)
            object lblNomeClasseExibicao: TLabel
              Left = 8
              Top = 20
              Width = 38
              Height = 13
              Caption = 'Singular'
            end
            object edtNomeClasseExibicao: TEdit
              Left = 8
              Top = 37
              Width = 180
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
              TextHint = 'Ex: Grupo Empresarial'
            end
          end
        end
        object gbxAtributos: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 81
          Width = 1000
          Height = 581
          Align = alClient
          Caption = 'Atributos'
          TabOrder = 1
          object tlAtributos: TcxDBTreeList
            AlignWithMargins = True
            Left = 5
            Top = 18
            Width = 990
            Height = 558
            Align = alClient
            Bands = <
              item
              end>
            DataController.KeyField = 'Nome'
            Navigator.Buttons.OnButtonClick = tlAtributosNavigatorButtonsButtonClick
            Navigator.Buttons.CustomButtons = <>
            Navigator.Buttons.First.Visible = False
            Navigator.Buttons.PriorPage.Visible = False
            Navigator.Buttons.Prior.Visible = False
            Navigator.Buttons.Next.Visible = False
            Navigator.Buttons.NextPage.Visible = False
            Navigator.Buttons.Last.Visible = False
            Navigator.Buttons.Insert.Visible = False
            Navigator.Buttons.Append.Hint = 'Adicionar'
            Navigator.Buttons.Append.Visible = True
            Navigator.Buttons.Delete.Hint = 'Remover'
            Navigator.Buttons.Edit.Hint = 'Editar'
            Navigator.Buttons.Post.Hint = 'Salvar'
            Navigator.Buttons.Cancel.Hint = 'Cancelar'
            Navigator.Buttons.Refresh.Hint = 'Atualizar'
            Navigator.Buttons.Refresh.Visible = True
            Navigator.Buttons.SaveBookmark.Visible = False
            Navigator.Buttons.GotoBookmark.Visible = False
            Navigator.Buttons.Filter.Visible = False
            Navigator.Visible = True
            OptionsData.Inserting = True
            RootValue = -1
            TabOrder = 0
            object tlAtributosSelecionado: TcxDBTreeListColumn
              PropertiesClassName = 'TcxCheckBoxProperties'
              Properties.ValueChecked = 'S'
              Properties.ValueUnchecked = 'N'
              Caption.Text = ' '
              DataBinding.FieldName = 'Selecionado'
              Width = 30
              Position.ColIndex = 0
              Position.RowIndex = 0
              Position.BandIndex = 0
              Summary.FooterSummaryItems = <>
              Summary.GroupFooterSummaryItems = <>
            end
            object tlAtributosNome: TcxDBTreeListColumn
              Caption.AlignHorz = taCenter
              DataBinding.FieldName = 'Nome'
              Width = 150
              Position.ColIndex = 1
              Position.RowIndex = 0
              Position.BandIndex = 0
              Summary.FooterSummaryItems = <>
              Summary.GroupFooterSummaryItems = <>
            end
            object tlAtributosNomeExibicao: TcxDBTreeListColumn
              Caption.AlignHorz = taCenter
              Caption.Text = 'Nome Exibi'#231#227'o'
              DataBinding.FieldName = 'NomeExibicao'
              Width = 150
              Position.ColIndex = 2
              Position.RowIndex = 0
              Position.BandIndex = 0
              Summary.FooterSummaryItems = <>
              Summary.GroupFooterSummaryItems = <>
            end
            object tlAtributosTipo: TcxDBTreeListColumn
              PropertiesClassName = 'TcxComboBoxProperties'
              Properties.Items.Strings = (
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
              Caption.AlignHorz = taCenter
              DataBinding.FieldName = 'Tipo'
              Width = 100
              Position.ColIndex = 3
              Position.RowIndex = 0
              Position.BandIndex = 0
              Summary.FooterSummaryItems = <>
              Summary.GroupFooterSummaryItems = <>
            end
            object tlAtributosChavePrimaria: TcxDBTreeListColumn
              PropertiesClassName = 'TcxCheckBoxProperties'
              Properties.ValueChecked = 'S'
              Properties.ValueUnchecked = 'N'
              Visible = False
              Caption.AlignHorz = taCenter
              Caption.Text = 'Chave Prim'#225'ria'
              DataBinding.FieldName = 'ChavePrimaria'
              Width = 100
              Position.ColIndex = 4
              Position.RowIndex = 0
              Position.BandIndex = 0
              Summary.FooterSummaryItems = <>
              Summary.GroupFooterSummaryItems = <>
            end
            object tlAtributosChaveUnica: TcxDBTreeListColumn
              PropertiesClassName = 'TcxCheckBoxProperties'
              Properties.ValueChecked = 'S'
              Properties.ValueUnchecked = 'N'
              Caption.AlignHorz = taCenter
              Caption.Text = 'Chave '#218'nica'
              DataBinding.FieldName = 'ChaveUnica'
              Width = 80
              Position.ColIndex = 5
              Position.RowIndex = 0
              Position.BandIndex = 0
              Summary.FooterSummaryItems = <>
              Summary.GroupFooterSummaryItems = <>
            end
            object tlAtributosRequerido: TcxDBTreeListColumn
              PropertiesClassName = 'TcxCheckBoxProperties'
              Properties.ValueChecked = 'S'
              Properties.ValueUnchecked = 'N'
              Caption.AlignHorz = taCenter
              DataBinding.FieldName = 'Requerido'
              Width = 80
              Position.ColIndex = 6
              Position.RowIndex = 0
              Position.BandIndex = 0
              Summary.FooterSummaryItems = <>
              Summary.GroupFooterSummaryItems = <>
            end
          end
        end
      end
      object tsPreview: TTabSheet
        Caption = 'Preview'
        ImageIndex = 3
        object Splitter: TSplitter
          Left = 230
          Top = 29
          Height = 636
          ExplicitLeft = 192
          ExplicitTop = 64
          ExplicitHeight = 100
        end
        object tvArquivos: TTreeView
          AlignWithMargins = True
          Left = 3
          Top = 32
          Width = 224
          Height = 630
          Align = alLeft
          Indent = 19
          ReadOnly = True
          TabOrder = 0
          OnChange = tvArquivosChange
          OnCustomDrawItem = tvArquivosCustomDrawItem
        end
        object edtConteudo: TMemo
          AlignWithMargins = True
          Left = 236
          Top = 32
          Width = 767
          Height = 630
          Align = alClient
          Color = clScrollBar
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          Lines.Strings = (
            '')
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 1
          WordWrap = False
        end
        object pnlAtualizarPreview: TPanel
          Left = 0
          Top = 0
          Width = 1006
          Height = 29
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object btnAtualizar: TButton
            Left = 6
            Top = 3
            Width = 75
            Height = 25
            Caption = 'Atualizar'
            TabOrder = 0
            OnClick = btnAtualizarClick
          end
        end
      end
    end
  end
end
