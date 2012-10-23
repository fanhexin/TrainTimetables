#include "utility.h"

Utility::Utility()
{
}

void Utility::debug(const char *msg)
{
    FILE *stream = NULL;
    stream = fopen("/home/user/MyDocs/TrainTimetablesErrLog.txt", "a+");
    fprintf(stream, "Error: %s\n", msg);
    fclose(stream);
}

