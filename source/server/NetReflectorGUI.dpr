program NetReflectorGUI;

{$R 'version.res' '..\common\version.rc'}

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
  ToolsU in '..\..\config\source\ToolsU.pas',
  ServiceControlU in '..\..\config\source\ServiceControlU.pas',
  frmNetReflectorU in '..\config\frmNetReflectorU.pas' {frmNetReflector},
  dmReflectorU in '..\config\dmReflectorU.pas' {dmReflector: TDataModule},
  frmReflectorEditorU in '..\config\frmReflectorEditorU.pas' {frmReflectorEditor},
  frmBindingEditorU in '..\config\frmBindingEditorU.pas' {frmBindingEditor};

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
  Application.CreateForm(TfrmNetReflector, frmNetReflector);
  Application.CreateForm(TdmReflector, dmReflector);
  Application.Run;

end.
