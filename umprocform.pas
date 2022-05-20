unit umprocform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)

    procedure bclick(Sender:TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  btn:array of TButton;
  l_turn:TLabel;
  gfield:array of integer; //0 - [], 1 - X, 2  - O
  turn:integer=1;



implementation

{$R *.lfm}

{ TForm1 }

function  getplayersymbol(plr:integer):string; forward;
procedure updatefield; forward;

procedure resetgame;
var i:integer;
begin
  for i:=0 to length(gfield)-1 do gfield[i]:=0;
    turn:=1; updatefield;
end;

procedure getfieldcords(cl,fw:integer;var x,y:integer);
var k,r:integer;
begin
  k:=0; r:=cl;
  while (r>0) do
  begin
    r:=r-fw;
    inc(k);
  end;
  x:=r+fw;
  y:=k;
end;

function fldidbycoords(x,y,w:integer):integer;
begin
  result:=y*w+x;
end;

procedure checkvictory;
var winner:integer; cp:integer;
    winline,fw,i,j,t,s,cr,pr:integer;
    isgood:boolean;
    havewinner:integer=0;
begin

  isgood:=false;

  winner:=0;
  fw:=round(Sqrt(length(gfield)));
  winline:=3;
  if (fw=4) then winline:=4;
  if (fw>4) then winline:=5;

    {if ((gfield[0]=gfield[1]) and (gfield[1]=gfield[2]) and (gfield[0]<>0) and (gfield[0]=cp)) or
       ((gfield[3]=gfield[4]) and (gfield[4]=gfield[5]) and (gfield[3]<>0) and (gfield[3]=cp)) or
       ((gfield[6]=gfield[7]) and (gfield[7]=gfield[8]) and (gfield[6]<>0) and (gfield[6]=cp)) or
       ((gfield[0]=gfield[3]) and (gfield[3]=gfield[6]) and (gfield[0]<>0) and (gfield[0]=cp)) or
       ((gfield[1]=gfield[4]) and (gfield[4]=gfield[7]) and (gfield[1]<>0) and (gfield[1]=cp)) or
       ((gfield[2]=gfield[5]) and (gfield[5]=gfield[8]) and (gfield[2]<>0) and (gfield[2]=cp)) or
       ((gfield[0]=gfield[4]) and (gfield[4]=gfield[8]) and (gfield[0]<>0) and (gfield[0]=cp)) or
       ((gfield[2]=gfield[4]) and (gfield[4]=gfield[6]) and (gfield[2]<>0) and (gfield[2]=cp)) then}

       //read horyzontal lines
       for j:=0 to (fw-1) do
       begin

         //ShowMessage('j='+inttostr(j));

         isgood:=false;

         for i:=0 to (fw-winline) do
         begin

           //ShowMessage('i='+inttostr(fldidbycoords(i,j,fw)));

           isgood:=true;
           cr:=gfield[fldidbycoords(i,j,fw)];
           pr:=cr;

           for t:=1 to (winline-1) do
           begin
             //ShowMessage('i+t='+inttostr(fldidbycoords(i+t,j,fw)));
             cr:=gfield[fldidbycoords(i+t,j,fw)];
             if (cr<>pr) then isgood:=false;
             pr:=cr;
           end;

           if (isgood) then
           begin
             havewinner:=gfield[fldidbycoords(i,j,fw)];
             if (havewinner<>0) then break;
           end;

         end;
         if (isgood) then break;
       end;

       //read vertical lines
       if (havewinner=0) then
       begin

       for i:=0 to (fw-1) do
       begin

         //ShowMessage('j='+inttostr(j));

         isgood:=false;

         for j:=0 to (fw-winline) do
         begin

           //ShowMessage('i='+inttostr(fldidbycoords(i,j,fw)));

           isgood:=true;
           cr:=gfield[fldidbycoords(i,j,fw)];
           pr:=cr;

           for t:=1 to (winline-1) do
           begin
             //ShowMessage('i+t='+inttostr(fldidbycoords(i+t,j,fw)));
             cr:=gfield[fldidbycoords(i,j+t,fw)];
             if (cr<>pr) then isgood:=false;
             pr:=cr;
           end;

           if (isgood) then
           begin
             havewinner:=gfield[fldidbycoords(i,j,fw)];
             if (havewinner<>0) then break;
           end;

         end;
         if (isgood) then break;
       end;

       end;

       //read diagonal lines straight
       if (havewinner=0) then
       begin

       for j:=0 to (fw-winline) do
       begin

         //ShowMessage('j='+inttostr(j));

         isgood:=false;

         for i:=0 to (fw-winline) do
         begin

           //ShowMessage('i='+inttostr(fldidbycoords(i,j,fw)));

           isgood:=true;
           cr:=gfield[fldidbycoords(i,j,fw)];
           pr:=cr;

           for t:=1 to (winline-1) do
           begin
             //ShowMessage('i+t='+inttostr(fldidbycoords(i+t,j,fw)));
             cr:=gfield[fldidbycoords(i+t,j+t,fw)];
             if (cr<>pr) and (cr<>0) then isgood:=false;
             pr:=cr;
           end;

           if (isgood) then
           begin
             havewinner:=cr;
             if (havewinner<>0) then break;
           end;

         end;
         if (isgood) then break;
       end;

       end;

       //read diagonal lines reverse
       if (havewinner=0) then
       begin

       for j:=0 to (fw-winline) do
       begin

         //ShowMessage('j='+inttostr(j));

         isgood:=false;

         for i:=fw-1 downto winline-1 do
         begin

           //ShowMessage('i='+inttostr(fldidbycoords(i,j,fw)));

           isgood:=true;
           cr:=gfield[fldidbycoords(i,j,fw)];
           pr:=cr;

           for t:=1 to (winline-1) do
           begin
             //ShowMessage('i+t='+inttostr(fldidbycoords(i+t,j,fw)));
             cr:=gfield[fldidbycoords(i-t,j+t,fw)];
             if (cr<>pr) then isgood:=false;
             pr:=cr;
           end;

           if (isgood) then
           begin
             havewinner:=gfield[fldidbycoords(i,j,fw)];
             if (havewinner<>0) then break;
           end;

         end;
         if (isgood) then break;
       end;

       end;


  if (havewinner>0) then
  begin
    winner:=havewinner;
    turn:=0;
    ShowMessage('Victory for '+getplayersymbol(winner)+'!');
  end;

end;

function  getplayersymbol(plr:integer):string;
begin
  if plr=0 then result:='[ ]';
  if plr=1 then result:='[X]';
  if plr=2 then result:='[O]';
end;


procedure updatefield;
var i:integer;
begin
  for i:=0 to length(btn)-1 do
  btn[i].Caption:=getplayersymbol(gfield[i]);
  l_turn.Caption:='Current turn: '+getplayersymbol(turn);
end;

procedure tform1.bclick(Sender:TObject);
var i,nb:integer;
begin
  if turn<>0 then
  begin
    nb:=-1;
    for i:=0 to Length(btn)-1 do
    begin
      if sender=btn[i] then nb:=i;
    end;
    if nb<>-1 then
    if gfield[nb]=0 then
    begin
     gfield[nb]:=turn;
     inc(turn); if turn>2 then turn:=1;
     updatefield;
     checkvictory;
    end;
  end
  else
  begin
    resetgame;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var i,j,k,l:integer;
begin
  k:=0;
  setlength(btn,16);
  SetLength(gfield, 16);
  l:=round(sqrt(length(btn)));
  form1.width:=10+l*100+10*l;
  form1.height:=10+l*100+10*l+20;
  for j:=0 to l-1 do
  for i:=0 to l-1 do
  begin
    btn[k]:=TButton.Create(Self);
    with btn[k] do
    begin
      Width:=100;
      Height:=100;
      Left:=10+i*100+10*i;
      Top:= 10+j*100+10*j;
      OnClick:=@bclick;
      Parent:=Form1;
    end;
    inc(k);
  end;
  l_turn:=TLabel.Create(Self);
  with l_turn do
  begin
    Top:=form1.Height-15;
    Left:=10;
    Caption:='Current turn: [X]';
    Parent:=Form1;
  end;
  resetgame;
  updatefield;
end;

end.

