; *********************************************************************
; リスト5.5 練習問題5.7
; 光が流れるプログラム（片道バージョン）
; （移動スピードを速くする）
; *********************************************************************
        LIST    P=P16F84A       ;使用するPICを指定
        INCLUDE "P16F84A.INC"   ;読み込む設定ファイルを指定
; *********************************************************************
LEDD    EQU     80H             ;LEDの点灯データの設定
CNT1    EQU     0CH             ;タイマ1用のカウント変数
CNT2    EQU     0DH             ;タイマ2用のカウント変数
CNT3    EQU     0EH             ;タイマ3用のカウント変数
; *********************************************************************
        ORG     0               ;プログラムを格納する先頭アドレス

        BSF     STATUS,RP0      ;バンク1を選択
        CLRF    TRISB           ;ポートBをすべて出力モードに設定
        BCF     STATUS,RP0      ;バンク0を選択
        BCF     STATUS,C        ;Cフラグをクリア

        MOVLW   LEDD            ;点灯データをWレジスタにセット
        MOVWF   PORTB           ;点灯データをポートBに出力（LEDが点灯）
REPEAT  CALL    TIMER2          ;2ミリ秒タイマの呼び出し
        RRF     PORTB,1         ;ポートBを1ビット右にローテイト
        GOTO    REPEAT

;止めるまで永遠に繰り返す

TIMER1  MOVLW   D'62'           ;0.1ミリ秒タイマサブルーチン
        MOVWF   CNT1
LOOP1   NOP
        DECFSZ  CNT1,F
        GOTO    LOOP1
        RETURN

TIMER2  MOVLW   D'20'          	;2ミリ秒タイマサブルーチン
        MOVLW   CNT2
LOOP2   NOP
        CALL    TIMER1
        DECFSZ  CNT2,F
        GOTO    LOOP2
        RETURN

        END                     ;プログラムの終わり
