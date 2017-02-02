; ************************************************************************
; リスト5.13
; 電子サイコロのプログラム
; 電子サイコロ
; ************************************************************************
        LIST    P=P16F84A           ;使用するPICを指定
        INCLUDE "P16F84A.INC"       ;読み込む設定ファイルを指定
; ************************************************************************
PB_D    EQU     01H                 ;ポートB入出力設定データ
NUM1    EQU     10H                 ;目データ
NUM2    EQU     22H
NUM3    EQU     32H
NUM4    EQU     0AAH
NUM5    EQU     0BAH
NUM6    EQU     0EEH
INT_OK  EQU     90H                 ;INT(RB0)ピン割り込み許可データ
INT_NG  EQU     10H                 ;割り込み禁止データ
TMP     EQU     0CH                 ;Wレジスタ待避用
CNT1    EQU     0DH                 ;タイマ1用カウント変数
CNT2    EQU     0EH                 ;タイマ2用カウント変数
CNT3    EQU     0FH                 ;タイマ3用カウント変数
; ************************************************************************
        ORG     0                   ;プログラムを格納する先頭アドレス
        GOTO    MAIN
        ORG     4                   ;割り込みベクタ
        MOVWF   TMP                 ;Wレジスタの待避
        MOVLW   INT_NG              ;割り込み禁止データ
        MOVWF   INTCON              ;割り込み禁止

; 割り込み処理 ***********************************************************
        MOVF    TMP,W               ;Wレジスタの回復
        MOVWF   PORTB               ;PORTBへ出力
        CALL    TIMER3              ;1秒タイマ呼び出し
        CLRF    PORTB               ;ポートBをクリア(LED消灯)
; ************************************************************************

        MOVLW   INT_OK              ;割り込み許可データ
        MOVWF   INTCON              ;割り込み許可
        RETFIE                      ;割り込みから戻る

MAIN    BSF     STATUS,RP0          ;バンク1を選択
        MOVLW   INT_OK              ;割り込み許可データ
        MOVWF   INTCON              ;割り込み許可
        BSF     OPTION_REG,INTEDG   ;割り込み信号の立ち上がりで動作
        MOVLW   PB_D                ;ポートB設定データ
        MOVWF   TRISB               ;RB0を入力、RB1〜RB7を出力モードに設定
        BCF     STATUS,RP0          ;バンク0を選択
        CLRF    PORTB               ;ポートBをクリア(LED消灯)

AGAIN   MOVLW   NUM1                ;目データの格納
        NOP
        NOP
        MOVLW   NUM2
        NOP
        NOP
        MOVLW   NUM3
        NOP
        NOP
        MOVLW   NUM4
        NOP
        NOP
        MOVLW   NUM5
        NOP
        NOP
        MOVLW   NUM6
        GOTO    AGAIN

TIMER1  MOVLW   D'62'               ;0.1ミリ秒タイマサブルーチン
        MOVWF   CNT1
LOOP1   NOP
        DECFSZ  CNT1,F
        GOTO    LOOP1
        RETURN

TIMER2  MOVLW   D'100'              ;10ミリ秒タイマサブルーチン
        MOVWF   CNT2
LOOP2   NOP
        CALL    TIMER1
        DECFSZ  CNT2,F
        GOTO    LOOP2
        RETURN

TIMER3  MOVLW   D'100'              ;1秒タイマサブルーチン
        MOVWF   CNT3
LOOP3   NOP
        CALL    TIMER2
        DECFSZ  CNT3,F
        GOTO    LOOP3
        RETURN

        END                         ;プログラムの終わり
