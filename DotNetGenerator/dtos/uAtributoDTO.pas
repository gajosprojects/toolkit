unit uAtributoDTO;

interface

type
  TAtributoDTO = class

  private
    FNome: string;
    FNomeExibicao: string;
    FTipo: string;
//    FChavePrimaria: Boolean;
    FChaveUnica: Boolean;
    FRequerido: Boolean;

  public
    property Nome: string read FNome write FNome;
    property NomeExibicao: string read FNomeExibicao write FNomeExibicao;
    property Tipo: string read FTipo write FTipo;
    //property ChavePrimaria: Boolean read FChavePrimaria write FChavePrimaria;
    property ChaveUnica: Boolean read FChaveUnica write FChaveUnica;
    property Requerido: Boolean read FRequerido write FRequerido;


  end;

implementation

end.
