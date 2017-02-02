;5-6
;header
        LIST    P=P16F84A
        INCLUDE "P16F84A.INC"
;var
;LEDD   EQU     80H             ;左端から右方向にスタート
LEDD    EQU     01H             ;右端から左方向にスタート
CNT1    EQU     0CH
CNT2    EQU     0DH
CNT3    EQU     0EH
;main
        ORG     0

        BSF     STATUS,RP0
        CLRF    TRISB
        BCF     STATUS,RP0
        BCF     STATUS,C
        MOVLW   LEDD
        MOVWF   PORTB

RIGHT   CALL    TIMER3
        RRF     PORTB,1
        BTFSS   STATUS,C
        GOTO    RIGHT

        RLF     PORTB,1         ;過分ローテイトの復旧
        RLF     PORTB,1

LEFT    CALL    TIMER3
        RLF     PORTB,1
        BTFSS   STATUS,C
        GOTO    LEFT

        RRF     PORTB,1         ;過分ローテイトの復旧
        RRF     PORTB,1
        GOTO    RIGHT

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

TIMER3  MOVLW   D'20'
        MOVWF   CNT3
LOOP3   NOP
        CALL    TIMER2
        DECFSZ  CNT3,F
        GOTO    LOOP3
        RETURN

        END
