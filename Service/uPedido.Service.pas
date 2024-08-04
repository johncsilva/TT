unit uPedido.Service;


interface

uses
  System.SysUtils,
  Data.DB,
  FireDAC.Stan.Param,
  FireDAC.Comp.Client,
  uPedido.DTO,
  uCliente.DTO;

type
  IPedidoService = interface
    ['{CBD93E91-AA70-4932-B708-470FBB2B961F}']
    function GravarPedido(var APedido : TPedidoDTO): Boolean;
    function CancelarPeloCodigo(const ACodigo : Integer): boolean;
    function BuscarPeloCodigo(const ACodigo: Integer;
      out APedido : TPedidoDTO;
      out ACliente : TClienteDTO): Boolean;
  end;

  TPedidoService = class(TInterfacedObject, IPedidoService)
  private
    class var FInstance: IPedidoService;
    procedure PreencheDadosPedido(AQuery: TFDQuery; out APedido : TPedidoDTO);
    procedure PreencheDadosCliente(AQuery: TFDQuery; out ACliente : TClienteDTO);
    procedure PreencheDadosItens(AQuery: TFDQuery; out APedido : TPedidoDTO);
  public
    function GravarPedido(var APedido : TPedidoDTO): Boolean;
    function CancelarPeloCodigo(const ACodigo : Integer): boolean;
    function BuscarPeloCodigo(const ACodigo: Integer;
      out APedido : TPedidoDTO;
      out ACliente : TClienteDTO): Boolean;
    class function GetInstance: IPedidoService;
  end;

implementation

uses
  uConnection.Factory, System.Variants;

function TPedidoService.CancelarPeloCodigo(const ACodigo: Integer): boolean;
var
  Conexao : TFDConnection;
begin
  Result := False;
  Conexao := TConnectionFactory.GetInstance.GetConnection;
  try
    Conexao.StartTransaction;
    Conexao.ExecSQL('DELETE FROM PEDIDOSITENS WHERE CODIGOPEDIDO = :ID', [ACodigo]);
    Conexao.ExecSQL('DELETE FROM PEDIDOS WHERE CODIGO = :ID', [ACodigo]);
    Conexao.Commit;
  except
    Conexao.Rollback;
    Raise;
  end;
end;

class function TPedidoService.GetInstance: IPedidoService;
begin
  if FInstance = nil then
    FInstance := TPedidoService.Create;
  Result := FInstance;
end;

procedure TPedidoService.PreencheDadosItens(AQuery: TFDQuery; out APedido : TPedidoDTO);
var
  Item: TPedidoItemDTO;
begin
  if AQuery.FieldByName('CodigoItem').AsString = EmptyStr then // Pedido não tem itens..
    Exit;

  AQuery.First;
  while not AQuery.Eof do
  begin
    Item                  := TPedidoItemDTO.Create;
    Item.Codigo           := AQuery.FieldByName('CodigoItem').AsInteger;
    Item.CodigoPedido     := AQuery.FieldByName('CodigoPedido').AsInteger;
    Item.CodigoProduto    := AQuery.FieldByName('CodigoProduto').AsInteger;
    Item.DescricaoProduto := AQuery.FieldByName('DescricaoProduto').AsString;
    Item.Quantidade       := AQuery.FieldByName('Quantidade').AsFloat;
    Item.ValorUnitario    := AQuery.FieldByName('ValorUnitario').AsFloat;
    Item.ValorTotal       := AQuery.FieldByName('ItemValorTotal').AsFloat;
    APedido.Itens.Add(Item);
    AQuery.Next;
  end;
end;

procedure TPedidoService.PreencheDadosPedido(AQuery: TFDQuery; out APedido : TPedidoDTO);
begin
  APedido               := TPedidoDTO.Create;
  APedido.Codigo        := AQuery.FieldByName('CodigoPedido').AsInteger;
  APedido.CodigoCliente := AQuery.FieldByName('CodigoCliente').AsInteger;
  APedido.DataEmissao   := AQuery.FieldByName('DataEmissao').AsDateTime;
  APedido.ValorTotal    := AQuery.FieldByName('PedidoValorTotal').AsFloat;

  PreencheDadosItens(AQuery, APedido);
end;

procedure TPedidoService.PreencheDadosCliente(AQuery: TFDQuery; out ACliente : TClienteDTO);
begin
  ACliente        := TClienteDTO.Create;
  ACliente.Codigo := AQuery.FieldByName('CodigoCliente').AsInteger;
  ACliente.Nome   := AQuery.FieldByName('ClienteNome').AsString;
  ACliente.Cidade := AQuery.FieldByName('Cidade').AsString;
  ACliente.UF     := AQuery.FieldByName('UF').AsString;
end;

function TPedidoService.GravarPedido(var APedido : TPedidoDTO): Boolean;
const
  _SQL_PEDIDOS_ =  'INSERT INTO PEDIDOS ' +
    ' ( CODIGO,  DATAEMISSAO,  CODIGOCLIENTE,  VALORTOTAL) VALUES ' +
    ' (:CODIGO, :DATAEMISSAO, :CODIGOCLIENTE, :VALORTOTAL) ' +
    ' ON DUPLICATE KEY UPDATE ' +
    '   CODIGOCLIENTE = VALUES(CODIGOCLIENTE), ' +
    '   DATAEMISSAO = VALUES(DATAEMISSAO), ' +
    '   VALORTOTAL = VALUES(VALORTOTAL) ';
  _SQL_PEDIDOS_ITENS_ = 'INSERT INTO PEDIDOSITENS '+
    ' ( CODIGO,  CODIGOPEDIDO,  CODIGOPRODUTO,  QUANTIDADE,  VALORUNITARIO,  VALORTOTAL) VALUES ' +
    ' (:CODIGO, :CODIGOPEDIDO, :CODIGOPRODUTO, :QUANTIDADE, :VALORUNITARIO, :VALORTOTAL)' +
    ' ON DUPLICATE KEY UPDATE ' +
    '   CODIGOPEDIDO = VALUES(CODIGOPEDIDO), ' +
    '   CODIGOPRODUTO = VALUES(CODIGOPRODUTO), ' +
    '   QUANTIDADE = VALUES(QUANTIDADE), ' +
    '   VALORUNITARIO = VALUES(VALORUNITARIO),' +
    '   VALORTOTAL = VALUES(VALORTOTAL) ';
var
  Query       : TFDQuery;
  Conexao     : TFDConnection;
  iCodPedido  : Integer;
  vValor      : Variant;
  i           : integer;
begin
  Result  := False;
  Conexao := nil;
  Query   := TFDQuery.Create(nil);
  try
    try
      Conexao := TConnectionFactory.GetInstance.GetConnection;
      if APedido.Codigo > 0 then
        iCodPedido := APedido.Codigo
      else
      begin
        iCodPedido := 0;
        vValor     := Conexao.ExecSQLScalar('SELECT MAX(CODIGO) FROM PEDIDOS');
        if not VarIsNull(vValor) then
          iCodPedido := vValor;
        Inc(iCodPedido);
      end;

      Conexao.StartTransaction;
      Query.Connection                             := Conexao;
      Query.SQL.Text                               := _SQL_PEDIDOS_;
      Query.ParamByName('Codigo').AsInteger        := iCodPedido;
      Query.ParamByName('DataEmissao').AsDateTime  := APedido.DataEmissao;
      Query.ParamByName('CodigoCliente').AsInteger := APedido.CodigoCliente;
      Query.ParamByName('ValorTotal').AsFloat      := APedido.ValorTotal;
      Query.ExecSQL;

      Query.SQL.Text         := _SQL_PEDIDOS_ITENS_;
      Query.Params.ArraySize := APedido.Itens.Count;
      for i := 0 to Pred(APedido.Itens.Count) do
      begin
        if APedido.Itens.Items[i].Codigo > 0 then
          Query.ParamByName('Codigo').AsIntegers[i] := APedido.Itens.Items[i].Codigo;
        Query.ParamByName('CodigoPedido').AsIntegers[i]  := iCodPedido;
        Query.ParamByName('CodigoProduto').AsIntegers[i] := APedido.Itens.Items[i].CodigoProduto;
        Query.ParamByName('Quantidade').AsFloats[i]      := APedido.Itens.Items[i].Quantidade;
        Query.ParamByName('ValorUnitario').AsFloats[i]   := APedido.Itens.Items[i].ValorUnitario;
        Query.ParamByName('ValorTotal').AsFloats[i]      := APedido.Itens.Items[i].ValorTotal;
      end;
      Query.Execute(APedido.Itens.Count, 0);

      Conexao.Commit;

      APedido.Codigo := iCodPedido;
      Result         := True;
    except
      Conexao.Rollback;
      Raise;
    end;
  finally
    Query.Free;
  end;
end;

function TPedidoService.BuscarPeloCodigo(const ACodigo: Integer;
  out APedido : TPedidoDTO;
  out ACliente : TClienteDTO): Boolean;
const
  _SQL_ =
    ' SELECT P1.Codigo CodigoPedido, P1.CodigoCliente, P1.DataEmissao, P1.ValorTotal PedidoValorTotal, ' +
    '        P2.Codigo CodigoItem, P2.CodigoProduto, P2.Quantidade, P2.ValorUnitario, P2.ValorTotal ItemValorTotal, ' +
    '        P3.Descricao DescricaoProduto, ' +
    '        C1.Codigo CodigoCliente, C1.Nome ClienteNome, C1.Cidade, C1.UF ' +
    '   FROM Pedidos P1 ' +
    '  INNER JOIN Clientes C1 ' +
    '     ON C1.Codigo = P1.CodigoCliente ' +
    '   LEFT JOIN PedidosItens P2' +
    '     ON P2.CodigoPedido = P1.Codigo' +
    '   LEFT JOIN Produtos P3' +
    '     ON P3.Codigo = P2.CodigoProduto' +
    '  WHERE P1.Codigo = :Codigo';
var
  Query: TFDQuery;
begin
  Result := False;
  Query  := TFDQuery.Create(nil);
  try
    Query.Connection := TConnectionFactory.GetInstance.GetConnection;
    Query.SQL.Text := _SQL_;
    Query.ParamByName('Codigo').AsInteger := ACodigo;
    Query.Open;
    if Query.IsEmpty then
      Exit;

    PreencheDadosPedido(Query, APedido);
    PreencheDadosCliente(Query, ACliente);
  finally
    Query.Free;
  end;
end;

end.


