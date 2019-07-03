unit uArquivoDTO;

interface

type
  TArquivoDTO = class

  private
    FDiretorio: string;
    FNome: string;
    FConteudo: WideString;

  public
    property Diretorio: string read FDiretorio write FDiretorio;
    property Nome: string read FNome write FNome;
    property Conteudo: WideString read FConteudo write FConteudo;

  end;

implementation

end.
