unit Principal;

interface

uses
  Windows, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, IB_Components, StdCtrls, ExtCtrls,
  Generics.Collections;

type
  TfrmPrincipal = class(TForm)
    sdBanco: TOpenDialog;
    RadioGroup1: TRadioGroup;
    conIBO: TIB_Connection;
    btnGerar: TButton;
    procedure btnGerarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FListaDeTabelas: TDictionary<string, string>;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  Tabelas;

{$R *.dfm}

procedure TfrmPrincipal.btnGerarClick(Sender: TObject);
begin
  if sdBanco.Execute then
  begin
    conIBO.Disconnect;
    conIBO.DatabaseName := '127.0.0.1:' + sdBanco.FileName;
    conIBO.Connect;
    TfrmSelecaoDeTabelas.Executar(conIBO, FListaDeTabelas);
  end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  FListaDeTabelas := TDictionary<string, string>.Create;
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  FListaDeTabelas.Free;
end;

end.
