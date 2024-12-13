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
    A   DWORD 3,1,6,2
    msgA BYTE "Matrix A",0Dh,0Ah,0
    B   DWORD 2,3,4,6
    msgB BYTE "Matrix B",0Dh,0Ah,0
    result  DWORD 4 DUP(?)
    msgResult BYTE "Result Matrix",0Dh,0Ah,0
    determinant DWORD ?
    scalar DWORD ?
    rows  DWORD 2
    cols  DWORD 2
    space BYTE " ",0
    msgAdd BYTE "A + B = ",0Dh,0Ah,0
    msgSub BYTE "A - B = ",0Dh,0Ah,0
    msgInputMatrix BYTE "Input matrix elements:",0Dh,0Ah,0
    msgElementPromptL BYTE "Enter element ",0
    msgElementPromptR BYTE ": ",0
    msgDeterminant BYTE "|A| = ",0
    msgEnterScalar BYTE "Enter scalar: ",0
.code
main PROC
    ; mInputMatrix A
    ; mPrintString msgA
    ; mPrintMatrix A
    ; CALL calcDeterminant
    CALL matrixMult

    ;  mPrintString msgB
    ;  mPrintMatrix B
    ;  CALL subMatrices
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

;calculate the determinant of matrix A
calcDeterminant PROC
    MOV eax,[A]
    IMUL eax,[A+12]
    MOV ebx,[A+4]
    IMUL ebx,[A+8]
    SUB eax,ebx
    MOV determinant,eax
    MOV edx,OFFSET msgDeterminant
    CALL WriteString
    CALL WriteInt
    CALL crlf
    RET
calcDeterminant ENDP

;multiply a matrix by a scalar
scalarMult PROC
    MOV edx,OFFSET msgEnterScalar
    CALL WriteString
    CALL ReadInt
    MOV scalar,eax
    MOV ecx,1
    MOV ebx,0
    .while ecx<=LENGTHOF A
        MOV eax,[A+ebx]
        IMUL scalar
        MOV [result+ebx],eax
        ADD ebx,TYPE A
        INC ecx
    .endw
    mPrintString msgResult
    mPrintMatrix result
    RET
scalarMult ENDP

;description
matrixMult PROC
    ;calculating result_11
    MOV eax,[A] ;A_11
    IMUL [B]    ;B_11
    MOV ebx,[A+TYPE A]  ;A_12
    IMUL ebx,[B+TYPE B+TYPE B] ;B_21
    ADD eax,ebx
    MOV [result],eax    ;1

    ;calculating result_12
    MOV eax,[A] ;A_11
    IMUL [B+TYPE A] ;B_12
    MOV ebx,[A+TYPE A]  ;A_12
    IMUL ebx,[B+TYPE B+TYPE B+TYPE B]   ;B_22
    ADD eax,ebx
    MOV [result+TYPE result],eax

    ;calculating result_21
    MOV eax,[A+TYPE A+TYPE A]   ;A_21
    IMUL [B]    ;B_11
    MOV ebx,[A+TYPE A+TYPE A+TYPE A]    ;A_22
    IMUL ebx,[B+TYPE B+TYPE B]  ;B_21
    ADD eax,ebx
    MOV [result+TYPE result+TYPE result],eax

    ;calculating result_22
    MOV eax,[A+TYPE A+TYPE A]   ;A_21
    IMUL [B+TYPE A] ;B_12
    MOV ebx,[A+TYPE A+TYPE A+TYPE A]    ;A_22
    IMUL ebx,[B+TYPE B+TYPE B+TYPE B]   ;B_22
    ADD eax,ebx
    MOV [result+TYPE result+TYPE result+TYPE result],eax

    mPrintString msgResult
    mPrintMatrix result
    RET
matrixMult ENDP
END main