program TesteWK;

uses
  madExcept,
  madLinkDisAsm,
  madListProcesses,
  madListModules,
  Winapi.Windows,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Themes,
  Vcl.Styles,
  Vcl.Taskbar,
  System.Classes,
  System.SyncObjs,
  System.SysUtils,
  uMain.View in 'Views\uMain.View.pas' {MainView},
  uProduto.DTO in 'Models\uProduto.DTO.pas',
  uProduto.Controller in 'Controllers\uProduto.Controller.pas',
  uCliente.DTO in 'Models\uCliente.DTO.pas',
  uPedido.DTO in 'Models\uPedido.DTO.pas',
  uCliente.Controller in 'Controllers\uCliente.Controller.pas',
  uPedido.Controller in 'Controllers\uPedido.Controller.pas',
  uConnection.Factory in 'Data\uConnection.Factory.pas',
  uCliente.Service in 'Service\uCliente.Service.pas',
  uProduto.Service in 'Service\uProduto.Service.pas',
  uPedido.Service in 'Service\uPedido.Service.pas',
  uPedido.DTO.Helpers in 'Utils\uPedido.DTO.Helpers.pas',
  uProcura.View in 'Views\uProcura.View.pas' {ProcuraView};

{$R *.res}

const
  _TITULOAPP_ = 'Teste WK';

var
  AppMutex : TMutex  = nil;
  MutexErr : Integer = 0;
  MyApp    : TApplication;

function FindWindowExtd(ATitulo : string) : HWND;
var
  hWndTemp   : hWnd;
  iLenText   : Integer;
  cTitletemp : array [0 .. 254] of Char;
  sTitleTemp : string;
begin
  hWndTemp := FindWindow(nil, nil);
  while hWndTemp <> 0 do
  begin
    iLenText   := GetWindowText(hWndTemp, cTitletemp, 255);
    sTitleTemp := cTitletemp;
    sTitleTemp := UpperCase(copy(sTitleTemp, 1, iLenText));
    ATitulo    := UpperCase(ATitulo);
    if pos(ATitulo, sTitleTemp) <> 0 then
      Break;
    hWndTemp := GetWindow(hWndTemp, GW_HWNDNEXT);
  end;
  result := hWndTemp;
end;

function EstaEmExecucao : Boolean;
const
  UNIQUE_MUTEX_NAME = '{AD12094E-7308-4067-8CAC-565A1FF3ADDC}';
begin
  Result   := False;
  AppMutex := TMutex.Create(nil, True, UNIQUE_MUTEX_NAME);
  MutexErr := GetLastError;
  if MutexErr <> ERROR_SUCCESS then
  begin
    Application.MessageBox(PWideChar(_TITULOAPP_ + ' já se encontra em execução!' ), 'Atenção', MB_OK);
    Exit(True);
  end;
end;

begin
  MyApp := Application;
  MyApp.Title := _TITULOAPP_;
  try
    try
      if EstaEmExecucao then
        Exit;
      ReportMemoryLeaksOnShutdown := True;
      MyApp.Initialize;
      MyApp.MainFormOnTaskbar := True;
      MyApp.CreateForm(TMainView, MainView);
      MyApp.Run;
    except
      on e : exception do
        ShowMessage(e.Message);
    end;
  finally
    if Assigned(AppMutex) then
      AppMutex.Free;
  end;
end.
