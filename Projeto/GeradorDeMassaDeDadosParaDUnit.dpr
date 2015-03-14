program GeradorDeMassaDeDadosParaDUnit;

uses
  Forms,
  Principal in '..\Principal.pas' {frmPrincipal},
  Tabelas in '..\Tabelas.pas' {frmSelecaoDeTabelas},
  Campos in '..\Campos.pas' {frmSelecaoDeCampos};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
