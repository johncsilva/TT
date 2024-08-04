unit uPedido.DTO;

interface

uses
  Rest.Json.Types,
  System.Generics.Collections;

type
  TPedidoItemDTO = class;

  TPedidoDTO = class
  private
    FCodigo        : Integer;
    FCodigoCliente : Integer;
    FDataEmissao   : TDateTime;
    FValorTotal    : Extended;
    FItens         : TObjectList<TPedidoItemDTO>;
  public
    constructor Create;
    destructor  Destroy; override;

    property Codigo        : Integer   read FCodigo        write FCodigo;
    property CodigoCliente : Integer   read FCodigoCliente write FCodigoCliente;
    property DataEmissao   : TDateTime read FDataEmissao   write FDataEmissao;
    property ValorTotal    : Extended  read FValorTotal    write FValorTotal;

    property Itens : TObjectList<TPedidoItemDTO> read FItens Write FItens;
  end;

  TPedidoItemDTO = class
  private
    FCodigo           : Integer;
    FCodigoPedido     : Integer;
    FCodigoProduto    : Integer;
    [JSONMarshalled(False)]
    FDescricaoProduto : String;
    FQuantidade       : Extended;
    FValorUnitario    : Extended;
    FValorTotal       : Extended;
  public
    property Codigo           : Integer  read FCodigo           write FCodigo;
    property CodigoPedido     : Integer  read FCodigoPedido     write FCodigoPedido;
    property CodigoProduto    : Integer  read FCodigoProduto    write FCodigoProduto;
    property DescricaoProduto : string   read FDescricaoProduto write FDescricaoProduto;
    property Quantidade       : Extended read FQuantidade       write FQuantidade;
    property ValorUnitario    : Extended read FValorUnitario    write FValorUnitario;
    property ValorTotal       : Extended read FValorTotal       write FValorTotal;
  end;

implementation

{ TPedidoDTO }

constructor TPedidoDTO.Create;
begin
  FItens := TObjectList<TPedidoItemDTO>.Create;
end;

destructor TPedidoDTO.Destroy;
begin
  FItens.Free;
  inherited;
end;

end.

