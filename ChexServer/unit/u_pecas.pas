unit u_pecas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  FMX.Objects, FMX.Layouts, Math,FMX.Dialogs, FMX.StdCtrls,
  FMX.Platform;


type
  TPosicao = record
    X : Single;
    Y : Single;
  end;

type
  TPeca = class
    procedure PieceMouseDown(Sender: TObject;
                             Button: TMouseButton;
                             Shift: TShiftState;
                             X, Y: Single);

    procedure PieceMouseUp  (Sender: TObject;
                             Button: TMouseButton;
                             Shift: TShiftState;
                             X, Y: Single);

    procedure LayoutMouseMove(Sender: TObject;
                              Shift: TShiftState;
                              X, Y: Single);

    function CriarPecas(Layout:TLayout):TRectangle;

    procedure MovePiece(Comand:String);

    function DeterminaPos(NumeroPeca:integer):TPosicao;




  private
    FPosX: String;
    FPosY: String;
    FNomePeca: String;
    FTag: String;
    procedure SetNomePeca(const Value: String);
    procedure SetPosX(const Value: String);
    procedure SetPosY(const Value: String);
    procedure SetTag(const Value: String);
    { Private declarations }
  public
    { Public declarations }
    constructor Create(TGTLayout:TLayout);
    destructor Destroy;

  published

    property PosX:String read FPosX write SetPosX;
    property PosY:String read FPosY write SetPosY;
    property NomePeca:String read FNomePeca write SetNomePeca;
    property Tag:String read FTag write SetTag;

  end;


implementation

uses
  FMX.Types, u_board, U_desenho_pecas, FMX.Graphics;


const
  MAX_RECTANGLES = 1;
  RECT_WIDTH = 50;
  RECT_HEIGHT = 50;

var
  Grab: boolean = false;
  Offset: tpointf;
  MovingRectangle: TRectangle;
  Layout:TLayout;
  List: TStrings;
  pMargin:Single;
{ TPeca }

constructor TPeca.Create(TGTLayout:TLayout);
begin

 Layout := TGTLayout;
 Layout.OnMouseMove := LayoutMouseMove;
 List := TStringList.Create;
 pMargin := 0;
 CriarPecas(Layout);
end;

function TPeca.CriarPecas(Layout:TLayout): TRectangle;
var
  I: integer;
  TitleRect: TRectangle;
  TitleLabel :TLabel;
  Pecas:array [0..31] of TRectangle;
  Imagem:TImagemPeca;

begin

  for I := 0 to 31 do
  begin

    Pecas[I] := TRectangle.Create(nil);
    Pecas[I].Parent := Layout;
    Pecas[I].OnMouseDown := PieceMouseDown;
    Pecas[I].OnMouseUp := PieceMouseUp;
    Pecas[I].Width := RECT_WIDTH;
    Pecas[I].Height := RECT_HEIGHT;
    Pecas[I].Name := 'A'+i.ToString;
    Pecas[I].Tag := i;
    Pecas[I].Stroke.Kind := TBrushKind.None;
    Pecas[I].Position.X := DeterminaPos(i).X;  //random(trunc(Layout.Width - RECT_WIDTH));
    Pecas[I].Position.Y := DeterminaPos(i).Y;  //random(trunc(Layout.Height - RECT_HEIGHT));
    Pecas[i].Fill.Bitmap.WrapMode  := TWrapMode.TileStretch;
    Pecas[i].Fill.Kind := TBrushKind.Bitmap;
    Pecas[i].Fill.Bitmap.Bitmap.LoadFromFile(Imagem.DesignaImagem(i));

    {$REGION 'OPTIONAL'}
//    Pecas[I].fill.Color := random($FFFFFF) or $FF000000;
//    TitleRect := TRectangle.Create(self);
//    TitleRect.fill.Color := Talphacolorrec.White;
//    TitleRect.Position.X := 0;
//    TitleRect.Position.Y := 0;
//    TitleRect.Width := RECT_WIDTH;
//    TitleRect.Height := 16;
//    TitleRect.HitTest := false;
//
    {$ENDREGION}

   TitleLabel := TLabel.Create(nil);
   TitleLabel.StyledSettings:=[];
   TitleLabel.Font.Size:=12;
   TitleLabel.Align := TAlignLayout.VertCenter;
   TitleLabel.Text := Pecas[I].Name;
   TitleLabel.FontColor := TAlphaColors.White;
   Pecas[I].AddObject(TitleLabel);

   Layout.AddObject(Pecas[i]);


    result := Pecas[i];
  end;

end;


destructor TPeca.Destroy;
begin
 List.Free;
end;

function TPeca.DeterminaPos(NumeroPeca: integer): TPosicao;
begin

  case NumeroPeca of
    0,1,3,4,5,6,7
    : begin

      Result.X :=  155 + pMargin;
      Result.Y := 120;
      pMargin := pMargin + 35;

    end;
  end;

  if NumeroPeca = 7 then pMargin := 0;


  case NumeroPeca of
    8,9,10,11,12,13,14
    : begin

      Result.X :=  155 + pMargin;
      Result.Y := 60;
      pMargin := pMargin + 35;

    end;
  end;



end;

procedure TPeca.LayoutMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
 if Grab and (ssleft in Shift) then
  begin
    // keep from dragging off Layout
    if X > (Layout.Width + Offset.X - RECT_WIDTH) then
      X := Layout.Width + Offset.X - RECT_WIDTH;
    if Y > (Layout.Height + Offset.Y - RECT_HEIGHT) then
      Y := Layout.Height + Offset.Y - RECT_HEIGHT;
    if X < Offset.X then
      X := Offset.X;
    if Y < Offset.Y then
      Y := Offset.Y;

    MovingRectangle.Position.X := X - Offset.X;
    MovingRectangle.Position.Y := Y - Offset.Y;


    PosX := FloatToStr(SimpleRoundTo(MovingRectangle.Position.X,-2));
    PosY := FloatToStr(SimpleRoundTo(MovingRectangle.Position.Y,-2));

    Users.EnviaPosicao;


  end;
end;

procedure TPeca.MovePiece(Comand: String);
var Pos:String;oRect:TObject;i:integer;
begin
  List.Clear;
  ExtractStrings([':'], [], PChar(Comand), List);
  if List[0] <> '' then
  begin
    Pos:= List[1];
    ExtractStrings(['|'], [], PChar(Pos), List);
   for i := 0 to Layout.ChildrenCount - 1 do
      if Layout.Children[i] is TRectangle then
         if ((Layout.Children[i] as TRectangle).Name = List[0]) then
         begin
           (Layout.Children[i] as TRectangle).Position.X := StrToInt(List[2]);
           (Layout.Children[i] as TRectangle).Position.Y := StrToInt(List[3]);
          end;
  end;
end;

procedure TPeca.PieceMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin

  MovingRectangle := Sender as TRectangle;
  Offset.X := X;
  Offset.Y := Y;
  Layout.Root.Captured := Layout;// sets mouse capture to Layout1
  MovingRectangle.BringToFront; // optional
  MovingRectangle.Repaint;
  Grab := true;
  NomePeca := MovingRectangle.Name;
  Tag := MovingRectangle.Tag.ToString;

end;

procedure TPeca.PieceMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
 Grab := False;

end;

procedure TPeca.SetNomePeca(const Value: String);
begin
  FNomePeca := Value;
end;

procedure TPeca.SetPosX(const Value: String);
begin
  FPosX := Value;
end;

procedure TPeca.SetPosY(const Value: String);
begin
  FPosY := Value;
end;

procedure TPeca.SetTag(const Value: String);
begin
  FTag := Value;
end;

end.
