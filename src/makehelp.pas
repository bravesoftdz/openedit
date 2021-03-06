Program MakeHelp;
Uses Utilpack;
Const
 Hdr: String[32]=#13#10'Open!EDIT Setup Help File'#13#10#13#10#26;
 HelpStr: Array[0..13,1..10] Of String[80] =
           (
{00}        ('Up/Dn/PgUp/PgDn/Home/End = Move  Space = Toggle  L/N/E/G = Global Toggles',
             'Should all local areas be turned on (Y) or turned off (N)?',
             'Should all netmail areas be turned on (Y) or turned off (N)?',
             'Should all echomail areas be turned on (Y) or turned off (N)?',
             'Should all areas in the group be turned on (Y) or turned off (N)?',
             'Are you using RemoteAccess v2.50?',
             'OESetup must be reloaded for registration changes to be made.  OK?',
             'Left column = Text the user types   Right column = Text it changes to',
             'Use the arrow keys to choose an item, press ENTER to change it.',
             'Use the arrow keys to choose a color, press ENTER when done.'),
{01}        ('Should Open!EDIT swap to EMS on Alt+J or Alt+Fx?',
             'Should Open!EDIT swap to XMS on Alt+J or Alt+Fx?',
             'Should Open!EDIT swap to disk on Alt+J or Alt+Fx?',
             'In what order should Open!EDIT attempt to swap?',
             'Should messages be stored every 2 mins to avoid loss (in case of crash, etc.)',
             'The 8-character filename (default extension is .LNG) of the language file.',
             'Permit users to use High ASCII in signatures? (HighBit filter has precedence)',
             'At what column should text be automatically wrapped down to the next line?',
             '',
             ''),
{02}        ('Warn user if this percent of text is quoted.',
             'Should user be forced to remove quoting if there is too much?',
             'Which key should open the quote window? Ctl+W or Ctl+Q?',
             'How many lines long should the quote window be?',
             'The first 15 chars of your " * In a message originally to x, x said" string.',
             '',
             '',
             '',
             '',
             ''),
{03}        ('What is the minimum security required to import files into the editor?',
             'What is the minimum security required to export files from the editor?',
             'What is the minimum security required to add words to the dictionary?',
             '',
             '',
             '',
             '',
             '',
             '',
             ''),
{04}        ('What tearline should be appended to the Open!EDIT message, if any?',
             'What BBS software are you using?',
             'What is the path to your BBS files? (Concord/RA users)',
             '[ **OPTION DISABLED** ] What is your registration UEC?',
             'Your name, exactly as entered in your BBS program''s configuration.',
             'Maximum number of lines of text the user is allowed to write.',
             'When the user reaches the end of the page, scroll how many lines?',
             'After how many seconds should Open!EDIT disconnect the user for inactivity?',
             'Should pressing ^] followed by an ASCII char allow users to enter low ASCII?',
             'How should the date/time be displayed in the header?'),
{05}        ('What is the name of your BBS?',
             'What username should be used during local logons?',
             'What city & province/state are you living in?',
             'What security level should a user logged in locally receive?',
             'How much time should a user logged in locally receive?',
             '',
             '',
             '',
             '',
             ''),
{06}        ('Miscellaneous configuration items.',
             'Defaults for when Open!EDIT is invoked with the -L parameter.',
             'Quoting Configuration.',
             'Swapping on DOS Shells & function key macros.',
             'Alt+Fx Key Macros.',
             'Security levels required for certain Open!EDIT features.',
             '',
             '',
             '',
             ''),
{07}        ('Should users be allowed to append taglines to their messages?',
             'Should users be permitted to use phrase expansions?',
             'Should users be permitted to use Open!EDIT''s signature feature?',
             'Should users be permitted to search for keywords in taglines?',
             'Should messages be censored prior to saving?',
             'Should messages have all high ASCII (characters 128-255) filtered out?',
             '',
             '',
             '',
             ''),
{08}        ('Path to plain text file containing taglines.',
{             'Should taglines be censored in the same manner as message text?',}
             'How many taglines should the user be able to choose from on-screen?',
             'Should messages be spellchecked prior to saving? (Yes/No/Ask user)',
             'Path to main dictionary (SE_DIC.*) and personal user dictionaries.',
             'Minimum security required to add words to the dictionary.',
             '',
             '',
             '',
             '',
             ''),
{09}        ('What character should be used to "blot" out inappropriate text?',
             'Should symbols (!@#$%*) be used randomly to "blot" out inappropriate text?',
             'Should only the vowels of the inappropriate text be censored out? (i.e. d*mn)',
             '',
             '',
             '',
             '',
             '',
             '',
             ''),
{10}        ('Press the symbol you would like to use as an "overstrike" character.',
             'Inappropriate text which will be censored by Open!EDIT.',
             'Should Open!EDIT try to detect as many configuration items as possible?',
             'Should Open!EDIT be installed into RA Config as your default message editor?',
             'Please proceed with configuring Open!EDIT.',
             'Modify the commandline if necessary, then press Enter.',
             '',
             '',
             '',
             ''),
{11}        ('Configure message censoring.',
             'Configure phrase expansions.',
             'Configure censor overstriking.',
             'User configuration editor.',
             '',
             '',
             '',
             '',
             '',
             ''),
{12}        ('General configuration options.',
             'Toggle features on or off.',
             'Change Open!EDIT''s default colors.',
             'Configure taglines and the spellchecker.',
             'Configure other miscellaneous features.',
             '',
             '',
             '',
             '',
             'Choose a color scheme to reset to (Default = Cool Blue)'),
{13}        ('Type the name of the desired user or press [ENTER] for a list.',
             'Up/Dn = Move  Ins = Add  Del = Remove  Enter = Edit  Esc = Exit',
             '',
             '',
             '',
             '',
             '',
             '',
             '',
             '')
           );
Type
 HelpRec = Record
   Topic: String[15];
   DataPtr: LongInt;
   DataLines: LongInt;
  End;
Var
 Produced,
 Adjust: LongInt;
 T: Text;
 S: String;
 TempFile,
 HelpFile: File;
 HRFile: File Of HelpRec;
 Help: HelpRec;
 NR: Word;
 TextBuf: Array[1..255] Of String[127];
 SpcCnt,
 SpcPos,
 Cnt,
 Lines: Word;
 Working: Boolean;
 HMain,HSub: Byte;
Begin
 Working:=False;
 Assign(T,'HELP.MAK');
 Reset(T);
 Assign(HRFile,'$$$.$$1');
 ReWrite(HRFile);
 Assign(HelpFile,'$$$.$$2');
 ReWrite(HelpFile,1);
 Produced:=0;
 Lines:=0;
 While Not Eof(T) Do
  Begin
   ReadLn(T,S);
   If S[1]='.' Then
    Begin
     If Working Then
      Begin
       Help.DataLines:=Lines;
       Inc(Produced);
       Write(HRFile,Help);
       For Cnt:=1 To Lines Do
        BlockWrite(HelpFile,TextBuf[Cnt],Ord(TextBuf[Cnt][0])+1);
       FillChar(Help,SizeOf(Help),#0);
       Lines:=0;
      End Else Working:=True;
     Help.Topic:=Copy(S,2,255);
     Help.DataPtr:=FileSize(HelpFile);
    End
    Else
    Begin
     While Pos('      ',S)>0 Do
      Begin
       SpcCnt:=0;
       SpcPos:=Pos('      ',S);
       While S[SpcPos]=' ' Do
        Begin
         Delete(S,SpcPos,1);
         Inc(SpcCnt);
        End;
       Insert('^\S'+LeadingZero(SpcCnt),S,SpcPos);
      End;
     Inc(Lines);
     TextBuf[Lines]:=S;
    End;
  End;
 Adjust:=FileSize(HRFile)*SizeOf(HelpRec);
 Close(HelpFile);
 Seek(HRFile,0);
 While Not Eof(HRFile) Do
  Begin
   Read(HRFile,Help);
   Help.DataPtr:=Help.DataPtr+Adjust;
   Seek(HRFile,FilePos(HRFile)-1);
   Write(HRFile,Help);
  End;
 Close(HRFile);
 Close(T);
 Assign(TempFile,'OESetup.HLP');
 ReWrite(TempFile,1);
 BlockWrite(TempFile,Hdr,SizeOf(Hdr));
 BlockWrite(TempFile,Produced,SizeOf(Produced));
 Assign(HelpFile,'$$$.$$1');
 Reset(HelpFile,1);
 Repeat
  BlockRead(HelpFile,TextBuf,Sizeof(TextBuf),NR);
  BlockWrite(TempFile,TextBuf,NR);
 Until NR=0;
 Close(HelpFile);
 Erase(HelpFile);
 Assign(HelpFile,'$$$.$$2');
 Reset(HelpFile,1);
 Repeat
  BlockRead(HelpFile,TextBuf,Sizeof(TextBuf),NR);
  BlockWrite(TempFile,TextBuf,NR);
 Until NR=0;
 Close(HelpFile);
 Erase(HelpFile);
 For HMain:=0 To 13 Do
  For HSub:=1 To 10 Do
   BlockWrite(TempFile,HelpStr[HMain,HSub],81);
 Close(TempFile);
End.
