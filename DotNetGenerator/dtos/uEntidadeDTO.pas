unit uEntidadeDTO;

interface

uses
  System.Generics.Collections,
  uAtributoDTO;

type
  TEntidadeDTO = class

  private
    FNomeModulo: string;
    FNomeSingular: string;
    FNomePlural: string;
    FAtributos: TObjectList<TAtributoDTO>;

  public
    constructor Create();
    destructor Destroy(); override;

    property NomeModulo: string read FNomeModulo write FNomeModulo;
    property NomeClasseSingular: string read FNomeSingular write FNomeSingular;
    property NomeClassePlural: string read FNomePlural write FNomePlural;
    property Atributos: TObjectList<TAtributoDTO> read FAtributos write FAtributos;

  end;

implementation

uses
  System.SysUtils;

{ clMain }

constructor TEntidadeDTO.Create();
begin
  Atributos := TObjectlist<TAtributoDTO>.Create();
end;

destructor TEntidadeDTO.Destroy();
begin
  FreeAndNil(FAtributos);
  inherited;
end;

end.
