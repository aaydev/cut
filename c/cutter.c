#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void cutFile(char* filename, int startAddr, int length, char* newFilename) {
    // Открытие исходного файла для чтения
    FILE* source = fopen(filename, "rb");
    if (source == NULL) {
        printf("Failed to open file %s", filename);
        return;
    }

    // Определение имени нового файла
    char* outputFilename = NULL;
    if (newFilename == NULL) {
        // Имя нового файла не задано, создаем имя добавлением '_cut' к имени исходного файла
        char* suffix = "_cut";
        outputFilename = malloc(strlen(filename) + strlen(suffix) + 1); // +1 для завершающего нулевого символа
        strcpy(outputFilename, filename);
        strcat(outputFilename, suffix);
    } else {
        // Имя нового файла задано, создаем его копию
        outputFilename = malloc(strlen(newFilename) + 1); // +1 для завершающего нулевого символа
        strcpy(outputFilename, newFilename);
    }

    // Открытие нового файла для записи
    FILE* destination = fopen(outputFilename, "wb");
    if (destination == NULL) {
        printf("Failed to create file %s", outputFilename);
        free(outputFilename);
        fclose(source);
        return;
    }

    // Выделение памяти для буфера чтения
    char* buffer = malloc(length);

    // Установка указателя чтения в исходном файле
    fseek(source, startAddr, SEEK_SET);

    // Чтение и запись данных в новый файл
    fread(buffer, 1, length, source);
    fwrite(buffer, 1, length, destination);

    // Освобождение ресурсов
    free(buffer);
    free(outputFilename);
    fclose(source);
    fclose(destination);

    printf("Part of the file has been cut out %s from the address %d length %d byte(s) and saved to file %s", filename, startAddr, length, outputFilename);
}

int main(int argc, char* argv[]) {
    if (argc < 4 || argc > 5) {
        printf("Wrong number of arguments.\n");
        printf("Usage: program <file_name> <starting_address> <length_in_bytes> [<new_file_name>]\n");
        return 1;
    }

    char* filename = argv[1];
    int startAddr = atoi(argv[2]);
    int length = atoi(argv[3]);
    char* newFilename = NULL;

    if (argc == 5) {
        newFilename = argv[4];
    }

    cutFile(filename, startAddr, length, newFilename);

    return 0;
}
