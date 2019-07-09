object MainDataModule: TMainDataModule
  OldCreateOrder = False
  Height = 168
  Width = 514
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
    Left = 24
    Top = 9
  end
  object dsAtributos: TDataSource
    DataSet = cdsAtributos
    Left = 24
    Top = 56
  end
  object cdsAtributos: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 104
    Top = 56
    object cdsAtributosSelecionado: TWideStringField
      FieldName = 'Selecionado'
      Size = 1
    end
    object cdsAtributosNome: TWideStringField
      FieldName = 'NomeCampo'
      Size = 100
    end
    object cdsAtributosNomeAtributo: TStringField
      FieldName = 'NomeAtributo'
      Size = 255
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
      Size = 1
    end
    object cdsAtributosChaveUnica: TWideStringField
      DisplayLabel = 'Chave '#218'nica'
      FieldName = 'ChaveUnica'
      Size = 1
    end
    object cdsAtributosRequerido: TWideStringField
      FieldName = 'Requerido'
      Size = 1
    end
  end
  object dsBaseDados: TDataSource
    DataSet = cdsBaseDados
    Left = 224
    Top = 8
  end
  object cdsBaseDados: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspBaseDados'
    Left = 296
    Top = 8
    object cdsBaseDadosNome: TWideStringField
      FieldName = 'nome'
      Required = True
      Size = 128
    end
  end
  object dspBaseDados: TDataSetProvider
    DataSet = qryBaseDados
    Left = 371
    Top = 8
  end
  object qryBaseDados: TZReadOnlyQuery
    Connection = conBD
    Params = <>
    Left = 447
    Top = 8
  end
  object qryTabelas: TZReadOnlyQuery
    Connection = conBD
    Params = <>
    Left = 447
    Top = 56
  end
  object dspTabelas: TDataSetProvider
    DataSet = qryTabelas
    Left = 371
    Top = 56
  end
  object cdsTabelas: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspTabelas'
    Left = 296
    Top = 56
    object cdsTabelasNome: TWideStringField
      FieldName = 'nome'
      Required = True
      Size = 128
    end
  end
  object dsTabelas: TDataSource
    DataSet = cdsTabelas
    Left = 224
    Top = 56
  end
  object cdsAux: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspAux'
    Left = 296
    Top = 107
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
  object dspAux: TDataSetProvider
    DataSet = qryAux
    Left = 371
    Top = 107
  end
  object qryAux: TZReadOnlyQuery
    Connection = conBD
    Params = <>
    Left = 447
    Top = 107
  end
end
