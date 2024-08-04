unit uPedido.Controller;


interface

uses
  System.SysUtils,
  uMain.View,
  uCliente.DTO,
  uPedido.DTO;

type
  IPedidoController = interface
    ['{F6BF339B-52D5-43B6-A38D-94B0CF735767}']
    function GravarPedido(var APedido : TPedidoDTO): boolean;
    function CancelarPeloCodigo(const ACodigo : Integer): boolean;
    function BuscarPeloCodigo(const ACodigo: Integer;
      out APedido : TPedidoDTO;
      out ACliente : TClienteDTO): Boolean;
  end;

  TPedidoController = class(TInterfacedObject, IPedidoController)
  private
    class var FInstance: IPedidoController;
  public
    constructor Create();

    class function GetInstance: IPedidoController;

    function GravarPedido(var APedido : TPedidoDTO): boolean;
    function CancelarPeloCodigo(const ACodigo : Integer): boolean;
    function BuscarPeloCodigo(const ACodigo: Integer;
      out APedido : TPedidoDTO;
      out ACliente : TClienteDTO): Boolean;
  end;

implementation

Uses
  uPedido.Service;

function TPedidoController.CancelarPeloCodigo(const ACodigo: Integer): boolean;
begin
  Result := TPedidoService.GetInstance.CancelarPeloCodigo(ACodigo);
end;

constructor TPedidoController.Create;
begin
end;

class function TPedidoController.GetInstance: IPedidoController;
begin
  if FInstance = nil then
    FInstance := TPedidoController.Create;
  Result := FInstance;
end;

function TPedidoController.BuscarPeloCodigo(const ACodigo: Integer; out APedido: TPedidoDTO; out ACliente: TClienteDTO): Boolean;
begin
  Result := TPedidoService.GetInstance.BuscarPeloCodigo(ACodigo, APedido, ACliente);
end;

function TPedidoController.GravarPedido(var APedido : TPedidoDTO): boolean;
begin
  Result := TPedidoService.GetInstance.GravarPedido(APedido);
end;

end.

