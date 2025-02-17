unit u_menu_main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  System.Math.Vectors, FMX.Controls3D, FMX.Layers3D, FMX.ListBox, FMX.Objects;

type
  Tfrm_main = class(TForm)
    Layout1: TLayout;
    Layout3D1: TLayout3D;
    StyleBook1: TStyleBook;
    ListBox1: TListBox;
    ListBoxItem2: TListBoxItem;
    Image1: TImage;
    ListBoxItem1: TListBoxItem;
    procedure ListBoxItem2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_main: Tfrm_main;

implementation

{$R *.fmx}

uses u_board;



procedure Tfrm_main.ListBoxItem2Click(Sender: TObject);
var frm_host:TUsers;
begin
  frm_host := TUsers.Create(Self);
  frm_host.ShowModal;
  frm_host.Free;

end;

end.
