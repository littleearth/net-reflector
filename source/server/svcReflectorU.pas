unit svcReflectorU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs, ReflectorsU;

type
  TNetReflectorService = class(TService)
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceDestroy(Sender: TObject);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
  private
    FReflectors: TReflectors;
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  NetReflectorService: TNetReflectorService;

implementation

{$R *.dfm}


procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  NetReflectorService.Controller(CtrlCode);
end;

function TNetReflectorService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TNetReflectorService.ServiceCreate(Sender: TObject);
begin
  FReflectors := TReflectors.Create(Self);
end;

procedure TNetReflectorService.ServiceDestroy(Sender: TObject);
begin
  FreeAndNil(FReflectors);
end;

procedure TNetReflectorService.ServiceStart(Sender: TService; var Started: Boolean);
begin
  FReflectors.LoadSettings;
  Started := FReflectors.Start;
end;

procedure TNetReflectorService.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  Stopped := FReflectors.Stop;
end;

end.
