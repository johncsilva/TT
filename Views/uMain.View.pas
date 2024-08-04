unit uMain.View;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Types,
  System.ImageList,
  Vcl.ImgList,
  Vcl.Buttons,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Grids,
  Vcl.DBGrids,
  Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TMainView = class(TForm)
    pnlDadosProduto: TPanel;
    pnlBody: TPanel;
    pnlBottom: TPanel;
    edtProduto: TEdit;
    edtNomeProduto: TEdit;
    lbProduto: TLabel;
    edtQuantidade: TEdit;
    edtPrecoVenda: TEdit;
    lbQuantidade: TLabel;
    lbPrecoVenda: TLabel;
    btnInserirProduto: TButton;
    gridItensPedido: TDBGrid;
    tbItensPedido: TFDMemTable;
    dsItensPedido: TDataSource;
    fieldProdutosCodigoProduto: TIntegerField;
    fieldProdutosDescricaoProduto: TStringField;
    FieldProdutosQuantidade: TFloatField;
    FieldProdutosValorUnitario: TFloatField;
    FieldProdutosValorTotal: TFloatField;
    pnlDadosCliente: TPanel;
    lbCliente: TLabel;
    edtCliente: TEdit;
    edtNomeCliente: TEdit;
    lbClienteNome: TLabel;
    lbCidade: TLabel;
    edtCidade: TEdit;
    lbUF: TLabel;
    edtUF: TEdit;
    btnGravarPedido: TButton;
    btnCancelarPedido: TButton;
    btnBuscarPedido: TButton;
    fieldItensPedidoCodigo: TIntegerField;
    fieldItensPedidoCodigoPedido: TIntegerField;
    btnNovoPedido: TButton;
    btnProcuraCliente: TSpeedButton;
    ilImagens: TImageList;
    btnProcuraProduto: TSpeedButton;
    lbTotalPedido: TLabel;
    procedure btnBuscarPedidoClick(Sender: TObject);
    procedure btnNovoPedidoClick(Sender: TObject);
    procedure btnCancelarPedidoClick(Sender: TObject);
    procedure btnGravarPedidoClick(Sender: TObject);
    procedure btnInserirProdutoClick(Sender: TObject);
    procedure btnProcuraClienteClick(Sender: TObject);
    procedure btnProcuraProdutoClick(Sender: TObject);
    procedure edtClienteChange(Sender: TObject);
    procedure edtClienteExit(Sender: TObject);
    procedure edtClienteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtPrecoVendaChange(Sender: TObject);
    procedure edtPrecoVendaEnter(Sender: TObject);
    procedure edtPrecoVendaExit(Sender: TObject);
    procedure edtPrecoVendaKeyPress(Sender: TObject; var Key: Char);
    procedure edtProdutoChange(Sender: TObject);
    procedure edtProdutoExit(Sender: TObject);
    procedure edtProdutoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtQuantidadeChange(Sender: TObject);
    procedure edtQuantidadeEnter(Sender: TObject);
    procedure edtQuantidadeExit(Sender: TObject);
    procedure edtQuantidadeKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure gridItensPedidoEnter(Sender: TObject);
    procedure gridItensPedidoExit(Sender: TObject);
    procedure gridItensPedidoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tbItensPedidoAfterPost(DataSet: TDataSet);
    procedure tbItensPedidoBeforeDelete(DataSet: TDataSet);
    procedure tbItensPedidoBeforeInsert(DataSet: TDataSet);
    procedure tbItensPedidoCalcFields(DataSet: TDataSet);
  private
    FCodigoPedido : Integer;
    function getFormatoFloat: String;
    function ValidarValorNumerico(ASender : TEdit; out ACodigo : Integer): boolean;
    procedure ValidarValorExit(Sender: TObject);
    procedure ValidarKeyPress(Sender: TObject; var Key: Char);
    procedure LimparDadosProduto(const ALimparCodigo : boolean = false);
    procedure LimparDadosCliente(ALimparCodigo : Boolean = False);
    procedure HabilitaBotaoInserir;
    procedure InicializaPropriedades;
    procedure EditarProduto;
    procedure VerificarConexaoBanco;
    procedure InicializaDatasets;
    procedure GravarPedido;
    procedure InserirProduto;
    function BuscarPedido(out ARetorno : String): Boolean;
    function RetornarValor(const AValue: string): Extended;
    procedure Focar(ASender: TWinControl);
    procedure CriarNovoPedido(const APedeConfirmacao : boolean = False);
    procedure ProcurarCliente;
    procedure ProcurarProduto;
    procedure TratarEntradaEdit(Sender: TObject);
  public
  end;

const
  _VALOR_INVALIDO_      = -1;
  _CASAS_DECIMAIS_      = 2;
  _CAPTION_BTN_INSERIR_ = 'Inserir Produto [Ctrl+Ins]';
  _CAPTION_BTN_EDITAR_  = 'Editar Produto [Ctrl+Ins]';

var
  MainView: TMainView;

implementation

uses
  uConnection.Factory,
  uCliente.DTO,
  uProduto.DTO,
  uPedido.DTO,
  uCliente.Controller,
  uProduto.Controller,
  uPedido.Controller,
  uPedido.DTO.Helpers,
  uProcura.View;

{$R *.dfm}

procedure TMainView.Focar(ASender : TWinControl);
begin
  if ASender.CanFocus then
    ASender.SetFocus;
end;

function TMainView.BuscarPedido(out ARetorno : String): Boolean;
var
  vRetorno : Variant;
begin
  Result := False;
  TProcurar
    .GetInstance
      .SetaTabela('PEDIDOS')
      .AddCampo('PEDIDOS','CODIGO', 'CODIGO', 'Código', 10, True, True, True)
      .AddCampo('PEDIDOS','CODIGOCLIENTE', 'CODIGOCLIENTE', 'Código Cliente', 10, True, True)
      .AddCampo('CLIENTES','NOME', 'NOME', 'Nome Cliente', 50, True, True, True)
      .AddCampo('CLIENTES','CIDADE', 'CIDADE', '', 50, False, True)
      .AddCampo('CLIENTES','UF', 'UF', '', 50, False, True, True)
      .AddCampo('PEDIDOS','DATAEMISSAO', 'DATAEMISSAO', 'Data Emissão', 10, True, False)
      .AddCampo('PEDIDOS','VALORTOTAL', 'VALORTOTAL', 'Valor Total', 10, True, False, True)
      .SetaJoin('JOIN CLIENTES ON CLIENTES.CODIGO = PEDIDOS.CODIGOCLIENTE')
    .Executa
    .Retorno(vRetorno);
  if VarIsNull(vRetorno) then
    Exit;

  ARetorno := vRetorno;
  Result := True;
end;

procedure TMainView.btnBuscarPedidoClick(Sender: TObject);
var
  Cliente   : TClienteDTO;
  Pedido    : TPedidoDTO;
  sValor    : String;
  slRetorno : TStringlist;
begin
  if not BuscarPedido(sValor) then
    Exit;

  slRetorno := TStringlist.Create;
  try
    slRetorno.Delimiter       := ';';
    slRetorno.StrictDelimiter := True;
    slRetorno.DelimitedText   := sValor;
    TPedidoController.GetInstance.BuscarPeloCodigo(
      slRetorno.Values['CODIGO'].ToInteger,
      Pedido,
      Cliente
    );
    FCodigoPedido       := Pedido.Codigo;
    edtCliente.Text     := Cliente.Codigo.ToString;
    edtNomeCliente.Text := Cliente.Nome;
    edtCidade.Text      := Cliente.Cidade;
    edtUf.Text          := Cliente.UF;
    edtCliente.Tag      := Cliente.Codigo;
    Pedido.ItensToTable(tbItensPedido);
  finally
    FreeAndNil(Pedido);
    FreeAndNil(Cliente);
    slRetorno.Free;
  end;
end;

procedure TMainView.btnNovoPedidoClick(Sender: TObject);
begin
  CriarNovoPedido(True);
end;

procedure TMainView.CriarNovoPedido(const APedeConfirmacao : boolean = False);
begin
  if (APedeConfirmacao) and
     (Application.MessageBox('Deseja criar um novo pedido? As alterações atuais serão perdidas.',
      'Atenção', MB_YESNO OR MB_ICONQUESTION OR MB_DEFBUTTON2) = IDNO) then
    Exit;

  LimparDadosCliente(True);
  LimparDadosProduto(True);
  tbItensPedido.EmptyDataSet;
  FCodigoPedido := -1;
  edtCliente.Tag := -1;
  Focar(edtCliente);
  lbTotalPedido.Caption := 'Total do Pedido: R$ 0,00';
end;

procedure TMainView.btnCancelarPedidoClick(Sender: TObject);
var
  slRetorno : TStringlist;
  sValor    : String;
  sDados    : String;
begin
  if not BuscarPedido(sValor) then
    Exit;

  slRetorno := TStringlist.Create;
  try
    slRetorno.Delimiter       := ';';
    slRetorno.StrictDelimiter := True;
    slRetorno.DelimitedText   := sValor;
    sDados := 'Confirma a exclusão desse pedido?' + sLineBreak +
      'Pedido Número: ' + slRetorno.Values['CODIGO'] + sLineBreak +
      'Cliente: ' + slRetorno.Values['NOME'] + sLineBreak +
      'Valor: ' + slRetorno.Values['VALORTOTAL'];
    if Application.MessageBox(PWideChar(sDados), 'Atenção', MB_YESNO OR MB_ICONQUESTION OR MB_DEFBUTTON2) = IDNO then
      Exit;
    TPedidoController.GetInstance.CancelarPeloCodigo(
      slRetorno.Values['CODIGO'].ToInteger
    );
  finally
    slRetorno.Free;
  end;
end;

procedure TMainView.btnGravarPedidoClick(Sender: TObject);
begin
  GravarPedido;
end;

procedure TMainView.GravarPedido;
var
  Pedido : TPedidoDTO;
begin
  if edtCliente.Text = EmptyStr then
  begin
    Application.MessageBox('Não é possível salvar um pedido sem cliente!',
      'Erro', MB_OK OR MB_ICONERROR);
    Focar(edtCliente);
    Exit;
  end;

  if tbItensPedido.IsEmpty then
  begin
    Application.MessageBox('Não é possível salvar um pedido sem itens!',
      'Erro', MB_OK OR MB_ICONERROR);
    Focar(edtProduto);
    Exit;
  end;

  if Application.MessageBox('Confirma a gravação do pedido?', 'Atenção', MB_YESNO OR MB_ICONQUESTION) = IDNO then
    Exit;

  Pedido := TPedidoDTO.Create;
  try
    Pedido.Codigo        := FCodigoPedido;
    Pedido.CodigoCliente := StrToIntDef(edtCliente.Text, 0);
    Pedido.DataEmissao   := Date;
    Pedido.ValorTotal    := tbItensPedido.Aggregates[0].Value;
    Pedido.TableToItens(tbItensPedido);
    if not TPedidoController.GetInstance.GravarPedido(Pedido) then
      Exit;
    Application.MessageBox(PWideChar(Format('Pedido %d gravado com sucesso!!', [Pedido.Codigo])),
      'Aviso', MB_OK OR MB_ICONINFORMATION);
    CriarNovoPedido;
  finally
    Pedido.Free;
  end;
end;

procedure TMainView.btnInserirProdutoClick(Sender: TObject);
begin
  InserirProduto;
end;

procedure TMainView.btnProcuraClienteClick(Sender: TObject);
begin
  ProcurarCliente;
end;

procedure TMainView.btnProcuraProdutoClick(Sender: TObject);
begin
  ProcurarProduto;
end;

procedure TMainView.ProcurarProduto;
var
  slRetorno: TStringlist;
  vRetorno : Variant;
begin
  TProcurar
    .GetInstance
      .SetaTabela('PRODUTOS')
      .AddCampo('PRODUTOS','DESCRICAO', 'DESCRICAO', 'Descrição', 80, True, True, True)
      .AddCampo('PRODUTOS','CODIGO', 'CODIGO', 'Código', 10, True, True, True)
      .AddCampo('PRODUTOS','PRECOVENDA', 'PRECOVENDA', 'Preço de Venda', 20, True, True, True)
    .Executa
    .Retorno(vRetorno);
  if VarIsNull(vRetorno) then
    Exit;

  slRetorno := TStringlist.Create;
  try
    slRetorno.Delimiter       := ';';
    slRetorno.StrictDelimiter := True;
    slRetorno.DelimitedText   := vRetorno;
    edtProduto.Text           := slRetorno.Values['CODIGO'];
    edtNomeProduto.Text       := slRetorno.Values['DESCRICAO'];
    edtPrecoVenda.Text        := slRetorno.Values['PRECOVENDA'];
    Focar(edtQuantidade);
  finally
    slRetorno.Free;
  end;
end;

procedure TMainView.ProcurarCliente;
var
  slRetorno: TStringlist;
  vRetorno : Variant;
begin
  TProcurar
    .GetInstance
      .SetaTabela('CLIENTES')
      .AddCampo('CLIENTES','NOME', 'NOME', 'Nome Cliente', 50, True, True, True)
      .AddCampo('CLIENTES','CODIGO', 'CODIGO', 'Código', 10, True, True, True)
      .AddCampo('CLIENTES','CIDADE', 'CIDADE', 'Cidade', 50, True, True, True)
      .AddCampo('CLIENTES','UF', 'UF', 'UF', 5, True, True, True)
    .Executa
    .Retorno(vRetorno);
  if VarIsNull(vRetorno) then
    Exit;

  slRetorno := TStringlist.Create;
  try
    slRetorno.Delimiter       := ';';
    slRetorno.StrictDelimiter := True;
    slRetorno.DelimitedText   := vRetorno;
    edtCliente.Text           := slRetorno.Values['CODIGO'];
    edtNomeCliente.Text       := slRetorno.Values['NOME'];
    edtCidade.Text            := slRetorno.Values['CIDADE'];
    edtUF.Text                := slRetorno.Values['UF'];
    Focar(edtProduto);
  finally
    slRetorno.Free;
  end;
end;

procedure TMainView.InserirProduto;
begin
  if btnInserirProduto.Caption = _CAPTION_BTN_INSERIR_ then
  begin
    tbItensPedido.Append;
    fieldProdutosCodigoProduto.AsString    := edtProduto.Text;
    fieldProdutosDescricaoProduto.AsString := edtNomeProduto.Text;
  end
  else
  begin
    tbItensPedido.Edit;
    btnInserirProduto.Caption := _CAPTION_BTN_INSERIR_;
  end;
  fieldProdutosQuantidade.AsFloat    := RetornarValor(edtQuantidade.Text);
  fieldProdutosValorUnitario.AsFloat := RetornarValor(edtPrecoVenda.Text);
  tbItensPedido.Post;
  LimparDadosProduto(True);
  edtProduto.Enabled := True;
  edtProduto.Color   := clWindow;
  Focar(edtProduto);
end;

function TMainView.getFormatoFloat: String;
begin
  Result := '#,##0.' + StringOfChar('0', _CASAS_DECIMAIS_);
end;

procedure TMainView.edtClienteChange(Sender: TObject);
begin
  LimparDadosCliente;
  btnCancelarPedido.Visible := edtCliente.Text = EmptyStr;
  btnBuscarPedido.Visible := edtCliente.Text = EmptyStr;
end;

procedure TMainView.LimparDadosCliente(ALimparCodigo : Boolean = False);
begin
  if ALimparCodigo then
    edtCliente.Clear;
  edtNomeCliente.Clear;
  edtCidade.Clear;
  edtUF.Clear;
end;

function TMainView.ValidarValorNumerico(ASender : TEdit; out ACodigo : Integer): boolean;
begin
  Result := True;
  ACodigo := StrToIntDef(ASender.Text, _VALOR_INVALIDO_);
  if ACodigo = _VALOR_INVALIDO_ then
  begin
    Focar(ASender);
    Application.MessageBox('Digite apenas valores inteiros!', 'Atenção', MB_OK OR MB_ICONERROR);
    Exit(False);
  end;
end;

procedure TMainView.edtClienteExit(Sender: TObject);
var
  Cliente : TClienteDTO;
  iCodigo : Integer;
begin
  Cliente := nil;
  if (edtCliente.Text = EmptyStr) or
     ((edtCliente.Tag > 0)and
      (edtCliente.Tag = StrToInt(edtCliente.Text))) then
    Exit;

  if not ValidarValorNumerico(edtCliente, iCodigo) then
    Exit;

  try
    Cliente := TClienteController.GetInstance.BuscarPeloCodigo(iCodigo);
    if Cliente.Codigo <> iCodigo then
    begin
      Focar(edtCliente);
      Application.MessageBox(PWideChar('Cliente não encontrado!' + sLineBreak +
        'Verifique o valor digitado e tente novamente.'),
        'Atenção', MB_OK OR MB_ICONERROR);
      Exit;
    end;
    edtNomeCliente.Text := Cliente.Nome;
    edtCidade.Text      := Cliente.Cidade;
    edtUF.Text          := Cliente.UF;
    edtCliente.Tag      := StrToInt(edtCliente.Text);
  finally
    Cliente.Free;
  end;
end;

procedure TMainView.edtPrecoVendaChange(Sender: TObject);
begin
  HabilitaBotaoInserir;
end;

procedure TMainView.edtProdutoChange(Sender: TObject);
begin
  LimparDadosProduto;
  HabilitaBotaoInserir;
end;

procedure TMainView.LimparDadosProduto(const ALimparCodigo : boolean = false);
begin
  if ALimparCodigo then
    edtProduto.Clear;
  edtNomeProduto.Clear;
  edtProduto.Enabled  := True;
  edtProduto.Color    := clWindow;
  edtQuantidade.Text  := FormatFloat(getFormatoFloat, 0);
  edtPrecoVenda.Text  := FormatFloat(getFormatoFloat, 0);
  btnInserirProduto.Caption := _CAPTION_BTN_INSERIR_;
end;

function TMainView.RetornarValor(const AValue : string): Extended;
begin
  Result := StrToFloatDef(StringReplace(AValue,FormatSettings.ThousandSeparator, '', [rfReplaceAll]) , 0);
end;

procedure TMainView.HabilitaBotaoInserir;
begin
  btnInserirProduto.Enabled :=
    (edtNomeProduto.Text <> EmptyStr) and
    (RetornarValor(edtQuantidade.Text) > 0) and
    (RetornarValor(edtPrecoVenda.Text) > 0)
end;

procedure TMainView.edtProdutoExit(Sender: TObject);
var
  Produto : TProdutoDTO;
  iCodigo : Integer;
begin
  Produto := nil;
  if (edtProduto.Text = EmptyStr) then
    Exit;

  if not ValidarValorNumerico(edtProduto, iCodigo) then
    Exit;

  try
    Produto := TProdutoController.GetInstance.BuscarPeloCodigo(iCodigo);
    if Produto.Codigo <> iCodigo then
    begin
      Focar(edtProduto);
      Application.MessageBox(PWideChar('Produto não encontrado!' + sLineBreak +
        'Verifique o valor digitado e tente novamente.'),
        'Atenção', MB_OK OR MB_ICONERROR);
      Exit;
    end;
    edtNomeProduto.Text := Produto.Descricao;
    edtPrecoVenda.Text := FormatFloat(getFormatoFloat, Produto.PrecoVenda);
  finally
    Produto.Free;
  end;
end;

procedure TMainView.edtQuantidadeChange(Sender: TObject);
begin
  HabilitaBotaoInserir;
end;

procedure TMainView.edtQuantidadeExit(Sender: TObject);
begin
  ValidarValorExit(Sender);
  HabilitaBotaoInserir;
end;

procedure TMainView.ValidarValorExit(Sender: TObject);
var
  edit   : TEdit absolute Sender;
  nValor : Double;
  sValor : string;
begin
  if not (Sender is TEdit) then
    Exit;

  if edit.Text = EmptyStr then
  begin
    edit.Text := FormatFloat(getFormatoFloat, 0);
    Exit;
  end;

  sValor := StringReplace(edit.Text, FormatSettings.ThousandSeparator, '', [rfReplaceAll]);
  if not TryStrToFloat(sValor, nValor) then
  begin
    Focar(edit);
    Application.MessageBox('Digite uma quantidade válida!', 'Atenção', MB_OK OR MB_ICONERROR);
  end
  else
    edit.Text := FormatFloat(getFormatoFloat, nValor);
end;

procedure TMainView.edtQuantidadeKeyPress(Sender: TObject; var Key: Char);
begin
  ValidarKeyPress(Sender, Key);
end;

procedure TMainView.ValidarKeyPress(Sender: TObject; var Key: Char);
var
  edit : TEdit absolute Sender;
begin
  if (not CharInSet(Key, ['0'..'9', #8, FormatSettings.DecimalSeparator]))
     or
     ((Key = FormatSettings.DecimalSeparator) and
      (String(edit.Text).CountChar(FormatSettings.DecimalSeparator) = 1 )) then
    Key := #0;
end;

procedure TMainView.FormDestroy(Sender: TObject);
begin
  TConnectionFactory.GetInstance.Release;
end;

procedure TMainView.FormCreate(Sender: TObject);
begin
  VerificarConexaoBanco;
  InicializaPropriedades;
  InicializaDatasets;
end;

procedure TMainView.InicializaDatasets;
begin
  with tbItensPedido.Aggregates.Add do
  begin
    Name := 'SomaValorTotal';
    Expression := 'SUM(Quantidade*ValorUnitario)';
    Active := True;
  end;
  tbItensPedido.AggregatesActive := True;
  tbItensPedido.Open;
end;

procedure TMainView.VerificarConexaoBanco;
begin
  Try
    TConnectionFactory.GetInstance;
  except
    on e: exception do
    begin
      Application.MessageBox(
        PWideChar('Não foi possível conectar ao banco de dados. Verifique suas configurações.' + sLineBreak +
        'Msg de erro:' + e.Message),
        'Erro', MB_OK OR MB_ICONERROR
      );
      TerminateProcess(GetCurrentProcess, 0);
    end;
  End;
end;

procedure TMainView.gridItensPedidoKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  if tbItensPedido.IsEmpty then
    Exit;

  case Key of
    VK_Return : EditarProduto;
    VK_Delete : tbItensPedido.Delete;
  end;
end;

procedure TMainView.EditarProduto;
begin
  edtProduto.Text     := fieldProdutosCodigoProduto.AsString;
  edtNomeProduto.Text := fieldProdutosDescricaoProduto.AsString;
  edtQuantidade.Text  := FormatFloat( getFormatoFloat, FieldProdutosQuantidade.AsFloat);
  edtPrecoVenda.Text  := FormatFloat( getFormatoFloat, fieldProdutosValorUnitario.AsFloat);

  edtProduto.Enabled  := False;
  edtProduto.Color    := clBtnFace;

  Focar(edtQuantidade);

  btnInserirProduto.Caption := _CAPTION_BTN_EDITAR_;
end;

procedure TMainView.edtClienteKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  if Key = VK_F3 then
    ProcurarCliente;
end;

procedure TMainView.edtPrecoVendaEnter(Sender: TObject);
begin
  TratarEntradaEdit(Sender);
end;

procedure TMainView.TratarEntradaEdit(Sender: TObject);
var
  edit  : TEdit absolute Sender;
  Value : Double;
begin
  if TryStrToFloat(StringReplace(edit.Text, '.', '', [rfReplaceAll]), Value) then
  begin
    edit.Text := FloatToStr(Value);
  end;
  edit.SelectAll;
end;

procedure TMainView.edtPrecoVendaExit(Sender: TObject);
begin
  ValidarValorExit(Sender);
  HabilitaBotaoInserir;
end;

procedure TMainView.edtPrecoVendaKeyPress(Sender: TObject; var Key: Char);
begin
  ValidarKeyPress(Sender, Key);
end;

procedure TMainView.edtProdutoKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  if Key = VK_F3 then
    ProcurarProduto;
end;

procedure TMainView.edtQuantidadeEnter(Sender: TObject);
begin
  TratarEntradaEdit(Sender);
end;

procedure TMainView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Application.MessageBox('Deseja finalizar o programa? Quaisquer alterações não salvas serão perdidas.',
     'Atenção', MB_YESNO OR MB_ICONQUESTION OR MB_DEFBUTTON2) = IDNO then
    Action := caNone;
end;

procedure TMainView.FormKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  if Self.ActiveControl = gridItensPedido then
    Exit;

  case Key of
    VK_F12 : CriarNovoPedido(True);
    VK_RETURN :
    begin
      Key := 0;
      Perform(WM_NEXTDLGCTL, 0, 0);
    end;
    83 :
    begin
      if Shift = [ssCtrl] then
        GravarPedido;
    end;
    VK_INSERT :
    begin
      if (Shift = [ssCtrl]) and (btnInserirProduto.Enabled) then
        InserirProduto;
    end;
  end;
end;

procedure TMainView.gridItensPedidoEnter(Sender: TObject);
begin
  gridItensPedido.Options := gridItensPedido.Options + [dgRowSelect];
end;

procedure TMainView.gridItensPedidoExit(Sender: TObject);
begin
  gridItensPedido.Options := gridItensPedido.Options - [dgRowSelect];
end;

procedure TMainView.InicializaPropriedades;
begin
  FCodigoPedido                            := -1;
  FormatSettings.DecimalSeparator          := ',';
  FieldProdutosQuantidade.DisplayFormat    := getFormatoFloat;
  FieldProdutosValorUnitario.DisplayFormat := getFormatoFloat;
  FieldProdutosValorTotal.DisplayFormat    := getFormatoFloat;
  btnInserirProduto.Enabled                := False;
  lbTotalPedido.Caption                    := 'Total do Pedido: R$ 0,00';
end;

procedure TMainView.tbItensPedidoAfterPost(DataSet: TDataSet);
begin
  lbTotalPedido.Caption := 'Total do Pedido: R$ ' + FormatFloat(getFormatoFloat, tbItensPedido.Aggregates[0].Value);
end;

procedure TMainView.tbItensPedidoBeforeDelete(DataSet: TDataSet);
begin
  if Application.MessageBox('Deseja realmente excluir esse item?',
     'Atenção', MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) = IDNO then
    Abort;
  LimparDadosProduto(True);
end;

procedure TMainView.tbItensPedidoBeforeInsert(DataSet: TDataSet);
begin
  gridItensPedido.Columns.Clear;
end;

procedure TMainView.tbItensPedidoCalcFields(DataSet: TDataSet);
begin
  FieldProdutosValorTotal.Value :=
    FieldProdutosQuantidade.Value * FieldProdutosValorUnitario.Value;
end;

end.

