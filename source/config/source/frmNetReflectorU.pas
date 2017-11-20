unit frmNetReflectorU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  System.Actions, Vcl.ActnList, Vcl.ComCtrls,
  Vcl.ToolWin, Vcl.StdCtrls, Vcl.Buttons, ReflectorsU, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.Imaging.jpeg, HTMLCredit, System.UITypes;

const
  APPLICATION_SERVICE_NAME = 'NetReflectorService';

type
  TfrmNetReflector = class(TForm)
    PageControlReflectors: TPageControl;
    tabGeneral: TTabSheet;
    tabReflectors: TTabSheet;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ActionList: TActionList;
    ActionAdd: TAction;
    ActionDelete: TAction;
    ActionEdit: TAction;
    GroupBox1: TGroupBox;
    BitBtn2: TBitBtn;
    ActionStartStopService: TAction;
    ActionRefresh: TAction;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    imgLogo: TImage;
    tabAbout: TTabSheet;
    ScrollText: THTMLCredit;
    ListViewReflectors: TListView;
    procedure ActionAddExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ActionRefreshExecute(Sender: TObject);
    procedure ActionEditUpdate(Sender: TObject);
    procedure ActionEditExecute(Sender: TObject);
    procedure ActionDeleteExecute(Sender: TObject);
    procedure PageControlReflectorsChange(Sender: TObject);
    procedure ActionStartStopServiceUpdate(Sender: TObject);
    procedure ActionStartStopServiceExecute(Sender: TObject);
    procedure ActionAddUpdate(Sender: TObject);
    procedure ListViewReflectorsDblClick(Sender: TObject);
  private
    FReflectors: TReflectors;
    FApplicationActive: Boolean;
    procedure RefreshSettings;
    function IsServiceRunning(AServiceName: string): Boolean;
    function StartService(AServiceName: string): Boolean;
    function StopService(AServiceName: string): Boolean;
  public
    { Public declarations }
  end;

var
  frmNetReflector: TfrmNetReflector;

implementation

{$R *.dfm}

uses
  dmReflectorU, frmReflectorEditorU, ServiceControlU;

procedure TfrmNetReflector.ActionAddExecute(Sender: TObject);
var
  LEditor: TfrmReflectorEditor;
  LReflectorSettings: TReflectorSettings;
begin
  LEditor := TfrmReflectorEditor.Create(Self);
  LReflectorSettings := TReflectorSettings.Create;
  try
    if LEditor.Edit(LReflectorSettings) then
    begin
      FReflectors.Settings.Add(LReflectorSettings);
      FReflectors.SaveSettings;
    end
    else
    begin
      FreeAndNil(LReflectorSettings);
    end;
  finally
    FreeAndNil(LEditor);
  end;
  ActionRefresh.Execute;
end;

procedure TfrmNetReflector.ActionAddUpdate(Sender: TObject);
var
  LAllowExecute: Boolean;
begin
  LAllowExecute := not IsServiceRunning(APPLICATION_SERVICE_NAME);
  (Sender as TAction).Enabled := LAllowExecute;
end;

procedure TfrmNetReflector.ActionDeleteExecute(Sender: TObject);
var
  LReflectorSettings: TReflectorSettings;
begin
  LReflectorSettings := TReflectorSettings(ListViewReflectors.Selected.Data);
  if MessageDlg(Format('Delete "%s"?', [LReflectorSettings.ReflectorName]),
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    FReflectors.Settings.Remove(LReflectorSettings);
    FReflectors.SaveSettings;
  end;
  ActionRefresh.Execute;
end;

procedure TfrmNetReflector.ActionEditExecute(Sender: TObject);
var
  LEditor: TfrmReflectorEditor;
  LReflectorSettings: TReflectorSettings;
begin
  LEditor := TfrmReflectorEditor.Create(Self);
  LReflectorSettings := TObject(ListViewReflectors.Selected.Data)
    as TReflectorSettings;
  try
    if LEditor.Edit(LReflectorSettings) then
    begin
      FReflectors.SaveSettings;
    end;
  finally
    FreeAndNil(LEditor);
  end;
  ActionRefresh.Execute;
end;

procedure TfrmNetReflector.ActionEditUpdate(Sender: TObject);
var
  LAllowExecute: Boolean;
begin
  LAllowExecute := not IsServiceRunning(APPLICATION_SERVICE_NAME);
  if LAllowExecute then
  begin
    LAllowExecute := ListViewReflectors.ItemIndex <> -1;
  end;
  if LAllowExecute then
  begin
    LAllowExecute := ListViewReflectors.Selected.Data <> nil;
  end;
  if LAllowExecute then
  begin
    LAllowExecute := TObject(ListViewReflectors.Selected.Data)
      is TReflectorSettings;
  end;
  (Sender as TAction).Enabled := LAllowExecute;
end;

procedure TfrmNetReflector.RefreshSettings;
var
  LReflectorSettings: TReflectorSettings;
  LListViewItem: TListItem;
begin
  ListViewReflectors.Items.Clear;
  ListViewReflectors.Items.BeginUpdate;
  try
    For LReflectorSettings in FReflectors.Settings do
    begin
      LListViewItem := ListViewReflectors.Items.Add;
      LListViewItem.Caption := LReflectorSettings.ReflectorName;
      LListViewItem.SubItems.Add(LReflectorSettings.MappedHost);
      LListViewItem.SubItems.Add(LReflectorSettings.MappedPort.ToString);
      LListViewItem.Data := LReflectorSettings;
    end;
  finally
    ListViewReflectors.Items.EndUpdate;
  end;
end;

procedure TfrmNetReflector.ActionRefreshExecute(Sender: TObject);
begin
  if PageControlReflectors.ActivePage = tabReflectors then
  begin
    RefreshSettings;
  end;
end;

procedure TfrmNetReflector.ActionStartStopServiceExecute(Sender: TObject);
begin
  if IsServiceRunning(APPLICATION_SERVICE_NAME) then
  begin
    StopService(APPLICATION_SERVICE_NAME);
  end
  else
  begin
    StartService(APPLICATION_SERVICE_NAME);
  end;
end;

procedure TfrmNetReflector.ActionStartStopServiceUpdate(Sender: TObject);
begin
  if IsServiceRunning(APPLICATION_SERVICE_NAME) then
  begin
    ActionStartStopService.Caption := 'Stop';
    ActionStartStopService.ImageIndex := 6;
  end
  else
  begin
    ActionStartStopService.Caption := 'Start';
    ActionStartStopService.ImageIndex := 5;
  end;
end;

procedure TfrmNetReflector.FormActivate(Sender: TObject);
begin
  if not FApplicationActive then
  begin
    FApplicationActive := True;
    FReflectors.LoadSettings;
  end;
end;

procedure TfrmNetReflector.FormCreate(Sender: TObject);
begin
  FApplicationActive := False;
  FReflectors := TReflectors.Create(Self);
  PageControlReflectors.ActivePageIndex := 0;
end;

procedure TfrmNetReflector.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FReflectors);
end;

function TfrmNetReflector.IsServiceRunning(AServiceName: string): Boolean;
var
  NTServiceControl: TNTServiceControl;
begin
  NTServiceControl := TNTServiceControl.Create(nil);
  try
    NTServiceControl.ServiceName := AServiceName;
    Result := NTServiceControl.IsRunning;
  finally
    FreeAndNil(NTServiceControl);
  end;
end;

procedure TfrmNetReflector.ListViewReflectorsDblClick(Sender: TObject);
begin
  ActionEdit.Execute;
end;

function TfrmNetReflector.StartService(AServiceName: string): Boolean;
var
  NTServiceControl: TNTServiceControl;
begin
  NTServiceControl := TNTServiceControl.Create(nil);
  try
    NTServiceControl.ServiceName := AServiceName;
    NTServiceControl.StartDependencies := True;
    Result := NTServiceControl.Start;
  finally
    FreeAndNil(NTServiceControl);
  end;
end;

function TfrmNetReflector.StopService(AServiceName: string): Boolean;
var
  NTServiceControl: TNTServiceControl;
begin
  NTServiceControl := TNTServiceControl.Create(nil);
  try
    NTServiceControl.ServiceName := AServiceName;
    NTServiceControl.StopDependencies := True;
    Result := NTServiceControl.Stop;
  finally
    FreeAndNil(NTServiceControl);
  end;
end;

procedure TfrmNetReflector.PageControlReflectorsChange(Sender: TObject);
begin
  ActionRefresh.Execute;
end;

end.
