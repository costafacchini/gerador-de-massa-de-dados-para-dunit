unit Campos;

interface

uses
  Windows, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, IB_Components,
  IB_Access, Grids, IB_Grid, Generics.Collections;

type
  TfrmSelecaoDeCampos = class(TForm)
    grdTabelas: TIB_Grid;
    qryCampos: TIB_Query;
    dtsCampos: TIB_DataSource;
    btnOK: TButton;
    btnCancelar: TButton;
    btnTodos: TButton;
    Label1: TLabel;
    lblTabela: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure grdTabelasCellClick(Sender: TObject; ACol, ARow: Integer; AButton: TMouseButton; AShift: TShiftState);
    procedure grdTabelasGetCellProps(Sender: TObject; ACol, ARow: Integer; AState: TGridDrawState; var AColor: TColor;
      AFont: TFont);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnTodosClick(Sender: TObject);
  private
    FTabela: string;
    FListaDeCamposSelecionados: TDictionary<string, string>;
  public
    class function Executar(conexao: TIB_Connection; tabela: string; listaDeCampos: TStringList): Boolean;
  end;

implementation

{$R *.dfm}

procedure TfrmSelecaoDeCampos.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmSelecaoDeCampos.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmSelecaoDeCampos.btnTodosClick(Sender: TObject);
begin
  qryCampos.First;
  while not qryCampos.Eof do
  begin
    FListaDeCamposSelecionados.AddOrSetValue(qryCampos.FieldByName('Campo').AsString, qryCampos.FieldByName('Campo').AsString);
    qryCampos.Next;
  end;
  grdTabelas.Refresh;
end;

class function TfrmSelecaoDeCampos.Executar(conexao: TIB_Connection; tabela: string;
  listaDeCampos: TStringList): Boolean;
var
  frm: TfrmSelecaoDeCampos;
  CodigoKey: string;
begin
  Application.CreateForm(TfrmSelecaoDeCampos, frm);
  try
    frm.FTabela := tabela;
    frm.lblTabela.Caption := tabela;
    frm.qryCampos.IB_Connection := conexao;
    frm.qryCampos.ParamByName('TABELA').AsString := tabela;
    frm.qryCampos.Open;

    frm.ShowModal;
    Result := False;
    if frm.ModalResult = mrOk then
    begin
      for CodigoKey in frm.FListaDeCamposSelecionados.Keys do
      begin
        listaDeCampos.Add(frm.FListaDeCamposSelecionados.Items[CodigoKey]);
      end;
      Result := True;
    end;
  finally
    frm.Release;
  end;
end;

procedure TfrmSelecaoDeCampos.FormCreate(Sender: TObject);
begin
  FListaDeCamposSelecionados := TDictionary<string, string>.Create;
end;

procedure TfrmSelecaoDeCampos.FormDestroy(Sender: TObject);
begin
  FListaDeCamposSelecionados.Free;
end;

procedure TfrmSelecaoDeCampos.grdTabelasCellClick(Sender: TObject; ACol, ARow: Integer; AButton: TMouseButton;
  AShift: TShiftState);
begin
  qryCampos.BufferRowNum := grdTabelas.DataRow[ ARow ];
  if FListaDeCamposSelecionados.ContainsKey(qryCampos.BufferFieldByName('Campo').AsString) then
    FListaDeCamposSelecionados.Remove(qryCampos.BufferFieldByName('Campo').AsString)
  else
    FListaDeCamposSelecionados.Add(qryCampos.BufferFieldByName('Campo').AsString, qryCampos.BufferFieldByName('Campo').AsString);
  grdTabelas.Refresh;
end;

procedure TfrmSelecaoDeCampos.grdTabelasGetCellProps(Sender: TObject; ACol, ARow: Integer; AState: TGridDrawState;
  var AColor: TColor; AFont: TFont);
begin
  if Active and ( ACol > 0 ) and ( aRow > 0 ) then begin
    qryCampos.BufferRowNum := grdTabelas.DataRow[ ARow ];
    if (not qryCampos.IsEmpty) and (qryCampos.BufferRowNum > 0) then begin
      if AFont.Color <> clHighlightText then begin
        if FListaDeCamposSelecionados.ContainsKey(qryCampos.BufferFieldByName('Campo').AsString) then begin
          AColor := $00B7FFB7;
        end;
      end;
    end;
  end;
end;

end.
