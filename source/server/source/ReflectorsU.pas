unit ReflectorsU;

interface

uses
  System.Generics.Collections, System.IniFiles,
  Winapi.Windows, Winapi.Messages, Winapi.ShlObj, System.SysUtils,
  System.Variants, System.Classes, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdMappedPortTCP, IdUDPBase, IdUDPServer, IdMappedPortUDP,
  IdSocketHandle, IdContext, ToolsU;

type
  EReflectorException = class(Exception);
  TReflectorType = (refTCP, refUDP);

type
  TReflectorBinding = class
  private
    FPort: integer;
    FIP: string;
    procedure SetIP(const Value: string);
    procedure SetPort(const Value: integer);
  public
    property IP: string read FIP write SetIP;
    property Port: integer read FPort write SetPort;
  end;

  TReflectorBindings = TObjectList<TReflectorBinding>;

  TReflectorSettings = class(TPersistent)
  private
    FReflectorBindings: TReflectorBindings;
    FMappedPort: integer;
    FMappedHost: string;
    FReflectorType: TReflectorType;
    FEnabled: boolean;
    FReflectorName: string;
    procedure SetMappedHost(const Value: string);
    procedure SetMappedPort(const Value: integer);
    procedure SetReflectorType(const Value: TReflectorType);
    procedure SetEnabled(const Value: boolean);
    procedure SetReflectorName(const Value: string);
    procedure Load(AINIFile: TINIFile);
    procedure Save(AINIFile: TINIFile);
    procedure Reset(APreserveName: boolean = false);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure AddBindings(AIP: string; APort: integer);
    property Enabled: boolean read FEnabled write SetEnabled;
    property ReflectorName: string read FReflectorName write SetReflectorName;
    property Bindings: TReflectorBindings read FReflectorBindings;
    property ReflectorType: TReflectorType read FReflectorType
      write SetReflectorType;
    property MappedHost: string read FMappedHost write SetMappedHost;
    property MappedPort: integer read FMappedPort write SetMappedPort;
  end;

  TReflector = class(TObject)
  private
    FIdMappedPortTCP: TIdMappedPortTCP;
    FIdMappedPortUDP: TIdMappedPortUDP;
  protected
    property IdMappedPortTCP: TIdMappedPortTCP read FIdMappedPortTCP;
    property IdMappedPortUDP: TIdMappedPortUDP read FIdMappedPortUDP;
    procedure IdMappedPortConnect(AContext: TIdContext);
    procedure IdMappedPortDisconnect(AContext: TIdContext);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    function Start(AReflectorSettings: TReflectorSettings): boolean;
    function Stop: boolean;
  end;

  TReflectorList = TObjectList<TReflector>;
  TReflectorSettingsList = TObjectList<TReflectorSettings>;

  TReflectors = class(TComponent)
  private
    FReflectorList: TReflectorList;
    FReflectorSettingsList: TReflectorSettingsList;
    FFileName: TFileName;
    procedure SetFileName(const Value: TFileName);
  protected
    property ReflectorList: TReflectorList read FReflectorList;
    function GetDefaultSettingsFolder: string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Settings: TReflectorSettingsList read FReflectorSettingsList;
    property FileName: TFileName read FFileName write SetFileName;
    procedure LoadSettings;
    procedure SaveSettings(AFileName: TFileName); overload;
    procedure SaveSettings; overload;
    function RunCount: integer;
    function IsRunning: boolean;
    function Start: boolean;
    function Stop: boolean;
  end;

implementation

{ TReflectors }

constructor TReflectors.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FReflectorList := TReflectorList.Create(True);
  FReflectorSettingsList := TReflectorSettingsList.Create(True);
  FFileName := GetDefaultSettingsFolder + 'reflectors.ini';
end;

destructor TReflectors.Destroy;
begin
  try
    Stop;
    FreeAndNil(FReflectorSettingsList);
    FreeAndNil(FReflectorList);
  finally
    inherited;
  end;
end;

function TReflectors.GetDefaultSettingsFolder: string;
begin
  Result := IncludeTrailingPathDelimiter
    (IncludeTrailingPathDelimiter(GetShellFolderPath(CSIDL_COMMON_APPDATA)) +
    'NetReflector');
  CheckDirectoryExists(Result, True);
end;

function TReflectors.IsRunning: boolean;
begin
  Result := FReflectorList.Count > 0;
end;

procedure TReflectors.LoadSettings;
var
  LINIFile: TINIFile;
  LSettingsList: TStringList;
  LIdx: integer;
  LReflectorSettings: TReflectorSettings;
begin
  Stop;
  LINIFile := TINIFile.Create(FFileName);
  LSettingsList := TStringList.Create;
  FReflectorSettingsList.Clear;
  try
    LINIFile.ReadSection('Reflectors', LSettingsList);
    For LIdx := 0 to Pred(LSettingsList.Count) do
    begin
      LReflectorSettings := TReflectorSettings.Create;
      LReflectorSettings.ReflectorName := LSettingsList[LIdx];
      LReflectorSettings.Load(LINIFile);
      FReflectorSettingsList.Add(LReflectorSettings);
    end;
  finally
    FreeAndNil(LINIFile);
    FreeAndNil(LSettingsList);
  end;
end;

function TReflectors.RunCount: integer;
begin
  Result := FReflectorList.Count;
end;

procedure TReflectors.SaveSettings(AFileName: TFileName);
var
  LINIFile: TINIFile;
  LReflectorSettings: TReflectorSettings;
begin
  if FileExists(AFileName) then
  begin
    DeleteFile(AFileName);
  end;
  LINIFile := TINIFile.Create(AFileName);
  try
    for LReflectorSettings in FReflectorSettingsList do
    begin
      LReflectorSettings.Save(LINIFile);
    end;
  finally
    FreeAndNil(LINIFile);
  end;
end;

procedure TReflectors.SaveSettings;
begin
  SaveSettings(FFileName);
end;

procedure TReflectors.SetFileName(const Value: TFileName);
begin
  if not SameText(FFileName, Value) then
  begin
    FFileName := Value;
  end;
end;

function TReflectors.Start: boolean;
var
  LReflectorSettings: TReflectorSettings;
  LReflector: TReflector;
begin
  Stop;
  for LReflectorSettings in FReflectorSettingsList do
  begin
    LReflector := TReflector.Create;
    if LReflectorSettings.Enabled then
    begin
      if LReflector.Start(LReflectorSettings) then
      begin
        FReflectorList.Add(LReflector);
      end
      else
      begin
        FreeAndNil(LReflector);
      end;
    end;
  end;
  Result := FReflectorList.Count > 0;
end;

function TReflectors.Stop: boolean;
var
  LIdx: integer;
begin
  Result := false;
  try
    For LIdx := 0 to Pred(FReflectorList.Count) do
    begin
      FReflectorList[LIdx].Stop;
    end;
    FReflectorList.Clear;
    Result := True;
  except
    on E: Exception do
    begin
      //Error(E);
    end;
  end;
end;

{ TReflector }

constructor TReflector.Create;
begin
  inherited;
end;

destructor TReflector.Destroy;
begin
  try
    Stop;
  finally
    inherited;
  end;
end;

procedure TReflector.IdMappedPortConnect(AContext: TIdContext);
begin
  // Log('Connect: ' + AContext.Binding.PeerIP + ': ' +
  // IntToStr(AContext.Binding.PeerPort));
end;

procedure TReflector.IdMappedPortDisconnect(AContext: TIdContext);
begin
  // Log('Disconnect: ' + AContext.Binding.PeerIP + ': ' +
  // IntToStr(AContext.Binding.PeerPort));
end;

function TReflector.Start(AReflectorSettings: TReflectorSettings): boolean;
var
  LIdx: integer;
begin
  Result := false;
  try
    case AReflectorSettings.ReflectorType of
      refTCP:
        begin
          FIdMappedPortTCP := TIdMappedPortTCP.Create(nil);
          FIdMappedPortTCP.OnConnect := IdMappedPortConnect;
          FIdMappedPortTCP.OnDisconnect := IdMappedPortDisconnect;
          FIdMappedPortTCP.MappedHost := AReflectorSettings.MappedHost;
          FIdMappedPortTCP.MappedPort := AReflectorSettings.MappedPort;
          if AReflectorSettings.Bindings.Count > 0 then
          begin
            For LIdx := 0 to Pred(AReflectorSettings.Bindings.Count) do
            begin
              with FIdMappedPortTCP.Bindings.Add do
              begin
                IP := AReflectorSettings.Bindings[LIdx].IP;
                Port := AReflectorSettings.Bindings[LIdx].Port;
              end;
            end;
          end
          else
          begin
            with FIdMappedPortTCP.Bindings.Add do
            begin
              IP := '0.0.0.0';
              Port := AReflectorSettings.MappedPort;
            end;
          end;
          FIdMappedPortTCP.Active := True;
          Result := FIdMappedPortTCP.Active;
        end;
      refUDP:
        begin
          FIdMappedPortUDP := TIdMappedPortUDP.Create(nil);
          FIdMappedPortUDP.MappedHost := AReflectorSettings.MappedHost;
          FIdMappedPortUDP.MappedPort := AReflectorSettings.MappedPort;
          if AReflectorSettings.Bindings.Count > 0 then
          begin
            For LIdx := 0 to Pred(AReflectorSettings.Bindings.Count) do
            begin
              with FIdMappedPortUDP.Bindings.Add do
              begin
                IP := AReflectorSettings.Bindings[LIdx].IP;
                Port := AReflectorSettings.Bindings[LIdx].Port;
              end;
            end;
          end
          else
          begin
            with FIdMappedPortUDP.Bindings.Add do
            begin
              IP := '0.0.0.0';
              Port := AReflectorSettings.MappedPort;
            end;
          end;
          FIdMappedPortUDP.Active := True;
          Result := FIdMappedPortUDP.Active;
        end;
    end;
  except
    on E: Exception do
    begin
     // Error(E);
    end;
  end;
end;

function TReflector.Stop: boolean;
begin
  Result := false;
  try
    if Assigned(FIdMappedPortTCP) then
    begin
      FIdMappedPortTCP.Active := false;
      FreeAndNil(FIdMappedPortTCP);
    end;
    if Assigned(FIdMappedPortUDP) then
    begin
      FIdMappedPortUDP.Active := false;
      FreeAndNil(FIdMappedPortUDP);
    end;
  except
    on E: Exception do
    begin
     // Error(E);
    end;
  end;
end;

{ TReflectorSettings }

procedure TReflectorSettings.AddBindings(AIP: string; APort: integer);
var
  LReflectorBinding: TReflectorBinding;
begin
  LReflectorBinding := TReflectorBinding.Create;
  LReflectorBinding.Port := APort;
  LReflectorBinding.IP := AIP;
  FReflectorBindings.Add(LReflectorBinding);
end;

constructor TReflectorSettings.Create;
begin
  FReflectorBindings := TReflectorBindings.Create(True);
  Reset;
end;

destructor TReflectorSettings.Destroy;
begin
  try
    FreeAndNil(FReflectorBindings);
  finally
    inherited;
  end;
end;

procedure TReflectorSettings.Load(AINIFile: TINIFile);
var
  LBindingSections: TStringList;
  LIdx: integer;
  LBinding: TReflectorBinding;
begin
  Reset(True);
  if not IsEmptyString(FReflectorName) then
  begin
    LBindingSections := TStringList.Create;
    try
      FEnabled := AINIFile.ReadBool(FReflectorName, 'Enabled', True);
      FReflectorType := TReflectorType(AINIFile.ReadInteger(FReflectorName,
        'Type', integer(refTCP)));
      FMappedPort := AINIFile.ReadInteger(FReflectorName, 'MappedPort', 0);
      FMappedHost := AINIFile.ReadString(FReflectorName, 'MappedHost', '');
      AINIFile.ReadSection(FReflectorName + '.Bindings', LBindingSections);
      For LIdx := 0 to Pred(LBindingSections.Count) do
      begin
        LBinding := TReflectorBinding.Create;
        LBinding.IP := AINIFile.ReadString(LBindingSections[LIdx], 'IP',
          '0.0.0.0');
        LBinding.Port := AINIFile.ReadInteger(LBindingSections[LIdx], 'Port',
          FMappedPort);
        Bindings.Add(LBinding);
      end;
    finally
      FreeAndNil(LBindingSections);
    end;
  end
  else
  begin
    raise EReflectorException.Create('Name has not been specified');
  end;
end;

procedure TReflectorSettings.Reset(APreserveName: boolean);
begin
  if not APreserveName then
  begin
    FReflectorName := '';
  end;
  FEnabled := True;
  FReflectorType := refTCP;
  FMappedPort := 0;
  FMappedHost := 'localhost';
  FReflectorBindings.Clear;
end;

procedure TReflectorSettings.Save(AINIFile: TINIFile);
var
  LIdx: integer;
  LBindingSectionName: string;
begin
  if not IsEmptyString(FReflectorName) then
  begin
    AINIFile.WriteString('Reflectors', FReflectorName, '');
    AINIFile.WriteBool(FReflectorName, 'Enabled', FEnabled);
    AINIFile.WriteInteger(FReflectorName, 'Type', integer(FReflectorType));
    AINIFile.WriteInteger(FReflectorName, 'MappedPort', FMappedPort);
    AINIFile.WriteString(FReflectorName, 'MappedHost', FMappedHost);
    AINIFile.EraseSection(FReflectorName + '.Bindings');
    For LIdx := 0 to Pred(FReflectorBindings.Count) do
    begin
      LBindingSectionName := FReflectorName + '.Bindings' + '.' +
        IntToStr(LIdx);
      AINIFile.WriteString(FReflectorName + '.Bindings',
        LBindingSectionName, '');
      AINIFile.WriteString(LBindingSectionName, 'IP', Bindings[LIdx].IP);
      AINIFile.WriteInteger(LBindingSectionName, 'Port', Bindings[LIdx].Port);
    end;
  end
  else
  begin
    raise EReflectorException.Create('Name has not been specified');
  end;
end;

procedure TReflectorSettings.SetEnabled(const Value: boolean);
begin
  FEnabled := Value;
end;

procedure TReflectorSettings.SetMappedHost(const Value: string);
begin
  FMappedHost := Value;
end;

procedure TReflectorSettings.SetMappedPort(const Value: integer);
begin
  FMappedPort := Value;
end;

procedure TReflectorSettings.SetReflectorName(const Value: string);
begin
  FReflectorName := Value;
end;

procedure TReflectorSettings.SetReflectorType(const Value: TReflectorType);
begin
  FReflectorType := Value;
end;

{ TReflectorBinding }

procedure TReflectorBinding.SetIP(const Value: string);
begin
  FIP := Value;
end;

procedure TReflectorBinding.SetPort(const Value: integer);
begin
  FPort := Value;
end;

end.
