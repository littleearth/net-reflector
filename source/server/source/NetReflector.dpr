program NetReflector;

uses
  JclDebug,
  VCL.SvcMgr,
  svcReflectorU in 'svcReflectorU.pas' {NetReflectorService: TService},
  ReflectorsU in 'ReflectorsU.pas',
  ToolsU in '..\..\config\source\ToolsU.pas';

{$R *.RES}

begin
  if not Application.DelayInitialize or Application.Installing then
    Application.Initialize;
  Application.CreateForm(TNetReflectorService, NetReflectorService);
  Application.Run;

end.
