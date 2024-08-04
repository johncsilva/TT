unit uCliente.Controller;


interface

uses
  System.SysUtils,
  uCliente.Service,
  uCliente.DTO;

type
  IClienteController = interface
    ['{CBD93E91-AA70-4932-B708-470FBB2B961F}']
    function BuscarPeloCodigo(const ACodigo: Integer): TClienteDTO;
  end;

  TClienteController = class(TInterfacedObject, IClienteController)
  private
    class var FInstance: IClienteController;
  public
    constructor Create();

    class function GetInstance: IClienteController;

    function BuscarPeloCodigo(const ACodigo: Integer): TClienteDTO;
  end;

implementation

constructor TClienteController.Create;
begin
end;

class function TClienteController.GetInstance: IClienteController;
begin
  if FInstance = nil then
    FInstance := TClienteController.Create;
  Result := FInstance;
end;

function TClienteController.BuscarPeloCodigo(const ACodigo: Integer):
    TClienteDTO;
begin
  Result := TClienteService.GetInstance.BuscarPeloCodigo(ACodigo);
end;

end.

