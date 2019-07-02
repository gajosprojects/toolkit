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
    FNomeSingular: string;
    FNomePlural: string;
//    FAtributos: TObjectList<TAtributoDTO>;
    FAtributos: TObjectList;

  public
    constructor Create(AOwner: TComponent);
    destructor Destroy(); override;

  published
    property NomeModulo: string read FNomeModulo write FNomeModulo;
    property NomeClasseSingular: string read FNomeSingular write FNomeSingular;
    property NomeClassePlural: string read FNomePlural write FNomePlural;
//    property Atributos: TObjectList<TAtributoDTO> read FAtributos write FAtributos;
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
