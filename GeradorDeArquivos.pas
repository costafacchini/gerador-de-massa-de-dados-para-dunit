unit GeradorDeArquivos;

interface

uses
  IB_Components, IB_Access, Generics.Collections, Classes;

type

  TGeradorDeArquivos = class
  private
    class procedure GeraTabela(conexao: TIB_Connection; arquivo: TStringList; const tabela, campos: string);
    class procedure GeraLinha(qry:  TIB_Query; arquivo: TStringList; const tabela: string);
    class function GetTamanhoDoCampo(const nomeDoField, valorDoField: string): Integer;
    class function padL(const Oque: string; const Tamanho: integer; const ComOque: char): string; static;
  public
    class procedure Gerar(conexao: TIB_Connection; listaDeTabelas: TDictionary<string, string>);
  end;

implementation

uses
  SysUtils, Dialogs;

class procedure TGeradorDeArquivos.Gerar(conexao: TIB_Connection; listaDeTabelas: TDictionary<string, string>);
var
  Arquivo: TStringList;
  CodigoKey: string;
  SD: TSaveDialog;
begin
  Arquivo := TStringList.Create;
  try
    for CodigoKey in listaDeTabelas.Keys do
    begin
      GeraTabela(conexao, Arquivo, AnsiLowerCase(CodigoKey), listaDeTabelas.Items[CodigoKey]);
    end;
    SD := TSaveDialog.Create(nil);
    try
      SD.Filter := 'Arquivos de DUnit (*.sql)|*.sql';
      SD.FilterIndex := 0;
      SD.DefaultExt := '*.zip';
      SD.FileName := 'InicializaBancoDeDados.sql';
      if SD.Execute then
        Arquivo.SaveToFile(SD.FileName);
    finally
      SD.Free;
    end;

  finally
    Arquivo.Free;
  end;
end;

class procedure TGeradorDeArquivos.GeraTabela(conexao: TIB_Connection; arquivo: TStringList; const tabela, campos: string);
var
  Qry: TIB_Query;
begin
  Qry := TIB_Query.Create(nil);
  try
    Qry.IB_Connection := conexao;
    Qry.CommitAction := caInvalidateCursor;
    Qry.SQL.Add('Select');
    Qry.SQL.Add('    ' + campos);
    Qry.SQL.Add('From');
    Qry.SQL.Add('    ' + tabela);
    Qry.Open;
    if not Qry.IsEmpty then
    begin
      arquivo.Add('/*');
      arquivo.Add('Amostra:');
      arquivo.Add('');
      arquivo.Add('Cenário:');
      arquivo.Add('*/');
      while not Qry.Eof do
      begin
        GeraLinha(qry, arquivo, tabela);
        arquivo.Add('');
        Qry.Next;
      end;
    end;
    arquivo.Add('');
    arquivo.Add('');
    arquivo.Add('');
  finally
    Qry.Free;
  end;
end;

class procedure TGeradorDeArquivos.GeraLinha(qry: TIB_Query; arquivo: TStringList; const tabela: string);
var
  LinhaCabecalho: string;
  LinhaValores: string;
  i: Integer;
  Tamanho: Integer;
  ValorDoField: string;
begin
  LinhaCabecalho := '';
  LinhaValores := '';
  Tamanho := 0;
  for i := 0 to qry.FieldCount - 1 do
  begin
    if qry.Fields[i].FieldName <> 'DB_KEY' then
    begin
      if qry.Fields[i].IsNumeric then
      begin
        ValorDoField := qry.FieldByName(qry.Fields[i].FieldName).AsString;
        ValorDoField := StringReplace(ValorDoField, ',', '.', [rfReplaceAll])
      end
      else
      begin
        if qry.Fields[i].IsDateTime then
        begin
          if qry.Fields[i].IsDateOnly then
            ValorDoField := FormatDateTime('dd.mm.yyyy', qry.FieldByName(qry.Fields[i].FieldName).AsDate)
          else
            ValorDoField := FormatDateTime('dd.mm.yyyy HH:MM:ss', qry.FieldByName(qry.Fields[i].FieldName).AsDateTime);
        end
        else
          ValorDoField := qry.FieldByName(qry.Fields[i].FieldName).AsString;

        ValorDoField := QuotedStr(ValorDoField);
      end;

      Tamanho := GetTamanhoDoCampo(qry.Fields[i].FieldName, ValorDoField);
      LinhaCabecalho := LinhaCabecalho + padL(qry.Fields[i].FieldName, Tamanho, ' ') + ', ';
      LinhaCabecalho := AnsiLowerCase(LinhaCabecalho);
      LinhaValores := LinhaValores + padL(ValorDoField, Tamanho, ' ') + ', ';
    end;
  end;
  Delete(LinhaCabecalho, Length(LinhaCabecalho)-1, 2);
  Delete(LinhaValores, Length(LinhaValores)-1, 2);
  arquivo.Add('insert into ' + tabela + ' (' + LinhaCabecalho + ')');
  arquivo.Add(StringOfChar(' ', (length(tabela) + 6)) + 'values (' + LinhaValores + ');');
end;

class function TGeradorDeArquivos.GetTamanhoDoCampo(const nomeDoField, valorDoField: string): Integer;
begin
  Result := length(nomeDoField);
  if length(valorDoField) > length(nomeDoField) then
    Result := length(valorDoField);
end;

class function TGeradorDeArquivos.padL(const Oque: string; const Tamanho: integer; const ComOque: char): string;
begin
  Result := Copy(Oque, 1, Tamanho);
  if Length(Result) < Tamanho then
    Result := StringOfChar(ComOque, Tamanho - Length(Result)) + Result;
end;

end.
