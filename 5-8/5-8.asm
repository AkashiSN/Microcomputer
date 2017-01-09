;5-8
;header
        LIST    P=PIC16F84A
        INCLUDE "P16F84A.INC"
;var
RELAY   EQU     01H
CNT1    EQU     0CH
CNT2    EQU     0DH
CNT3    EQU     0EH
;main
        ORG     0

        BSF     STATUS,RP0
        CLRF    TRISB
        BCF     STATUS,RP0

REPEAT  CLRF    PORTB
        CALL    TIMER3
        MOVLW   RELAY
        MOVWF   PORTB
        CALL    TIMER3
        GOTO    REPEAT

TIMER1  MOVLW   D'62'
        MOVWF   CNT1
LOOP1   NOP
        DECFSZ  CNT1,F
        GOTO    LOOP1
        RETURN

TIMER2  MOVLW   D'100'
        MOVWF   CNT2
LOOP2   NOP
        CALL    TIMER1
        DECFSZ  CNT2,F
        GOTO    LOOP2
        RETURN
TIMER3  MOVLW   D'100'
        MOVWF   CNT3
LOOP3   NOP
        CALL    TIMER2
        DECFSZ  CNT3,F
        GOTO    LOOP3
        RETURN

        END