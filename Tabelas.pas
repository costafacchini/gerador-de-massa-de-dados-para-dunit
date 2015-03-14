unit Tabelas;

interface

uses
  Windows, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, Grids, IB_Grid, IB_Components,
  IB_Access, Generics.Collections, StdCtrls;

type
  TfrmSelecaoDeTabelas = class(TForm)
    grdTabelas: TIB_Grid;
    qryTabelas: TIB_Query;
    dtsTabelas: TIB_DataSource;
    btnOK: TButton;
    btnCancelar: TButton;
    procedure grdTabelasCellClick(Sender: TObject; ACol, ARow: Integer; AButton: TMouseButton; AShift: TShiftState);
    procedure grdTabelasGetCellProps(Sender: TObject; ACol, ARow: Integer; AState: TGridDrawState; var AColor: TColor;
      AFont: TFont);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FConexao: TIB_Connection;
    FListaDeTabelasSelecionadas: TDictionary<string, string>;
  public
    class function Executar(conexao: TIB_Connection; listaDeTabelas: TDictionary<string, string>): Boolean;
  end;

implementation

uses
  Campos;

{$R *.dfm}

procedure TfrmSelecaoDeTabelas.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmSelecaoDeTabelas.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

class function TfrmSelecaoDeTabelas.Executar(conexao: TIB_Connection; listaDeTabelas: TDictionary<string, string>): Boolean;
var
  frm: TfrmSelecaoDeTabelas;
begin
  Application.CreateForm(TfrmSelecaoDeTabelas, frm);
  try
    frm.FListaDeTabelasSelecionadas := listaDeTabelas;
    frm.FConexao := conexao;
    frm.qryTabelas.IB_Connection := conexao;
    frm.qryTabelas.Open;

    frm.ShowModal;
    Result := False;
    if frm.ModalResult = mrOk then
      Result := True;
  finally
    frm.Release;
  end;
end;

procedure TfrmSelecaoDeTabelas.grdTabelasCellClick(Sender: TObject; ACol, ARow: Integer; AButton: TMouseButton;
  AShift: TShiftState);
var
  Campos: TStringList;
begin
  qryTabelas.BufferRowNum := grdTabelas.DataRow[ ARow ];
  if FListaDeTabelasSelecionadas.ContainsKey(qryTabelas.BufferFieldByName('Tabela').AsString) then
    FListaDeTabelasSelecionadas.Remove(qryTabelas.BufferFieldByName('Tabela').AsString)
  else
  begin
    Campos := TStringList.Create;
    try
      Campos.Delimiter := ',';
      if TfrmSelecaoDeCampos.Executar(FConexao, qryTabelas.BufferFieldByName('Tabela').AsString, Campos) then
        FListaDeTabelasSelecionadas.Add(qryTabelas.BufferFieldByName('Tabela').AsString, Campos.DelimitedText);
    finally
      Campos.Free;
    end;
  end;
  grdTabelas.Refresh;
end;

procedure TfrmSelecaoDeTabelas.grdTabelasGetCellProps(Sender: TObject; ACol, ARow: Integer; AState: TGridDrawState;
  var AColor: TColor; AFont: TFont);
begin
  if Active and ( ACol > 0 ) and ( aRow > 0 ) then begin
    qryTabelas.BufferRowNum := grdTabelas.DataRow[ ARow ];
    if (not qryTabelas.IsEmpty) and (qryTabelas.BufferRowNum > 0) then begin
      if AFont.Color <> clHighlightText then begin
        if FListaDeTabelasSelecionadas.ContainsKey(qryTabelas.BufferFieldByName('Tabela').AsString) then begin
          AColor := $00B7FFB7;
        end;
      end;
    end;
  end;
end;

end.
