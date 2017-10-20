section    .text
    global start   ;must be declared for linker (ld)
    
start:              ;tells linker entry point
; In macOS / BSD the args are pushed to the stack
; instead of being taken from registers (Linux style).
;   mov    edx,len   ;message length
;   mov    ecx,msg   ;message to write
;   mov    ebx,1     ;file descriptor (stdout)
    push    dword len     ;message length (4 bytes)
    push    dword msg     ;message to write (4 bytes)
    push    dword 1       ;file descriptor (stdout) (4 byte)

    mov     eax,4       ;system call number (sys_write)
    sub     esp,4       ;BSD wants an extra 4 bytes on the stack
                        ;this is invisible when calling functions
    int     0x80        ;call kernel
    add     esp,16      ;clean up the stack
    
    push    dword 0     ;exit code 0
    mov     eax,1       ;system call number (sys_exit)
    sub     esp,4       ;extra 4 bytes
    int     0x80        ;call kernel

section    .data
    msg db 'Hello, world!', 0xa  ;our dear string
    len equ $ - msg    ;length of our dear string
