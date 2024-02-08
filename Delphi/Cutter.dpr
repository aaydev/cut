program Cutter;

{$APPTYPE CONSOLE}

uses
  System.Classes,
  System.SysUtils;

procedure CutFile(const FileName: string; StartAddress, LengthBytes: Integer; const NewFileName: string = '');
var
  OriginalFile, CutFile: TFileStream;
  Buffer: array of Byte;
  ActualLength: Integer;
  CutFileName: string;
begin
  OriginalFile := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    // ��������� ������������ �������� ����������
    if (StartAddress < 0) or (StartAddress >= OriginalFile.Size) then
    begin
      Writeln('Error: invalid starting address');
      Exit;
    end;

    if (LengthBytes <= 0) or (StartAddress + LengthBytes > OriginalFile.Size) then
    begin
      Writeln('Error: incorrect length');
      Exit;
    end;

    // ��������� ����������� ����� (����� ���� ������, ���� ��������� ����� �����)
    ActualLength := OriginalFile.Size - StartAddress;
    if ActualLength > LengthBytes then
      ActualLength := LengthBytes;

    // ������� ���������� ��� ��� ��������� �����, ���� �� ������
    if NewFileName = '' then
    begin
      CutFileName := ChangeFileExt(FileName, '') + '_cut' + ExtractFileExt(FileName);
    end
    else
    begin
      CutFileName := NewFileName;
    end;

    // ������� � ���������� � �������� ����
    CutFile := TFileStream.Create(CutFileName, fmCreate);
    try
      SetLength(Buffer, ActualLength);
      OriginalFile.Seek(StartAddress, soFromBeginning);
      OriginalFile.ReadBuffer(Buffer[0], ActualLength);
      CutFile.WriteBuffer(Buffer[0], ActualLength);
    finally
      CutFile.Free;
    end;
  finally
    OriginalFile.Free;
  end;

  Writeln('The file was successfully cut and saved to a new file: ' + CutFileName);
end;

var
  FileName, NewFileName: string;
  StartAddress, LengthBytes: Integer;
begin
  try
    // ��������� ��������� ���������
    if ParamCount < 3 then
    begin
      Writeln('Not enough arguments. Usage example: cut.exe <file_name> <starting_address> <length_in_bytes> [<new_file_name>]');
      Exit;
    end;

    FileName := ParamStr(1);
    StartAddress := StrToIntDef(ParamStr(2), -1);
    LengthBytes := StrToIntDef(ParamStr(3), -1);

    if ParamCount > 3 then
      NewFileName := ParamStr(4)
    else
      NewFileName := '';

    // �������� ������� ��������� �����
    CutFile(FileName, StartAddress, LengthBytes, NewFileName);
  except
    on E: Exception do
      Writeln('Error: ' + E.Message);
  end;
end.

