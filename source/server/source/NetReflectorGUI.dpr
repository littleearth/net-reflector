program NetReflectorGUI;

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
  Printers,
  System.UITypes,
  frmServerGUIU in 'frmServerGUIU.pas' {frmServerGUI},
  ReflectorsU in 'ReflectorsU.pas',
  dmReflectorU in '..\..\config\source\dmReflectorU.pas' {dmReflector: TDataModule},
  frmNetReflectorU in '..\..\config\source\frmNetReflectorU.pas' {frmNetReflector},
  frmBindingEditorU in '..\..\config\source\frmBindingEditorU.pas' {frmBindingEditor},
  frmReflectorEditorU in '..\..\config\source\frmReflectorEditorU.pas' {frmReflectorEditor},
  ToolsU in '..\..\config\source\ToolsU.pas',
  ServiceControlU in '..\..\config\source\ServiceControlU.pas';

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
  Application.CreateForm(TfrmServerGUI, frmServerGUI);
  Application.CreateForm(TdmReflector, dmReflector);
  Application.Run;

end.
