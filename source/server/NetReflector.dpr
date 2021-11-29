program NetReflector;

{$R 'version.res' '..\common\version.rc'}

uses
  JclDebug,
  VCL.SvcMgr,
  svcReflectorU in 'svcReflectorU.pas' {NetReflectorService: TService};

{$R *.RES}

begin
  if not Application.DelayInitialize or Application.Installing then
    Application.Initialize;
  Application.Title := 'NetReflectorService';
  Application.CreateForm(TNetReflectorService, NetReflectorService);
  Application.Run;

end.
