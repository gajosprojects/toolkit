unit uAtributoDTO;

interface

uses
  System.Classes;

type
  TAtributoDTO = class(TPersistent)

  private
    FOrdem: Integer;
    FNomeCampo: string;
    FNomeAtributo: string;
    FNomeExibicao: string;
    FTipo: string;
    FChavePrimaria: Boolean;
    FChaveEstrangeira: Boolean;
    FLista: Boolean;
    FChaveUnica: Boolean;
    FRequerido: Boolean;
    FEntidadeBase: Boolean;

  published
    property Ordem: Integer read FOrdem write FOrdem;
    property NomeCampo: string read FNomeCampo write FNomeCampo;
    property NomeAtributo: string read FNomeAtributo write FNomeAtributo;
    property NomeExibicao: string read FNomeExibicao write FNomeExibicao;
    property Tipo: string read FTipo write FTipo;
    property ChavePrimaria: Boolean read FChavePrimaria write FChavePrimaria;
    property ChaveEstrangeira: Boolean read FChaveEstrangeira write FChaveEstrangeira;
    property Lista: Boolean read FLista write FLista;
    property ChaveUnica: Boolean read FChaveUnica write FChaveUnica;
    property Requerido: Boolean read FRequerido write FRequerido;
    property EntidadeBase: Boolean read FEntidadeBase write FEntidadeBase;

  end;

implementation

{ TAtributoDTO }

initialization
  RegisterClass(TAtributoDTO);

end.
