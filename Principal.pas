unit Principal;

interface

uses
  Windows, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, IB_Components, StdCtrls, ExtCtrls,
  Generics.Collections, ComCtrls;

type
  TfrmPrincipal = class(TForm)
    sdBanco: TOpenDialog;
    rgrFormatoDeSaida: TRadioGroup;
    conIBO: TIB_Connection;
    btnGerar: TButton;
    barRodape: TStatusBar;
    procedure btnGerarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private const
    INDEX_DO_PAINEL_DA_BARRA = 0;
  private
    FListaDeTabelas: TDictionary<string, string>;

    procedure SelecionarTabelas;
    procedure GerarArquivoDeAmostras;
    procedure GerarArquivoDeAmostrarNoFormatoDeInserts;
    procedure GerarArquivoDeAmostrarNoFormatoDeUpdates;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  Tabelas, GeradorDeArquivos;

{$R *.dfm}

procedure TfrmPrincipal.btnGerarClick(Sender: TObject);
const
  LOCALHOST = '127.0.0.1';
begin
  if sdBanco.Execute then
  begin
    conIBO.Disconnect;
    conIBO.DatabaseName := LOCALHOST + ':' + sdBanco.FileName;
    conIBO.Connect;

    SelecionarTabelas;
    GerarArquivoDeAmostras;
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

procedure TfrmPrincipal.SelecionarTabelas;
begin
  Application.ProcessMessages;
  barRodape.Panels.Items[INDEX_DO_PAINEL_DA_BARRA].Text := 'Selecionar as tabelas';
  try
    TfrmSelecaoDeTabelas.Executar(conIBO, FListaDeTabelas);
  finally
    barRodape.Panels.Items[INDEX_DO_PAINEL_DA_BARRA].Text := '';
  end;
end;

procedure TfrmPrincipal.GerarArquivoDeAmostras;
const
  INDEX_DO_FORMATO_DE_ARQUIVO_EM_INSERTS = 0;
begin
  if FListaDeTabelas.Count > 0 then
  begin
    Application.ProcessMessages;
    barRodape.Panels.Items[INDEX_DO_PAINEL_DA_BARRA].Text := 'Gerar arquivo de amostrar';
    try
      if rgrFormatoDeSaida.ItemIndex = INDEX_DO_FORMATO_DE_ARQUIVO_EM_INSERTS then
        GerarArquivoDeAmostrarNoFormatoDeInserts
      else
        GerarArquivoDeAmostrarNoFormatoDeUpdates;
    finally
      barRodape.Panels.Items[INDEX_DO_PAINEL_DA_BARRA].Text := '';
    end;
  end;
end;

procedure TfrmPrincipal.GerarArquivoDeAmostrarNoFormatoDeInserts;
begin
  TGeradorDeArquivos.Gerar(conIBO, FListaDeTabelas);
end;

procedure TfrmPrincipal.GerarArquivoDeAmostrarNoFormatoDeUpdates;
begin
  //Ainda não implementado
end;

end.
