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
    object pgcGenerator: TPageControl
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 790
      Height = 525
      ActivePage = tsDadosClasse
      Align = alClient
      TabOrder = 0
      object tsConexao: TTabSheet
        Caption = 'Conex'#227'o'
        ImageIndex = 1
        object gbxDadosConexaoSQLServer: TGroupBox
          Left = 0
          Top = 0
          Width = 782
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
          Width = 782
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
          Width = 776
          Height = 72
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object gbxNomeEntidade: TGroupBox
            AlignWithMargins = True
            Left = 262
            Top = 3
            Width = 511
            Height = 66
            Align = alClient
            Caption = 'Nome da Entidade'
            TabOrder = 1
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
          object tlAtributos: TcxDBTreeList
            AlignWithMargins = True
            Left = 5
            Top = 18
            Width = 766
            Height = 390
            Align = alClient
            Bands = <
              item
              end>
            DataController.KeyField = 'Nome'
            Navigator.Buttons.OnButtonClick = tlAtributosNavigatorButtonsButtonClick
            Navigator.Buttons.ConfirmDelete = True
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
    end
  end
end
