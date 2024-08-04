object MainView: TMainView
  Left = 0
  Top = 0
  Caption = 'Tela de Pedidos'
  ClientHeight = 604
  ClientWidth = 887
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  TextHeight = 15
  object pnlDadosProduto: TPanel
    Left = 0
    Top = 90
    Width = 887
    Height = 76
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lbProduto: TLabel
      Left = 32
      Top = 9
      Width = 43
      Height = 15
      Caption = 'Produto'
    end
    object lbQuantidade: TLabel
      Left = 13
      Top = 38
      Width = 62
      Height = 15
      Caption = 'Quantidade'
    end
    object lbPrecoVenda: TLabel
      Left = 264
      Top = 37
      Width = 71
      Height = 15
      Caption = 'Valor Unit'#225'rio'
    end
    object btnProcuraProduto: TSpeedButton
      Left = 244
      Top = 6
      Width = 60
      Height = 22
      Caption = '[F3]'
      ImageIndex = 0
      Images = ilImagens
      HotImageIndex = 0
      OnClick = btnProcuraProdutoClick
    end
    object edtProduto: TEdit
      Left = 80
      Top = 5
      Width = 161
      Height = 23
      Hint = 'Digite o c'#243'digo do produto'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TextHint = 'Digite o c'#243'digo do produto..'
      OnChange = edtProdutoChange
      OnExit = edtProdutoExit
      OnKeyDown = edtProdutoKeyDown
    end
    object edtNomeProduto: TEdit
      Left = 308
      Top = 5
      Width = 405
      Height = 23
      TabStop = False
      Color = clBtnFace
      TabOrder = 1
    end
    object edtQuantidade: TEdit
      Left = 80
      Top = 34
      Width = 161
      Height = 23
      Hint = 'Digite a Quantidade'
      Alignment = taRightJustify
      MaxLength = 9
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      TextHint = 'Digite a quantidade..'
      OnChange = edtQuantidadeChange
      OnEnter = edtQuantidadeEnter
      OnExit = edtQuantidadeExit
      OnKeyPress = edtQuantidadeKeyPress
    end
    object edtPrecoVenda: TEdit
      Left = 344
      Top = 34
      Width = 161
      Height = 23
      Hint = 'Digite o valor unit'#225'rio'
      Alignment = taRightJustify
      MaxLength = 9
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      TextHint = 'Digite o valor unit'#225'rio..'
      OnChange = edtPrecoVendaChange
      OnEnter = edtPrecoVendaEnter
      OnExit = edtPrecoVendaExit
      OnKeyPress = edtPrecoVendaKeyPress
    end
    object btnInserirProduto: TButton
      Left = 560
      Top = 34
      Width = 154
      Height = 25
      Caption = 'Inserir Produto [Ctrl+Ins]'
      TabOrder = 4
      OnClick = btnInserirProdutoClick
    end
  end
  object pnlBody: TPanel
    Left = 0
    Top = 166
    Width = 887
    Height = 397
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object gridItensPedido: TDBGrid
      Left = 0
      Top = 0
      Width = 887
      Height = 397
      Align = alClient
      DataSource = dsItensPedido
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnEnter = gridItensPedidoEnter
      OnExit = gridItensPedidoExit
      OnKeyDown = gridItensPedidoKeyDown
      Columns = <
        item
          Expanded = False
          Title.Alignment = taCenter
          Title.Caption = 'Nenhum dado a ser exibido'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clSilver
          Title.Font.Height = -12
          Title.Font.Name = 'Segoe UI'
          Title.Font.Style = [fsItalic]
          Width = 100000
          Visible = True
        end>
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 563
    Width = 887
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object lbTotalPedido: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 6
      Height = 35
      Align = alLeft
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ExplicitHeight = 30
    end
    object btnGravarPedido: TButton
      AlignWithMargins = True
      Left = 717
      Top = 5
      Width = 167
      Height = 31
      Hint = 'Clique aqui para salvar os dados do pedido'
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alRight
      Caption = 'Gravar Pedido [Ctrl+S]'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnGravarPedidoClick
    end
    object btnNovoPedido: TButton
      AlignWithMargins = True
      Left = 544
      Top = 5
      Width = 167
      Height = 31
      Hint = 'Clique aqui para inserir um novo pedido'
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alRight
      Caption = 'Novo Pedido [F12]'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnNovoPedidoClick
    end
  end
  object pnlDadosCliente: TPanel
    Left = 0
    Top = 0
    Width = 887
    Height = 90
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lbCliente: TLabel
      Left = 38
      Top = 13
      Width = 37
      Height = 15
      Caption = 'Cliente'
    end
    object lbClienteNome: TLabel
      Left = 42
      Top = 40
      Width = 33
      Height = 15
      Caption = 'Nome'
    end
    object lbCidade: TLabel
      Left = 38
      Top = 69
      Width = 37
      Height = 15
      Caption = 'Cidade'
    end
    object lbUF: TLabel
      Left = 628
      Top = 69
      Width = 14
      Height = 15
      Caption = 'UF'
    end
    object btnProcuraCliente: TSpeedButton
      Left = 244
      Top = 9
      Width = 60
      Height = 22
      Caption = '[F3]'
      ImageIndex = 0
      Images = ilImagens
      HotImageIndex = 0
      OnClick = btnProcuraClienteClick
    end
    object edtCliente: TEdit
      Left = 80
      Top = 8
      Width = 161
      Height = 23
      Hint = 'Digite o c'#243'digo do cliente'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TextHint = 'Digite o c'#243'digo do cliente..'
      OnChange = edtClienteChange
      OnExit = edtClienteExit
      OnKeyDown = edtClienteKeyDown
    end
    object edtNomeCliente: TEdit
      Left = 80
      Top = 37
      Width = 633
      Height = 23
      TabStop = False
      Color = clBtnFace
      TabOrder = 3
    end
    object edtCidade: TEdit
      Left = 80
      Top = 66
      Width = 513
      Height = 23
      TabStop = False
      Color = clBtnFace
      TabOrder = 4
    end
    object edtUF: TEdit
      Left = 648
      Top = 66
      Width = 65
      Height = 23
      TabStop = False
      Color = clBtnFace
      TabOrder = 5
    end
    object btnCancelarPedido: TButton
      Left = 719
      Top = 41
      Width = 167
      Height = 28
      Hint = 'Clique aqui para localizar e cancelar um pedido feito'
      Caption = 'Cancelar Pedido'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnCancelarPedidoClick
    end
    object btnBuscarPedido: TButton
      Left = 720
      Top = 7
      Width = 167
      Height = 28
      Hint = 'Clique aqui para localizar e carregar um pedido j'#225' salvo'
      Caption = 'Buscar Pedido'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnBuscarPedidoClick
    end
  end
  object tbItensPedido: TFDMemTable
    BeforeInsert = tbItensPedidoBeforeInsert
    AfterPost = tbItensPedidoAfterPost
    BeforeDelete = tbItensPedidoBeforeDelete
    OnCalcFields = tbItensPedidoCalcFields
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 429
    Top = 288
    object fieldItensPedidoCodigo: TIntegerField
      FieldName = 'Codigo'
      Visible = False
    end
    object fieldItensPedidoCodigoPedido: TIntegerField
      FieldName = 'CodigoPedido'
      Visible = False
    end
    object fieldProdutosCodigoProduto: TIntegerField
      DisplayLabel = 'C'#243'digo Produto'
      DisplayWidth = 15
      FieldName = 'CodigoProduto'
    end
    object fieldProdutosDescricaoProduto: TStringField
      DisplayLabel = 'Descri'#231#227'o do Produto'
      DisplayWidth = 50
      FieldName = 'DescricaoProduto'
      Size = 200
    end
    object FieldProdutosQuantidade: TFloatField
      DisplayWidth = 20
      FieldName = 'Quantidade'
    end
    object FieldProdutosValorUnitario: TFloatField
      DisplayLabel = 'Valor Unit'#225'rio'
      DisplayWidth = 20
      FieldName = 'ValorUnitario'
    end
    object FieldProdutosValorTotal: TFloatField
      DisplayLabel = 'Valor Total'
      DisplayWidth = 20
      FieldKind = fkCalculated
      FieldName = 'ValorTotal'
      Calculated = True
    end
  end
  object dsItensPedido: TDataSource
    DataSet = tbItensPedido
    Left = 396
    Top = 288
  end
  object ilImagens: TImageList
    Left = 462
    Top = 288
    Bitmap = {
      494C010101000800040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      000000000000000000000000000000000000000000FF99999900C2C2C2000000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008A8A8A003535350013131300AAAA
      AA00000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C7C7C7001B1B1B009A9A9A001313
      1300AAAAAA00000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FFB6B6B6001B1B1B009A9A
      9A0013131300BCBCBC00000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FFB6B6B6001B1B
      1B003E3E3E0078787800000000FF000000FF8B8B8B0060606000696969009B9B
      9B00000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FFCECE
      CE008A8A8A001A1A1A006F6F6F00131313006666660097999900909090005252
      520016161600B0B0B000000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF6F6F6F0032323200000000FF000000FF000000FF000000FF0000
      00FFC7C7C7001A1A1A00B7B7B700000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF15151500000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FFBFC0C0001F1F1F00000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF8D8D8D0071717100000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF3D3F3F00B7B7B7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF62626200A6A6A600ADADAD00D9D9D900000000FF000000FF000000FF0000
      00FF000000FF000000FF72737300878787000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF68686800A3A3A3007878780086868600000000FF000000FF000000FF0000
      00FF000000FF000000FF6D6D6D008A8A8A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF9A9A9A0068686800C9C9C9001D1D1D00000000FF000000FF000000FF0000
      00FF000000FF000000FF2F303000BDBDBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF1C1C1C00DCDCDC008B8B8B00131313005E5E5E00D8D8D8000000
      00FF000000FFABABAB002A2A2A00000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FFABABAB0027272700D5D5D500DADADA00A0A0A000000000FF0000
      00FFB1B1B10016161600CACACA00000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FFB1B1B1001F1F1F0050505000818181007C7C7C003B3B
      3B002B2B2B00CBCBCB00000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FFB3B3B3008B8B8B008F8F8F00C1C1
      C100000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF009FFF0000000000000FFF000000000000
      07FF00000000000083FF000000000000C30F000000000000E003000000000000
      F9F1000000000000FBF9000000000000F3FC000000000000F0FC000000000000
      F0FC000000000000F0FC000000000000F819000000000000F831000000000000
      FC03000000000000FF0F00000000000000000000000000000000000000000000
      000000000000}
  end
end
