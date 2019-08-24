unit uStringHelper;

interface

uses
   vcl.StdCtrls, SysUtils;

type
   TStringHelper = record helper for string
   public
     function ToLowerCase(): string;
     function ToUpperCase(): string;
     function DecapitalizeFirstLetter(): string;

end;

implementation

{ TStringHelper }

function TStringHelper.DecapitalizeFirstLetter(): string;
begin
  Result := LowerCase(Copy(Self, 1, 1)) + Copy(Self, 2, Length(Self));
end;

function TStringHelper.ToLowerCase(): string;
begin
  Result := LowerCase(Self);
end;

function TStringHelper.ToUpperCase(): string;
begin
  Result := UpperCase(Self);
end;

end.
