object Form1: TForm1
  Left = 205
  Top = 123
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'A Star'
  ClientHeight = 601
  ClientWidth = 818
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -6
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    000000000000000000000000000000000000000000000000000000000000000F
    FFFFFFFFFFFFFFFFFFFFFFFFF00000FFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF
    FFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF
    FFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFF11111FF111FFFFFFFFFFF0000FF
    FFFF9999911999FFFFFFFFFFFF0000FFFFF99999999991FFFFFFFFFFFF0000FF
    FF9999FFF99991FFFFFFFFFFFF0000FFFF9991FFFF9991FFFFFFFFFFFF0000FF
    FF9991111F9991FFFFFFFFFFFF0000FFFFF99999119991FFFFFFFFFFFF0000FF
    FFFF9999999991FFFFFFFFFFFF0000FFFFFFFFF9999991FFFFFFFFFFFF0000FF
    FFF111FFFF9991FFF1FF1FFFFF0000FFFF99911FFF9991FF91F911FFFF0000FF
    FFF9991119999FF991F99FFFFF0000FFFFF999999999FFFF99991FFFFF0000FF
    FFFFF999999FFFF11999111FFF0000FFFFFFFFFFFFFFFF999999991FFF0000FF
    FFFFFFFFFFFFFF99F99199FFFF0000FFFFFFFFFFFFFFFFFFF991FFFFFF0000FF
    FFFFFFFFFFFFFFFFF99FFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF
    FFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF
    FFFFFFFFFFFFFFFFFFFFFFFFFF00000FFFFFFFFFFFFFFFFFFFFFFFFFF0000000
    000000000000000000000000000000000000000000000000000000000000C000
    0003800000010000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000080000001C0000003}
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Label3: TLabel
    Left = 600
    Top = 56
    Width = 71
    Height = 16
    Caption = 'Square size'
  end
  object Label5: TLabel
    Left = 600
    Top = 8
    Width = 84
    Height = 16
    Caption = 'Indication size'
  end
  object Label6: TLabel
    Left = 600
    Top = 192
    Width = 84
    Height = 16
    Caption = 'Calculate time'
  end
  object Label7: TLabel
    Left = 600
    Top = 104
    Width = 78
    Height = 16
    Caption = 'Wall number '
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 585
    Height = 585
    BevelOuter = bvLowered
    TabOrder = 0
    object Image: TImage
      Left = 1
      Top = 1
      Width = 583
      Height = 583
      Cursor = crHandPoint
      Align = alClient
      OnMouseDown = ImageMouseDown
      OnMouseMove = ImageMouseMove
      OnMouseUp = ImageMouseUp
    end
    object Label4: TLabel
      Left = 16
      Top = 40
      Width = 59
      Height = 16
      Caption = 'Carry size'
      Visible = False
    end
  end
  object GroupBox1: TGroupBox
    Left = 599
    Top = 408
    Width = 210
    Height = 129
    Caption = ' Points '
    TabOrder = 1
    object RadioButton1: TRadioButton
      Left = 16
      Top = 24
      Width = 133
      Height = 17
      Caption = 'Destination point'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 16
      Top = 48
      Width = 133
      Height = 17
      Caption = 'Start point'
      TabOrder = 1
    end
    object RadioButton3: TRadioButton
      Left = 16
      Top = 96
      Width = 89
      Height = 17
      Caption = 'Draw wall'
      TabOrder = 2
    end
    object RadioButton4: TRadioButton
      Left = 16
      Top = 72
      Width = 97
      Height = 17
      Caption = 'Clear wall'
      TabOrder = 3
    end
  end
  object GroupBox3: TGroupBox
    Left = 600
    Top = 544
    Width = 209
    Height = 49
    Caption = ' Distance '
    Color = clBtnFace
    ParentColor = False
    TabOrder = 2
    object Label1: TLabel
      Left = 106
      Top = 22
      Width = 3
      Height = 16
    end
    object Label2: TLabel
      Left = 10
      Top = 22
      Width = 86
      Height = 16
      Caption = 'Founded path:'
    end
  end
  object Panel2: TPanel
    Left = 599
    Top = 248
    Width = 210
    Height = 153
    BevelOuter = bvLowered
    TabOrder = 3
    object RadioButton5: TRadioButton
      Left = 14
      Top = 12
      Width = 139
      Height = 21
      Caption = 'A*'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton6: TRadioButton
      Left = 14
      Top = 33
      Width = 139
      Height = 21
      Caption = 'A* affine'
      TabOrder = 1
    end
    object RadioButton7: TRadioButton
      Left = 14
      Top = 55
      Width = 139
      Height = 21
      Caption = 'A* et A* affine'
      TabOrder = 2
    end
    object CheckBox1: TCheckBox
      Left = 14
      Top = 76
      Width = 139
      Height = 21
      Caption = 'Deplacement'
      TabOrder = 3
    end
    object CheckBox2: TCheckBox
      Left = 14
      Top = 98
      Width = 119
      Height = 21
      Caption = 'Afficher fleches'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 4
    end
    object CheckBox3: TCheckBox
      Left = 14
      Top = 119
      Width = 119
      Height = 21
      Caption = 'Afficher Coup'
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
  end
  object Edit4: TEdit
    Left = 599
    Top = 216
    Width = 210
    Height = 24
    TabOrder = 4
  end
  object ScrollBar2: TScrollBar
    Left = 600
    Top = 32
    Width = 153
    Height = 17
    Max = 50
    Min = 3
    PageSize = 0
    Position = 25
    TabOrder = 5
    OnChange = ScrollBar2Change
  end
  object ScrollBar3: TScrollBar
    Left = 24
    Top = 72
    Width = 153
    Height = 17
    LargeChange = 5
    Max = 50
    Min = 5
    PageSize = 0
    Position = 25
    TabOrder = 6
    Visible = False
    OnChange = ScrollBar3Change
  end
  object ScrollBar4: TScrollBar
    Left = 601
    Top = 81
    Width = 152
    Height = 16
    LargeChange = 5
    Max = 150
    Min = 10
    PageSize = 0
    Position = 20
    TabOrder = 7
    OnChange = ScrollBar4Change
  end
  object Edit1: TEdit
    Left = 760
    Top = 22
    Width = 49
    Height = 24
    TabOrder = 8
    Text = '25'
  end
  object Edit2: TEdit
    Left = 184
    Top = 72
    Width = 41
    Height = 24
    TabOrder = 9
    Text = '25'
    Visible = False
  end
  object Edit3: TEdit
    Left = 760
    Top = 72
    Width = 49
    Height = 24
    ReadOnly = True
    TabOrder = 10
    Text = '20'
  end
  object Button1: TButton
    Left = 599
    Top = 152
    Width = 82
    Height = 25
    Caption = 'Generate'
    TabOrder = 11
    OnClick = Button1Click
  end
  object ScrollBar1: TScrollBar
    Left = 599
    Top = 128
    Width = 154
    Height = 17
    Min = 1
    PageSize = 0
    Position = 1
    TabOrder = 12
    OnChange = ScrollBar1Change
  end
  object Edit5: TEdit
    Left = 760
    Top = 120
    Width = 49
    Height = 24
    TabOrder = 13
    Text = '1'
  end
  object Button2: TButton
    Left = 728
    Top = 152
    Width = 81
    Height = 25
    Caption = 'Clear'
    TabOrder = 14
    OnClick = Button2Click
  end
  object XPManifest1: TXPManifest
    Left = 408
    Top = 296
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 320
    Top = 200
  end
end
