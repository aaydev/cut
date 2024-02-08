param (
    [Parameter(Mandatory=$true, Position=0)]
    [string]$filename,
    [Parameter(Mandatory=$true, Position=1)]
    [string]$startAddress,
    [Parameter(Mandatory=$true, Position=2)]
    [int]$length,
    [string]$newFilename
)

$startAddress = [int]$startAddress

# �������� ���������� � �����
$fileInfo = Get-Item $filename

# �������� ��� ����� ��� ����������
$baseName = [System.IO.Path]::GetFileNameWithoutExtension($filename)

# ���������, ������ �� ����� ��� �����
if (![string]::IsNullOrWhiteSpace($newFilename)) {
    $newFilename = $newFilename.Trim()
} else {
    # ������� ����� ��� ����� � ����������� '_cut'
    $newFilename = $baseName + "_cut" + $fileInfo.Extension
}

if (Test-Path -Path $filename -PathType Leaf) {
} else {
    Write-Host "���� $filename �� ����������."
    exit
}

# ��������� �������� ���� ��� ������ � �������� ������
$sourceFile = [System.IO.File]::OpenRead($filename)

# ������� ����� ���� ��� ������ ���������� �����
$targetFile = [System.IO.File]::OpenWrite($newFilename)

# ���������� ��������� � ������ �������
$sourceFile.Position = $startAddress

# ����� ��� ������ � ������ ������
$buffer = New-Object byte[] 4096
$bytesRead = 0

# ������ � ���������� ������ ���� �� ��������� �������� ����� ��� ����� �����
while ($bytesRead -lt $length -and ($sourceFile.Position -lt $fileInfo.Length)) {
    $bytesToRead = [Math]::Min($length - $bytesRead, $buffer.Length)
    $bytesRead = $sourceFile.Read($buffer, 0, $bytesToRead)
    $targetFile.Write($buffer, 0, $bytesRead)
}

# ��������� �����
$sourceFile.Close()
$targetFile.Close()

Write-Output "���������� ����� ��������� � �����: $newFilename"