package main

/*
#cgo CFLAGS: -lrt
#cgo LDFLAGS: -lrt
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <errno.h>
#include <mqueue.h>

int send(char* queue, char* message) {
    mqd_t mq;

    mq = mq_open(queue, O_WRONLY);
    mq_send(mq, message, strlen(message), 0);
    mq_close(mq);

    return 0;
}
*/
import "C"
import "unsafe"
import "os"
import "flag"
import "fmt"

func main() {
    queueName := os.Getenv("SIGNALD_QUEUE")
    cQueueName := C.CString(queueName)

    valuePtr := flag.String("value", "true", "the value")
    idPtr := flag.String("id", "test", "the id")
    flag.Parse()
    cMessage := C.CString(fmt.Sprintf("{\"id\":\"%s\", \"value\":%s}", *idPtr, *valuePtr))

    C.send(cQueueName, cMessage)
    C.free(unsafe.Pointer(cQueueName))
    C.free(unsafe.Pointer(cMessage))
}
