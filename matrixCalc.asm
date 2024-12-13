INCLUDE Irvine32.inc

mInputMatrix MACRO matrix
    mPrintString msgInputMatrix
    MOV ecx,1
    MOV ebx,0
    .while ecx<=LENGTHOF matrix
        mPrintString msgElementPromptL
        MOV eax,ecx
        CALL WriteDec
        mPrintString msgElementPromptR
        CALL ReadInt
        MOV [matrix+ebx],eax
        ADD ebx,TYPE matrix
        INC ecx
    .endw
ENDM

mPrintMatrix MACRO matrix
    MOV esi,OFFSET matrix
    MOV  ecx,1
    MOV ebx,0
    .while ecx<=rows
    PUSH ecx
    mov ecx,1
        .while ecx<=cols
            MOV  eax,[matrix+ebx]
            CALL WriteInt
            MOV edx,OFFSET space
            CALL WriteString
            ADD ebx,TYPE matrix
            INC ecx
            .endw
        POP ecx
        CALL crlf
        INC ecx
        .endw
        CALL crlf
ENDM

mPrintString MACRO string
    MOV edx,OFFSET string
    CALL WriteString
ENDM

.data
    A   DWORD 4 DUP(?)
    msgA BYTE "Matrix A",0Dh,0Ah,0
    B   DWORD 2,3,4,6
    msgB BYTE "Matrix B",0Dh,0Ah,0
    result  DWORD 4 DUP(?)
    msgResult BYTE "Result Matrix",0Dh,0Ah,0
    rows  DWORD 2
    cols  DWORD 2
    space BYTE " ",0
    msgAdd BYTE "Addtion",0Dh,0Ah,0
    msgSub BYTE "Subtraction",0Dh,0Ah,0
    msgInputMatrix BYTE "Input matrix elements:",0Dh,0Ah,0
    msgElementPromptL BYTE "Enter element ",0
    msgElementPromptR BYTE ": ",0
.code
main PROC
        mInputMatrix A
        mPrintString msgA
         mPrintMatrix A
         mPrintString msgB
         mPrintMatrix B
         CALL subMatrices
         mPrintString msgResult
         mPrintMatrix result
         exit
main ENDP

;add matrices A and B
addMatrices PROC
    mPrintString msgAdd
    MOV esi,OFFSET result
    MOV ecx,1
    MOV ebx,0
    .while ecx<=LENGTHOF A
    MOV eax,[A+ebx]
    ADD eax,[B+ebx]
    MOV [result+ebx],eax
    INC ecx
    ADD ebx,TYPE A
    .endw
    RET
addMatrices ENDP

;subtract matrices A and B
subMatrices PROC
    mPrintString msgSub
    MOV esi,OFFSET result
    MOV ecx,1
    MOV ebx,0
    .while ecx<=LENGTHOF A
    MOV eax,[A+ebx]
    SUB eax,[B+ebx]
    MOV [result+ebx],eax
    INC ecx
    ADD ebx,TYPE A
    .endw
    RET
subMatrices ENDP

END main