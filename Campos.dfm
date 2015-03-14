object frmSelecaoDeCampos: TfrmSelecaoDeCampos
  Left = 0
  Top = 0
  Caption = 'frmSelecaoDeCampos'
  ClientHeight = 678
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 39
    Height = 13
    Caption = 'Tabela: '
  end
  object lblTabela: TLabel
    Left = 48
    Top = 3
    Width = 64
    Height = 19
    Caption = 'lblTabela'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object grdTabelas: TIB_Grid
    Left = 8
    Top = 28
    Width = 385
    Height = 612
    CustomGlyphsSupplied = []
    DataSource = dtsCampos
    TabOrder = 0
    GridLinks.Strings = (
      'CAMPO=WIDTH=\2\4\8'
      'Obrigatorio=20')
    OnCellClick = grdTabelasCellClick
    OnGetCellProps = grdTabelasGetCellProps
  end
  object btnOK: TButton
    Left = 237
    Top = 646
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancelar: TButton
    Left = 318
    Top = 646
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 2
    OnClick = btnCancelarClick
  end
  object btnTodos: TButton
    Left = 8
    Top = 646
    Width = 75
    Height = 25
    Caption = 'Todos'
    TabOrder = 3
    OnClick = btnTodosClick
  end
  object btnObrigatorios: TButton
    Left = 89
    Top = 646
    Width = 75
    Height = 25
    Caption = 'Obrigat'#243'rios'
    TabOrder = 4
    OnClick = btnObrigatoriosClick
  end
  object qryCampos: TIB_Query
    DatabaseName = 
      '127.0.0.1:C:\Asseinfo\Clientes\desenvolvimento\desenvolvimento.f' +
      'db'
    FieldsDisplayLabel.Strings = (
      'Obrigatorio='#39'Obrigat'#243'rio'#39)
    IB_Connection = frmPrincipal.conIBO
    SQL.Strings = (
      'Select'
      '    A.Rdb$Relation_Name Tabela,'
      '    A.Rdb$Field_Name Campo,'
      '    C.Rdb$Type_Name,'
      '    (Select'
      '         S.RDB$FIELD_NAME'
      '       From'
      '         RDB$RELATION_CONSTRAINTS C'
      '         join'
      '           RDB$INDICES I'
      '         on'
      '           C.RDB$INDEX_NAME = I.RDB$INDEX_NAME'
      '         join'
      '           RDB$INDEX_SEGMENTS S'
      '         on'
      '           S.RDB$INDEX_NAME = I.RDB$INDEX_NAME'
      '       Where'
      '         Upper(C.Rdb$Relation_Name) = Upper(A.Rdb$Relation_Name)'
      '         and Upper( S.RDB$FIELD_NAME) = Upper(A.Rdb$Field_Name)'
      '         and Upper(C.Rdb$Constraint_Type) = '#39'PRIMARY KEY'#39
      '    ) Chave,'
      '    ('
      '      case A.Rdb$Null_Flag'
      '        when 1 then '#39'S'#39
      '        else '#39'N'#39
      '      end'
      '    ) Obrigatorio'
      'From'
      '    Rdb$Relation_Fields A'
      '    Join'
      '        Rdb$Fields B'
      '    On'
      '        A.Rdb$Field_Source = B.Rdb$Field_Name'
      '    Join'
      '        Rdb$Types C'
      '    On'
      '        Upper(C.Rdb$Field_Name) = '#39'RDB$FIELD_TYPE'#39' And'
      '        B.Rdb$Field_Type = C.Rdb$Type'
      'Where'
      '    Upper(Substring(A.Rdb$Relation_Name From 1 For 4)) <> '#39'RDB$'#39
      
        '    and ( (A.Rdb$Base_Field is null) and (A.Rdb$View_Context is ' +
        'null) ) /* Para ignorar view */'
      
        '    and ( (RDB$COMPUTED_BLR is null) and (RDB$COMPUTED_SOURCE is' +
        ' null) ) /* Ignorar campo computados */'
      '    and A.Rdb$Relation_Name = :TABELA'
      'Order By'
      '    1,'
      '    A.Rdb$Field_Position')
    KeyLinksAutoDefine = False
    BufferSynchroFlags = [bsBeforeEdit, bsAfterEdit, bsAfterInsert]
    Left = 228
    Top = 3
  end
  object dtsCampos: TIB_DataSource
    AutoEdit = False
    AutoInsert = False
    Dataset = qryCampos
    Left = 256
    Top = 3
  end
end
