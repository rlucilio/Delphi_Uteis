unit Model.ViewUtil;

interface

uses
  FMX.Types, FMX.Printer;

function ResultadoDaPergunta(titulo, pergunta: string): string;
function SelecionarCaminhoDoArquivo(filtro, titulo: string): string;
procedure animacaoPulsar(componenteVisual: TFmxObject; TamanhoOriginal: double);
function selecionarImpressora: string;
procedure MostrarMsg(const msg: string);

implementation

uses
  FMX.Dialogs, System.SysUtils, FMX.Platform, FMX.Controls, FMX.Ani;

procedure MostrarMsg(const msg: string);
var
  dialog: IFMXDialogServiceSync;
begin
   TPlatformServices.Current.SupportsPlatformService(IFMXDialogServiceSync,
    IInterface(dialog));

  dialog.ShowMessageSync(msg);
end;

function SelecionarCaminhoDoArquivo(filtro, titulo: string): string;
var
  openDialog: TOpenDialog;
begin
  openDialog := TOpenDialog.Create(nil);
  openDialog.Title := titulo;
  openDialog.InitialDir := 'C:\';
  openDialog.Filter := filtro;
  try
    if openDialog.Execute then
    begin
      if openDialog.FileName <> '' then
      begin
        Result := openDialog.FileName;
      end
      else
        ShowMessage('Arquivo Inv�lido');
    end;
  finally
    FreeAndNil(openDialog);
  end;
end;

function ResultadoDaPergunta(titulo, pergunta: string): string;
var
  dialog: IFMXDialogServiceSync;
  resposta: array [1 .. 1] of string;
begin
  resposta[1] := '';
  TPlatformServices.Current.SupportsPlatformService(IFMXDialogServiceSync,
    IInterface(dialog));

  dialog.InputQuerySync(titulo, [pergunta], resposta);

  Result := resposta[1];
end;

procedure animacaoPulsar(componenteVisual: TFmxObject; TamanhoOriginal: double);
var
  tamanho: double;
  altura: double;
  tamanhoAnimacao: integer;
begin
  tamanho := (componenteVisual as TControl).Width;
  altura := (componenteVisual as TControl).Height;
  tamanhoAnimacao := 5;

  if tamanho = TamanhoOriginal then
  begin
    TAnimator.AnimateFloat(componenteVisual, 'Width', tamanho + tamanhoAnimacao,
      0.2, TAnimationType.&In, TInterpolationType.Quadratic);

    TAnimator.AnimateFloat(componenteVisual, 'Height', altura + tamanhoAnimacao,
      0.2, TAnimationType.&In, TInterpolationType.Quadratic);
  end
  else
  begin
    TAnimator.AnimateFloat(componenteVisual, 'Width', tamanho - tamanhoAnimacao,
      0.2, TAnimationType.Out, TInterpolationType.Quadratic);

    TAnimator.AnimateFloat(componenteVisual, 'Height', altura - tamanhoAnimacao,
      0.2, TAnimationType.Out, TInterpolationType.Quadratic);
  end;
end;

function selecionarImpressora: string;
var
  dialog: TPrintDialog;
begin
  dialog := TPrintDialog.Create(nil);
  try
    dialog.Execute;
    Result := Printer.ActivePrinter.Device;
  finally
    dialog.Free;
  end;
end;

end.
