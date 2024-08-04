unit uProcura.View;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.StrUtils,
  System.Generics.Collections,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
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
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TCampo = class
    Tabela  : string;
    Nome    : string;
    Alias   : string;
    Caption : string;
    Tamanho : Integer;
    Visivel : Boolean;
    Procura : Boolean;
    Retorno : Boolean;
    Posicao : Integer;
  end;

  TProcuraView = class(TForm)
    pnlTopo: TPanel;
    pnlCorpo: TPanel;
    pnlBaixo: TPanel;
    edtValorBusca: TEdit;
    gridProcura: TDBGrid;
    btnOk: TButton;
    btnCancelar: TButton;
    quProcura: TFDQuery;
    dsProcura: TDataSource;
    cbbColunaBusca: TComboBox;
    cbbTipoPesquisa: TComboBox;
    btnBuscar: TButton;
    procedure btnBuscarClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure gridProcuraDblClick(Sender: TObject);
    procedure quProcuraAfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
    FCampos  : TDictionary<String,TCampo>;
    FTabela  : String;
    FJoin    : String;
    FWhere   : String;
    FRetorno : Variant;
    procedure ReordenarColunas(const slPosicao: TStringList);
    procedure MontaCampos(out ACampos: string);
    procedure RealizarBusca;
    procedure InicializarTela;
    procedure RetornarBusca;
    procedure AjustarPropriedadesColunas(DataSet: TDataSet);
  public
    { Public declarations }
    destructor Destroy; override;
  end;

  IProcurar = interface
    function Executa: IProcurar;
    function SetaTabela(const AValue : String): IProcurar;
    function SetaJoin(const AValue : String): IProcurar;
    function SetaWhere(const AValue : String): IProcurar;
    function AddCampo(const ATabela, ANome, AAlias, ACaption : string; ATamanho : integer;
      AVisivel, AProcura : boolean; ARetorno : Boolean = False): IProcurar;
    function Retorno(out AValue :Variant): IProcurar;
  end;

  TProcurar = class(TInterfacedObject, IProcurar)
  private
    class var FInstance: IProcurar;
    FTabela  : String;
    FCampos  : TDictionary<String,TCampo>;
    FJoin    : String;
    FWhere   : String;
    FRetorno : Variant;
    constructor Create;
  public
    class function GetInstance: IProcurar;

    destructor Destroy; override;

    function SetaTabela(const AValue : String): IProcurar;
    function AddCampo(const ATabela, ANome, AAlias, ACaption : string; ATamanho : integer;
      AVisivel, AProcura : boolean; ARetorno : Boolean = False): IProcurar;
    function SetaJoin(const AValue : String): IProcurar;
    function SetaWhere(const AValue : String): IProcurar;
    function Retorno(out AValue :Variant): IProcurar;
    function Executa: IProcurar;
  end;

var
  ProcuraView: TProcuraView;

implementation

uses
  uConnection.Factory;

{$R *.dfm}

{ TProcurar }

function TProcurar.AddCampo(const ATabela, ANome, AAlias, ACaption : string;
    ATamanho : integer; AVisivel, AProcura : boolean; ARetorno : Boolean =
    False): IProcurar;
var
  Campo : TCampo;
begin
  Result        := Self;
  if not FCampos.TryGetValue(AAlias, Campo) then
    Campo := TCampo.Create;

  Campo.Tabela  := ATabela;
  Campo.Nome    := ANome;
  Campo.Alias   := AAlias;
  Campo.Caption := ACaption;
  Campo.Tamanho := ATamanho;
  Campo.Visivel := AVisivel;
  Campo.Procura := AProcura;
  Campo.Retorno := ARetorno;
  Campo.Posicao := FCampos.Count;

  FCampos.AddOrSetValue(AAlias, Campo);
end;

constructor TProcurar.Create;
begin
  FCampos := TDictionary<String,TCampo>.Create;
end;

destructor TProcurar.Destroy;
var
  key : string;
begin
  for key in FCampos.Keys do
    FCampos.Items[key].Free;
  FCampos.Free;
  inherited;
end;

function TProcurar.Executa: IProcurar;
var
  Form : TProcuraView;
begin
  Result       := Self;
  Form         := TProcuraView.Create(nil);
  Form.FCampos := FCampos;
  Form.FTabela := FTabela;
  Form.FJoin   := FJoin;
  Form.FWhere  := FWhere;
  try
    if Form.ShowModal = mrOk then
      FRetorno := Form.FRetorno;
  finally
    Form.FCampos := nil;
    Form.Free;
  end;
end;

class function TProcurar.GetInstance: IProcurar;
var
  key : string;
begin
  if FInstance = nil then
    FInstance := TProcurar.Create;
  for key in FCampos.Keys do
    FCampos.Items[key].Free;
  FCampos.Clear;
  FCampos.TrimExcess;
  FRetorno := null;
  FTabela  := EmptyStr;
  FJoin    := EmptyStr;
  FWhere   := EmptyStr;
  Result := FInstance;
end;

function TProcurar.Retorno(out AValue :Variant): IProcurar;
begin
  Result := Self;
  AValue := FRetorno;
end;

function TProcurar.SetaJoin(const AValue: String): IProcurar;
begin
  Result := Self;
  FJoin := AValue;
end;

function TProcurar.SetaTabela(const AValue : String): IProcurar;
begin
  Result := Self;
  FTabela := AValue;
end;

function TProcurar.SetaWhere(const AValue: String): IProcurar;
begin
  Result := Self;
  FWhere := AValue
end;

destructor TProcuraView.Destroy;
begin
  inherited;
end;

procedure TProcuraView.btnBuscarClick(Sender: TObject);
begin
  RealizarBusca;
end;

procedure TProcuraView.btnOkClick(Sender: TObject);
begin
  RetornarBusca;
end;

procedure TProcuraView.FormCreate(Sender: TObject);
begin
  quProcura.Connection := TConnectionFactory.GetInstance.GetConnection;
  btnOk.Enabled := False;
end;

procedure TProcuraView.FormKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  case Key of
    VK_Return : begin
      if (Shift = [ssCtrl]) or
         (Self.ActiveControl = gridProcura)then
        RetornarBusca
      else
        RealizarBusca;
    end;
    VK_UP : begin
      if Self.ActiveControl <> edtValorBusca then
        Exit;
      Key := 0;
      if quProcura.RecordCount > 0 then
        quProcura.Prior;
    end;
    VK_DOWN : begin
      if Self.ActiveControl <> edtValorBusca then
        Exit;
      Key := 0;
      if quProcura.RecordCount > 0 then
        quProcura.Next;
    end;
    VK_ESCAPE : ModalResult := mrCancel;
  end;
end;

procedure TProcuraView.FormShow(Sender: TObject);
begin
  InicializarTela;
end;

procedure TProcuraView.gridProcuraDblClick(Sender: TObject);
begin
  RetornarBusca;
end;

procedure TProcuraView.InicializarTela;
var
  iTamanho : Integer;
  key      : string;
  slOrdem  : TStringList;
begin
  iTamanho := 0;
  slOrdem := TStringList.Create();
  try
    for key in FCampos.keys do
    begin
      if FCampos.Items[key].Visivel then
      begin
        iTamanho := iTamanho + (FCampos.Items[key].Tamanho * Canvas.TextWidth('a'));
        if FCampos.Items[key].Procura then
          slOrdem.AddObject(FCampos.Items[key].Posicao.ToString, FCampos.Items[key])
      end;
    end;
    slOrdem.Sort;
    while slOrdem.Count > 0 do
    begin
      cbbColunaBusca.AddItem(TCampo(slOrdem.Objects[0]).Caption, TCampo(slOrdem.Objects[0]));
      slOrdem.Delete(0);
    end;
    Self.Width := iTamanho + 110;
    cbbColunaBusca.ItemIndex := 0;
    if cbbColunaBusca.Items.Count = 0 then
      Raise Exception.Create('Nenhum campo definido para busca!!');
  finally
    slOrdem.Free;
  end;
end;

procedure TProcuraView.quProcuraAfterOpen(DataSet: TDataSet);
begin
  AjustarPropriedadesColunas(Dataset);
end;

procedure TProcuraView.AjustarPropriedadesColunas(DataSet: TDataSet);
var
  i         : Integer;
  Campo     : TCampo;
  Field     : TField;
  slPosicao : TStringList;
begin
  slPosicao := TStringList.Create;
  try
    for i := 0 to Pred(quProcura.Fields.Count) do
    begin
      if not FCampos.TryGetValue(quProcura.Fields.Fields[i].FieldName, Campo) then
        Continue;

      Field := quProcura.FieldByName(Campo.Nome);

      Field.DisplayLabel := Campo.Caption;
      Field.DisplayWidth := Campo.Tamanho;
      Field.Visible      := Campo.Visivel;
      if Field.DataType in [ftSmallint, ftInteger, ftWord, ftFloat, ftCurrency, ftBCD, ftFMTBcd, ftExtended] then
        TFloatField(Field).DisplayFormat := '#,##0.00';

      slPosicao.AddObject(Campo.Posicao.ToString, Campo);
    end;
    ReordenarColunas(slPosicao);
  finally
    slPosicao.Free;
  end;
end;

procedure TProcuraView.ReordenarColunas(const slPosicao : TStringList);
var
  Coluna: TColumn;
  I: Integer;
begin
  slPosicao.Sort;
  gridProcura.Columns.BeginUpdate;
  try
    gridProcura.Columns.Clear;

    for I := 0 to Pred(slPosicao.Count) do
    begin
      if not TCampo(slPosicao.Objects[i]).Visivel then
        Continue;
      Coluna := gridProcura.Columns.Add;
      Coluna.FieldName := TCampo(slPosicao.Objects[i]).Alias;
    end;
  finally
    gridProcura.Columns.EndUpdate;
  end;
end;

procedure TProcuraView.MontaCampos(out ACampos : string);
var
  Campo : String;
begin
  ACampos := '';
  for Campo in FCampos.Keys do
  begin
    ACampos :=
      ACampos + IfThen(ACampos = EmptyStr, '', ',') +
      FCampos.Items[Campo].Tabela + '.' + FCampos.Items[Campo].Nome + ' ' + FCampos.Items[Campo].Alias;
  end;
end;

procedure TProcuraView.RetornarBusca;
var
  Campo : String;
begin
  if quProcura.IsEmpty then
    Exit;

  FRetorno := '';
  for Campo in FCampos.Keys do
  begin
    if FCampos.Items[Campo].Retorno then
      FRetorno :=
        FRetorno + IfThen(FRetorno = EmptyStr, '', ';') +
        FCampos.Items[Campo].Nome + '=' + quProcura.FieldByName(FCampos.Items[Campo].Alias).AsString;
  end;

  ModalResult := mrOk;
end;

procedure TProcuraView.RealizarBusca;
var
  sCampos       : string;
  Campo         : TCampo;
  sTipoPesquisa : string;
  sValorBusca   : string;
begin
  MontaCampos(sCampos);
  Campo := TCampo(cbbColunaBusca.Items.Objects[cbbColunaBusca.ItemIndex]);
  case cbbTipoPesquisa.ItemIndex of
    0: begin
      sTipoPesquisa := ' = :valor';
      sValorBusca := edtValorBusca.Text;  // Busca exata
    end;
    1: begin
      sTipoPesquisa := ' LIKE :valor';
      sValorBusca := '%' + edtValorBusca.Text + '%';  // Contém
    end;
    2: begin
      sTipoPesquisa := ' LIKE :valor';
      sValorBusca := edtValorBusca.Text + '%';  // Começa com
    end;
    3: begin
      sTipoPesquisa := ' LIKE :valor';
      sValorBusca := '%' + edtValorBusca.Text;  // Termina com
    end;
  else
    raise Exception.Create('Tipo de pesquisa inválido.');
  end;
  quProcura.SQL.Text :=
    ' SELECT ' + sCampos
    + ' FROM ' + FTabela + ' '
    + FJoin + ' ' + FWhere;
  if edtValorBusca.Text <> EmptyStr then
  begin
    quProcura.SQL.Text := quProcura.SQL.Text +
      IfThen(FWhere <> EmptyStr, ' AND ', ' WHERE ')
      + Campo.Tabela + '.' + Campo.Alias + sTipoPesquisa;
    quProcura.ParamByName('valor').Value := sValorBusca;
  end;
  quProcura.Open;
  btnOk.Enabled := quProcura.RecordCount > 0;
end;

end.
