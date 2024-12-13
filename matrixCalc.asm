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
    msgWelcome BYTE "2D Matrix Calculator",0Dh,0Ah,0
    msgMenu BYTE "--------------------",0Dh,0Ah,"Select an operation: ",0Dh,0Ah,"1. Addition",0Dh,0Ah,"2. Subtraction",0Dh,0Ah,"3. Determinant",0Dh,0Ah,"4. Scalar Multiplication",0Dh,0Ah,"5. Matrix Multiplication",0Dh,0Ah,"0. Quit Calculator",0Dh,0Ah,0
    msgChoice BYTE "Choice: ",0
    msgInvalidInput BYTE "Invalid input! Try again.",0Dh,0Ah,0
    A   DWORD 4 DUP(?)
    msgA BYTE "Matrix A",0Dh,0Ah,0
    B   DWORD 4 DUP(?)
    msgB BYTE "Matrix B",0Dh,0Ah,0
    result  DWORD 4 DUP(?)
    msgResult BYTE "Result Matrix",0Dh,0Ah,0
    det DWORD ?
    scalar DWORD ?
    rows  DWORD 2
    cols  DWORD 2
    space BYTE " ",0
    msgAdd BYTE "A + B = ",0Dh,0Ah,0
    msgSub BYTE "A - B = ",0Dh,0Ah,0
    msgScalarMult BYTE "kA = ",0Dh,0Ah,0
    msgMatrixMult BYTE "A * B = ",0Dh,0Ah,0
    msgInputMatrix BYTE "Input matrix elements:",0Dh,0Ah,0
    msgElementPromptL BYTE "Enter element ",0
    msgElementPromptR BYTE ": ",0
    msgDet BYTE "|A| = ",0
    msgEnterScalar BYTE "Enter scalar k: ",0
    choice DWORD ?
.code
main PROC
    mPrintString msgWelcome
    mainLoop:
        mPrintString msgMenu
        mPrintString msgChoice
        CALL ReadInt
        MOV choice,eax
        CMP choice,1
        JE Addition
        CMP choice,2
        JE Subtraction
        CMP choice,3
        JE Determinant
        CMP choice,4
        JE ScalarMultiplication
        CMP choice,5
        JE MatrixMultiplication
        CMP choice,0
        JE Quit
        JMP invalidInput

        invalidInput:
            mPrintString msgInvalidInput
            JMP mainLoop

        Addition:
            mPrintString msgA
            mInputMatrix A
            mPrintString msgB
            mInputMatrix B
            CALL addMatrices
            JMP mainLoop

        Subtraction:
            mPrintString msgA
            mInputMatrix A
            mPrintString msgB
            mInputMatrix B
            CALL subMatrices
            JMP mainLoop

        Determinant:
            mPrintString msgA
            mInputMatrix A
            mPrintString msgA
            mPrintMatrix A
            CALL calcDeterminant
            JMP mainLoop

        ScalarMultiplication:
            mPrintString msgA
            mInputMatrix A
            mPrintString msgA
            mPrintMatrix A
            CALL scalarMult
            JMP mainLoop

        MatrixMultiplication:
            mPrintString msgA
            mInputMatrix A
            mPrintString msgB
            mInputMatrix B
            CALL matrixMult
            JMP mainLoop

        Quit:
            exit
main ENDP

;add matrices A and B
addMatrices PROC
    MOV ecx,1
    MOV ebx,0
    .while ecx<=LENGTHOF A
        MOV eax,[A+ebx]
        ADD eax,[B+ebx]
        MOV [result+ebx],eax
        INC ecx
        ADD ebx,TYPE A
    .endw
    mPrintString msgAdd
    mPrintString msgResult
    mPrintMatrix result
    CALL WaitMsg
    CALL crlf
    RET
addMatrices ENDP

;subtract matrices A and B
subMatrices PROC
    MOV ecx,1
    MOV ebx,0
    .while ecx<=LENGTHOF A
        MOV eax,[A+ebx]
        SUB eax,[B+ebx]
        MOV [result+ebx],eax
        INC ecx
        ADD ebx,TYPE A
    .endw
    mPrintString msgSub
    mPrintString msgResult
    mPrintMatrix result
    CALL WaitMsg
    CALL crlf
    RET
subMatrices ENDP

;calculate the determinant of matrix A
calcDeterminant PROC
    MOV eax,[A]
    IMUL eax,[A+12]
    MOV ebx,[A+4]
    IMUL ebx,[A+8]
    SUB eax,ebx
    MOV det,eax
    mPrintString msgDet
    CALL WriteInt
    CALL crlf
    CALL WaitMsg
    CALL crlf
    RET
calcDeterminant ENDP

;multiply a matrix A by a scalar
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
    mPrintString msgScalarMult
    mPrintString msgResult
    mPrintMatrix result
    CALL WaitMsg
    CALL crlf
    RET
scalarMult ENDP

;multiply matrices A and B
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

    mPrintString msgMatrixMult
    mPrintString msgResult
    mPrintMatrix result
    CALL WaitMsg
    CALL crlf
    RET
matrixMult ENDP
END main