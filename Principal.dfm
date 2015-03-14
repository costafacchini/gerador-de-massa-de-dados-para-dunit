object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Formatador de Dados para os casos de teste do DUnit'
  ClientHeight = 101
  ClientWidth = 400
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
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 8
    Width = 385
    Height = 57
    Caption = 'Formato de Sa'#237'da'
    Enabled = False
    ItemIndex = 0
    Items.Strings = (
      
        'Formato Insert (Linha de Campos e abaixo os valores corresponden' +
        'tes)'
      
        'Formato Update (Campos um debaixo do outro com os valores ao lad' +
        'o)')
    TabOrder = 0
  end
  object btnGerar: TButton
    Left = 317
    Top = 71
    Width = 75
    Height = 25
    Caption = 'Gerar'
    TabOrder = 1
    OnClick = btnGerarClick
  end
  object sdBanco: TOpenDialog
    DefaultExt = '*.fdb'
    Filter = 'Arquivos do Firebird (*.fdb)|*.fdb'
    FilterIndex = 0
    InitialDir = 'C:\Asseinfo\Clientes\Desenvolvimento'
    Left = 200
    Top = 64
  end
  object conIBO: TIB_Connection
    PasswordStorage = psParams
    SQLDialect = 3
    Params.Strings = (
      'PATH=C:\Asseinfo\Clientes\desenvolvimento\desenvolvimento.fdb'
      'SQL DIALECT=3'
      'USER NAME=sysdba'
      'CHARACTER SET=WIN1252'
      'PASSWORD=masterkey'
      'PROTOCOL=TCP/IP'
      'SERVER=127.0.0.1')
    Left = 164
    Top = 65
  end
end
