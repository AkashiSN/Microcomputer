;5-7
;header
        LIST    P=PIC16F84A
        INCLUDE "P16F84A.INC"
;main
        ORG     0

        BSF     STATUS,RP0
        MOVLW   1FH
        MOVWF   TRISA
        CLRF    TRISB
        BCF     STATUS,RP0
        CLRF    PORTB

        CLRW
        BTFSC   PORTA,0
        MOVLW   0FH
        BTFSC   PORTA,1
        IORLW   0F0H
        MOVWF   PORTB

WAIT    GOTO    WAIT

        END