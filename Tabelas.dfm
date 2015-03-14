object frmSelecaoDeTabelas: TfrmSelecaoDeTabelas
  Left = 0
  Top = 0
  Caption = 'frmSelecaoDeTabelas'
  ClientHeight = 664
  ClientWidth = 299
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object grdTabelas: TIB_Grid
    Left = 8
    Top = 8
    Width = 281
    Height = 616
    CustomGlyphsSupplied = []
    DataSource = dtsTabelas
    TabOrder = 0
    GridLinks.Strings = (
      'TABELA=WIDTH=\2\4\8')
    OnCellClick = grdTabelasCellClick
    OnGetCellProps = grdTabelasGetCellProps
  end
  object btnOK: TButton
    Left = 133
    Top = 630
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancelar: TButton
    Left = 214
    Top = 630
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 2
    OnClick = btnCancelarClick
  end
  object qryTabelas: TIB_Query
    DatabaseName = 
      '127.0.0.1:C:\Asseinfo\Clientes\desenvolvimento\desenvolvimento.f' +
      'db'
    IB_Connection = frmPrincipal.conIBO
    SQL.Strings = (
      'SELECT'
      '    a.RDB$RELATION_ID Codigo,'
      '    a.RDB$FIELD_ID,'
      '    a.RDB$RELATION_NAME Tabela'
      'FROM RDB$RELATIONS a'
      'WHERE'
      '    Upper(Substring(A.Rdb$Relation_Name From 1 For 4)) <> '#39'RDB$'#39
      'ORDER BY'
      '    a.RDB$RELATION_NAME')
    KeyLinksAutoDefine = False
    BufferSynchroFlags = [bsBeforeEdit, bsAfterEdit, bsAfterInsert]
    Left = 4
    Top = 626
  end
  object dtsTabelas: TIB_DataSource
    AutoEdit = False
    AutoInsert = False
    Dataset = qryTabelas
    Left = 32
    Top = 626
  end
end
