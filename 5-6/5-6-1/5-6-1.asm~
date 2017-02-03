; *********************************************************************
; リスト5.6 練習問題5.8
; 光が流れるプログラム（往復バージョン）
; （リスト5.6と移動方向が反対バージョン）
; *********************************************************************
        LIST    P=P16F84A       ;使用するPICを指定
        INCLUDE "P16F84A.INC"   ;読み込む設定ファイルを指定
; *********************************************************************
LEDD    EQU     01H             ;LEDの点灯データの設定
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

RIGHT   CALL    TIMER3          ;0.2秒タイマの呼び出し
        RRF     PORTB,1         ;ポートBを1ビット右にローテイト
        BTFSS   STATUS,C        ;Cフラグが1なら次の命令をスキップ
        GOTO    RIGHT

        RLF     PORTB,1         ;過分ローテイトの復旧
        RLF     PORTB,1         ;過分ローテイトの復旧

LEFT    CALL    TIMER3          ;0.2秒タイマの呼び出し
        RLF     PORTB,1         ;ポートBを1ビット左にローテイト
        BTFSS   STATUS,C        ;Cフラグが1なら次の命令をスキップ
        GOTO    LEFT

        RRF     PORTB,1         ;過分ローテイトの復旧
        RRF     PORTB,1         ;過分ローテイトの復旧

;止めるまで永遠に繰り返す

TIMER1  MOVLW   D'62'           ;0.1ミリ秒タイマサブルーチン
        MOVWF   CNT1
LOOP1   NOP
        DECFSZ  CNT1,F
        GOTO    LOOP1
        RETURN

TIMER2  MOVLW   D'100'          ;10ミリ秒タイマサブルーチン
        MOVWF   CNT2
LOOP2   NOP
        CALL    TIMER1
        DECFSZ  CNT2,F
        GOTO    LOOP2
        RETURN

TIMER3  MOVLW   D'20'           ;0.2秒タイマサブルーチン
        MOVWF   CNT3
LOOP3   NOP
        CALL    TIMER2
        DECFSZ  CNT3,F
        GOTO    LOOP3
        RETURN

        END                     ;プログラムの終わり
