unit ToolsU;

interface

uses
  JwaShLWAPI, ComObj,
  Windows, Messages, SysUtils, Classes, VCL.Controls, VCL.Forms, VCL.Dialogs,
  ShellAPI, SHFolder, DB, Variants, Printers, WinSpool, System.Win.Registry,
  System.UITypes, VCL.Graphics;

function IsEmptyString(AValue: string): boolean;
function StripExtraSpaces(AValue: string; ARemoveTab: boolean = False;
  ARemoveCRLF: boolean = False): string;

function IsFontInstalled(const AFontName: string): boolean;

function GetShellFolderPath(AFolder: integer): string;
function CheckDirectoryExists(ADirectory: string; ACreate: boolean): boolean;

procedure GetNetworkIPList(AList: TStrings);

implementation

uses
  IdStack;

function IsFontInstalled(const AFontName: string): boolean;
begin
  Result := Screen.Fonts.IndexOf(AFontName) <> -1;
end;

function IsEmptyString(AValue: string): boolean;
begin
  Result := Trim(AValue) = '';
end;

function StripExtraSpaces(AValue: string; ARemoveTab: boolean = False;
  ARemoveCRLF: boolean = False): string;
var
  i: integer;
  Source: string;
begin
  Source := Trim(AValue);

  Source := StringReplace(Source, #160, ' ', [rfReplaceAll]);

  if ARemoveTab then
    Source := StringReplace(Source, #9, ' ', [rfReplaceAll]);
  if ARemoveCRLF then
  begin
    Source := StringReplace(Source, #10, ' ', [rfReplaceAll]);
    Source := StringReplace(Source, #13, ' ', [rfReplaceAll]);
  end;

  if Length(Source) > 1 then
  begin
    Result := Source[1];
    for i := 2 to Length(Source) do
    begin
      if Source[i] = ' ' then
      begin
        if not(Source[i - 1] = ' ') then
          Result := Result + ' ';
      end
      else
      begin
        Result := Result + Source[i];
      end;
    end;
  end
  else
  begin
    Result := Source;
  end;
  Result := Trim(Result);
end;

function GetShellFolderPath(AFolder: integer): string;
const
  SHGFP_TYPE_CURRENT = 0;
var
  path: array [0 .. MAX_PATH] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0, AFolder, 0, SHGFP_TYPE_CURRENT, @path[0]))
  then
    Result := path
  else
    Result := '';
end;

function CheckDirectoryExists(ADirectory: string; ACreate: boolean): boolean;
begin
  try
    if ACreate then
    begin
      if not DirectoryExists(ADirectory) then
      begin
        ForceDirectories(ADirectory);
      end;
    end;
  finally
    Result := DirectoryExists(ADirectory);
  end;
end;

procedure GetNetworkIPList(AList: TStrings);
var
  Lidx: integer;
  LAddress: string;
begin
  TIdStack.IncUsage;
  try
    if Assigned(GStack) then
    begin
      for Lidx := 0 to Pred(GStack.LocalAddresses.Count) do
      begin
        LAddress := StripExtraSpaces(GStack.LocalAddresses[Lidx], True, True);
        if not IsEmptyString(LAddress) then
          AList.Add(LAddress);
      end;
    end;
  finally
    TIdStack.DecUsage;
    AList.Add('127.0.0.1');
  end;
end;

end.
