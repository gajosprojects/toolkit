unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls,
  dxGDIPlusClasses, Vcl.ComCtrls;

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
    StatusBar1: TStatusBar;

  private
    { Private declarations }
    FMainMenu: TMainMenu;
    FFrame: TFrame;

    FStatusBar: TStatusBar;
    FProgressBar: TProgressBar;

    FPanelProgressBarIndex: Integer;

    function AnonimousProcedureToNotifyEvent(pOwner: TComponent; pProcedure: TProc<TObject>): TNotifyEvent;
    function CreateMenu(p_Caption: string; p_Procedure: TProc<TObject>): TMenuItem;
    function CreateSubMenu(p_MenuOwner: TMenuItem; p_Caption: string; p_Procedure: TProc<TObject>): TMenuItem;

    procedure CreateStatusBarColumns();
    procedure CreateMenuGenerator();

    procedure ConfigureProgressBar();
    procedure StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);

    function VersaoExe(): String;


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

  FStatusBar := TStatusBar.Create(Self);
  FProgressBar := TProgressBar.Create(Self);

  MainForm.InicializeComponents();
end;

function TMainForm.CreateMenu(p_Caption: string; p_Procedure: TProc<TObject>): TMenuItem;
begin
  Result         := TMenuItem.Create(FMainMenu);
  Result.Caption := p_Caption;

  if Assigned(p_Procedure) then
    Result.OnClick := AnonimousProcedureToNotifyEvent(Result, p_Procedure);
end;

procedure TMainForm.CreateStatusBarColumns();
var
  t_StatusPanel: TStatusPanel;
begin
  Self.Caption := '';

  FStatusBar.Align := alBottom;
  FStatusBar.Parent := MainForm;
  FStatusBar.OnDrawPanel := StatusBarDrawPanel;

  t_StatusPanel := FStatusBar.Panels.Add();
  t_StatusPanel.Text := ' ' + FormatDateTime('dddd", "dd" de "mmmm" de "yyyy', Now);
  t_StatusPanel.Width := 200;

  t_StatusPanel := FStatusBar.Panels.Add();
  t_StatusPanel.Text := 'Versão: ' + VersaoExe();
  t_StatusPanel.Width := 100;

  t_StatusPanel := FStatusBar.Panels.Add();
  t_StatusPanel.Width := 524;

  t_StatusPanel := FStatusBar.Panels.Add();
  t_StatusPanel.Width := 200;
  t_StatusPanel.Style := psOwnerDraw;

  ConfigureProgressBar();
  FPanelProgressBarIndex := t_StatusPanel.Index;
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
                                                           TDotNetGeneratorSourceCodeFrame(FFrame).ExibirFrame(FProgressBar);
                                                           MainForm.Caption := 'Gajos Project - Tookit - .NET Source Generator';
                                                         end);

  t_Menu.Add(t_SubMenu);
end;

procedure TMainForm.ConfigureProgressBar();
var
  t_ProgressBarStyle: Integer;
begin
  FProgressBar.Parent := FStatusBar;

  t_ProgressBarStyle := GetWindowLong(FProgressBar.Handle, GWL_EXSTYLE);
  t_ProgressBarStyle := t_ProgressBarStyle - WS_EX_STATICEDGE;

  SetWindowLong(FProgressBar.Handle, GWL_EXSTYLE, t_ProgressBarStyle);
end;

destructor TMainForm.Destroy();
begin
  if Assigned(FFrame) then
    FreeAndNil(FFrame);

  if Assigned(FProgressBar) then
    FreeAndNil(FProgressBar);

  if Assigned(FStatusBar) then
    FreeAndNil(FStatusBar);

  if Assigned(FMainMenu) then
    FreeAndNil(FMainMenu);
end;

procedure TMainForm.InicializeComponents();
begin
  Self.Caption := '';

  FProgressBar.Visible := True;

  CreateStatusBarColumns();
  CreateMenuGenerator();

  MainForm.Caption := 'Gajos Project - Tookit';
end;

procedure TMainForm.StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
begin
  if (Panel = StatusBar.Panels[FPanelProgressBarIndex]) then
  begin
    FProgressBar.Top    := Rect.Top;
    FProgressBar.Left   := Rect.Left + 2;
    FProgressBar.Width  := (Rect.Right - Rect.Left - 4);
    FProgressBar.Height := (Rect.Bottom - Rect.Top);

    FProgressBar.PaintTo(FStatusBar.Canvas.Handle, Rect.Left, Rect.Top);
  end;
end;

function TMainForm.VersaoExe: String;
type
   PFFI = ^vs_FixedFileInfo;
var
   F       : PFFI;
   Handle  : Dword;
   Len     : Longint;
   Data    : Pchar;
   Buffer  : Pointer;
   Tamanho : Dword;
   Parquivo: Pchar;
   Arquivo : String;
begin
   Arquivo  := Application.ExeName;
   Parquivo := StrAlloc(Length(Arquivo) + 1);
   StrPcopy(Parquivo, Arquivo);
   Len := GetFileVersionInfoSize(Parquivo, Handle);
   Result := '';

   if Len > 0 then
   begin
      Data:=StrAlloc(Len+1);
      if GetFileVersionInfo(Parquivo,Handle,Len,Data) then
      begin
         VerQueryValue(Data, '',Buffer,Tamanho);
         F := PFFI(Buffer);
         Result := Format('%d.%d.%d.%d',
                          [HiWord(F^.dwFileVersionMs),
                           LoWord(F^.dwFileVersionMs),
                           HiWord(F^.dwFileVersionLs),
                           Loword(F^.dwFileVersionLs)]
                         );
      end;

      StrDispose(Data);
   end;

   StrDispose(Parquivo);
end;

end.
