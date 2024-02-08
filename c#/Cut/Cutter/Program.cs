using System;
using System.IO;

if (args.Length < 3)
{
    Console.WriteLine("Необходимо передать имя файла, начальный адрес и длину в байтах");
    return;
}
else
{
    string fileName = args[0];
    string startAddress = args[1];
    int length = int.Parse(args[2]);

    string newFileName = "";
    if (args.Length > 3)
    {
        newFileName = args[3];
    }
    else
    {
        newFileName = Path.GetFileNameWithoutExtension(fileName) + "_cut" + Path.GetExtension(fileName);
    }

    try
    {
        using (FileStream inputStream = new(
            fileName, FileMode.Open, FileAccess.Read))
        {
            byte[] buffer = new byte[length];
            inputStream.Seek(long.Parse(startAddress), SeekOrigin.Begin);
            inputStream.Read(buffer, 0, length);

            using FileStream outputStream = new FileStream(newFileName, FileMode.Create);
            outputStream.Write(buffer, 0, length);
        }

        Console.WriteLine("Вырезанная часть файла сохранена в новый файл: " + newFileName);
    }
    catch (Exception ex)
    {
        Console.WriteLine("Ошибка при обработке файла: " + ex.Message);
    }
}
