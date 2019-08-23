unit uEntidadeDTO;

interface

uses
  System.Classes,
  System.Contnrs,
  uAtributoDTO;

type
  TEntidadeDTO = class(TPersistent)

  private
    FNomeModulo: string;
    FNomeTabela: string;
    FNomeClasseAgregacaoSingular: string;
    FNomeClasseAgregacaoPlural: string;
    FNomeClasseSingular: string;
    FNomeClassePlural: string;
    FNomeClasseExibicaoSingular: string;
    FNomeClasseExibicaoPlural: string;
    FAtributos: TObjectList;

  public
    constructor Create();
    destructor Destroy(); override;

  published
    property NomeModulo: string read FNomeModulo write FNomeModulo;
    property NomeTabela: string read FNomeTabela write FNomeTabela;
    property NomeClasseAgregacaoSingular: string read FNomeClasseAgregacaoSingular write FNomeClasseAgregacaoSingular;
    property NomeClasseAgregacaoPlural: string read FNomeClasseAgregacaoPlural write FNomeClasseAgregacaoPlural;
    property NomeClasseSingular: string read FNomeClasseSingular write FNomeClasseSingular;
    property NomeClassePlural: string read FNomeClassePlural write FNomeClassePlural;
    property NomeClasseExibicaoSingular: string read FNomeClasseExibicaoSingular write FNomeClasseExibicaoSingular;
    property NomeClasseExibicaoPlural: string read FNomeClasseExibicaoPlural write FNomeClasseExibicaoPlural;
    property Atributos: TObjectList read FAtributos write FAtributos;

  end;

implementation

uses
  System.SysUtils;

{ TEntidadeDTO }

constructor TEntidadeDTO.Create();
begin
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
