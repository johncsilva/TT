unit uConnection.Factory;

interface

uses
  System.SysUtils,
  System.Classes,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Stan.Def,
  FireDAC.Phys,
  FireDAC.Phys.Intf,
  FireDAC.Phys.MySQL,
  Firedac.Phys.MySQLWrapper,
  FireDAC.Phys.MySQLDef,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client,
  FireDAC.DApt,
  Data.DB,
  Data.SqlExpr;

type
  TConnectionFactory = class
  private
    class var FInstance: TConnectionFactory;
    FFDConnection: TFDConnection;
    FMySQLDriver: TFDPhysMySQLDriverLink;
    constructor Create;
    procedure ConexaoError(ASender, AInitiator: TObject; var AException: Exception);
    procedure TratarChaveEstrangeira(ErroFiredac: EMySqlNativeException);
    procedure TratarChavePrimaria(ErroFiredac: EMySqlNativeException);
    procedure TratarRegistroBloqueado(ErroFiredac: EFDDBEngineException);
  public
    destructor Destroy; override;

    function GetConnection: TFDConnection;

    class function GetInstance: TConnectionFactory;
    class procedure Release;
  end;

implementation

uses
  System.IniFiles;

constructor TConnectionFactory.Create;
var
  Ini : TIniFile;
begin
  inherited Create;
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
  try
    FMySQLDriver := TFDPhysMySQLDriverLink.Create(nil);
    FMySQLDriver.VendorLib := Ini.ReadString('MYSQL', 'LibMySQL', ExtractFilePath(ParamStr(0)) + 'libmysql.dll');

    FFDConnection := TFDConnection.Create(nil);
    FFDConnection.DriverName := 'MySQL';
    FFDConnection.Params.Values['Database']  := Ini.ReadString('MYSQL', 'Database', 'wk');
    FFDConnection.Params.Values['User_Name'] := Ini.ReadString('MYSQL', 'UserName', 'root');
    FFDConnection.Params.Values['HostName']  := Ini.ReadString('MYSQL', 'Server'  , 'localhost');
    FFDConnection.Params.Values['Port']      := Ini.ReadString('MYSQL', 'Port'    , '3306');
    FFDConnection.Params.Values['Password']  := Ini.ReadString('MYSQL', 'Password', '');
    FFDConnection.LoginPrompt := False;
    FFDConnection.OnError     := ConexaoError;
    FFDConnection.Connected   := True;
  finally
    Ini.Free;
  end;
end;

procedure TConnectionFactory.ConexaoError(ASender, AInitiator: TObject; var AException: Exception);
var
  ErroFiredac: EMySqlNativeException;
  MsgOriginal: string;
begin
  MsgOriginal := AException.Message;
  if AException is EMySqlNativeException then begin

    ErroFiredac := EMySqlNativeException(AException);

    case ErroFiredac.Kind of
      ekOther             : ErroFiredac.Message := '';
      ekNoDataFound       : ;
      ekTooManyRows       : ;
      ekRecordLocked      : TratarRegistroBloqueado(ErroFiredac);
      ekUKViolated        : TratarChavePrimaria(ErroFiredac);
      ekFKViolated        : TratarChaveEstrangeira(ErroFiredac);
      ekObjNotExists      : ;
      ekUserPwdInvalid    : ;
      ekUserPwdExpired    : ;
      ekUserPwdWillExpire : ;
      ekCmdAborted        : ;
      ekServerGone        : ;
      ekServerOutput      : ;
      ekArrExecMalfunc    : ;
      ekInvalidParams     : ;
    end;
  end;
end;

procedure TConnectionFactory.TratarRegistroBloqueado(ErroFiredac: EFDDBEngineException);
begin
  ErroFiredac.Message := 'Não foi possível realizar esta operação nesse momento, por favor tente novamente mais tarde!';;
end;

procedure TConnectionFactory.TratarChavePrimaria(ErroFiredac: EMySqlNativeException);
begin
  if SameText(ErroFiredac[0].ObjName, 'PK_PEDIDOS') then
    ErroFiredac.Message := Format( 'Já existe um %s com este mesmo código!!', ['Pedido'])
end;

procedure TConnectionFactory.TratarChaveEstrangeira(ErroFiredac: EMySqlNativeException);
begin
  if ErroFiredac[0].Message.Contains('target does not exist') then
  begin

  end
  else if ErroFiredac[0].Message.Contains('FOREIGN KEY constraint failed') then
  begin
    if (ErroFiredac.FDObjName.ToUpper.Contains('.UPDATE')) OR
       (ErroFiredac.FDObjName.ToUpper.Contains('.INSERT')) then
    begin
      if ErroFiredac.FDObjName.ToUpper.Contains('PEDIDO') then
      begin
        ErroFiredac.Message := Format('Não existe um %s com este código!!', ['Pedido']);
      end;
    end
    else if ErroFiredac.FDObjName.ToUpper.Contains('.DELETE') then
    begin
      if ErroFiredac.FDObjName.ToUpper.Contains('PEDIDO:') then
      begin
        ErroFiredac.Message := Format('Não é possível excluir esse registro. O mesmo esta sendo referenciado na tabela de %s!', ['PEDIDO']);
      end;
    end;
  end;
end;

destructor TConnectionFactory.Destroy;
begin
  FFDConnection.Free;
  FMySQLDriver.Free;
  inherited;
end;

class function TConnectionFactory.GetInstance: TConnectionFactory;
begin
  if FInstance = nil then
    FInstance := TConnectionFactory.Create;
  Result := FInstance;
end;

class procedure TConnectionFactory.Release;
begin
  FInstance.Free;
end;

function TConnectionFactory.GetConnection: TFDConnection;
begin
  Result := FFDConnection;
end;


end.


