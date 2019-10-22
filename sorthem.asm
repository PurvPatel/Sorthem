%include "asm_io.inc"
extern rconf

SECTION .data
ERR1:  db "incorrect number of command line arguements",10,0
ERR2:  db "incorrect command line arguement",10,0

FIRST: db "          intial configuration",10,0       ;wrote strings with spaces to match output from given output
LAST:  db "          final configuration" ,10,0 

ARR:   dd 0,0,0,0,0,0,0,0,0

DISK1: db "                    o|o"          ,10,0
DISK2: db "                   oo|oo"         ,10,0
DISK3: db "                  ooo|ooo"        ,10,0
DISK4: db "                 oooo|oooo"       ,10,0
DISK5: db "                ooooo|ooooo"      ,10,0
DISK6: db "               oooooo|oooooo"     ,10,0
DISK7: db "              ooooooo|ooooooo"    ,10,0 
DISK8: db "             oooooooo|oooooooo"   ,10,0
DISK9: db "            ooooooooo|ooooooooo"  ,10,0
DISKX: db "          XXXXXXXXXXXXXXXXXXXXXXX",10,0

SECTION .bss
SIZE: resd 1
ADDR: resd 1

SECTION .text
global asm_main

showp:
	enter 0,0
	pusha

	mov eax, [ebp+12]                 ;Getting number of disks to get address of last disk 
	mov ebx, 4                       
	mul ebx                           ;eax = number of disks * 4 
	sub eax, dword 4                  ;eax = eax - 4
 	mov ebx, [ebp+8]                  ;ebx = adress of first element of passed array 
	add ebx, eax                      ;storing address of last disk in ebx, ebx = ebx + eax	
	
	mov ecx, [ebp+12]                 ;getting number of disks
	call print_nl	
loop:
	cmp ecx, dword 0                  ;Terminating condition of loop
	je END2
 
	cmp [ebx], dword 1                ;checking if element = 1
	je disk1
	cmp [ebx], dword 2                ;checking if element = 2
	je disk2
	cmp [ebx], dword 3                ;checking if element = 3
	je disk3
	cmp [ebx], dword 4                ;checking if element = 4
	je disk4
	cmp [ebx], dword 5                ;checking if element = 5
	je disk5
	cmp [ebx], dword 6                ;checking if element = 6
	je disk6
	cmp [ebx], dword 7                ;checking if element = 7
	je disk7
	cmp [ebx], dword 8                ;checking if element = 8
	je disk8
	cmp [ebx], dword 9                ;checking if element = 9
	je disk9	
cont2:
	sub ebx, dword 4                  ;decrementing element, ebx = ebx - 4
	dec ecx                           ;decrementing counter ecx = ecx - 1 
	jmp loop
disk1:                                    ;showing  DISK1
	mov eax, DISK1
	call print_string
	jmp cont2
disk2:                                    ;showing DISK2
	mov eax, DISK2
	call print_string
	jmp cont2
disk3:                                    ;showing DISK3
	mov eax, DISK3
	call print_string
	jmp cont2
disk4:                                    ;showing DISK4
	mov eax, DISK4
	call print_string
	jmp cont2
disk5:                                    ;showing DISK5
 	mov eax, DISK5
	call print_string
	jmp cont2
disk6:                                    ;showing DISK6
	mov eax, DISK6
	call print_string
	jmp cont2
disk7:                                    ;showing DISK7
	mov eax, DISK7
	call print_string
	jmp cont2
disk8:                                    ;showing DISK8
	mov eax, DISK8
	call print_string
	jmp cont2
disk9:                                    ;showing DISK9
	mov eax, DISK9
	call print_string
	jmp cont2 
END2:
	mov eax, DISKX                    ;showing DISKX
	call print_string
	call read_char                    ;waiting for user to depress a key 
	
	popa                              ;return
	leave
	ret

sorthem:
	enter 0,0                         ;setup routine
	pusha

	mov eax, [ebp+8]                  ;eax = address of array
	mov ebx, [ebp+12]                 ;ebx = number of disks

	cmp ebx, dword 2                  ;terminating condition: does sorthem calls until ebx = 2 
	jne rcall
cont3:
	mov ecx, dword 1                  ;intializing loop counter
	mov eax, dword [ebp+8]            ;resetting eax = address of array after recall
loop2:	
	cmp ecx, dword [ebp+12]           ;loop terminating condition, ecx = number of disks
	je END3
	mov edx, dword [eax+4]            ;edx = element at address eax + 4
	cmp [eax], edx                    ;checking if elements need to be swapped
	jg loopend

	mov ebx, [eax]                    ;swapping two elements
	mov edx, [eax+4]
	mov [eax], edx
	mov [eax+4], ebx

loopend:
	inc ecx                           ;incrementing counter
	add eax, 4                        ;incrementing element address of array
	jmp loop2
END3:
	mov eax, dword [SIZE]             ;showing peg after each swapping     
	push eax
	mov eax, dword [ADDR]
	push eax
	call showp
	add esp,8

	popa
	leave
	ret
rcall:
	add eax, dword 4                  ;passing next element to sorthem: eax = eax + 4
	sub ebx, dword 1                  ;decrementing size of array: ebx = ebx - 1
	push ebx                              
	push eax
	call sorthem                      ;recursively calling sorthem 
	pop eax
	pop ebx

	jmp cont3                         ;jumping back to swapping after recursive calls are done 

asm_main:
	enter 0,0                          ;setup routine
	pusha
Try1:
	mov eax, dword [ebp+8]             ;Checking argc[] = 2 
	cmp eax, dword 2
	jne error1
Try2:
	mov ebx, dword [ebp+12]            ;getting argv[1]
	mov eax, dword [ebx+4]

	mov bl, byte [eax+1]               ;checking length of argv[1]
	cmp bl, byte 0
	jne error2

	mov bl, byte [eax]                 ;checking if argv[1] is in range [2,9]
	sub bl, '0'
	mov eax,0 
	mov al, bl
	cmp eax, dword 2
	jl error2
	cmp eax, dword 9
	jg error2


	push eax                           ;generating random peg  
	mov ebx, ARR
	push ebx
	call rconf
	pop ebx
	pop ecx
	
	mov [SIZE], ecx                    ;storing peg address and size for use in sorthem
	mov [ADDR], ebx

	call print_nl
	call print_nl

	mov eax, FIRST                     ;intial configuration
	call print_string
	push ecx
	push ebx
	call showp
	pop ebx
	pop ecx
	
	push ecx                           ;showing peg again to match given outputs 
	push ebx
	call showp
	pop ebx
	pop ecx
 
	push ecx                           ;sorting peg
	push ebx
	call sorthem
	pop ebx
	pop ecx

	mov eax, LAST                      ;showing final configuration 
	call print_string
	push ecx
	push ebx
	call showp
	add esp,8

	jmp END

error1:                                    ;showing ERR1: wrong number of arguements
	mov eax, ERR1
	call print_string
	jmp END
error2:                                    ;showing ERR2: invalid arguement
	mov eax, ERR2
	call print_string
END:                                       ;return and end program
	popa
	leave
	ret		
