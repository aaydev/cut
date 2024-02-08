#include <iostream>
#include <fstream>
#include <string>

int main(int argc, char** argv) {
    if (argc < 4) {
        std::cout << "Not enough arguments. Usage example: cut.exe <file_name> <starting_address> <length_in_bytes> [<new_file_name>]\n";
        return 1;
    }

    std::string originalFileName = argv[1];
    std::string newFileName = (argc >= 5) ? argv[4] : originalFileName + "_cut";
    std::ifstream originalFile(originalFileName, std::ios::binary);
    std::ofstream newFile(newFileName, std::ios::binary | std::ios::trunc);
    if (!originalFile.is_open()) {
        std::cout << "Could not open source file.\n";
        return 1;
    }
    if (!newFile.is_open()) {
        std::cout << "Failed to create new file.\n";
        return 1;
    }

    unsigned int startAddress = std::stoi(argv[2]);
    unsigned int length = std::stoi(argv[3]);
    char* buffer = new char[length];
    
    originalFile.seekg(startAddress, std::ios::beg);
    originalFile.read(buffer, length);
    newFile.write(buffer, length);

    delete[] buffer;
    originalFile.close();
    newFile.close();

    std::cout << "The file was successfully cut and saved to a new file \"" << newFileName << "\".\n";

    return 0;
}
