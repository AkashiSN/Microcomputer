; ************************************************************************
; リスト5.14
; タイマ割り込み制御プログラム
; LEDの点滅
; ************************************************************************
        LIST    P=P16F84A       ;使用するPICを指定
        INCLUDE "P16F84A.INC"   ;読み込む設定ファイルを指定
; ************************************************************************
TIMO    EQU     87H             ;タイマ設定用データ
INT_OK  EQU     0A0H            ;割り込み許可データ
INT_NG  EQU     10H             ;割り込み禁止データ
CNTN    EQU     D'38'           ;割り込み回数データ
LEDD1   EQU     55H             ;LED点灯データ1の設定
LEDD2   EQU     0AAH            ;LED点灯データ2の設定
INTG    EQU     0CH             ;割り込み発生フラグ
INTC    EQU     0DH             ;割り込み回数カウンタ
DATAF   EQU     0EH             ;データ設定フラグ
TMP     EQU     0FH             ;Wレジスタ待避用
; ************************************************************************
        ORG     0               ;プログラムを格納する先頭アドレス
        GOTO    MAIN

        ORG     4               ;割り込みベクタ
        MOVWF   TMP             ;Wレジスタ待避
        MOVLW   INT_NG          ;割り込み禁止
        MOVWF   INTCON

; 割り込み処理 ***********************************************************
        DECFSZ  INTC,F          ;割り込み回数のチェック
        GOTO    IEXIT           ;CNTN回未満なら、IEXITへジャンプ
        BSF     INTG,0          ;CNTN回なら、割り込み発生フラグのセット
        MOVLW   CNTN            ;割り込み回数データ
        MOVWF   INTC            ;割り込み回数カウンタの更新
; ************************************************************************
IEXIT   MOVF    TMP,W           ;Wレジスタの回復
        MOVLW   INT_OK          ;割り込み許可
        MOVWF   INTCON
        RETFIE                  ;割り込みから戻る

MAIN    BSF     STATUS,RP0      ;バンク1を選択
        MOVLW   TIMO            ;タイマ0設定用データ
        MOVWF   OPTION_REG
        CLRF    TRISB           ;ポートBをすべて出力モードに設定
        BCF     STATUS,RP0      ;バンク0を選択
        MOVLW   INT_OK          ;割り込み設定用データ
        MOVWF   INTCON          ;タイマ0割り込みの許可
        CLRF    TIMO            ;タイマ0の初期化
        MOVLW   CNTN            ;割り込み回数
        MOVWF   INTC
        CLRF    INTG            ;割り込み発生フラグの初期化
        CLRF    DATAF           ;データ設定フラグの初期化
        MOVLW   LEDD2           ;点灯データ2をWレジスタにセット
        MOVWF   PORTB           ;点灯データ2をポートBに出力

REPEAT  BTFSS   INTG,0          ;タイマ0割り込み発生フラグのチェック
        GOTO    REPEAT          ;発生していなければ繰り返しチェック
        BCF     INTC,0          ;発生していれば、フラグをクリア
        BTFSC   DATAF,0         ;データ設定フラグは0か
        GOTO    P2              ;1ならばパターン2へジャンプ
        MOVLW   LEDD1           ;0ならば点灯データ1をWレジスタにセット
        MOVWF   PORTB           ;点灯データ1をポートBに出力
        BSF     DATAF,0         ;データ設定フラグを1にセット
        GOTO    REPEAT          ;繰り返し起点へジャンプ

P2      MOVLW   LEDD2           ;点灯データ2をWレジスタにセット
        MOVWF   PORTB           ;点灯データ2をポートBに出力
        BCF     DATAF,0         ;データ設定フラグを0にクリア
        GOTO    REPEAT          ;繰り返し起点へジャンプ

        END                     ; プログラムの終わり