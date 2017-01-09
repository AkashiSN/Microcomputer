;5-1
;header
        LIST    P=PIC16F84A
        INCLUDE "P16F84A.INC"
;var
LEDD    EQU     55H
;main
        ORG     0
        BSF     STATUS,RP0
        CLRF    TRISB
        BCF     STATUS,RP0
        CLRF    PORTB
        MOVLW   LEDD
        MOVWF   PORTB
WAIT    GOTO    WAIT

        END
