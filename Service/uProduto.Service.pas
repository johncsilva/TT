unit uProduto.Service;

interface

uses
  Data.DB,
  FireDAC.Stan.Param,
  FireDAC.Comp.Client,
  uProduto.DTO;

type
  IProdutoService = interface
    ['{FAF51A11-D790-4F77-96B7-C1DE4DE3D6C2}']
    function BuscarPeloCodigo(const ACodigo: Integer): TProdutoDTO;
  end;

  TProdutoService = class(TInterfacedObject, IProdutoService)
  private
    class var FInstance: IProdutoService;
  public
    function BuscarPeloCodigo(const ACodigo: Integer): TProdutoDTO;
    class function GetInstance: IProdutoService;
  end;

implementation

uses
  uConnection.Factory;

class function TProdutoService.GetInstance: IProdutoService;
begin
  if FInstance = nil then
    FInstance := TProdutoService.Create;
  Result := FInstance;
end;

function TProdutoService.BuscarPeloCodigo(const ACodigo: Integer): TProdutoDTO;
var
  Query: TFDQuery;
begin
  Result := TProdutoDTO.Create;
  Query  := TFDQuery.Create(nil);
  try
    Query.Connection := TConnectionFactory.GetInstance.GetConnection;
    Query.SQL.Text := 'SELECT Codigo, Descricao, PrecoVenda FROM Produtos WHERE Codigo = :Codigo';
    Query.ParamByName('Codigo').AsInteger := ACodigo;
    Query.Open;
    if Query.IsEmpty then
      Exit;

    Result.Codigo     := Query.FieldByName('Codigo').AsInteger;
    Result.Descricao  := Query.FieldByName('Descricao').AsString;
    Result.PrecoVenda := Query.FieldByName('PrecoVenda').AsFloat;
  finally
    Query.Free;
  end;
end;

end.

