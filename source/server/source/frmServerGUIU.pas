unit frmServerGUIU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, VCL.Graphics, VCL.Controls, VCL.Forms, VCL.Dialogs,
  ReflectorsU, VCL.StdCtrls, VCL.Buttons, System.Actions, VCL.ActnList,
  VCL.ToolWin, VCL.ComCtrls, IdContext, IdBaseComponent, IdComponent,
  System.UITypes, IdCustomTCPServer, IdMappedPortTCP, VCL.ExtCtrls, ToolsU,
  VCL.Imaging.jpeg;

type
  TfrmServerGUI = class(TForm)
    ToolBar1: TToolBar;
    ActionList: TActionList;
    ActionStartStop: TAction;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ActionRefresh: TAction;
    StatusBar: TStatusBar;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ActionConfig: TAction;
    Timer: TTimer;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure ActionStartStopExecute(Sender: TObject);
    procedure ActionStartStopUpdate(Sender: TObject);
    procedure ActionRefreshExecute(Sender: TObject);
    procedure ActionConfigExecute(Sender: TObject);
    procedure ActionConfigUpdate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    FReflectors: TReflectors;
  public
    { Public declarations }
  end;

var
  frmServerGUI: TfrmServerGUI;

implementation

{$R *.dfm}

uses
  dmReflectorU, frmNetReflectorU;

procedure TfrmServerGUI.ActionConfigExecute(Sender: TObject);
var
  LfrmNetReflector: TfrmNetReflector;
begin
  LfrmNetReflector := TfrmNetReflector.Create(Self);
  try
    LfrmNetReflector.ShowModal;
  finally
    FreeAndNil(LfrmNetReflector);
  end;
  FReflectors.LoadSettings;
end;

procedure TfrmServerGUI.ActionConfigUpdate(Sender: TObject);
begin
  ActionConfig.Enabled := not FReflectors.IsRunning;
end;

procedure TfrmServerGUI.ActionRefreshExecute(Sender: TObject);
begin
  StatusBar.SimpleText := Format('%d reflector(s) active',
    [FReflectors.RunCount])
end;

procedure TfrmServerGUI.ActionStartStopExecute(Sender: TObject);
begin
  if FReflectors.IsRunning then
  begin
    if not FReflectors.Stop then
    begin
      MessageDlg('Failed to stop reflectors', mtError, [mbOK], 0);
    end;
  end
  else
  begin
    if not FReflectors.Start then
    begin
      MessageDlg('Failed to start reflectors', mtError, [mbOK], 0);
    end;
  end;
  ActionRefresh.Execute;
end;

procedure TfrmServerGUI.ActionStartStopUpdate(Sender: TObject);
begin
  if FReflectors.IsRunning then
  begin
    ActionStartStop.Caption := 'Stop';
    ActionStartStop.ImageIndex := 6;
  end
  else
  begin
    ActionStartStop.Caption := 'Start';
    ActionStartStop.ImageIndex := 5;
  end;
end;

procedure TfrmServerGUI.FormCreate(Sender: TObject);
begin
  FReflectors := TReflectors.Create(Self);
  FReflectors.LoadSettings;
end;

procedure TfrmServerGUI.TimerTimer(Sender: TObject);
begin
  ActionRefresh.Execute;
end;

end.
