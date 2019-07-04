unit uSerializadorXML;

interface

uses
  Classes, TypInfo, Dialogs, SysUtils, Contnrs, MSXML2_TLB, Variants;

type
  TSerializadorXML = class
  private

    procedure CreateRoot(var Root_DomDocument: IXMLDOMDocument; Root_Name: string);
    procedure CreateNode(var Root_DomDocument: IXMLDOMDocument; var Node: IXMLDOMNode; Node_Name, Node_Value: string);

    function CreateRootObject(XMLDoc: IXMLDOMDocument): TObject;

    procedure GetPropertyNames(AClass: TClass; PropertyNames: TStringList);

    function RecuperarCaracteresInvalidosXML(Texto: string): string;
    function LimparCaracteresInvalidosXML(Texto: string): string;

  public
    function ToXML(AObject: TObject): WideString;

    function ObjectFromXML(Source: WideString): TObject;

    procedure FromXML(AObject: TObject; Source: WideString);
  end;

implementation

{ TSerializadorXML }

procedure TSerializadorXML.CreateRoot(var Root_DomDocument: IXMLDOMDocument; Root_Name: string);
var
  String_XML: string;
begin
  String_XML := '<' + Trim(LowerCase(Root_Name)) + '/>';
  Root_DomDocument.loadXML(String_XML)
end;

procedure TSerializadorXML.CreateNode(var Root_DomDocument: IXMLDOMDocument; var Node: IXMLDOMNode; Node_Name, Node_Value: string);
begin
  Node := Root_DomDocument.createNode(1, Trim(LowerCase(Node_Name)), '');
  Node.text := Trim(Node_Value);
  Root_DomDocument.documentElement.appendChild(Node);
end;

function TSerializadorXML.CreateRootObject(XMLDoc: IXMLDOMDocument): TObject;
var
  AuxClass: TClass;
  ClassName: String;
  FirstNode: IXMLDOMNode;
begin
  FirstNode := XMLDoc.documentElement.firstChild;
  try
    ClassName := FirstNode.childNodes.item[0].text;
    AuxClass := FindClass(ClassName);
    Result := AuxClass.Create;
  finally
    FirstNode := nil;
  end;
end;

procedure TSerializadorXML.GetPropertyNames(AClass: TClass; PropertyNames: TStringList);
var
  TypeInfo: PTypeInfo;
  TypeData: PTypeData;
  PropList: PPropList;
  i: Integer;
begin
  if Assigned(PropertyNames) then { check to see if the TStringList is valid }
  begin
    PropertyNames.Clear;
    TypeInfo := AClass.ClassInfo;

    if TypeInfo^.Kind = tkClass then
    begin
      TypeData := GetTypeData(TypeInfo);

      if TypeData^.PropCount > 0 then
      begin
        PropertyNames.Add(TypeInfo^.Name + ':');
        new(PropList);
        GetPropInfos(TypeInfo, PropList);

        for i := 0 to Pred(TypeData^.PropCount) do
        begin
          if PropertyNames.IndexOf(PropList^[i]^.Name) < 0 then
            PropertyNames.Add(PropList^[i]^.Name);
        end;

        Dispose(PropList)
      end
    end
  end
end;

function TSerializadorXML.RecuperarCaracteresInvalidosXML(Texto: string): string;
begin
  Result := StringReplace(Texto, '%I$%', 'Î', [rfReplaceAll]);
end;

function TSerializadorXML.LimparCaracteresInvalidosXML(Texto: string): string;
begin
  Result := StringReplace(Texto, 'Î', '%I$%', [rfReplaceAll]);
end;

function TSerializadorXML.ToXML(AObject: TObject): WideString;
var
  i, j: Integer;
  slAux: TStringList;
  Node: IXMLDOMNode;
  XMLDoc: IXMLDOMDocument;
  XMLProperty: IXMLDOMDocument;
  XMLPropertyClass: IXMLDOMDocument;
  Kind: TTypeKind;
  FormatSettings: TFormatSettings;
begin
  Result := '';

  //Cria os documentos XML
  XMLDoc := ComsDOMDocument.Create;
  XMLProperty := ComsDOMDocument.Create;
  XMLPropertyClass := ComsDOMDocument.Create;

  //Cria o StringList que abrigará as propriedades publicadas da classe
  slAux := TStringList.Create;

  try
    //Cria o root e o nó com o nome da classe do objeto
    CreateRoot(XMLDoc, 'object');
    CreateNode(XMLDoc, Node, 'class', AObject.ClassName);

    //Exporta as propriedades obtidas para o documento XML
    if (AObject is TPersistent) then
    begin
      //Carrega o StringList com os nomes das propriedades da classe
      try
        GetPropertyNames(GetClass(AObject.ClassName), slAux);
      except
        ShowMessage(Format('Não foi possível identificar as propriedades da Classe %s ' + #13#10 + 'Verifique se a classe está registrada.', [AObject.ClassName]));
        Exit;
      end;

      for i := 1 to slAux.Count - 1 do
      begin
        //Verifica se a propriedade é uma classe
        if (PropIsType(AObject, slAux[i], tkClass)) then
        begin
          //Verifica se a propriedade está instanciada
          if (GetObjectProp(AObject, slAux[i]) = nil) then
            CreateRoot(XMLPropertyClass, LowerCase(slAux[i]))
          else
            XMLPropertyClass.loadXML('<' + Trim(LowerCase(slAux[i])) + '>' + ToXML(GetObjectProp(AObject, slAux[i])) + '</' + Trim(LowerCase(slAux[i])) + '>');

          XMLDoc.documentElement.appendChild(XMLPropertyClass.documentElement);
        end
        else //if (PropIsType(AObject, slAux[i], tkClass))...
        begin
          //Se a propriedade for um tipo básico (string, datetime, integer, etc.) cria um nó com seu valor
          Kind := PropType(AObject, slAux[i]);
          case Kind of
            tkMethod:
              begin
              end;

            tkFloat:
              begin
                GetLocaleFormatSettings(1, FormatSettings);
                FormatSettings.DecimalSeparator := '.';
                CreateNode(XMLDoc, Node, slAux[i], FloatToStr((GetFloatProp(AObject, slAux[i])), FormatSettings));
              end;

            tkEnumeration:
              begin
                if (LowerCase(VarAsType(GetPropValue(AObject, slAux[i]), varString)) = 'true') or (LowerCase(VarAsType(GetPropValue(AObject, slAux[i]), varString)) = 'false') then
                  CreateNode(XMLDoc, Node, slAux[i], VarAsType(GetPropValue(AObject, slAux[i]), varString))
                else
                  CreateNode(XMLDoc, Node, slAux[i], VarAsType(GetPropValue(AObject, slAux[i], False), $0003)); //$0003 = Integer
              end;

            tkDynArray:
              begin
                CreateRoot(XMLProperty, slAux[i]);

                try
                  for j := 0 to VarArrayDimCount(GetPropValue(AObject, slAux[i])) - 1 do
                    CreateNode(XMLProperty, Node, 'item', GetPropValue(AObject, slAux[i])[j]);
                except
                end;
                XMLDoc.documentElement.appendChild(XMLProperty.documentElement);
              end;
          else
            begin
              CreateNode(XMLDoc, Node, slAux[i], LimparCaracteresInvalidosXML(VarAsType(GetPropValue(AObject, slAux[i]), varString)));
            end;
          end; //Case
        end;
      end;
    end
    //AObject.ClassParent.QualifiedClassName
    else if (AObject is TObjectList) then
    begin
      //Grava a tag que indica o início dos nós de itens
      CreateRoot(XMLPropertyClass, 'items');

      //Cria os nós de todos os itens que estão instanciados no objeto de lista
      for i := 0 to TObjectList(AObject).Count - 1 do
      begin
        XMLProperty.loadXML(ToXML(TObjectList(AObject).Items[i]));

        XMLPropertyClass.documentElement.appendChild(XMLProperty.documentElement);
      end;

      XMLDoc.documentElement.appendChild(XMLPropertyClass.documentElement);
    end;

    //Retorna o XML gerado com o objeto completo
    Result := XMLDoc.documentElement.xml;
  finally
    //libera os recursos
    XMLDoc := nil;
    XMLProperty := nil;
    XMLPropertyClass := nil;
    Node := nil;
    slAux.Free;
  end;
end;

procedure TSerializadorXML.FromXML(AObject: TObject; Source: WideString);
var
  slAux: TStringList;
  XMLDoc: IXMLDOMDocument;
  ObjetoAux: IXMLDOMNodeList;
  ItemsAux: IXMLDOMNodeList;
  i: Integer;
  XMLPropertyClass: IXMLDOMDocument;
  Kind: TTypeKind;
  auxClasse: TClass;
  FormatSettings: TFormatSettings;
begin
  if (Trim(Source) = '') then
    Exit;
  //Cria os documentos XML
  XMLDoc := ComsDOMDocument.Create;
  XMLPropertyClass := ComsDOMDocument.Create;

  //Cria o StringList para carregar o nome das propriedades publicadas
  slAux := TStringList.Create;
  try
    //Carrega o documento XML principal com a String fornecida
    XMLDoc.loadXML(Source);

    if (AObject is TPersistent) then
    begin
      //Carrega os nomes das propriedades
      try
        GetPropertyNames(GetClass(AObject.ClassName), slAux);
      except
        ShowMessage(Format('Não foi possível identificar as propriedades da Classe %s ' + #13#10 + 'Verifique se a classe está registrada.', [AObject.ClassName]));
        Exit;
      end;
      //Importa as propriedades publicadas
      for i := 1 to slAux.Count - 1 do
      begin

        //Verifica se a propriedade é uma classe
        if (PropIsType(AObject, slAux[i], tkClass)) then
        begin
          //Carrega os nós do Texto iniciados com a Tag do nome do atributo
          ObjetoAux := XMLDoc.documentElement.selectNodes(LowerCase(slAux[i]));
          if (ObjetoAux.length = 0) then
            Continue;

          //Carrega os nós do "corpo" do objeto e se estiver vazio vai para a
          //  próxima propriedade
          ObjetoAux := ObjetoAux.item[0].selectNodes('object');
          if (ObjetoAux.length = 0) then
            Continue;

          //Se a propriedade ainda não estiver instanciada, cria a instância...
          if (GetObjectProp(AObject, slAux[i]) = nil) then
          begin
            auxClasse := GetObjectPropClass(AObject, slAux[i]);
            if (auxClasse <> nil) then
            begin
              // Alterado por Claudio Quevedo em 16/01/2008:
              // Quando a propriedade do objeto destino não estava assinalada
              // e as classes das propriedades origem e destino fossem diferentes,
              // o método não instanciava a propriedade destino.


              if (auxClasse.InheritsFrom(GetObjectPropClass(AObject, slAux[i]))) or (auxClasse = GetObjectPropClass(AObject, slAux[i])) then
                SetObjectProp(AObject, slAux[i], auxClasse.Create)
              else
                raise Exception.CreateFmt('A classe descrita no xml %s não compatível com classe da propriedade: %s', [auxClasse.ClassName, slAux[i]]);
            end
            else
            begin
              ShowMessage(Format('A Classe %s não foi encontrada.' + #13#10 + 'Verifique se a classe está registrada.', [auxClasse.ClassName]));
              Continue;
            end;
          end;

          if (GetObjectProp(AObject, slAux[i]) <> nil) then
            FromXML((GetObjectProp(AObject, slAux[i], GetObjectPropClass(AObject, slAux[i]))), ObjetoAux.item[0].transformNode(ObjetoAux.item[0]));
        end
        else if (XMLDoc.documentElement.selectSingleNode(LowerCase(slAux[i])) <> nil) then
        begin
          // Claudio e André em 18/06/2009: Só pode fazer a atribuição da propriedade
          //                                se esta não for read-only. Para isso o
          //                                if abaixo foi incluído.
          if GetPropInfo(AObject, slAux[i]).SetProc <> nil then
          begin
            Kind := PropType(AObject, slAux[i]);
            case Kind of
              tkMethod:
                begin
                end;
              tkFloat:
                begin
                  GetLocaleFormatSettings(1, FormatSettings);
                  FormatSettings.DecimalSeparator := '.';
                  SetPropValue(AObject, slAux[i], StrToFloat(XMLDoc.documentElement.selectSingleNode(LowerCase(slAux[i])).text, FormatSettings));
                end;
              tkEnumeration:
                begin
                  if LowerCase(XMLDoc.documentElement.selectSingleNode(LowerCase(slAux[i])).text) = 'true' then
                    SetPropValue(AObject, slAux[i], 1)
                  else if LowerCase(XMLDoc.documentElement.selectSingleNode(LowerCase(slAux[i])).text) = 'false' then
                    SetPropValue(AObject, slAux[i], 0)
                  else
                    SetPropValue(AObject, slAux[i], StrToInt(XMLDoc.documentElement.selectSingleNode(LowerCase(slAux[i])).text));
                end;
              tkDynArray:
                begin
                end;
            else
              begin
                SetPropValue(AObject, slAux[i], RecuperarCaracteresInvalidosXML(XMLDoc.documentElement.selectSingleNode(LowerCase(slAux[i])).text));
              end;
            end;
          end;
        end;
      end;
    end//if (AObject Is TPersistent) then
    else if (AObject is TObjectList) then
    begin
        //Lê os nós de XML contendo os itens (containers) da lista
      ItemsAux := XMLDoc.documentElement.selectNodes('items');
      if (ItemsAux.length > 0) then
        ItemsAux := ItemsAux.item[0].selectNodes('object');

        //Limpa os itens existentes
      for i := 0 to TObjectList(AObject).Count - 1 do
        if (TObjectList(AObject).Items[i] <> nil) then
          TObject(TObjectList(AObject).Items[i]).Free;
      TObjectList(AObject).Clear;

        //Instancia os itens e faz a carga dos atributos
      for i := 0 to ItemsAux.length - 1 do
      begin
          //Instancia o Item
        TObjectList(AObject).Add(FindClass(ItemsAux.item[i].selectsinglenode('class').text).Create);
          //Carrega os atributos encontrados no XML para o item
        FromXML(TObjectList(AObject).Items[TObjectList(AObject).Count - 1], ItemsAux.item[i].transformNode(ItemsAux.item[i]));
      end;
    end;
  finally
    //Libera os recursos
    XMLDoc := nil;
    XMLPropertyClass := nil;
    ObjetoAux := nil;
    ItemsAux := nil;
    slAux.Free;
  end;
end;

function TSerializadorXML.ObjectFromXML(Source: WideString): TObject;
var
  XMLDoc: IXMLDOMDocument;
  XMLPropertyClass: IXMLDOMDocument;
begin
  XMLDoc := ComsDOMDocument.Create;
  XMLPropertyClass := ComsDOMDocument.Create;
  XMLDoc.loadXML(Source);

  try
    Result := CreateRootObject(XMLDoc);
    XMLDoc := nil;
    XMLPropertyClass := nil;
    FromXML(Result, Source);
  finally
    XMLDoc := nil;
    XMLPropertyClass := nil;
  end;
end;

end.

