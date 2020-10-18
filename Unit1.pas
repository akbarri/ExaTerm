unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellAPI, ExtCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Edit1: TEdit;
    tmr1: TTimer;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure tmr1Timer(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ifile: textfile;
  cmd: string;

implementation

{$R *.dfm}

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
  begin
  assignfile(ifile,'if.sh');
  rewrite(ifile);
  write(ifile, '#!/bin/bash', AnsiChar(#10));
  if Edit1.Text <> '' then
  cmd:=Edit1.Text + ' &> of.log' + AnsiChar(#10)
  else
  cmd:='';
  write(ifile, cmd);
  closefile(ifile);
  Edit1.Text:='';
  shellexecute(0, nil, PChar('if.sh'), nil, nil, SW_SHOWNORMAL);
  end;
end;

procedure TForm1.tmr1Timer(Sender: TObject);
begin
  if FileExists('of.log') then
  try
    Memo1.Lines.LoadFromFile('of.log');
  except
    on EFOpenError do
    ; //swallow this error
  end;
end;

procedure ScrollToLastLine(Memo: TMemo);
begin
  SendMessage(Memo.Handle, EM_LINESCROLL, 0,Memo.Lines.Count);
end;


procedure TForm1.Memo1Change(Sender: TObject);
begin
   ScrollToLastLine(Memo1);
end;

end.
