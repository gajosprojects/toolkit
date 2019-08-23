object DotNetGeneratorSourceCodeFrame: TDotNetGeneratorSourceCodeFrame
  AlignWithMargins = True
  Left = 0
  Top = 0
  Width = 1024
  Height = 768
  TabOrder = 0
  object gbxGenerator: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 172
    Width = 1018
    Height = 593
    Align = alClient
    TabOrder = 0
    object pgcGenerator: TPageControl
      Left = 2
      Top = 15
      Width = 1014
      Height = 576
      ActivePage = tsDadosClasse
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
          object gbxModulo: TGroupBox
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 245
            Height = 66
            Align = alLeft
            Caption = 'Nome do M'#243'dulo'
            TabOrder = 0
            DesignSize = (
              245
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
              Width = 227
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
              TextHint = 'Ex: Gerencial'
              ExplicitWidth = 309
            end
          end
          object gbxNomeTabela: TGroupBox
            AlignWithMargins = True
            Left = 752
            Top = 3
            Width = 245
            Height = 66
            Align = alClient
            Caption = 'Nome da Tabela'
            TabOrder = 2
            ExplicitLeft = 753
            ExplicitWidth = 244
            DesignSize = (
              245
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
              Width = 227
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
              TextHint = 'Ex: empresa'
              ExplicitWidth = 309
            end
          end
          object gbxNomeClasseAgregadora: TGroupBox
            AlignWithMargins = True
            Left = 254
            Top = 3
            Width = 492
            Height = 66
            Align = alLeft
            Caption = 'Nome da Entidade Agregadora'
            TabOrder = 1
            DesignSize = (
              492
              66)
            object lblNomeClasseAgregadoraPlural: TLabel
              Left = 253
              Top = 20
              Width = 26
              Height = 13
              Caption = 'Plural'
            end
            object lbl1: TLabel
              Left = 8
              Top = 20
              Width = 38
              Height = 13
              Caption = 'Singular'
            end
            object edtNomeClasseAgregadoraPlural: TEdit
              Left = 253
              Top = 37
              Width = 227
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
              TextHint = 'Ex: GruposEmpresariais'
            end
            object edtNomeClasseAgregadoraSingular: TEdit
              Left = 8
              Top = 37
              Width = 227
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
              TextHint = 'Ex: GruposEmpresarial'
            end
          end
        end
        object gbxAtributos: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 159
          Width = 1000
          Height = 386
          Align = alClient
          Caption = 'Atributos'
          TabOrder = 1
          object tlAtributos: TcxDBTreeList
            AlignWithMargins = True
            Left = 5
            Top = 44
            Width = 990
            Height = 337
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
            OptionsBehavior.Sorting = False
            OptionsCustomizing.ColumnHiding = True
            OptionsData.Inserting = True
            RootValue = -1
            TabOrder = 0
            object tlAtributosSelecionado: TcxDBTreeListColumn
              PropertiesClassName = 'TcxCheckBoxProperties'
              Properties.ValueChecked = 'S'
              Properties.ValueUnchecked = 'N'
              Caption.MultiLine = True
              Caption.Text = ' '
              DataBinding.FieldName = 'Selecionado'
              Options.Customizing = False
              Width = 30
              Position.ColIndex = 0
              Position.RowIndex = 0
              Position.BandIndex = 0
              Summary.FooterSummaryItems = <>
              Summary.GroupFooterSummaryItems = <>
            end
            object tlAtributosOrdem: TcxDBTreeListColumn
              PropertiesClassName = 'TcxTextEditProperties'
              Properties.ReadOnly = True
              Caption.AlignHorz = taCenter
              Caption.MultiLine = True
              DataBinding.FieldName = 'Ordem'
              Options.Customizing = False
              Width = 60
              Position.ColIndex = 1
              Position.RowIndex = 0
              Position.BandIndex = 0
              SortOrder = soAscending
              SortIndex = 1
              Summary.FooterSummaryItems = <>
              Summary.GroupFooterSummaryItems = <>
            end
            object tlAtributosId: TcxDBTreeListColumn
              Visible = False
              Caption.MultiLine = True
              DataBinding.FieldName = 'Id'
              Options.Customizing = False
              Width = 40
              Position.ColIndex = 2
              Position.RowIndex = 0
              Position.BandIndex = 0
              Summary.FooterSummaryItems = <>
              Summary.GroupFooterSummaryItems = <>
            end
            object tlAtributosNomeCampo: TcxDBTreeListColumn
              PropertiesClassName = 'TcxTextEditProperties'
              Caption.AlignHorz = taCenter
              Caption.MultiLine = True
              Caption.Text = 'Nome Campo'
              DataBinding.FieldName = 'NomeCampo'
              Width = 150
              Position.ColIndex = 3
              Position.RowIndex = 0
              Position.BandIndex = 0
              Summary.FooterSummaryItems = <>
              Summary.GroupFooterSummaryItems = <>
            end
            object tlAtributosNomeAtributo: TcxDBTreeListColumn
              PropertiesClassName = 'TcxTextEditProperties'
              Caption.AlignHorz = taCenter
              Caption.MultiLine = True
              Caption.Text = 'Nome Atributo'
              DataBinding.FieldName = 'NomeAtributo'
              Width = 150
              Position.ColIndex = 4
              Position.RowIndex = 0
              Position.BandIndex = 0
              Summary.FooterSummaryItems = <>
              Summary.GroupFooterSummaryItems = <>
            end
            object tlAtributosNomeExibicao: TcxDBTreeListColumn
              PropertiesClassName = 'TcxTextEditProperties'
              Caption.AlignHorz = taCenter
              Caption.MultiLine = True
              Caption.Text = 'Nome Exibi'#231#227'o'
              DataBinding.FieldName = 'NomeExibicao'
              Width = 150
              Position.ColIndex = 5
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
                'char'
                'decimal'
                'double'
                'float'
                'int'
                'long'
                'short'
                'string'
                'uint'
                'ulong'
                'unshort'
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
              Caption.MultiLine = True
              DataBinding.FieldName = 'Tipo'
              Width = 130
              Position.ColIndex = 6
              Position.RowIndex = 0
              Position.BandIndex = 0
              Summary.FooterSummaryItems = <>
              Summary.GroupFooterSummaryItems = <>
            end
            object tlAtributosLista: TcxDBTreeListColumn
              PropertiesClassName = 'TcxCheckBoxProperties'
              Properties.ValueChecked = 'S'
              Properties.ValueUnchecked = 'N'
              Visible = False
              Caption.AlignHorz = taCenter
              Caption.MultiLine = True
              DataBinding.FieldName = 'Lista'
              Width = 50
              Position.ColIndex = 7
              Position.RowIndex = 0
              Position.BandIndex = 0
              Summary.FooterSummaryItems = <>
              Summary.GroupFooterSummaryItems = <>
            end
            object tlAtributosChavePrimaria: TcxDBTreeListColumn
              PropertiesClassName = 'TcxCheckBoxProperties'
              Properties.ValueChecked = 'S'
              Properties.ValueUnchecked = 'N'
              Caption.AlignHorz = taCenter
              Caption.MultiLine = True
              Caption.Text = 'PK'
              DataBinding.FieldName = 'ChavePrimaria'
              Width = 40
              Position.ColIndex = 8
              Position.RowIndex = 0
              Position.BandIndex = 0
              Summary.FooterSummaryItems = <>
              Summary.GroupFooterSummaryItems = <>
            end
            object tlAtributosChaveEstrangeira: TcxDBTreeListColumn
              PropertiesClassName = 'TcxCheckBoxProperties'
              Properties.ValueChecked = 'S'
              Properties.ValueUnchecked = 'N'
              Visible = False
              Caption.AlignHorz = taCenter
              Caption.MultiLine = True
              Caption.Text = 'FK'
              DataBinding.FieldName = 'ChaveEstrangeira'
              Width = 40
              Position.ColIndex = 9
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
              Caption.MultiLine = True
              Caption.Text = 'UK'
              DataBinding.FieldName = 'ChaveUnica'
              Width = 40
              Position.ColIndex = 10
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
              Caption.MultiLine = True
              Caption.Text = 'Not Null'
              DataBinding.FieldName = 'Requerido'
              Width = 50
              Position.ColIndex = 11
              Position.RowIndex = 0
              Position.BandIndex = 0
              Summary.FooterSummaryItems = <>
              Summary.GroupFooterSummaryItems = <>
            end
            object tlAtributosEntidadeBase: TcxDBTreeListColumn
              PropertiesClassName = 'TcxCheckBoxProperties'
              Properties.ValueChecked = 'S'
              Properties.ValueUnchecked = 'N'
              Caption.AlignHorz = taCenter
              Caption.Text = 'Base'
              DataBinding.FieldName = 'EntidadeBase'
              Width = 40
              Position.ColIndex = 12
              Position.RowIndex = 0
              Position.BandIndex = 0
              Summary.FooterSummaryItems = <>
              Summary.GroupFooterSummaryItems = <>
            end
          end
          object pnlMoverNos: TPanel
            Left = 2
            Top = 15
            Width = 996
            Height = 26
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            object btnMoverParaBaixo: TSpeedButton
              Left = 107
              Top = 0
              Width = 100
              Height = 25
              AllowAllUp = True
              Caption = 'Para Baixo'
              Glyph.Data = {
                36040000424D3604000000000000360000002800000010000000100000000100
                2000000000000004000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000505051517171763272727A7343434DC3B3B3BFB343434DC2727
                27A7171717630505051500000000000000000000000000000000000000000000
                000010101043292929B03C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
                3CFF3C3C3CFF292929B010101043000000000000000000000000000000001010
                10432F2F2FC93C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
                3CFF3C3C3CFF3C3C3CFF2F2F2FC9101010430000000000000000050505152929
                29B03C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF1E1E1E813C3C3CFF3C3C
                3CFF3C3C3CFF3C3C3CFF3C3C3CFF292929B00505051500000000171717633C3C
                3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF1E1E1E81000000001E1E1E7E3C3C
                3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF1717176300000000272727A73C3C
                3CFF3C3C3CFF3C3C3CFF3C3C3CFF1E1E1E810000000000000000000000001E1E
                1E7E3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF272727A700000000343434DC3C3C
                3CFF3C3C3CFF3C3C3CFF1E1E1E81000000002D2D2DC1000000002D2D2DBF0000
                00001E1E1E7E3C3C3CFF3C3C3CFF3C3C3CFF343434DC000000003B3B3BFB3C3C
                3CFF3C3C3CFF3C3C3CFF000000002D2D2DC13C3C3CFF000000003C3C3CFF2D2D
                2DBF000000003C3C3CFF3C3C3CFF3C3C3CFF3B3B3BFB00000000343434DC3C3C
                3CFF3C3C3CFF3C3C3CFF2D2D2DC13C3C3CFF3C3C3CFF000000003C3C3CFF3C3C
                3CFF2D2D2DC13C3C3CFF3C3C3CFF3C3C3CFF343434DC00000000272727A73C3C
                3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF000000003C3C3CFF3C3C
                3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF272727A700000000171717633C3C
                3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF000000003C3C3CFF3C3C
                3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF1717176300000000050505152929
                29B03C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF000000003C3C3CFF3C3C
                3CFF3C3C3CFF3C3C3CFF3C3C3CFF292929B00505051500000000000000001010
                10432F2F2FC93C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
                3CFF3C3C3CFF3C3C3CFF2F2F2FC9101010430000000000000000000000000000
                000010101043292929B03C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
                3CFF3C3C3CFF292929B010101043000000000000000000000000000000000000
                0000000000000505051517171763272727A7343434DC3B3B3BFB343434DC2727
                27A7171717630505051500000000000000000000000000000000}
              OnClick = btnMoverParaBaixoClick
            end
            object btnMoverParaCima: TSpeedButton
              Left = 3
              Top = 0
              Width = 100
              Height = 25
              AllowAllUp = True
              GroupIndex = 1
              Caption = 'Para Cima'
              Glyph.Data = {
                36040000424D3604000000000000360000002800000010000000100000000100
                2000000000000004000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000505051517171763272727A7343434DC3B3B3BFB343434DC2727
                27A7171717630505051500000000000000000000000000000000000000000000
                000010101043292929B03C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
                3CFF3C3C3CFF292929B010101043000000000000000000000000000000001010
                10432F2F2FC93C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
                3CFF3C3C3CFF3C3C3CFF2F2F2FC9101010430000000000000000050505152929
                29B03C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF000000003C3C3CFF3C3C
                3CFF3C3C3CFF3C3C3CFF3C3C3CFF292929B00505051500000000171717633C3C
                3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF000000003C3C3CFF3C3C
                3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF1717176300000000272727A73C3C
                3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF000000003C3C3CFF3C3C
                3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF272727A700000000343434DC3C3C
                3CFF3C3C3CFF3C3C3CFF2D2D2DC13C3C3CFF3C3C3CFF000000003C3C3CFF3C3C
                3CFF2D2D2DC13C3C3CFF3C3C3CFF3C3C3CFF343434DC000000003B3B3BFB3C3C
                3CFF3C3C3CFF3C3C3CFF000000002D2D2DC13C3C3CFF000000003C3C3CFF2D2D
                2DBF000000003C3C3CFF3C3C3CFF3C3C3CFF3B3B3BFB00000000343434DC3C3C
                3CFF3C3C3CFF3C3C3CFF1E1E1E81000000002D2D2DC1000000002D2D2DBF0000
                00001E1E1E7E3C3C3CFF3C3C3CFF3C3C3CFF343434DC00000000272727A73C3C
                3CFF3C3C3CFF3C3C3CFF3C3C3CFF1E1E1E810000000000000000000000001E1E
                1E7E3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF272727A700000000171717633C3C
                3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF1E1E1E81000000001E1E1E7E3C3C
                3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF1717176300000000050505152929
                29B03C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF1E1E1E813C3C3CFF3C3C
                3CFF3C3C3CFF3C3C3CFF3C3C3CFF292929B00505051500000000000000001010
                10432F2F2FC93C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
                3CFF3C3C3CFF3C3C3CFF2F2F2FC9101010430000000000000000000000000000
                000010101043292929B03C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
                3CFF3C3C3CFF292929B010101043000000000000000000000000000000000000
                0000000000000505051517171763272727A7343434DC3B3B3BFB343434DC2727
                27A7171717630505051500000000000000000000000000000000}
              OnClick = btnMoverParaCimaClick
            end
          end
        end
        object Panel1: TPanel
          AlignWithMargins = True
          Left = 3
          Top = 81
          Width = 1000
          Height = 72
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object gbxNomeEntidade: TGroupBox
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 494
            Height = 66
            Align = alClient
            Caption = 'Nome da Entidade'
            TabOrder = 0
            ExplicitWidth = 487
            DesignSize = (
              494
              66)
            object lblNomeSingular: TLabel
              Left = 8
              Top = 20
              Width = 38
              Height = 13
              Caption = 'Singular'
            end
            object lblNomePlural: TLabel
              Left = 254
              Top = 20
              Width = 26
              Height = 13
              Caption = 'Plural'
            end
            object edtNomeClasseSingular: TEdit
              Left = 8
              Top = 37
              Width = 227
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
              TextHint = 'Ex: Empresa'
            end
            object edtNomeClassePlural: TEdit
              Left = 254
              Top = 37
              Width = 227
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
              TextHint = 'Ex: Empresas'
            end
          end
          object gbxNomeClasseExibicao: TGroupBox
            AlignWithMargins = True
            Left = 503
            Top = 3
            Width = 494
            Height = 66
            Align = alRight
            Caption = 'Nome de Exibi'#231#227'o da Entidade'
            TabOrder = 1
            DesignSize = (
              494
              66)
            object lblNomeClasseExibicaoSingular: TLabel
              Left = 8
              Top = 20
              Width = 38
              Height = 13
              Caption = 'Singular'
            end
            object lblNomeClasseExibicaoPlural: TLabel
              Left = 252
              Top = 20
              Width = 26
              Height = 13
              Caption = 'Plural'
            end
            object edtNomeClasseExibicaoSingular: TEdit
              Left = 8
              Top = 37
              Width = 227
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
              TextHint = 'Ex: Empresa'
            end
            object edtNomeClasseExibicaoPlural: TEdit
              Left = 252
              Top = 37
              Width = 227
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
              TextHint = 'Ex: Empresas'
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
          Height = 519
          ExplicitLeft = 192
          ExplicitTop = 64
          ExplicitHeight = 100
        end
        object tvArquivos: TTreeView
          AlignWithMargins = True
          Left = 3
          Top = 32
          Width = 224
          Height = 513
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
          Height = 513
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
  object pnlParametros: TPanel
    Left = 0
    Top = 47
    Width = 1024
    Height = 122
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object pnlOrigem: TPanel
      Left = 0
      Top = 60
      Width = 1024
      Height = 60
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object gbxOrigem: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 1018
        Height = 54
        Align = alClient
        Caption = 'Origem'
        TabOrder = 0
        ExplicitTop = -5
        object cmbOrigemClasse: TComboBox
          Left = 8
          Top = 20
          Width = 200
          Height = 21
          TabOrder = 0
          TextHint = 'Selecione'
          OnChange = cmbOrigemClasseChange
          Items.Strings = (
            'Manual'
            'Tabela')
        end
      end
    end
    object pnlDiretorio: TPanel
      Left = 0
      Top = 0
      Width = 1024
      Height = 60
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object gbxDiretorioArquivos: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 506
        Height = 54
        Align = alLeft
        Caption = 'Diret'#243'rio dos arquivos .NET'
        TabOrder = 0
        DesignSize = (
          506
          54)
        object btnSelecionarDiretorioArquivosDotnet: TSpeedButton
          Left = 471
          Top = 19
          Width = 23
          Height = 23
          Anchors = [akTop, akRight]
          Caption = '...'
          OnClick = btnSelecionarDiretorioArquivosDotnetClick
          ExplicitLeft = 983
        end
        object edtDiretorioArquivosDotNet: TEdit
          Left = 8
          Top = 20
          Width = 465
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          ReadOnly = True
          TabOrder = 0
        end
      end
      object gbxDiretorioXML: TGroupBox
        AlignWithMargins = True
        Left = 515
        Top = 3
        Width = 506
        Height = 54
        Align = alClient
        Caption = 'Diret'#243'rio dos arquivos XML'
        TabOrder = 1
        DesignSize = (
          506
          54)
        object btnSelecionarDiretorioXML: TSpeedButton
          Left = 471
          Top = 19
          Width = 23
          Height = 23
          Anchors = [akTop, akRight]
          Caption = '...'
          OnClick = btnSelecionarDiretorioXMLClick
        end
        object edtDiretorioXML: TEdit
          Left = 8
          Top = 20
          Width = 465
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          ReadOnly = True
          TabOrder = 0
        end
      end
    end
  end
  object gbxTop: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 1018
    Height = 41
    Align = alTop
    TabOrder = 2
    object btnParametros: TSpeedButton
      Left = 15
      Top = 8
      Width = 100
      Height = 25
      AllowAllUp = True
      GroupIndex = 1
      Down = True
      Caption = 'Par'#226'metros'
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000003C3C
        3CFF1E1E1E810000000000000000000000000000000000000000000000000000
        00000000000000000000141414552D2D2DC02D2D2DC014141455000000001E1E
        1E7E3C3C3CFF1E1E1E8100000000000000000000000000000000000000000000
        0000000000001B1B1B72353535E03C3C3CFF3C3C3CFF2D2D2DC0000000000000
        00001E1E1E7E3C3C3CFF1E1E1E81000000000000000000000000000000000000
        00001212124E3B3B3BFC3C3C3CFF3C3C3CFF3C3C3CFF2D2D2DC0000000000000
        0000000000001E1E1E7E3C3C3CFF1E1E1E810000000000000000000000000D0D
        0D363A3A3AF63C3C3CFF3C3C3CFF3C3C3CFF353535E014141455000000000000
        000000000000000000001E1E1E7E3C3C3CFF1E1E1E8100000000040404133535
        35E23C3C3CFF3C3C3CFF3C3C3CFF3B3B3BFC1919196C00000000000000000000
        00000000000000000000000000001E1E1E7E3C3C3CFF262626A21C1C1C760F0F
        0F40383838ED3C3C3CFF3A3A3AF6141414540000000000000000000000000000
        000000000000000000000000000000000000262626A03C3C3CFF3C3C3CFF2F2F
        2FC60C0C0C332F2F2FC90D0D0D36000000000000000000000000000000000000
        0000000000000000000000000000000000021D1D1D7A3C3C3CFF3C3C3CFF3C3C
        3CFF343434DB0909092700000000000000000000000000000000000000000F0F
        0F4024242499353535E0353535E0303030CD0E0E0E3D2F2F2FC93C3C3CFF3C3C
        3CFF3C3C3CFF373737EA0D0D0D360000000000000000000000000F0F0F403030
        30CC3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF373737EA0D0D0D36343434DB3C3C
        3CFF3C3C3CFF3C3C3CFF3A3A3AF6141414540000000000000000242424993C3C
        3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF2B2B2BB5080808243737
        37EA3C3C3CFF3C3C3CFF3C3C3CFF3B3B3BFC1919196C00000000353535E02828
        28AA0F0F0F3F0F0F0F3F282828AA3C3C3CFF3C3C3CFF353535E0000000000D0D
        0D363A3A3AF63C3C3CFF3C3C3CFF3C3C3CFF353535E014141455232323950404
        041000000000000000000F0F0F3F3C3C3CFF3C3C3CFF353535E0000000000000
        00001212124E3B3B3BFC3C3C3CFF3C3C3CFF3C3C3CFF2D2D2DC0020202090000
        000000000000000000000F0F0F3F3C3C3CFF3C3C3CFF24242499000000000000
        0000000000001B1B1B72353535E03C3C3CFF3C3C3CFF2D2D2DC0000000000000
        00000000000004040410282828AA3C3C3CFF303030CC0F0F0F40000000000000
        00000000000000000000141414552D2D2DC02D2D2DC014141455000000000000
        00000202020923232395353535E0242424990F0F0F4000000000000000000000
        0000000000000000000000000000000000000000000000000000}
      OnClick = btnParametrosClick
    end
    object btnCarregarXML: TSpeedButton
      Left = 587
      Top = 8
      Width = 100
      Height = 25
      AllowAllUp = True
      Caption = 'Carregar'
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        000000000000000000003C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
        3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF000000000000
        000000000000000000003C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
        3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF000000000000
        000000000000000000003C3C3CFF3C3C3CFF0000000000000000000000000000
        0000000000000000000000000000000000003C3C3CFF3C3C3CFF3C3C3CFF3C3C
        3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
        3CFF3C3C3CFF3C3C3CFF3C3C3CFF000000003C3C3CFF3C3C3CFF3C3C3CFF0000
        00003C3C3CFF000000003C3C3CFF000000003C3C3CFF000000003C3C3CFF0000
        000000000000000000003C3C3CFF000000003C3C3CFF3C3C3CFF3C3C3CFF0000
        00001E1E1E80000000003C3C3CFF000000003C3C3CFF000000003C3C3CFF0000
        00003C3C3CFF3C3C3CFF3C3C3CFF000000003C3C3CFF3C3C3CFF3C3C3CFF1E1E
        1E80000000001E1E1E803C3C3CFF000000003C3C3CFF000000003C3C3CFF0000
        00003C3C3CFF3C3C3CFF3C3C3CFF000000003C3C3CFF3C3C3CFF3C3C3CFF0000
        00001E1E1E80000000003C3C3CFF0000000000000000000000003C3C3CFF0000
        00003C3C3CFF3C3C3CFF3C3C3CFF000000003C3C3CFF3C3C3CFF3C3C3CFF0000
        00003C3C3CFF000000003C3C3CFF000000003C3C3CFF000000003C3C3CFF0000
        00003C3C3CFF3C3C3CFF3C3C3CFF000000003C3C3CFF3C3C3CFF3C3C3CFF3C3C
        3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
        3CFF3C3C3CFF3C3C3CFF3C3C3CFF000000003C3C3CFF3C3C3CFF000000000000
        000000000000000000003C3C3CFF3C3C3CFF0000000000000000000000000000
        0000000000000000000000000000000000003C3C3CFF3C3C3CFF000000000000
        000000000000000000003C3C3CFF3C3C3CFF0000000000000000000000000000
        0000000000003C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF000000000000
        000000000000000000003C3C3CFF3C3C3CFF0000000000000000000000000000
        0000000000003C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF1E1E1E7E000000000000
        000000000000000000003C3C3CFF3C3C3CFF0000000000000000000000000000
        0000000000003C3C3CFF3C3C3CFF3C3C3CFF1E1E1E7E00000000000000000000
        000000000000000000003C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
        3CFF3C3C3CFF3C3C3CFF3C3C3CFF1E1E1E7E0000000000000000000000000000
        000000000000000000003C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
        3CFF3C3C3CFF3C3C3CFF1E1E1E7E000000000000000000000000}
      OnClick = btnCarregarXMLClick
    end
    object btnExportarXML: TSpeedButton
      Left = 691
      Top = 8
      Width = 100
      Height = 25
      AllowAllUp = True
      Caption = 'Exportar XML'
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000002B2B
        2BB73C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
        3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF2B2B2BB700000000000000003C3C
        3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
        3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF00000000000000003C3C
        3CFF3C3C3CFF0000000000000000000000000000000000000000000000000000
        00000000000000000000000000003C3C3CFF3C3C3CFF00000000000000003C3C
        3CFF3C3C3CFF0000000000000000000000000000000000000000000000000000
        00000000000000000000000000003C3C3CFF3C3C3CFF00000000000000003C3C
        3CFF3C3C3CFF0000000000000000000000000000000000000000000000000000
        00000000000000000000000000003C3C3CFF3C3C3CFF00000000000000003C3C
        3CFF3C3C3CFF0000000000000000000000000000000000000000000000000000
        00000000000000000000000000003C3C3CFF3C3C3CFF00000000000000003C3C
        3CFF3C3C3CFF0000000000000000000000000000000000000000000000000000
        00000000000000000000000000003C3C3CFF3C3C3CFF00000000000000003C3C
        3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
        3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF00000000000000003C3C
        3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
        3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF00000000000000003C3C
        3CFF3C3C3CFF3C3C3CFF00000000000000000000000000000000000000000000
        000000000000000000003C3C3CFF3C3C3CFF3C3C3CFF00000000000000003C3C
        3CFF3C3C3CFF3C3C3CFF000000003C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
        3CFF3C3C3CFF000000003C3C3CFF3C3C3CFF3C3C3CFF00000000000000003C3C
        3CFF3C3C3CFF3C3C3CFF000000003C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF0000
        00003C3C3CFF000000003C3C3CFF3C3C3CFF3C3C3CFF00000000000000003C3C
        3CFF3C3C3CFF3C3C3CFF000000003C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF0000
        00003C3C3CFF000000003C3C3CFF3C3C3CFF3C3C3CFF00000000000000002C2C
        2CBD3C3C3CFF3C3C3CFF000000003C3C3CFF3C3C3CFF3C3C3CFF3C3C3CFF3C3C
        3CFF3C3C3CFF000000003C3C3CFF3C3C3CFF2C2C2CBD00000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000}
      OnClick = btnExportarXMLClick
    end
    object btnPreview: TSpeedButton
      Left = 795
      Top = 8
      Width = 100
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
    object btnGerar: TSpeedButton
      Left = 899
      Top = 8
      Width = 100
      Height = 25
      AllowAllUp = True
      Caption = 'Gerar'
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        00000000000000000000000000000000000000000015000000FF000000FF0000
        0015000000000000000000000000000000000000000000000000000000000000
        00000000000C0000001C000000000000000000000040000000FF000000FF0000
        004000000000000000000000001C0000000C0000000000000000000000000000
        000C000000C3000000ED000000580000006C000000D4000000FF000000FF0000
        00D30000006C00000058000000ED000000C30000000C00000000000000000000
        001C000000ED000000FF000000FF000000FF000000FF000000FF000000FF0000
        00FF000000FF000000FF000000FF000000ED0000001C00000000000000000000
        000000000058000000FF000000FF000000E3000000550000000E0000000E0000
        0052000000DA000000FF000000FF000000580000000000000000000000000000
        00000000006D000000FF000000D8000000120000000000000000000000000000
        000000000012000000E3000000FF0000006C0000000000000000000000140000
        0040000000D3000000FF00000051000000000000000000000000000000000000
        00000000000000000056000000FF000000D30000004000000014000000FF0000
        00FF000000FF000000FF0000000D000000000000000000000000000000000000
        0000000000000000000F000000FF000000FF000000FF000000FF000000FF0000
        00FF000000FF000000FF0000000D000000000000000000000000000000000000
        0000000000000000000E000000FF000000FF000000FF000000FF000000140000
        0040000000D3000000FF00000053000000000000000000000000000000000000
        00000000000000000055000000FF000000D30000004000000014000000000000
        00000000006D000000FF000000E2000000120000000000000000000000000000
        000000000011000000E2000000FF0000006C0000000000000000000000000000
        000000000058000000FF000000FF000000E2000000530000000D0000000D0000
        0050000000D8000000FF000000FF000000580000000000000000000000000000
        001C000000ED000000FF000000FF000000FF000000FF000000FF000000FF0000
        00FF000000FF000000FF000000FF000000ED0000001C00000000000000000000
        000C000000C3000000ED000000580000006C000000D4000000FF000000FF0000
        00D40000006C00000058000000ED000000C30000000C00000000000000000000
        00000000000C0000001C000000000000000000000040000000FF000000FF0000
        004000000000000000000000001C0000000C0000000000000000000000000000
        00000000000000000000000000000000000000000015000000FF000000FF0000
        0015000000000000000000000000000000000000000000000000}
      OnClick = btnGerarClick
    end
  end
end
