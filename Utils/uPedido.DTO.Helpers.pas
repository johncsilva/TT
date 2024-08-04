unit uPedido.DTO.Helpers;

interface

Uses
  Data.DB,
  uPedido.DTO;

type
  TPedidoDTOHelper = class helper for TPedidoDTO
  private
  public
    procedure TableToItens(ADataset : TDataset);
    procedure ItensToTable(ADataset: TDataset);
  end;

implementation

{ TPedidoDTOHelper }

procedure TPedidoDTOHelper.TableToItens(ADataset : TDataset);
var
  Item : TPedidoItemDTO;
begin
  ADataset.First;
  ADataset.DisableControls;
  try
    while not ADataset.Eof do
    begin
      Item               := TPedidoItemDTO.Create;
      Item.Codigo        := ADataset.FieldByName('Codigo').AsInteger;
      Item.CodigoPedido  := ADataset.FieldByName('CodigoPedido').AsInteger;
      Item.CodigoProduto := ADataset.FieldByName('CodigoProduto').AsInteger;
      Item.Quantidade    := ADataset.FieldByName('Quantidade').AsFloat;
      Item.ValorUnitario := ADataset.FieldByName('ValorUnitario').AsFloat;
      Item.ValorTotal    := ADataset.FieldByName('ValorTotal').AsFloat;
      Self.Itens.Add(Item);
      ADataset.Next;
    end;
  finally
    ADataset.First;
    ADataset.EnableControls;
  end;
end;

procedure TPedidoDTOHelper.ItensToTable(ADataset : TDataset);
var
  i      : Integer;
  Evento : TDatasetNotifyEvent;
begin
  Evento := nil;
  ADataset.DisableControls;
  try
    Evento := ADataset.BeforeDelete;
    ADataset.BeforeDelete := nil;
    while ADataset.RecordCount > 0 do
      ADataset.Delete;
    for i := 0 to Pred(Self.Itens.Count) do
    begin
      ADataset.Append;
      ADataset.FieldByName('Codigo').AsInteger          := Self.Itens.Items[i].Codigo;
      ADataset.FieldByName('CodigoPedido').AsInteger    := Self.Itens.Items[i].CodigoPedido;
      ADataset.FieldByName('CodigoProduto').AsInteger   := Self.Itens.Items[i].CodigoProduto;
      ADataset.FieldByName('DescricaoProduto').AsString := Self.Itens.Items[i].DescricaoProduto;
      ADataset.FieldByName('Quantidade').AsFloat        := Self.Itens.Items[i].Quantidade;
      ADataset.FieldByName('ValorUnitario').AsFloat     := Self.Itens.Items[i].ValorUnitario;
      ADataset.FieldByName('ValorTotal').AsFloat        := Self.Itens.Items[i].ValorTotal;
      ADataset.Post;
    end;
  finally
    ADataset.BeforeDelete := Evento;
    ADataset.First;
    ADataset.EnableControls;
  end;
end;

end.
