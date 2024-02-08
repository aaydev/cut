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

# Получаем информацию о файле
$fileInfo = Get-Item $filename

# Получаем имя файла без расширения
$baseName = [System.IO.Path]::GetFileNameWithoutExtension($filename)

# Проверяем, задано ли новое имя файла
if (![string]::IsNullOrWhiteSpace($newFilename)) {
    $newFilename = $newFilename.Trim()
} else {
    # Создаем новое имя файла с добавлением '_cut'
    $newFilename = $baseName + "_cut" + $fileInfo.Extension
}

if (Test-Path -Path $filename -PathType Leaf) {
} else {
    Write-Host "Файл $filename не существует."
    exit
}

# Открываем исходный файл для чтения в бинарном режиме
$sourceFile = [System.IO.File]::OpenRead($filename)

# Создаем новый файл для записи вырезанной части
$targetFile = [System.IO.File]::OpenWrite($newFilename)

# Перемещаем указатель в нужную позицию
$sourceFile.Position = $startAddress

# Буфер для чтения и записи данных
$buffer = New-Object byte[] 4096
$bytesRead = 0

# Читаем и записываем данные пока не достигнем заданной длины или конец файла
while ($bytesRead -lt $length -and ($sourceFile.Position -lt $fileInfo.Length)) {
    $bytesToRead = [Math]::Min($length - $bytesRead, $buffer.Length)
    $bytesRead = $sourceFile.Read($buffer, 0, $bytesToRead)
    $targetFile.Write($buffer, 0, $bytesRead)
}

# Закрываем файлы
$sourceFile.Close()
$targetFile.Close()

Write-Output "Вырезанная часть сохранена в файле: $newFilename"