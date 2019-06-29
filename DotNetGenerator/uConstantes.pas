unit uConstantes;

interface

const
  aColunasBoolean: Array [0 .. 3] of string = (
    'Selecionado',
    'ChavePrimaria',
    'ChaveUnica',
    'Requerido');

  cSim = 'S';
  cNao = 'N';

  cOrigemManual       = 0;
  cOrigemTabela       = 1;
  cOrigemInstrucaoSQL = 2;

implementation

end.
