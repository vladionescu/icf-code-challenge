section    .text
    global start   ;must be declared for linker (ld)
    
start:              ;linker entry point
    xor     eax, eax
    xor     edx, edx
    mov     eax, [nr_amounts] ;divide the number of elements in the amounts
    mov     ecx, 4          ;array by 4, because the current lenght in
    div     ecx             ;nr_amounts is too long (it assumes each element
    mov     [nr_amounts], eax ;is 1 byte when in fact they are 4 bytes long)

;debug - print the amouns array (no separators between elements)
;    mov     eax, amounts    ;array to print
;    mov     ebx, 4          ;size of each element
;    mov     dl, [nr_amounts];size of array
;    call    print_int_array
;
;    call    print_newline

;debug - print the initial denoms array (no separators between elements)
;    mov     eax, denoms     ;array to print
;    mov     ebx, 1          ;size of each element
;    mov     dl, [nr_denoms] ;size of array
;    call    print_int_array

    call    sort_denoms

;    call    print_newline
;
;debug - print the sorted denoms array (no separators between elements)
;    mov     eax, denoms     ;array to print
;    mov     ebx, 1          ;size of each element
;    mov     dl, [nr_denoms] ;size of array
;    call    print_int_array
;
;    call    print_newline

    xor     ecx, ecx
loop_through_amounts:
    push    ecx
    imul    ecx, 4
    
    mov     eax, [amounts+ecx]
    mov     ebx, 4
    call    print_int

    mov     eax, [amounts+ecx]
    call    find_min_coins

    pop     ecx

    call    print_comma

    mov     ebx, 1
    mov     eax, [coins]
    call    print_int

    inc     cl
    cmp     cl, [nr_amounts]
    je      loop_through_amounts_done
    call    print_newline
    ;call    print_comma
    jmp     loop_through_amounts

loop_through_amounts_done:
    call    print_newline

    push    dword 0     ;exit code 0
    mov     eax, 1      ;system call number (sys_exit)
    sub     esp, 4      ;extra 4 bytes
    int     0x80        ;call kernel
    ret

;sort denoms in ascending order
sort_denoms:
    xor     eax, eax
    xor     ecx, ecx         

sort_loop_outer:            ;iterate through all elements
    cmp     cl, [nr_denoms] ;stop if we are at the end of the array
    je      near exit_func

    mov     ebx, 1          ;set the inner loop counter to be the current
    add     ebx, ecx        ;array index + 1

sort_loop_inner:            ;swap larger values after this point with this element
    cmp     bl, [nr_denoms] ;stop swapping if we are at the end of the array
    je      near sort_loop_outer_go_again
    
    mov     al, [denoms+ecx]  ;pick the current array element (outer loop)
    mov     dl, [denoms+ebx]  ;pick an array element from ahead (inner loop)
    cmp     al, dl          ;if the further ahead element is larger than
    jl      swap_elements   ;the current one, swap their places

sort_loop_inner_continue:
    inc     ebx             ;go to next array element
    jmp     sort_loop_inner

sort_loop_outer_go_again:
    inc     ecx             ;go to next array element
    jmp     sort_loop_outer

swap_elements:
    mov     [denoms+ecx], dl
    mov     [denoms+ebx], al
    jmp     sort_loop_inner_continue

;find the minimum number of coins of any combination of
;values in the denoms array, in order to add up to the given
;amount
;
;eax = amount
find_min_coins:
    push    ecx

    xor     ebx, ebx
    xor     ecx, ecx
    mov     [coins], ecx
    mov     esi, eax            ;prime ESI with the initial amount 

find_min_coins_loop:
    cmp     cl, [nr_denoms]
    je      near exit_find_min_coins

    mov     bl, [denoms+ecx]    ;put the current denomination in EBX
    mov     eax, esi            ;save the amount in ESI while we work on EAX
    xor     edx, edx
    div     ebx                 ;EAX = amount / denomination

    cmp     eax, 0                       ;if we can fit the denomination in the
    je      find_min_coins_loop_continue ;current amount, count up the total coins
                                         ;else continue to the next denomination

    add     [coins], eax

    mov     esi, edx
    cmp     eax, 0
    je      near exit_find_min_coins    ;no amount left over, we did it!

find_min_coins_loop_continue:
    inc     cl
    jmp     find_min_coins_loop

exit_find_min_coins:
    pop     ecx
    ret

;eax = address of array to print
;dl = size of array (nr of elements)
;ebx = size of each element in bytes
print_int_array:
    xor     ecx, ecx         

print_int_array_loop:
    cmp     cl, dl  ;stop if we are at the end of the array
    je      near exit_func

    push    ecx
    imul    ecx, ebx
    
    push    eax
    mov     eax, [eax+ecx]  ;pick the current array element
    call    print_int
    pop     eax

    pop     ecx
    inc     ecx             ;go to next array element
    jmp     print_int_array_loop 

;convert int to str and write()
;
;eax = int to print
;ebx = size of int in bytes
print_int:              
    push    ebx
    push    ecx
    push    edx

    mov     ecx, 4          ;EBX = 4 - EBX
    sub     ecx, ebx
    mov     ebx, ecx
    imul    ebx, 8          ;EBX is given in bytes, multiply by 8 to bitshift by bytes

    mov     edx, 0xffffffff ;mask off the incoming 4 bytes in EAX to keep
    mov     cl, bl          ;just the number of bytes specified by the value
    shr     edx, cl         ;in EBX
    and     eax, edx        

    mov     ecx, 0          ;count digits in number to print

print_loop1:                ;lop off the LSDs and push them on the stack
    call    dividebyten

    add     eax, 48         ;add 48 (ascii "0" to the int to get the ascii nr)
    push    dword eax       ;store the digit to write on the stack

    mov     eax, ebx        ;prepare to divide the quotient (what is left of
                            ;the original integer after lopping off the LSD)

    cmp     eax, 0          ;keep going until we have no digits left
    jnz     print_loop1

print_loop2:                ;write the digits to STDOUT
    pop     eax             ;get the MSD (most significant digit)
    mov     [var1], eax     ;store the data to write in memory

    push    dword 1         ;write a single byte
    push    dword var1      ;buffer to write
    push    dword 1         ;stdout
    call    write
    add     esp, 12         ;clean up the stack

    dec     ecx             ;next digit
    jne     print_loop2

    pop     edx
    pop     ecx
    pop     ebx
    ret

;divide EAX by 10, storing quotient in EBX and remainder in EAX
;limited to dividend max 10^32-1
;
;eax = dividend
dividebyten:
    inc     ecx             ;count digits in number to print
    mov     ebx, 10
    xor     edx, edx
    div     ebx

    xor     ebx, ebx        ;store the quotient in EBX
    mov     ebx, eax        
    mov     eax, edx        ;store the remainder in EAX

    ret

print_newline:
    push    dword 2         ;write a single byte
    push    dword newline   ;buffer to write
    push    dword 1         ;stdout
    call    write
    add     esp, 12         ;clean up the stack
    ret

print_comma:
    push    dword 1         ;write a single byte
    push    dword comma     ;buffer to write
    push    dword 1         ;stdout
    call    write
    add     esp, 12         ;clean up the stack
    ret

write:
    mov     eax, 4          ;system call number (sys_write)
    int     0x80            ;call kernel
    ret

exit_func:
    ret

section    .data
    denoms      db 2, 10, 20, 5, 2, 1   ;denominations available to us
    nr_denoms   db $ - denoms           ;number of denominations
    amounts     dd 46, 41, 20, 73, 91, 78, 1200000    ;amounts to solve for
;    amounts     dd 46                   ;amounts to solve for, keeping it simple
;    amounts     dd 1200000             ;amounts to solve for, keeping it simple
    nr_amounts  db $ - amounts          ;number of amounts (this is divided by 4 in the code
                                        ;because each amount is 4 bytes)
    var1        db 0
    coins       db 0

section    .rodata
    comma       db 0x2c
    newline     db 0xa, 0xd
