unit uAtributoDTO;

interface

uses
  System.Classes;

type
//  TAtributoDTO = class(TCollectionItem)
  TAtributoDTO = class(TPersistent)

  private
    FNomeCampo: string;
    FNomeAtributo: string;
    FNomeExibicao: string;
    FTipo: string;
//    FChavePrimaria: Boolean;
    FChaveUnica: Boolean;
    FRequerido: Boolean;

  published
    property NomeCampo: string read FNomeCampo write FNomeCampo;
    property NomeAtributo: string read FNomeAtributo write FNomeAtributo;
    property NomeExibicao: string read FNomeExibicao write FNomeExibicao;
    property Tipo: string read FTipo write FTipo;
//    property ChavePrimaria: Boolean read FChavePrimaria write FChavePrimaria;
    property ChaveUnica: Boolean read FChaveUnica write FChaveUnica;
    property Requerido: Boolean read FRequerido write FRequerido;

  end;

implementation

{ TAtributoDTO }

initialization
  RegisterClass(TAtributoDTO);

end.
