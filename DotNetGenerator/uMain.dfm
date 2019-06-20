object Main: TMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '4'
  ClientHeight = 571
  ClientWidth = 794
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlOrigem: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 788
    Height = 43
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object btnGerar: TButton
      Left = 704
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Gerar'
      TabOrder = 0
      OnClick = btnGerarClick
    end
  end
  object gbxAtributos: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 130
    Width = 788
    Height = 438
    Align = alClient
    Caption = 'Atributos'
    TabOrder = 2
    object dbgAtributos: TDBGrid
      AlignWithMargins = True
      Left = 5
      Top = 49
      Width = 778
      Height = 384
      Align = alClient
      DataSource = dsAtributos
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnCellClick = dbgAtributosCellClick
      OnColEnter = dbgAtributosColEnter
      OnDrawColumnCell = dbgAtributosDrawColumnCell
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
          Expanded = False
          FieldName = 'Tipo'
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
    object dbnAtributos: TDBNavigator
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 778
      Height = 25
      DataSource = dsAtributos
      VisibleButtons = [nbInsert, nbDelete, nbEdit, nbPost, nbCancel, nbRefresh]
      Align = alTop
      TabOrder = 1
      OnClick = dbnAtributosClick
    end
  end
  object pnlEntidade: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 52
    Width = 788
    Height = 72
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object gbxNomeEntidade: TGroupBox
      AlignWithMargins = True
      Left = 267
      Top = 3
      Width = 518
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
        Left = 265
        Top = 20
        Width = 26
        Height = 13
        Caption = 'Plural'
      end
      object txtNomeSingular: TEdit
        Left = 8
        Top = 37
        Width = 245
        Height = 21
        TabOrder = 0
      end
      object txtNomePlural: TEdit
        Left = 264
        Top = 37
        Width = 245
        Height = 21
        TabOrder = 1
      end
    end
    object gbxModulo: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 258
      Height = 66
      Align = alLeft
      Caption = 'Nome do M'#243'dulo'
      TabOrder = 0
      object txtNomeModulo: TEdit
        Left = 8
        Top = 37
        Width = 245
        Height = 21
        TabOrder = 0
      end
    end
  end
  object cdsAtributos: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 432
    Top = 224
    object cdsAtributosSelecionado: TStringField
      FieldName = 'Selecionado'
      OnGetText = cdsAtributosSelecionadoGetText
      Size = 1
    end
    object cdsAtributosNome: TStringField
      FieldName = 'Nome'
      Size = 100
    end
    object cdsAtributosNomeExibicao: TStringField
      DisplayLabel = 'Nome Exibi'#231#227'o'
      FieldName = 'NomeExibicao'
      Size = 255
    end
    object cdsAtributosTipo: TStringField
      FieldName = 'Tipo'
      Size = 50
    end
    object cdsAtributosChavePrimaria: TStringField
      DisplayLabel = 'Chave Prim'#225'ria'
      FieldName = 'ChavePrimaria'
      OnGetText = cdsAtributosChavePrimariaGetText
      Size = 1
    end
    object cdsAtributosRequerido: TStringField
      FieldName = 'Requerido'
      OnGetText = cdsAtributosRequeridoGetText
      Size = 1
    end
    object cdsAtributosChaveUnica: TStringField
      DisplayLabel = 'Chave '#218'nica'
      FieldName = 'ChaveUnica'
      Size = 1
    end
  end
  object dsAtributos: TDataSource
    DataSet = cdsAtributos
    Left = 368
    Top = 224
  end
end
