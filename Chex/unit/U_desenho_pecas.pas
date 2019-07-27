unit U_desenho_pecas;

interface

uses
  System.Classes,System.IOUTils,SysUtils,FMX.Forms;

   type TImagemPeca = class
     function DesignaImagem(NumeroPeca:Integer):String;
   end;

const PP = '\img\PP.png';
const TP = '\img\TP.png';
const CP = '\img\CP.png';
const BP = '\img\BP.png';
const RP = '\img\RP.png';
const DP = '\img\DP.png';

const PB = '\img\PB.png';
const TB = '\img\TB.png';
const CB = '\img\CB.png';
const BB = '\img\BB.png';
const RB = '\img\RB.png';
const DB = '\img\DB.png';

implementation


{ TImagemPeca }

function TImagemPeca.DesignaImagem(NumeroPeca: Integer):String;
begin
 case NumeroPeca of

  //peças pretas
  0,1,2,3,4,5,6,7: result := TDirectory.GetParent(ExtractFileDir(ParamStr(0))) + (PP);

  8,9: result := TDirectory.GetParent(ExtractFileDir(ParamStr(0))) + (TP);

  10,11: result := TDirectory.GetParent(ExtractFileDir(ParamStr(0))) + (CP);

  12,13: result := TDirectory.GetParent(ExtractFileDir(ParamStr(0))) + (BP);

  14: result := TDirectory.GetParent(ExtractFileDir(ParamStr(0))) + (RP);

  15: result := TDirectory.GetParent(ExtractFileDir(ParamStr(0))) + (DP);


  //peças brancas

  16,17,18,19,20,21,22,23: result := TDirectory.GetParent(ExtractFileDir(ParamStr(0))) + (PB);

  24,25: result := TDirectory.GetParent(ExtractFileDir(ParamStr(0))) + (TB);

  26,27: result := TDirectory.GetParent(ExtractFileDir(ParamStr(0))) + (CB);

  28,29: result := TDirectory.GetParent(ExtractFileDir(ParamStr(0))) + (BB);

  30: result := TDirectory.GetParent(ExtractFileDir(ParamStr(0))) + (RB);

  31: result := TDirectory.GetParent(ExtractFileDir(ParamStr(0))) + (DB);


  end;
end;

end.
