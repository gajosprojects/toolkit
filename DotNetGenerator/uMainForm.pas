unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls,
  dxGDIPlusClasses;

type
  TNotifyEventWrapper = class(TComponent)
  private
    FProc: TProc<TObject>;
  public
    constructor Create(Owner: TComponent; Proc: TProc<TObject>); overload;
  published
    procedure Event(Sender: TObject);
end;

type
  TMainForm = class(TForm)
    imgMarcaDagua: TImage;

  private
    { Private declarations }
    FMainMenu: TMainMenu;
    FFrame: TFrame;

    function AnonimousProcedureToNotifyEvent(pOwner: TComponent; pProcedure: TProc<TObject>): TNotifyEvent;
    function CreateMenu(p_Caption: string; p_Procedure: TProc<TObject>): TMenuItem;
    function CreateSubMenu(p_MenuOwner: TMenuItem; p_Caption: string; p_Procedure: TProc<TObject>): TMenuItem;

    procedure CreateMenuGenerator();

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

    procedure InicializeComponents();
  end;

var
  MainForm: TMainForm;

implementation

uses
  uDotNetGeneratorSourceCodeFrame;

{$R *.dfm}

{ TNotifyEventWrapper }

constructor TNotifyEventWrapper.Create(Owner: TComponent; Proc: TProc<TObject>);
begin
  inherited Create(Owner);
  FProc := Proc;
end;

procedure TNotifyEventWrapper.Event(Sender: TObject);
begin
  FProc(Sender);
end;

{ TMainForm }

function TMainForm.AnonimousProcedureToNotifyEvent(pOwner: TComponent; pProcedure: TProc<TObject>): TNotifyEvent;
begin
  Result := TNotifyEventWrapper.Create(pOwner, pProcedure).Event;
end;

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited;

  FMainMenu := TMainMenu.Create(Self);

  MainForm.InicializeComponents();
end;

function TMainForm.CreateMenu(p_Caption: string; p_Procedure: TProc<TObject>): TMenuItem;
begin
  Result         := TMenuItem.Create(FMainMenu);
  Result.Caption := p_Caption;

  if Assigned(p_Procedure) then
    Result.OnClick := AnonimousProcedureToNotifyEvent(Result, p_Procedure);
end;

function TMainForm.CreateSubMenu(p_MenuOwner: TMenuItem; p_Caption: string; p_Procedure: TProc<TObject>): TMenuItem;
begin
  Result         := TMenuItem.Create(p_MenuOwner);
  Result.Caption := p_Caption;

  if Assigned(p_Procedure) then
    Result.OnClick := AnonimousProcedureToNotifyEvent(Result, p_Procedure);
end;

procedure TMainForm.CreateMenuGenerator();
var
  t_Menu: TMenuItem;
  t_SubMenu: TMenuItem;
begin
  FMainMenu.Items.Clear();

  t_Menu := CreateMenu('Generator', nil);
  FMainMenu.Items.Add(t_Menu);

  t_SubMenu := CreateSubMenu(t_Menu, '.NET Source Code', procedure(Sender: TObject)
                                                         begin
                                                           if Assigned(FFrame) then
                                                           begin
                                                             FreeAndNil(FFrame);
                                                           end;

                                                           FFrame        := TDotNetGeneratorSourceCodeFrame.Create(nil);
                                                           FFrame.Align  := alClient;
                                                           FFrame.Parent := MainForm;
                                                           FFrame.Show();
                                                           MainForm.Caption := 'Gajos Project - Tookit - .NET Source Generator';
                                                         end);

  t_Menu.Add(t_SubMenu);
end;

destructor TMainForm.Destroy();
begin
  if Assigned(FFrame) then
    FreeAndNil(FFrame);
end;

procedure TMainForm.InicializeComponents();
begin
  Self.Caption := '';

  CreateMenuGenerator();

  MainForm.Caption := 'Gajos Project - Tookit';
end;

end.
