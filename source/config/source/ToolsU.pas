unit ToolsU;

interface

uses
  ComObj,
  Windows, Messages, SysUtils, Classes, VCL.Controls, VCL.Forms, VCL.Dialogs,
  ShellAPI, SHFolder, DB, Variants, Printers, WinSpool,
  System.UITypes, VCL.Graphics;

function IsEmptyString(AValue: string): boolean;
function StripExtraSpaces(AValue: string; ARemoveTab: boolean = False;
  ARemoveCRLF: boolean = False): string;
function StripCharsInSet(const AValue: string; ACharset: TSysCharSet): string;

function GetUserAppDataDir: string;
function GetShellFolderPath(AFolder: integer): string;
function CheckDirectoryExists(ADirectory: string; ACreate: boolean): boolean;
function ExecuteFile(const Operation, FileName, Params, DefaultDir: string;
  ShowCmd: word): integer;
function ValidateFileName(AFileName: TFileName): TFileName;
function GetFileSize(const AFileName: string): int64;

procedure GetNetworkIPList(AList: TStrings);

function IsFontInstalled(const AFontName: string): boolean;

implementation

uses
  IdStack, Winapi.ShlObj;

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

function GetUserAppDataDir: string;
begin
  Result := IncludeTrailingPathDelimiter
    (IncludeTrailingPathDelimiter(GetShellFolderPath(CSIDL_APPDATA)) +
    Application.Title);
  CheckDirectoryExists(Result, true);
end;

function ExecuteFile(const Operation, FileName, Params, DefaultDir: string;
  ShowCmd: word): integer;
var
  zFileName, zParams, zDir: array [0 .. 255] of char;
begin
  Result := ShellExecute(Application.Handle, PChar(Operation),
    StrPCopy(zFileName, FileName), StrPCopy(zParams, Params),
    StrPCopy(zDir, DefaultDir), ShowCmd);
end;

function StripCharsInSet(const AValue: string; ACharset: TSysCharSet): string;
var
  i: integer;
begin
  for i := 1 to Length(AValue) do
  begin
    if not CharInSet(AValue[i], ACharset) then
      Result := Result + AValue[i];
  end;
end;

function ValidateFileName(AFileName: TFileName): TFileName;
begin
  Result := AFileName;
  Result := StripExtraSpaces(Result, true, true);
  Result := StripCharsInSet(Result, ['\', '/', ':', '*', '?', '"', '<',
    '>', '|']);
end;

function GetFileSize(const AFileName: string): int64;
var
  Handle: THandle;
  FindData: TWin32FindData;
begin
  Handle := FindFirstFile(PChar(AFileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(Handle);
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
    begin
      Int64Rec(Result).Lo := FindData.nFileSizeLow;
      Int64Rec(Result).Hi := FindData.nFileSizeHigh;
      Exit;
    end;
  end;
  Result := -1;
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
        LAddress := StripExtraSpaces(GStack.LocalAddresses[Lidx], true, true);
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
