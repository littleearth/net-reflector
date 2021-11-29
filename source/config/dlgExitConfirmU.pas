unit dlgExitConfirmU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TdlgExitConfirm = class(TForm)
    Panel1:    TPanel;
    Panel2:    TPanel;
    btnCancel: TBitBtn;
    btnOk:     TBitBtn;
    ImageExit: TImage;
    Panel3:    TPanel;
    lblExitMessage: TLabel;
    cbStartService: TCheckBox;
  private
    { Private declarations }
  public
    function Execute(var AStartService: boolean): boolean;
  end;

var
  dlgExitConfirm: TdlgExitConfirm;

implementation

{$R *.dfm}

function TdlgExitConfirm.Execute(var AStartService: boolean): boolean;
begin
  Result := False;
  cbStartService.Checked := AStartService;
  cbStartService.Visible := AStartService;
  if Self.ShowModal = mrOk then
  begin
    Result := True;
    AStartService := cbStartService.Checked;
  end;
end;

end.

