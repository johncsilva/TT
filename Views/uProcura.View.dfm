object ProcuraView: TProcuraView
  Left = 0
  Top = 0
  Caption = 'Procura'
  ClientHeight = 406
  ClientWidth = 489
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 15
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 489
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = -6
    object edtValorBusca: TEdit
      AlignWithMargins = True
      Left = 305
      Top = 10
      Width = 100
      Height = 23
      Margins.Top = 10
      Margins.Bottom = 8
      Align = alClient
      TabOrder = 2
      TextHint = 'Digite o valor para busca..'
      ExplicitLeft = 65
      ExplicitWidth = 208
    end
    object cbbColunaBusca: TComboBox
      AlignWithMargins = True
      Left = 3
      Top = 10
      Width = 145
      Height = 28
      Margins.Top = 10
      Align = alLeft
      Style = csDropDownList
      TabOrder = 0
    end
    object cbbTipoPesquisa: TComboBox
      AlignWithMargins = True
      Left = 154
      Top = 10
      Width = 145
      Height = 28
      Margins.Top = 10
      Align = alLeft
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 1
      Text = 'Igual'
      Items.Strings = (
        'Igual'
        'Cont'#233'm'
        'Come'#231'a com'
        'Termina com')
    end
    object btnBuscar: TButton
      AlignWithMargins = True
      Left = 411
      Top = 8
      Width = 75
      Height = 25
      Margins.Top = 8
      Margins.Bottom = 8
      Align = alRight
      Caption = 'Buscar'
      TabOrder = 3
      OnClick = btnBuscarClick
      ExplicitTop = 5
    end
  end
  object pnlCorpo: TPanel
    Left = 0
    Top = 41
    Width = 489
    Height = 324
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 168
    ExplicitTop = 295
    ExplicitWidth = 185
    ExplicitHeight = 41
    object gridProcura: TDBGrid
      Left = 0
      Top = 0
      Width = 489
      Height = 324
      Align = alClient
      DataSource = dsProcura
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnDblClick = gridProcuraDblClick
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
          Width = 1000
          Visible = True
        end>
    end
  end
  object pnlBaixo: TPanel
    Left = 0
    Top = 365
    Width = 489
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitLeft = 184
    ExplicitTop = 335
    ExplicitWidth = 185
    object btnOk: TButton
      AlignWithMargins = True
      Left = 224
      Top = 5
      Width = 126
      Height = 31
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alRight
      Caption = 'Ok [Ctrl+Enter]'
      TabOrder = 0
      OnClick = btnOkClick
      ExplicitLeft = 240
    end
    object btnCancelar: TButton
      AlignWithMargins = True
      Left = 360
      Top = 5
      Width = 124
      Height = 31
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alRight
      Caption = 'Cancelar [Esc]'
      TabOrder = 1
    end
  end
  object quProcura: TFDQuery
    AfterOpen = quProcuraAfterOpen
    Left = 240
    Top = 208
  end
  object dsProcura: TDataSource
    DataSet = quProcura
    Left = 280
    Top = 208
  end
end
