unit u_board;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  FMX.Forms,
  FMX.Dialogs,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdThreadComponent,
  FMX.StdCtrls,
  System.Math,
  u_pecas,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Objects,
  FMX.Layouts,
  FMX.Controls.Presentation,
  System.Math.Vectors,
  FMX.Controls3D,
  FMX.Layers3D;

type
  Tfrm_client = class(TForm)
    Board: TImage;
    lytPrincipal: TLayout;
    StyleBook1: TStyleBook;
    Button1: TButton;
    procedure ConectarCliente;
    procedure DesconectarCliente;
    procedure MandarMsg;
    procedure FormCreate(Sender: TObject);
    procedure IdTCPClientConnected(Sender: TObject);
    procedure IdThreadComponentRun(Sender: TIdThreadComponent);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
    function  GetNow():String;
    procedure Display(p_sender: String; p_message: string);

  public
    { Public declarations }
    procedure EnviaPosicao;
  end;

var
  frm_client: Tfrm_client;
  // ... TIdTCPClient
  idTCPClient         : TIdTCPClient;
  // ... TIdThreadComponent
  idThreadComponent   : TIdThreadComponent;

  //message
  messageToSend:String;
  msgFromServer : string;

  //Indica se est� segurando ou n�o a pe�a
  Grab: boolean = false;
  Offset: tpointf;
  MovingRectangle: TRectangle;
  Pecas:TPeca;


// ... listening port : GUEST CLIENT
const
  GUEST_PORT = 20010;

implementation

{$R *.fmx}


{ TForm1 }


procedure Tfrm_client.EnviaPosicao;
begin

  IdTCPClient.IOHandler.WriteLn(Pecas.NomePeca+':'+Pecas.PosX+'|'+Pecas.PosY);
end;

procedure Tfrm_client.Button1Click(Sender: TObject);

begin

 // MandarMsg;

  Pecas := TPeca.Create(lytPrincipal);



end;

procedure Tfrm_client.ConectarCliente;
begin
 // ... disable connect button
 //   btn_connect.Enabled := False;

    // ... try to connect to Server
    try
        IdTCPClient.Connect;
    except
        on E: Exception do begin
            Display('CLIENT', 'CONNECTION ERROR! ' + E.Message);
            //btn_connect.Enabled := True;
        end;
    end;
end;

procedure Tfrm_client.DesconectarCliente;
begin
 // ... is connected?
    if IdTCPClient.Connected then begin
        // ... disconnect from Server
        IdTCPClient.Disconnect;

    end;
end;

procedure Tfrm_client.Display(p_sender, p_message: string);
var msg:String;
begin
  TThread.Queue(nil, procedure
                     begin
                         msg := ('[' + p_sender + '] - '
                         + GetNow() + ': ' + p_message);
                     end
               );
end;

procedure Tfrm_client.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   DesconectarCliente;
end;

procedure Tfrm_client.FormCreate(Sender: TObject);
begin
// ... create TIdTCPClient
    idTCPClient                 := TIdTCPClient.Create(Self);

    // ... set properties
    idTCPClient.Host            := '10.0.0.109';
    idTCPClient.Port            := GUEST_PORT;
    // ... etc..

    // ... callback functions
    idTCPClient.OnConnected     := IdTCPClientConnected;
    // ... etc..

    // ... create TIdThreadComponent
    idThreadComponent           := TIdThreadComponent.Create();

    // ... callback functions
    idThreadComponent.OnRun     := IdThreadComponentRun;
    // ... etc..

    ConectarCliente;
end;

function Tfrm_client.GetNow: String;
begin
 Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ': ';
end;

procedure Tfrm_client.IdTCPClientConnected(Sender: TObject);
begin

    // ... after connection is ok, run the Thread ... waiting messages from server
    IdThreadComponent.Active  := True;



end;

procedure Tfrm_client.IdThreadComponentRun(Sender: TIdThreadComponent);

begin
    // ... read message from server
    msgFromServer := IdTCPClient.IOHandler.ReadLn();

    Pecas.MovePiece(msgFromServer);
    lytPrincipal.Repaint;

end;

procedure Tfrm_client.MandarMsg;
begin
 // ... send message to Server
    IdTCPClient.IOHandler.WriteLn('');
    ShowMessage(msgFromServer);
end;

end.
