object frmReflectorEditor: TfrmReflectorEditor
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Reflector Editor'
  ClientHeight = 455
  ClientWidth = 376
  Color = clWhite
  ParentFont = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object NukePanel2: TPanel
    Left = 0
    Top = 418
    Width = 376
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'NukePanel1'
    ShowCaption = False
    TabOrder = 1
    object BitBtn1: TBitBtn
      AlignWithMargins = True
      Left = 207
      Top = 3
      Width = 80
      Height = 31
      Action = ActionSave
      Align = alRight
      Caption = 'Save'
      TabOrder = 0
      ExplicitLeft = 121
      ExplicitTop = 6
    end
    object BitBtn2: TBitBtn
      AlignWithMargins = True
      Left = 293
      Top = 3
      Width = 80
      Height = 31
      Action = ActionCancel
      Align = alRight
      Caption = 'Cancel'
      TabOrder = 1
    end
  end
  object NukePanel1: TPanel
    Left = 0
    Top = 0
    Width = 376
    Height = 418
    Align = alClient
    BevelOuter = bvNone
    Caption = 'NukePanel1'
    ShowCaption = False
    TabOrder = 0
    object cbEnabled: TCheckBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 370
      Height = 17
      Align = alTop
      Caption = 'Enabled'
      TabOrder = 0
    end
    object radiogroupType: TRadioGroup
      AlignWithMargins = True
      Left = 3
      Top = 74
      Width = 370
      Height = 56
      Align = alTop
      Caption = 'Type'
      Columns = 2
      Items.Strings = (
        'TCP'
        'UDP')
      TabOrder = 2
    end
    object NukeLabelPanel2: TPanel
      Left = 0
      Top = 133
      Width = 376
      Height = 48
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Mapped Host'
      ShowCaption = False
      TabOrder = 3
      object Label2: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 22
        Height = 13
        Align = alTop
        Caption = 'Host'
        Transparent = True
      end
      object editMappedHost: TEdit
        AlignWithMargins = True
        Left = 3
        Top = 19
        Width = 370
        Height = 21
        Align = alTop
        TabOrder = 0
        Text = 'editMappedHost'
      end
    end
    object NukeLabelPanel3: TPanel
      Left = 0
      Top = 229
      Width = 376
      Height = 189
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Bindings'
      ShowCaption = False
      TabOrder = 5
      object ToolBar1: TToolBar
        Left = 0
        Top = 0
        Width = 376
        Height = 39
        ButtonHeight = 30
        ButtonWidth = 31
        Caption = 'ToolBar1'
        Images = dmReflector.ImageListCommon
        TabOrder = 0
        Transparent = True
        object ToolButton1: TToolButton
          Left = 0
          Top = 0
          Action = ActionAddBinding
        end
        object ToolButton2: TToolButton
          Left = 31
          Top = 0
          Width = 10
          Caption = 'ToolButton2'
          ImageIndex = 1
          Style = tbsSeparator
        end
        object ToolButton3: TToolButton
          Left = 41
          Top = 0
          Action = ActionRemoveBinding
        end
      end
      object ListViewBindings: TListView
        AlignWithMargins = True
        Left = 3
        Top = 42
        Width = 370
        Height = 144
        Align = alClient
        Columns = <
          item
            AutoSize = True
            Caption = 'IP'
          end
          item
            AutoSize = True
            Caption = 'Port'
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 1
        ViewStyle = vsReport
      end
    end
    object NukeLabelPanel1: TPanel
      Left = 0
      Top = 181
      Width = 376
      Height = 48
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Mapped Port'
      ShowCaption = False
      TabOrder = 4
      object Label3: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 20
        Height = 13
        Align = alTop
        Caption = 'Port'
        Transparent = True
      end
      object editMappedPort: TEdit
        AlignWithMargins = True
        Left = 3
        Top = 19
        Width = 370
        Height = 21
        Align = alTop
        TabOrder = 0
        Text = 'editMappedPort'
      end
    end
    object NukeLabelPanel4: TPanel
      Left = 0
      Top = 23
      Width = 376
      Height = 48
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Name'
      ShowCaption = False
      TabOrder = 1
      object Label1: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 27
        Height = 13
        Align = alTop
        Caption = 'Name'
        Transparent = True
      end
      object editReflectorName: TEdit
        AlignWithMargins = True
        Left = 3
        Top = 19
        Width = 370
        Height = 21
        Align = alTop
        TabOrder = 0
        Text = 'editReflectorName'
      end
    end
  end
  object ActionList: TActionList
    Images = dmReflector.ImageListCommon
    Left = 64
    Top = 324
    object ActionSave: TAction
      Caption = 'Save'
      ImageIndex = 4
      OnExecute = ActionSaveExecute
    end
    object ActionCancel: TAction
      Caption = 'Cancel'
      ImageIndex = 3
      OnExecute = ActionCancelExecute
    end
    object ActionAddBinding: TAction
      Caption = 'Add'
      ImageIndex = 0
      OnExecute = ActionAddBindingExecute
    end
    object ActionRemoveBinding: TAction
      Caption = 'ActionRemoveBinding'
      ImageIndex = 2
      OnExecute = ActionRemoveBindingExecute
      OnUpdate = ActionRemoveBindingUpdate
    end
  end
end
