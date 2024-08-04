unit uProduto.Controller;

interface

uses
  System.SysUtils,
  uProduto.Service,
  uProduto.DTO;

type
  IProdutoController = interface
    ['{A8A28107-713A-4218-8ED1-E21FA196E9A1}']
    function BuscarPeloCodigo(const ACodigo: Integer): TProdutoDTO;
  end;

  TProdutoController = class(TInterfacedObject, IProdutoController)
  private
    class var FInstance: IProdutoController;
  public
    constructor Create();

    class function GetInstance: IProdutoController;

    function BuscarPeloCodigo(const ACodigo: Integer): TProdutoDTO;
  end;

implementation

constructor TProdutoController.Create;
begin
end;

class function TProdutoController.GetInstance: IProdutoController;
begin
  if FInstance = nil then
    FInstance := TProdutoController.Create;
  Result := FInstance;
end;

function TProdutoController.BuscarPeloCodigo(const ACodigo: Integer):TProdutoDTO;
begin
  Result := TProdutoService.GetInstance.BuscarPeloCodigo(ACodigo);
end;

end.

