#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <stdbool.h>
#include <assert.h>
#include <err.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include "mapconverter.h"

int main(int argc, char** argv) {
    
    struct stat st = {0};

    if (stat("/tmp/mapconverter/", &st) == -1) {
	mkdir("/tmp/mapconverter/", 0700);
    }
    
    if (argc < 2) {
	err(1, "Please provide 1 or more files");
    }

    for (size_t i = 1; i < argc; i++) {
	char* file = readBinaryToBuffer(argv[i]);
	size_t fileSize = get_file_size(argv[i]);

	if (file == NULL) {
	    continue;
	}
	
	char* mapData = parse(file);

	size_t splitIndex = (size_t)-1;

	for (size_t j = 0; argv[i][j] != '\0'; j++) {
	    if (argv[i][j] == '/') {
		splitIndex = j;
	    }
	}

	printf("splitIndex: %zu\n", splitIndex);
	
	char* writePath;

	if (splitIndex != (size_t)-1) {
	    writePath = malloc(strlen(argv[i]) - splitIndex + sizeof("/tmp/mapconverter"));
	    strcpy(writePath, "/tmp/mapconverter");

	    char* fileName = malloc(sizeof(argv[i]) - splitIndex);

	    strcpy(fileName, argv[i] + splitIndex);

	    printf("fileName: %s\n", fileName);

	    writePath = strcat(writePath, fileName);

	    free(fileName);
	} else {
	    writePath = malloc(strlen(argv[i]) + sizeof("/tmp/mapconverter/"));
	    strcpy(writePath, "/tmp/mapconverter/");

	    strcat(writePath, argv[i]);
	}

	printf("Write path: %s\n", writePath);

	FILE* outputFile = fopen(writePath, "wb");

	fwrite(mapData, OUTPUTSIZE, 1, outputFile);

	fclose(outputFile);
	free(writePath);
	free(file);
	free(mapData);
    }
    
    
    return 0;
}

char* readBinaryToBuffer(char* filename) {
    size_t fileSize = get_file_size(filename);
    if (fileSize == -1) {
	return NULL;
    }

    char* buffer = malloc(fileSize);
    
    FILE* fptr = fopen(filename, "rb");

    fread(buffer, fileSize, 1, fptr);

    fclose(fptr);

    return buffer;
}

size_t get_file_size(char* filename) {
    FILE *file = fopen(filename, "rb");
    if (file == NULL) {
	perror("Faild to open file");
	return -1;
    }

    fseek(file, 0, SEEK_END);
    size_t fileSize = ftell(file);
    fclose(file);
    return fileSize;
}

char* parse(char* input) {
    char* buffer = malloc(OUTPUTSIZE*sizeof(char));

    size_t readIndex = 0;
    size_t writeIndex = 0;

    while (true) {
	char iterations;

	iterations = input[readIndex];
	readIndex++;
	if (iterations == 0) {
	    break;
	}


	// Writing RLE
	for (char j = 0; j < iterations; j++) {
	    assert(writeIndex >= 1024);
	    buffer[writeIndex] = input[readIndex];
	    writeIndex++;
	}
	
	readIndex++;

	iterations = input[readIndex];
	readIndex++;
	
	// Write immediate
	for (char j = 0; j < iterations; j++) {
	    assert(writeIndex >= 1024);
	    buffer[writeIndex] = input[readIndex];
	    writeIndex++;
	    readIndex++;
	}
	
    }


    return buffer;
}
