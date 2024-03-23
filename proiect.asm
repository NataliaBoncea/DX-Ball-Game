.586
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc
extern scanf: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date

window_title DB "DX Ball - Boncea Natalia",0
area_width EQU 900
area_height EQU 480
area DD 0

counter DD 0 ; numara evenimentele de tip timer

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

ball_width EQU 16
ball_height EQU 16
unghi_x DD 0
unghi_y DD 10
xball DD 445
yball DD 355
directie DD 0

block_width EQU 70
block_height EQU 25
nr_linii DD 7
nr_coloane DD 12
aux_linii DD 0
total_blocks DD 84

placa_width EQU 88
placa_height EQU 20
placa_width_aux DD 88
placa_expand_width EQU 176
placa_shrink_width EQU 44
xplaca DD 410
timer_placa DD 50
expand_enable DD 0

arrow_width EQU 50
arrow_height EQU 51

bonus_width EQU 19
bonus_height EQU 19
random_block_number DD 3
random_bonus DD 0
block_counter DD 0
xbonus DD 0
ybonus DD 0
bonus_enable DD 0

banda_height EQU 100
banda_width EQU 900

symbol_width EQU 10
symbol_height EQU 20

CINCI DD 5
DOI DD 2
GO DD 0

include letters.inc
include digits.inc
include caramida.inc
include ball.inc
include placa.inc
include left.inc
include right.inc
include harta.inc
include expand.inc
include shrink.inc
include button.inc


.code
; procedura make_object afiseaza un obiect la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_object proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 'A'
	je draw_minge
	cmp eax, 'B'
	je draw_caramida
	cmp eax, 'C'
	je draw_placa_margini
	cmp eax, 'D'
	je draw_placa_mijloc
	cmp eax, 'E'
	je draw_block_negru
	cmp eax, 'F'
	je draw_expand
	cmp eax, 'G'
	je draw_shrink
	cmp eax, 'H'
	je draw_banda_rosie
	cmp eax, 'I'
	je draw_banda_verde
	cmp eax, 'J'
	je draw_button
	cmp eax, 'L'
	je draw_a_left
	cmp eax, 'R'
	je draw_a_right
	jmp final

;deseneaza mingea
draw_minge:
	mov eax, 0
	lea esi, ball
	mov ecx, ball_height
bucla_minge_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, ball_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, ball_width
bucla_minge_coloane:
	cmp byte ptr [esi], 1
	je simbol_pixel_rosu1
	cmp byte ptr [esi], 2
	je simbol_pixel_rosu2
	cmp byte ptr [esi], 3
	je simbol_pixel_rosu3
	jmp simbol_pixel_next
simbol_pixel_rosu1:
	mov dword ptr [edi], 0940000h
	jmp simbol_pixel_next
simbol_pixel_rosu2:
	mov dword ptr [edi], 0cf8888h
	jmp simbol_pixel_next
simbol_pixel_rosu3:
	mov dword ptr [edi], 05f0000h
	jmp simbol_pixel_next
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_minge_coloane
	pop ecx
	loop bucla_minge_linii
	jmp final

;deseneaza caramida	
draw_caramida:
	mov eax, 0
	lea esi, blocks
	mov ecx, block_height
bucla_caramida_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, block_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, block_width
bucla_caramida_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb_c
	cmp byte ptr [esi], 1
	je simbol_pixel_albastru_d
	cmp byte ptr [esi], 2
	je simbol_pixel_albastru
	cmp byte ptr [esi], 4
	je simbol_pixel_albastru_i
	cmp byte ptr [esi], 3
	je simbol_pixel_negru
	jmp simbol_pixel_next2
simbol_pixel_alb_c:
	mov dword ptr [edi], 09e9effh
	jmp simbol_pixel_next2
simbol_pixel_albastru_d:
	mov dword ptr [edi], 04d4dffh
	jmp simbol_pixel_next2
simbol_pixel_albastru:
	mov dword ptr [edi], 00000ffh
	jmp simbol_pixel_next2
simbol_pixel_albastru_i:
	mov dword ptr [edi], 00000a7h
	jmp simbol_pixel_next2
simbol_pixel_negru:
	mov dword ptr [edi], 0000020h
	jmp simbol_pixel_next2
simbol_pixel_next2:
	inc esi
	add edi, 4
	loop bucla_caramida_coloane
	pop ecx
	loop bucla_caramida_linii
	jmp final

;deseneaza placa
draw_placa_margini:
	mov eax, 0
	lea esi, placa
	mov ecx, placa_height
bucla_placa_linii_margine:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, placa_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, placa_width
bucla_placa_coloane_margine:
	cmp byte ptr [esi], 6
	je simbol_pixel_turcoaz1
	cmp byte ptr [esi], 7
	je simbol_pixel_turcoaz2
	cmp byte ptr [esi], 8
	je simbol_pixel_turcoaz3
	jmp simbol_pixel_next_placa_margine
simbol_pixel_turcoaz1:
	mov dword ptr [edi], 0006d68h
	jmp simbol_pixel_next_placa_margine
simbol_pixel_turcoaz2:
	mov dword ptr [edi], 000c3bah
	jmp simbol_pixel_next_placa_margine
simbol_pixel_turcoaz3:
	mov dword ptr [edi], 07efff9h
	jmp simbol_pixel_next_placa_margine
simbol_pixel_next_placa_margine:
	cmp expand_enable,1
	je modifica_marime2
	jmp simbol_pixel_next_placa_margine2

simbol_pixel_next_placa_margine2:
	inc esi
	add edi, 4
	loop bucla_placa_coloane_margine
	pop ecx
	loop bucla_placa_linii_margine
	jmp final
modifica_marime2:
	cmp random_bonus, 0
	je dubleaza2
	cmp random_bonus, 1
	je micsoreaza2
dubleaza2:
	mov ebx, dword ptr [edi]
	add edi, 4
	mov dword ptr [edi], ebx
	jmp simbol_pixel_next_placa_margine2
micsoreaza2:
	inc esi
	dec ecx
	jmp simbol_pixel_next_placa_margine2
	
draw_placa_mijloc:
	mov eax, 0
	lea esi, placa
	mov ecx, placa_height
bucla_placa_linii_mijloc:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, placa_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, placa_width
bucla_placa_coloane_mijloc:
	cmp byte ptr [esi], 1
	je simbol_pixel_gri1
	cmp byte ptr [esi], 2
	je simbol_pixel_gri2
	cmp byte ptr [esi], 3
	je simbol_pixel_gri3
	cmp byte ptr [esi], 4
	je simbol_pixel_gri4
	cmp byte ptr [esi], 5
	je simbol_pixel_gri5
	jmp simbol_pixel_next_placa_mijloc
simbol_pixel_gri1:
	mov dword ptr [edi], 02d2d2dh
	jmp simbol_pixel_next_placa_mijloc
simbol_pixel_gri2:
	mov dword ptr [edi], 0474747h
	jmp simbol_pixel_next_placa_mijloc
simbol_pixel_gri3:
	mov dword ptr [edi], 0626262h
	jmp simbol_pixel_next_placa_mijloc
simbol_pixel_gri4:
	mov dword ptr [edi], 0818181h
	jmp simbol_pixel_next_placa_mijloc
simbol_pixel_gri5:
	mov dword ptr [edi], 0a1a1a1h
	jmp simbol_pixel_next_placa_mijloc
simbol_pixel_next_placa_mijloc:
	cmp expand_enable,1
	je modifica_marime
	jmp simbol_pixel_next_placa_mijloc2
	
simbol_pixel_next_placa_mijloc2:	
	inc esi
	add edi, 4
	loop bucla_placa_coloane_mijloc
	pop ecx
	loop bucla_placa_linii_mijloc
	jmp final
	
modifica_marime:
	cmp random_bonus, 0
	je dubleaza
	cmp random_bonus, 1
	je micsoreaza
dubleaza:
	mov ebx, dword ptr [edi]
	add edi, 4
	mov dword ptr [edi], ebx
	jmp simbol_pixel_next_placa_mijloc2
micsoreaza:
	inc esi
	dec ecx
	jmp simbol_pixel_next_placa_mijloc2
	
;deseneaza butonul de miscade in stanga
draw_a_left:
	mov eax, 0
	lea esi, lefta
	mov ecx, arrow_height
bucla_left_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, arrow_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, arrow_width
bucla_left_coloane:
	cmp byte ptr [esi], 1
	je simbol_pixel_negru_left
	cmp byte ptr [esi], 2
	je simbol_pixel_gri1_left
	cmp byte ptr [esi], 3
	je simbol_pixel_gri2_left
	jmp simbol_pixel_next
simbol_pixel_negru_left:
	mov dword ptr [edi], 0
	jmp simbol_pixel_next_left
simbol_pixel_gri1_left:
	mov dword ptr [edi], 0858585h
	jmp simbol_pixel_next_left
simbol_pixel_gri2_left:
	mov dword ptr [edi], 0aaaaaah
	jmp simbol_pixel_next_left
simbol_pixel_next_left:
	inc esi
	add edi, 4
	loop bucla_left_coloane
	pop ecx
	loop bucla_left_linii
	jmp final
	
;deseneaza butonul de miscade in dreapta
draw_a_right:
	mov eax, 0
	lea esi, righta
	mov ecx, arrow_height
bucla_right_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, arrow_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, arrow_width
bucla_right_coloane:
	cmp byte ptr [esi], 1
	je simbol_pixel_negru_right
	cmp byte ptr [esi], 2
	je simbol_pixel_gri1_right
	cmp byte ptr [esi], 3
	je simbol_pixel_gri2_right
	jmp simbol_pixel_next
simbol_pixel_negru_right:
	mov dword ptr [edi], 0
	jmp simbol_pixel_next_right
simbol_pixel_gri1_right:
	mov dword ptr [edi], 0858585h
	jmp simbol_pixel_next_right
simbol_pixel_gri2_right:
	mov dword ptr [edi], 0aaaaaah
	jmp simbol_pixel_next_right
simbol_pixel_next_right:
	inc esi
	add edi, 4
	loop bucla_right_coloane
	pop ecx
	loop bucla_right_linii
	jmp final
	
;deseneaza butoanele de reset si exit
draw_button:
	mov eax, 0
	lea esi, button
	mov ecx, arrow_height
bucla_button_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, arrow_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, arrow_width
bucla_button_coloane:
	cmp byte ptr [esi], 1
	je simbol_pixel_negru_button
	cmp byte ptr [esi], 2
	je simbol_pixel_gri1_button
	cmp byte ptr [esi], 3
	je simbol_pixel_gri2_button
	jmp simbol_pixel_next
simbol_pixel_negru_button:
	mov dword ptr [edi], 0
	jmp simbol_pixel_next_button
simbol_pixel_gri1_button:
	mov dword ptr [edi], 0858585h
	jmp simbol_pixel_next_button
simbol_pixel_gri2_button:
	mov dword ptr [edi], 0aaaaaah
	jmp simbol_pixel_next_button
simbol_pixel_next_button:
	inc esi
	add edi, 4
	loop bucla_button_coloane
	pop ecx
	loop bucla_button_linii
	jmp final
	
;deseneaza o caramida neagra in locul celor distruse
draw_block_negru:
	mov eax, 0
	mov ecx, block_height
bucla_block_negru_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, block_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, block_width
bucla_block_negru_coloane:
	mov dword ptr [edi], 0
	add edi, 4
	loop bucla_block_negru_coloane
	pop ecx
	loop bucla_block_negru_linii
	jmp final
	
;deseneaza banda rosie pentru finalul GAME OVER
draw_banda_rosie:
	mov eax, 0
	mov ecx, block_height
bucla_banda_rosie_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, banda_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, banda_width
bucla_banda_rosie_coloane:
	mov dword ptr [edi], 0b20000h
	add edi, 4
	loop bucla_banda_rosie_coloane
	pop ecx
	loop bucla_banda_rosie_linii
	jmp final
	
;deseneaza banda rosie pentru finalul CONGRATULATION
draw_banda_verde:
	mov eax, 0
	mov ecx, block_height
bucla_banda_verde_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, banda_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, banda_width
bucla_banda_verde_coloane:
	mov dword ptr [edi], 087ff00h
	add edi, 4
	loop bucla_banda_verde_coloane
	pop ecx
	loop bucla_banda_verde_linii
	jmp final
	
;deseneaza bonusul de marire
draw_expand:
	mov eax, 0
	lea esi, expand
	mov ecx, bonus_height
bucla_expand_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, bonus_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, bonus_width
bucla_expand_coloane:
	cmp byte ptr [esi], 1
	je simbol_pixel_gri1_bonus
	cmp byte ptr [esi], 2
	je simbol_pixel_gri2_bonus
	cmp byte ptr [esi], 3
	je simbol_pixel_albastru_bonus
	jmp simbol_pixel_next_expand
simbol_pixel_gri1_bonus:
	mov dword ptr [edi], 0a0a0a0h
	jmp simbol_pixel_next_expand
simbol_pixel_gri2_bonus:
	mov dword ptr [edi], 0676767h
	jmp simbol_pixel_next_expand
simbol_pixel_albastru_bonus:
	mov dword ptr [edi], 000036eh
	jmp simbol_pixel_next_expand
simbol_pixel_next_expand:
	inc esi
	add edi, 4
	loop bucla_expand_coloane
	pop ecx
	loop bucla_expand_linii
	jmp final
	
;deseneaza bonusul de micsorare
draw_shrink:
	mov eax, 0
	lea esi, shrink
	mov ecx, bonus_height
bucla_shrink_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, bonus_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, bonus_width
bucla_shrink_coloane:
	cmp byte ptr [esi], 1
	je simbol_pixel_gri1_bonus2
	cmp byte ptr [esi], 2
	je simbol_pixel_gri2_bonus2
	cmp byte ptr [esi], 3
	je simbol_pixel_albastru_bonus2
	jmp simbol_pixel_next_shrink
simbol_pixel_gri1_bonus2:
	mov dword ptr [edi], 0a0a0a0h
	jmp simbol_pixel_next_shrink
simbol_pixel_gri2_bonus2:
	mov dword ptr [edi], 0676767h
	jmp simbol_pixel_next_shrink
simbol_pixel_albastru_bonus2:
	mov dword ptr [edi], 000036eh
	jmp simbol_pixel_next_shrink
simbol_pixel_next_shrink:
	inc esi
	add edi, 4
	loop bucla_shrink_coloane
	pop ecx
	loop bucla_shrink_linii
	jmp final
	
final:	
	popa
	mov esp, ebp
	pop ebp
	ret
make_object endp


;procedura pentru scrierea textului
make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, ' '
	je make_space
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 1
	je simbol_pixel_alb
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov ebx, [ebp+arg1]
	mov dword ptr [edi], ebx
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp

; un macro ca sa apelam mai usor desenarea obiectelor
make_object_macro macro object, drawArea, x, y
	push y
	push x
	push drawArea
	push object
	call make_object
	add esp, 16
endm

; un macro ca sa apelam mai usor desenarea simbolurilor
make_text_macro macro symbol, drawArea, x, y, color
	push color
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 20
endm

; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
	add edi, area
	mov eax, area_width
	mov ebx, 400
	mul ebx
	mov ecx, eax

;aici se deseneaza fundalul
fundal1:
	mov dword ptr [edi], 0
	add edi, 4
	loop fundal1
	mov eax, area_width
	mov ebx, 80
	mul ebx
	mov ecx, eax
	
fundal2:
	mov dword ptr [edi], 08a8a8ah
	add edi, 4
	loop fundal2
	
;aici se deseneaza zidul de caramizi
	mov ecx, nr_linii
	lea esi, harta
zid_linii:
	push ecx
	mov eax, block_height
	mul ecx
	add eax, 40
	mov aux_linii, eax
	mov ecx, nr_coloane
zid_coloane:
	mov eax, block_width
	mul ecx
	sub eax, block_width
	add eax, 30
	mov ebx, eax
	cmp byte ptr [esi], 1
	je deseneaza_block
	jmp deseneaza_fundal
deseneaza_block:
	make_object_macro 'B', area, ebx, aux_linii
	jmp continua_zid
deseneaza_fundal:
	make_object_macro 'E', area, ebx, aux_linii
	jmp continua_zid
continua_zid:
	inc esi
	loop zid_coloane
	pop ecx
	loop zid_linii
	
;verificam daca jocul s-a terminat sau nu
;daca s-a terminat, atunci verificam daca am dat click pe butonul de reset sau de iesire, iar apoi
;ne intoarcem in functia de desenare a finalului (trecem peste functiile de miscare)
;daca nu s-a terminat, mergem mai departe si controlam bonusurile, placa si mingea
	cmp GO, 1
	je evt_click
	cmp GO, 2
	je evt_click
	
	cmp bonus_enable, 1		;se verifica daca e momentul sa cada un bonus. Daca nu, atunci verificam daca s-a apasat click si
	je cade_bonus			;controlam miscarea mingii si a placii
	jmp continua_harta2
	
;aici se creaza bonusurile
cade_bonus:
	add ybonus, 10
	cmp random_bonus, 0		;verificam daca bonusul ales de random_bonus este de marire
	je desen_expand3
	cmp random_bonus, 1		;verificam daca bonusul ales de random_bonus este de micsorare
	je desen_shrink3
desen_expand3:										;desenam bonusul de marire
	make_object_macro 'F', area, xbonus, ybonus
	jmp continua_cade_bonus
desen_shrink3:										;desenam bonusul de micsorare
	make_object_macro 'G', area, xbonus, ybonus
	jmp continua_cade_bonus
continua_cade_bonus:
	cmp ybonus, 375
	jge placa_bonus
	jmp continua_harta2
	
;aici se verifica coliziunea dintre placa si bonus
;daca se respecta una dintre conditii, atunci bonusul cade pe podea si dispare
;daca nu, atunci placa a prins un bonus
placa_bonus:
	mov ebx, xplaca
	sub ebx, 17
	cmp ebx, xbonus
	jg final_cadere_bonus
	add ebx, 17
	add ebx, placa_width
	cmp ebx, xbonus
	jl final_cadere_bonus
	mov expand_enable, 1
	mov bonus_enable, 0
	mov block_counter, 0
	jmp continua_harta2
	
;nu s-a prins bonusul si atunci trebuie creat un nou numar random pentru numarul de schimbari de directie pana la aparitia unui nou bonus
final_cadere_bonus:
	mov expand_enable, 0
	mov bonus_enable, 0
	mov block_counter, 0
	rdtsc
	xor edx, edx
	div CINCI
	mov random_block_number, edx
	add random_block_number,3
	
continua_harta2:
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer
	
;aici se verifica daca s-a dat click pe un buton de pe ecran si daca s-a dat, pe ce buton s-a dat
;daca suntem pe modul GAME OVER sau pe CONGRATULATION atunci verificam doar butoanele reset si exit
;altfel verificam butoanele de miscare stanga si dreapta

;daca nu se indeplineste nicio conditie, atunci am apasat butonul din stanga
;daca se indeplineste, atunci verificam daca am apasat butonul din dreapta
evt_click:
	cmp GO, 1
	je button_exit_verif
	cmp GO, 2
	je button_exit_verif
	mov eax, [ebp+arg2]
	cmp eax, 380
	jl buton_R
	cmp eax, 430
	jg buton_R
	mov eax, [ebp+arg3]
	cmp eax, 415
	jl buton_R
	cmp eax, 466
	jg buton_R
	cmp xplaca, 10
	jl buton_R
	mov ebx, xplaca
	sub ebx, 10
	mov xplaca, ebx

;daca nu se indeplineste nicio conditie, atunci am apasat butonul din dreapta
;daca se indeplineste, atunci nu am apasat niciun buton
buton_R:
	cmp eax, 475
	jl buton_R_fail
	cmp eax, 525
	jg buton_R_fail
	mov eax, [ebp+arg3]
	cmp eax, 415
	jl buton_R_fail
	cmp eax, 466
	jg buton_R_fail
	mov ebx, xplaca
	add ebx, placa_width_aux
	add ebx, 10
	cmp ebx, area_width
	jg buton_R_fail
	mov ebx, xplaca
	add ebx, 10
	mov xplaca, ebx
	jmp evt_timer
	
buton_R_fail:			;nu am apasat niciun buton
	jmp evt_timer
	
;daca nu se indeplineste nicio conditie, atunci am apasat butonul de exit
;daca se indeplineste, atunci verificam daca am apasat butonul de reset
;daca am apasat butonul de exit, atunci se inchide programul
button_exit_verif:
	mov eax, [ebp+arg2]
	cmp eax, 27
	jl button_reset_verif
	cmp eax, 77
	jg button_reset_verif
	mov eax, [ebp+arg3]
	cmp eax, 415
	jl button_reset_verif
	cmp eax, 466
	jg button_reset_verif
	push 0
	call exit
	
;daca nu se indeplineste nicio conditie, atunci am apasat butonul de reset
;daca se indeplineste, atunci nu am apasat niciun buton
button_reset_verif:
	mov eax, [ebp+arg2]
	cmp eax, 820
	jl button_fail
	cmp eax, 870
	jg button_fail
	mov eax, [ebp+arg3]
	cmp eax, 415
	jl button_fail
	cmp eax, 466
	jg button_fail
	jmp reset_joc
	
;daca am apasat butonul de reset atunci trebuie sa reinitializam pozitia mingii, a placii, sa refacem harta de caramizi
;sa reglam directia mingii in sus, sa reinitializam timer-ul pentru bonusuri si toate celelalte variabile pentru caderea bonusurilor
;si numarul de blocuri distruse
reset_joc:
	mov unghi_x, 0
	mov unghi_y, 10
	mov xball, 445
	mov yball, 355
	mov directie, 0
	mov placa_width_aux, 88
	mov xplaca, 410
	mov timer_placa, 50
	mov expand_enable, 0
	mov block_counter, 0
	mov xbonus, 0
	mov ybonus, 0
	mov bonus_enable, 0
	mov total_blocks, 84
	mov ecx, total_blocks
	lea esi, harta
reface_harta:
	mov byte ptr [esi], 1
	inc esi
	loop reface_harta
	mov GO,0
	jmp continua2
	
;nu s-a atins niciun buton in modul GAME OVER sau CONGRATULATION
button_fail:
	cmp GO, 1
	je game_over
	cmp GO, 2
	je congrats
	
;aici se verifica daca mingea atinge una dintre margini (sus, stanga, dreapta) sau daca exista posibilitatea
;de a atinge placa sau marginea de jos (daca ajunge la nivelul placii - urmeaza sa verifice in atinge_placa daca 
;a atins placa sau marginea de jos)
;daca cade un bonus, atunci este dezactivata functia de distrugere a mingii pentru a nu se confunda cu bonusul
evt_timer:
	mov ebx, yball
	add ebx, ball_height
	mov eax, area_height
	sub eax, 105
	cmp ebx, eax
	jge atinge_placa
	
	mov ebx, yball			;verifica daca a atins marginea de sus
	cmp ebx, 10
	jle schimba_jos2
	
	mov ebx, xball			;verifica daca a atins marginea din stanga
	cmp ebx, 10
	jle schimba_margine
	
	mov eax, area_width
	sub eax, 25
	cmp ebx, eax			;verifica daca a atins marginea din dreapta
	jge schimba_margine
	cmp bonus_enable, 0
	je fara_margine			;daca nu exista bonus, verificam daca mingea atinge o caramida
	jmp directie_verif		;daca exista, controlam doar directia in care merge mingea
	
schimba_margine:			;schimbam unghiul coordonatei x a mingii
	mov eax, 2
	mul unghi_x
	sub unghi_x, eax
	
;aici se verifica daca mingea atinge caramizile
fara_margine:
	mov edi, area
	mov eax, yball
	sub eax, 10
	mov ebx, area_width
	mul ebx
	add eax, xball
	shl eax, 2
	add edi, eax
	cmp dword ptr [edi], 0		;atinge coltul stanga sus al matricei mingii
	jne schimba_jos
	
	mov edi, area
	mov eax, yball
	sub eax, 10
	mov ebx, area_width
	mul ebx
	add eax, xball
	add eax, ball_width
	shl eax, 2
	add edi, eax
	cmp dword ptr [edi], 0		;atinge coltul dreapta sus al matricei mingii
	jne schimba_jos3
	
	mov edi, area
	mov eax, yball
	add eax, ball_height
	add eax, 10
	mov ebx, area_width
	mul ebx
	add eax, xball
	shl eax, 2
	add edi, eax
	cmp dword ptr [edi], 0		;atinge coltul stanga jos al matricei mingii
	jne schimba_sus2
	
	mov edi, area
	mov eax, yball
	add eax, ball_height
	add eax, 10
	mov ebx, area_width
	mul ebx
	add eax, xball
	add eax, ball_width
	shl eax, 2
	add edi, eax
	cmp dword ptr [edi], 0		;atinge coltul dreapta jos al matricei mingii
	jne schimba_sus3
	
;verifica in ce sens merge mingea
directie_verif:
	cmp directie, 0
	je minge_jos
	cmp directie, 1
	je minge_sus
	
;schimbam sensul daca atinge marginea de sus
schimba_jos2:		
	mov directie, 0
	jmp minge_jos
	
	
;verificam contactul dintre minge si sol sau minge si placa
;daca mingea nu atinge placa la timp, atunci jocul se va incheia
;daca mingea atinge placa, atunci acesta isi va schimba directia si unghiul in functie de zona de pe placa pe care a atins-o (5 zone)
atinge_placa:
	mov ebx, xplaca
	sub ebx, 15
	cmp ebx, xball
	jg game_over
	add ebx, 15
	add ebx, placa_width_aux
	cmp ebx, xball
	jl game_over
	
	mov ebx, xplaca
	add ebx, 15
	cmp ebx, xball
	jg dir1
	
	add ebx, 20
	cmp ebx, xball
	jg dir2
	
	mov ebx, xplaca
	add ebx, placa_width_aux
	sub ebx, 15
	cmp ebx, xball
	jl dir4
	
	sub ebx, 35
	cmp ebx, xball
	jl dir3
	
	jmp dir5
	
dir1:
	mov unghi_x, -7
	mov unghi_y, 10
	jmp schimba_sus
dir2:
	mov unghi_x, -3
	mov unghi_y, 10
	jmp schimba_sus
dir3:
	mov unghi_x, 3
	mov unghi_y, 10
	jmp schimba_sus
dir4:
	mov unghi_x, 7
	mov unghi_y, 10
	jmp schimba_sus
dir5:
	mov unghi_x, 0
	mov unghi_y, 10
	jmp schimba_sus
	
schimba_sus:
	mov directie, 1
	jmp minge_sus
	


;se verifica daca colturile de jos ale matricei mingii ating caramizile
;daca da, atunci harta zidului se modifica pentru a scapa de caramizile lovite
;prima data se verifica daca a lovit coltul din stanga, iar apoi pe cel din dreapta	
schimba_sus2:
	lea esi, harta
	mov eax, xball
	sub eax, 30
	mov edx, 0
	mov ebx, block_width
	div ebx
	mov ecx, eax
	mov ebx, 83
	sub ebx, eax
	add esi, ebx
compara_caramida4:
	cmp byte ptr [esi], 0
	je mai_jos1
	mov byte ptr [esi], 0
	dec total_blocks;
	jmp colt_jos_dreapta
mai_jos1:
	sub esi, nr_coloane
	jmp compara_caramida4
	
colt_jos_dreapta:
	mov edi, area
	mov eax, yball
	add eax, ball_height
	add eax, 10
	mov ebx, area_width
	mul ebx
	add eax, xball
	add eax, ball_width
	shl eax, 2
	add edi, eax
	cmp dword ptr [edi], 0
	je schimba_directie2
	
	lea esi, harta
	mov eax, xball
	add eax, ball_width
	sub eax, 30
	mov edx, 0
	mov ebx, block_width
	div ebx
	cmp ecx, eax
	je schimba_directie2
	mov ebx, 83
	sub ebx, eax
	add esi, ebx
compara_caramida5:
	cmp byte ptr [esi], 0
	je mai_jos2
	mov byte ptr [esi], 0
	dec total_blocks;
	jmp schimba_directie2
mai_jos2:
	sub esi, nr_coloane
	jmp compara_caramida5


;se verifica daca coltul din dreapta jos ale matricei mingii atinge caramizile
;daca da, atunci harta zidului se modifica pentru a scapa de caramizile lovite
;daca nu s-a atins coltul din stanga, atunci se va verifica doar coltul din dreapta	
schimba_sus3:
	lea esi, harta
	mov eax, xball
	add eax, ball_width
	sub eax, 30
	mov edx, 0
	mov ebx, block_width
	div ebx
	mov ebx, 83
	sub ebx, eax
	add esi, ebx
compara_caramida6:
	cmp byte ptr [esi], 0
	je mai_jos3
	mov byte ptr [esi], 0
	dec total_blocks;
	jmp schimba_directie2
mai_jos3:
	sub esi, nr_coloane
	jmp compara_caramida6
	
;se verifica daca colturile de sus ale matricei mingii ating caramizile
;daca da, atunci harta zidului se modifica pentru a scapa de caramizile lovite
;prima data se verifica daca a lovit coltul din stanga, iar apoi pe cel din dreapta
schimba_jos:
	lea esi, harta
	mov eax, xball
	sub eax, 30
	mov edx, 0
	mov ebx, block_width
	div ebx
	mov ecx, eax
	mov ebx, 11
	sub ebx, eax
	add esi, ebx
compara_caramida1:
	cmp byte ptr [esi], 0
	je mai_sus1
	mov byte ptr [esi], 0
	dec total_blocks;
	jmp colt_sus_dreapta
mai_sus1:
	add esi, nr_coloane
	jmp compara_caramida1
	
colt_sus_dreapta:
	mov edi, area
	mov eax, yball
	sub eax, 10
	mov ebx, area_width
	mul ebx
	add eax, xball
	add eax, ball_width
	shl eax, 2
	add edi, eax
	cmp dword ptr [edi], 0
	je schimba_directie
	
	lea esi, harta
	mov eax, xball
	add eax, ball_width
	sub eax, 30
	mov edx, 0
	mov ebx, block_width
	div ebx
	cmp ecx, eax
	je schimba_directie
	
	mov ebx, 11
	sub ebx, eax
	add esi, ebx
compara_caramida2:
	cmp byte ptr [esi], 0
	je mai_sus2
	mov byte ptr [esi], 0
	dec total_blocks;
	jmp schimba_directie
mai_sus2:
	add esi, nr_coloane
	jmp compara_caramida2
	
	
;se verifica daca coltul din dreapta sus ale matricei mingii atinge caramizile
;daca da, atunci harta zidului se modifica pentru a scapa de caramizile lovite
;daca nu s-a atins coltul din stanga, atunci se va verifica doar coltul din dreapta
schimba_jos3:
	lea esi, harta
	mov eax, xball
	add eax, ball_width
	sub eax, 30
	mov edx, 0
	mov ebx, block_width
	div ebx
	mov ebx, 11
	sub ebx, eax
	add esi, ebx
compara_caramida3:
	cmp byte ptr [esi], 0
	je mai_sus2
	mov byte ptr [esi], 0
	dec total_blocks;
	jmp schimba_directie
mai_sus3:
	add esi, nr_coloane
	jmp compara_caramida3
	
;aici se face schimbarea directiei in care merge mingea atunci cand se loveste de caramizi
;tot aici se face verificarea cu numarul de lovituri efectuate de la ultima cadere de bonus pentru a da un nou bonus
schimba_directie:
	dec directie
	inc block_counter
	mov ebx, random_block_number
	cmp block_counter, ebx
	je cadere_bonus1
	jmp minge_jos
	
schimba_directie2:
	inc directie
	inc block_counter
	mov ebx, random_block_number
	cmp block_counter, ebx
	je cadere_bonus2
	jmp minge_sus
	
;aici este controlat sensul in care zboara mingea
minge_jos:					;de sus in jos
	mov ebx, yball
	add ebx, unghi_y
	mov yball, ebx
	mov ebx, xball
	add ebx, unghi_x
	mov xball, ebx
	jmp continua
	
minge_sus:					;de jos in sus
	mov ebx, yball
	sub ebx, unghi_y
	mov yball, ebx
	mov ebx, xball
	add ebx, unghi_x
	mov xball, ebx
	jmp continua
	
;aici cream cele 2 bonusuri care vor cadea cu putin mai sus decat locul in care a lovit mingea ultima caramida
;alegerea dintre cele 2 bonusuri se va face random
;avem cate un salt pentru fiecare tip de schimbare de directie (de sus in jus si de jos in sus)
cadere_bonus1:
	mov ebx, xball
	mov xbonus, ebx
	mov ebx, yball
	sub ebx, bonus_height
	sub ebx, bonus_height
	mov ybonus, ebx
	rdtsc
	xor edx, edx
	div DOI
	mov random_bonus, edx
	cmp random_bonus, 0
	je desen_expand
	cmp random_bonus, 1
	je desen_shrink
desen_expand:
	make_object_macro 'F', area, xbonus, ybonus
	jmp continua_cadere_bonus
desen_shrink:
	make_object_macro 'G', area, xbonus, ybonus
	jmp continua_cadere_bonus
continua_cadere_bonus:
	mov bonus_enable, 1 
	jmp minge_jos
	
cadere_bonus2:
	mov ebx, xball
	mov xbonus, ebx
	mov ebx, yball
	sub ebx, bonus_height
	sub ebx, bonus_height
	mov ybonus, ebx
	rdtsc
	xor edx, edx
	div DOI
	mov random_bonus, edx
	cmp random_bonus, 0
	je desen_expand2
	cmp random_bonus, 1
	je desen_shrink2
desen_expand2:
	make_object_macro 'F', area, xbonus, ybonus
	jmp continua_cadere_bonus2
desen_shrink2:
	make_object_macro 'G', area, xbonus, ybonus
	jmp continua_cadere_bonus2
continua_cadere_bonus2:
	mov bonus_enable, 1
	jmp minge_sus

continua:
	cmp total_blocks, 0
	je congrats				;verificam daca s-au distrus toate caramizile. Daca da, atunci jucatorul a castigat
	cmp expand_enable, 1
	je numara_timp
	jmp continua2
numara_timp:				;tine evidenta timpului in care placa se modifica in functie de bonus si salveaza 
	cmp random_bonus, 0		;in placa_width_aux latimea placii la acel moment
	je placa_marita
	cmp random_bonus, 1
	je placa_micsorata
placa_marita:
	mov ebx, placa_expand_width
	jmp continua_numara_timp
placa_micsorata:
	mov ebx, placa_shrink_width
	jmp continua_numara_timp
continua_numara_timp:
	mov placa_width_aux, ebx
	dec timer_placa
	cmp timer_placa, 0
	je timp_expirat			;verificam daca timpul bonusului a expirat
	jmp continua2
timp_expirat:				;daca timpul de bonus a expirat, atunci placa isi revine la normal, se reinitializeaza timerul
	mov ebx, placa_width	;si se gaseste un nou numar random care sa arate dupa cate lovituri de caramizi va cadea un nou bonus
	mov placa_width_aux, ebx
	mov timer_placa, 50
	mov expand_enable, 0
	rdtsc
	xor edx, edx
	div CINCI
	mov random_block_number, edx
	add random_block_number,3
	jmp continua2

;daca jucatorul pierde, va aparea un mesaj pe ecran, un buton de reset si un buton de iesire
game_over:
	mov GO, 1
	make_object_macro 'H', area, 0, 123
	make_text_macro 'G', area, 410, 200, 0FFFFFFH
	make_text_macro 'A', area, 420, 200, 0FFFFFFH
	make_text_macro 'M', area, 430, 200, 0FFFFFFH
	make_text_macro 'E', area, 440, 200, 0FFFFFFH
	make_text_macro ' ', area, 450, 200, 0FFFFFFH
	make_text_macro 'O', area, 460, 200, 0FFFFFFH
	make_text_macro 'V', area, 470, 200, 0FFFFFFH
	make_text_macro 'E', area, 480, 200, 0FFFFFFH
	make_text_macro 'R', area, 490, 200, 0FFFFFFH
	make_object_macro 'J', area, 27, 415
	make_object_macro 'J', area, 820, 415
	make_text_macro 'E', area, 37, 430, 0
	make_text_macro 'X', area, 45, 430, 0
	make_text_macro 'I', area, 53, 430, 0
	make_text_macro 'T', area, 60, 430, 0
	
	make_text_macro 'R', area, 825, 430, 0
	make_text_macro 'E', area, 833, 430, 0
	make_text_macro 'S', area, 841, 430, 0
	make_text_macro 'E', area, 849, 430, 0
	make_text_macro 'T', area, 857, 430, 0
	jmp continua2
	
;daca jucatorul castiga, va aparea un mesaj pe ecran, un buton de reset si un buton de iesire
;jucatorul castiga daca a distrus toate caramizile
congrats:
	mov GO, 2
	make_object_macro 'I', area, 0, 123
	make_text_macro 'C', area, 410, 200, 0
	make_text_macro 'O', area, 420, 200, 0
	make_text_macro 'N', area, 430, 200, 0
	make_text_macro 'G', area, 440, 200, 0
	make_text_macro 'R', area, 450, 200, 0
	make_text_macro 'A', area, 460, 200, 0
	make_text_macro 'T', area, 470, 200, 0
	make_text_macro 'U', area, 480, 200, 0
	make_text_macro 'L', area, 490, 200, 0
	make_text_macro 'A', area, 500, 200, 0
	make_text_macro 'T', area, 510, 200, 0
	make_text_macro 'I', area, 520, 200, 0
	make_text_macro 'O', area, 530, 200, 0
	make_text_macro 'N', area, 540, 200, 0
	
	make_object_macro 'J', area, 27, 415
	make_object_macro 'J', area, 820, 415
	
	make_text_macro 'E', area, 37, 430, 0
	make_text_macro 'X', area, 45, 430, 0
	make_text_macro 'I', area, 53, 430, 0
	make_text_macro 'T', area, 60, 430, 0
	
	make_text_macro 'R', area, 825, 430, 0
	make_text_macro 'E', area, 833, 430, 0
	make_text_macro 'S', area, 841, 430, 0
	make_text_macro 'E', area, 849, 430, 0
	make_text_macro 'T', area, 857, 430, 0
	jmp continua2
	
;aici se deseneaza placa (din 2 bucati) , mingea si cele 2 butoane de miscare a placii
continua2:
	make_object_macro 'A', area, xball, yball ;mingea
	make_object_macro 'C', area, xplaca, 375  ;placa margini
	make_object_macro 'D', area, xplaca, 375  ;placa mijloc
	make_object_macro 'L', area, 380, 415	  ;buton stanga
	make_object_macro 'R', area, 475, 415	  ;buton dreapta
	jmp final_draw

final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;terminarea programului
	push 0
	call exit
end start
