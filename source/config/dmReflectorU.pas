unit dmReflectorU;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, Vcl.ImgList, Vcl.Controls;

type
  TdmReflector = class(TDataModule)
    ImageListCommon: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmReflector: TdmReflector;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
