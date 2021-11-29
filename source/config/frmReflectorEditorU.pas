unit frmReflectorEditorU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, VCL.Graphics, VCL.Controls, VCL.Forms, VCL.Dialogs,
  VCL.ComCtrls, VCL.StdCtrls, VCL.ExtCtrls, System.Actions,
  VCL.ActnList, VCL.Buttons, ReflectorsU, VCL.ToolWin, System.UITypes;

type
  TfrmReflectorEditor = class(TForm)
    ActionList: TActionList;
    ActionSave: TAction;
    ActionCancel: TAction;
    ActionAddBinding: TAction;
    ActionRemoveBinding: TAction;
    NukePanel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    NukePanel1: TPanel;
    cbEnabled: TCheckBox;
    radiogroupType: TRadioGroup;
    NukeLabelPanel2: TPanel;
    Label2: TLabel;
    editMappedHost: TEdit;
    NukeLabelPanel3: TPanel;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ListViewBindings: TListView;
    NukeLabelPanel1: TPanel;
    Label3: TLabel;
    editMappedPort: TEdit;
    NukeLabelPanel4: TPanel;
    Label1: TLabel;
    editReflectorName: TEdit;
    procedure ActionSaveExecute(Sender: TObject);
    procedure ActionCancelExecute(Sender: TObject);
    procedure ActionRemoveBindingExecute(Sender: TObject);
    procedure ActionRemoveBindingUpdate(Sender: TObject);
    procedure ActionAddBindingExecute(Sender: TObject);
  private
    FReflectorSettings: TReflectorSettings;
    procedure UpdatingBindings;
    procedure LoadSettings;
    procedure SaveSettings;
    function Validate(var AMessage: string): boolean;
  public
    function Edit(AReflectorSettings: TReflectorSettings): boolean;
  end;

implementation

{$R *.dfm}

uses
  dmReflectorU, frmBindingEditorU, ToolsU;

{ TfrmReflectorEditor }

procedure TfrmReflectorEditor.ActionAddBindingExecute(Sender: TObject);
var
  LfrmBindingEditor: TfrmBindingEditor;
  LIP: string;
  LPort: integer;
begin
  LfrmBindingEditor := TfrmBindingEditor.Create(Self);
  try
    LIP := '0.0.0.0';
    LPort := StrToIntDef(editMappedPort.Text, 0);
    if LfrmBindingEditor.Execute(LIP, LPort) then
    begin
      FReflectorSettings.AddBindings(LIP, LPort);
    end;
  finally
    FreeAndNil(LfrmBindingEditor);
  end;
  UpdatingBindings;
end;

procedure TfrmReflectorEditor.ActionCancelExecute(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TfrmReflectorEditor.ActionRemoveBindingExecute(Sender: TObject);
begin
  ListViewBindings.Selected.Delete;
end;

procedure TfrmReflectorEditor.ActionRemoveBindingUpdate(Sender: TObject);
begin
  ActionRemoveBinding.Enabled := Assigned(ListViewBindings.Selected);
end;

procedure TfrmReflectorEditor.ActionSaveExecute(Sender: TObject);
var
  LMessage: string;
begin
  if Validate(LMessage) then
  begin
    SaveSettings;
    Self.ModalResult := mrOk;
  end
  else
  begin
    MessageDlg(LMessage, mtError, [mbOK], 0);
  end;
end;

function TfrmReflectorEditor.Edit(AReflectorSettings
  : TReflectorSettings): boolean;
begin
  Result := False;
  FReflectorSettings := AReflectorSettings;
  try
    LoadSettings;
    if Self.ShowModal = mrOk then
    begin
      Result := True;
    end;
  finally
    FReflectorSettings := nil;
  end;
end;

procedure TfrmReflectorEditor.LoadSettings;
begin
  editMappedHost.Text := FReflectorSettings.MappedHost;
  editMappedPort.Text := FReflectorSettings.MappedPort.ToString;
  cbEnabled.Checked := FReflectorSettings.Enabled;
  radiogroupType.ItemIndex := integer(FReflectorSettings.ReflectorType);
  editReflectorName.Text := FReflectorSettings.ReflectorName;
  UpdatingBindings;
end;

procedure TfrmReflectorEditor.SaveSettings;
var
  LIdx: integer;
begin
  FReflectorSettings.MappedHost := editMappedHost.Text;
  FReflectorSettings.MappedPort := StrToIntDef(editMappedPort.Text, 0);
  FReflectorSettings.Enabled := cbEnabled.Checked;
  FReflectorSettings.ReflectorType := TReflectorType(radiogroupType.ItemIndex);
  FReflectorSettings.ReflectorName := editReflectorName.Text;
  FReflectorSettings.Bindings.Clear;
  For LIdx := 0 to Pred(ListViewBindings.Items.Count) do
  begin
    FReflectorSettings.AddBindings(ListViewBindings.Items[LIdx].Caption,
      StrToIntDef(ListViewBindings.Items[LIdx].SubItems[0], 0));
  end;
end;

procedure TfrmReflectorEditor.UpdatingBindings;
var
  LReflectorBinding: TReflectorBinding;
begin
  ListViewBindings.Items.Clear;
  ListViewBindings.Items.BeginUpdate;
  try
    For LReflectorBinding in FReflectorSettings.Bindings do
    begin
      with ListViewBindings.Items.Add do
      begin
        Caption := LReflectorBinding.IP;
        SubItems.Add(IntToStr(LReflectorBinding.Port));
      end;
    end;
  finally
    ListViewBindings.Items.EndUpdate;
  end;
end;

function TfrmReflectorEditor.Validate(var AMessage: string): boolean;
begin
  Result := True;
  if IsEmptyString(editReflectorName.Text) then
  begin
    AMessage := 'Please specify a valid name';
    Result := False;
  end;
  if IsEmptyString(editMappedHost.Text) then
  begin
    AMessage := 'Please specify a mapped host';
    Result := False;
  end;
  if radiogroupType.ItemIndex = -1 then
  begin
    AMessage := 'Please specify a valid type';
    Result := False;
  end;
  if StrToIntDef(editMappedPort.Text, 0) <= 0 then
  begin
    AMessage := 'Please specify a valid port';
    Result := False;
  end;
  if ListViewBindings.Items.Count = 0 then
  begin
    AMessage := 'Please specify port bindings';
    Result := False;
  end;
end;

end.
