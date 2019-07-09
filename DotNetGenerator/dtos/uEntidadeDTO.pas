unit uEntidadeDTO;

interface

uses
//  System.Generics.Collections,
  System.Classes,
  System.Contnrs,
  uAtributoDTO;

type
  TEntidadeDTO = class(TPersistent)

  private
    FNomeModulo: string;
    FNomeTabela: string;
    FNomeClasseAgregacao: string;
    FNomeClasseSingular: string;
    FNomeClassePlural: string;
    FNomeClasseExibicao: string;
    FAtributos: TObjectList;

  public
    constructor Create(AOwner: TComponent);
    destructor Destroy(); override;

  published
    property NomeModulo: string read FNomeModulo write FNomeModulo;
    property NomeTabela: string read FNomeTabela write FNomeTabela;
    property NomeClasseAgregacao: string read FNomeClasseAgregacao write FNomeClasseAgregacao;
    property NomeClasseSingular: string read FNomeClasseSingular write FNomeClasseSingular;
    property NomeClassePlural: string read FNomeClassePlural write FNomeClassePlural;
    property NomeClasseExibicao: string read FNomeClasseExibicao write FNomeClasseExibicao;
    property Atributos: TObjectList read FAtributos write FAtributos;

  end;

implementation

uses
  System.SysUtils;

{ TEntidadeDTO }

constructor TEntidadeDTO.Create(AOwner: TComponent);
begin
//  FAtributos := TObjectList<TAtributoDTO>.Create();;
  FAtributos := TObjectList.Create();
end;

destructor TEntidadeDTO.Destroy();
begin
  inherited Destroy;

  FreeAndNil(FAtributos);
end;

initialization
  RegisterClass(TEntidadeDTO);

end.
