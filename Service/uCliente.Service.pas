unit uCliente.Service;


interface

uses
  uCliente.DTO;

type
  IClientService = interface
    ['{4DBDEA5A-9C74-49C5-BB31-3CAEB83FC3C8}']
    function BuscarPeloCodigo(const ACodigo: Integer): TClienteDTO;
  end;

  TClienteService = class(TInterfacedObject, IClientService)
  private
    class var FInstance: IClientService;
  public
    function BuscarPeloCodigo(const ACodigo: Integer): TClienteDTO;
    class function GetInstance: IClientService;
  end;

implementation

uses
  Data.DB,
  FireDAC.Stan.Param,
  FireDAC.Comp.Client,
  uConnection.Factory;

class function TClienteService.GetInstance: IClientService;
begin
  if FInstance = nil then
    FInstance := TClienteService.Create;
  Result := FInstance;
end;

function TClienteService.BuscarPeloCodigo(const ACodigo: Integer): TClienteDTO;
var
  Query: TFDQuery;
begin
  Result := TClienteDTO.Create;
  Query  := TFDQuery.Create(nil);
  try
    Query.Connection := TConnectionFactory.GetInstance.GetConnection;
    Query.SQL.Text := 'SELECT Codigo, Nome, Cidade, UF FROM Clientes WHERE Codigo = :Codigo';
    Query.ParamByName('Codigo').AsInteger := ACodigo;
    Query.Open;
    if Query.IsEmpty then
      Exit;

    Result.Codigo := Query.FieldByName('Codigo').AsInteger;
    Result.Nome   := Query.FieldByName('Nome').AsString;
    Result.Cidade := Query.FieldByName('Cidade').AsString;
    Result.UF     := Query.FieldByName('UF').AsString;
  finally
    Query.Free;
  end;
end;

end.

