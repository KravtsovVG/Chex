program ChexServer;

uses
  System.StartUpCopy,
  FMX.Forms,
  u_board in '..\unit\u_board.pas' {Users},
  u_menu_main in '..\unit\u_menu_main.pas' {frm_main},
  u_pecas in '..\unit\u_pecas.pas',
  U_desenho_pecas in '..\unit\U_desenho_pecas.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfrm_main, frm_main);
  Application.Run;
end.
