; *********************************************************************
; リスト5.12
; パルスモータ1-2相励磁プログラム
; 間接アドレシング使用
; *********************************************************************
        LIST    P=P16F84A       ;使用するPICを指定
        INCLUDE "P16F84A.INC"   ;読み込む設定ファイルを指定
; *********************************************************************
WORK0   EQU     0CH             ;回転データ格納領域
WORK1   EQU     0DH
WORK2   EQU     0EH
WORK3   EQU     0FH
WORK4   EQU     10H
WORK5   EQU     11H
WORK6   EQU     12H
WORK7   EQU     13H
TMP     EQU     14H             ;Wレジスタ待避用
CNT1    EQU     15H             ;タイマ1用カウント変数
CNT2    EQU     16H             ;タイマ2用カウント変数
CNT3    EQU     17H             ;タイマ3用カウント変数
; *********************************************************************
        ORG     0               ;プログラムを格納する先頭アドレス

        BSF     STATUS,RP0      ;バンク1を選択
        CLRF    TRISB           ;ポートBを出力モードに設定
        BCF     STATUS,RP0      ;バンク0を選択
        CLRF    PORTB           ;ポートBをクリア（モータ停止）

        MOVLW   08H             ;回転データの格納
        MOVWF   WORK0
        MOVLW   0CH
        MOVWF   WORK1

        MOVLW   04H
        MOVWF   WORK2
        MOVLW   06H
        MOVWF   WORK3
        MOVLW   02H
        MOVWF   WORK4
        MOVLW   03H
        MOVWF   WORK5
        MOVLW   01H
        MOVWF   WORK6
        MOVLW   09H
        MOVWF   WORK7

NEW     MOVLW   WORK0           ;WORK0をアドレスとして読み取る
        MOVWF   FSR             ;FSRにアドレスを書き込む
MADA    MOVF    INDF,W          ;INDFレジスタを読み取る
        MOVWF   PORTB           ;回転データをポートBに出力
        MOVWF   TMP             ;Wレジスタの待避
        CALL    TIMER3          ;タイマの呼び出し
        MOVF    TMP,W           ;Wレジスタの回復
        SUBWF   WORK7,W         ;最後の回転データとの照合
        BTFSC   STATUS,Z        ;照合結果チェック
        GOTO    NEW             ;最後まで行っていれば最初から

        INCF    FSR,F           ;まだなら、FSRを1番地分進める
        GOTO    MADA            ;次のWORK領域を読み取る

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

TIMER3  MOVLW   D'50'           ;0.5ミリ秒タイマサブルーチン
        MOVWF   CNT3
LOOP3   NOP
        CALL    TIMER2
        DECFSZ  CNT3,F
        GOTO    LOOP3
        RETURN

        END                     ;プログラムの終わり
