program NetReflectorConfig;

uses
  FastMM4,
  JclDebug,
  IdThreadSafe,
  IdGlobal,
  Forms,
  Windows,
  Controls,
  Dialogs,
  SysUtils,
  System.UITypes,
  frmNetReflectorU in 'frmNetReflectorU.pas' {frmNetReflector},
  frmReflectorEditorU in 'frmReflectorEditorU.pas' {frmReflectorEditor},
  dmReflectorU in 'dmReflectorU.pas' {dmReflector: TDataModule},
  ReflectorsU in '..\..\server\source\ReflectorsU.pas',
  frmBindingEditorU in 'frmBindingEditorU.pas' {frmBindingEditor},
  ToolsU in 'ToolsU.pas',
  ServiceControlU in 'ServiceControlU.pas';

{$R *.res}

begin
  Application.Initialize;

  if CheckWin32Version(6) then

  begin

    if IsFontInstalled('Segoe UI') then
    begin
      Application.DefaultFont.Name := 'Segoe UI';
      Screen.MessageFont.Name := 'Segoe UI';
    end;

    if IsFontInstalled('Roboto Lt') then
    begin
      Application.DefaultFont.Name := 'Roboto Lt';
      Screen.MessageFont.Name := 'Roboto Lt';
    end;
  end;

  Application.MainFormOnTaskbar := True;
  Application.Title := 'NetReflector';
  Application.CreateForm(TfrmNetReflector, frmNetReflector);
  Application.CreateForm(TdmReflector, dmReflector);
  Application.Run;

end.
