unit frmBindingEditorU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.UITypes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
  Vcl.Buttons, System.Actions, Vcl.ActnList, System.Types,
  Vcl.ExtCtrls, AdvEdit, AdvIPEdit, Vcl.Menus;

type
  TfrmBindingEditor = class(TForm)
    ActionList: TActionList;
    ActionSave: TAction;
    ActionCancel: TAction;
    PopupMenuIPAddress: TPopupMenu;
    NukePanel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    NukePanel2: TPanel;
    NukePanel3: TPanel;
    btnIPAddress: TBitBtn;
    NukeLabelPanel1: TPanel;
    NukeLabelPanel2: TPanel;
    editIP: TAdvIPEdit;
    Label1: TLabel;
    Label2: TLabel;
    editPort: TEdit;
    procedure ActionSaveExecute(Sender: TObject);
    procedure ActionCancelExecute(Sender: TObject);
    procedure btnIPAddressClick(Sender: TObject);
    procedure PopupMenuIPAddressPopup(Sender: TObject);
  private
    function Validate(var AMessage: string): Boolean;
    procedure OnIPAddressPopupClickClick(Sender: TObject);
  public
    function Execute(var AIP: string; var APort: integer): Boolean;
  end;

implementation

{$R *.dfm}

uses
  dmReflectorU, ToolsU;

{ TfrmBindingEditor }

procedure TfrmBindingEditor.ActionCancelExecute(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TfrmBindingEditor.ActionSaveExecute(Sender: TObject);
var
  LMessage: string;
begin
  if Validate(LMessage) then
  begin
    Self.ModalResult := mrOk;
  end
  else
  begin
    MessageDlg(LMessage, mtError, [mbOK], 0);
  end;
end;

procedure TfrmBindingEditor.btnIPAddressClick(Sender: TObject);
begin
  if (Sender is TWinControl) then
  begin
    with (Sender as TWinControl).ClientToScreen
      (point((Sender as TWinControl).Width, (Sender as TWinControl).Height)) do
    begin
      PopupMenuIPAddress.Popup(X, Y);
    end;
  end;
end;

function TfrmBindingEditor.Execute(var AIP: string; var APort: integer)
  : Boolean;
begin
  Result := False;
  editIP.IPAddress := AIP;
  editPort.Text := APort.ToString;
  if Self.ShowModal = mrOk then
  begin
    APort := StrToIntDef(editPort.Text, 0);
    AIP := editIP.IPAddress;
    Result := True;
  end;
end;

procedure TfrmBindingEditor.OnIPAddressPopupClickClick(Sender: TObject);
var
  LIPAddress: string;
begin
  if (Sender is TMenuItem) then
  begin
    LIPAddress := (Sender as TMenuItem).Hint;
    editIP.IPAddress := LIPAddress;
  end;
end;

procedure TfrmBindingEditor.PopupMenuIPAddressPopup(Sender: TObject);
var
  LIPAddress: TStringList;
  LIdx: integer;
  LMenuItem: TMenuItem;
begin
  LIPAddress := TStringList.Create;
  try
    PopupMenuIPAddress.Items.Clear;
    LIPAddress.Add('0.0.0.0');
    GetNetworkIPList(LIPAddress);
    For LIdx := 0 to Pred(LIPAddress.Count) do
    begin
      LMenuItem := TMenuItem.Create(PopupMenuIPAddress);
      LMenuItem.Caption := LIPAddress[LIdx];
      LMenuItem.Hint := LIPAddress[LIdx];
      LMenuItem.OnClick := OnIPAddressPopupClickClick;
      PopupMenuIPAddress.Items.Add(LMenuItem);
    end;
  finally
    FreeAndNil(LIPAddress);
  end;
end;

function TfrmBindingEditor.Validate(var AMessage: string): Boolean;
begin
  Result := True;
  if StrToIntDef(editPort.Text, 0) <= 0 then
  begin
    AMessage := 'Please specify a valid port';
    Result := False;
  end;
end;

end.
