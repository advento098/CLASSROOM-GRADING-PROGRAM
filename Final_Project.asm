include 'emu8086.inc'

.model small
.stack 100h

.data
    ; Define ASCII art of a graduation cap manually
    
     WELCOME_MSG   DB 0Dh, 0Ah,                                                                , 0Dh, 0Ah
                   DB '    .------------------------------------------------------------.   ', 0Dh, 0Ah
                   DB '    |  /$$$$$$  /$$$$$$$   /$$$$$$  /$$$$$$$  /$$$$$$$$          |   ', 0Dh, 0Ah
                   DB '    | /$$__  $$| $$__  $$ /$$__  $$| $$__  $$| $$_____/          |   ', 0Dh, 0Ah
                   DB '    || $$  \__/| $$  \ $$| $$  \ $$| $$  \ $$| $$                |   ', 0Dh, 0Ah
                   DB '    || $$ /$$$$| $$$$$$$/| $$$$$$$$| $$  | $$| $$$$$             |   ', 0Dh, 0Ah
                   DB '    || $$|_  $$| $$__  $$| $$__  $$| $$  | $$| $$__/             |   ', 0Dh, 0Ah
                   DB '    || $$  \ $$| $$  \ $$| $$  | $$| $$  | $$| $$                |   ', 0Dh, 0Ah
                   DB '    ||  $$$$$$/| $$  | $$| $$  | $$| $$$$$$$/| $$$$$$$$          |   ', 0Dh, 0Ah
                   DB '    | \______/ |__/  |__/|__/  |__/|_______/ |________/          |   ', 0Dh, 0Ah
                   DB '    |                                                            |   ', 0Dh, 0Ah
                   DB '    |  /$$$$$$   /$$$$$$  /$$$$$$$  /$$$$$$$$ /$$$$$$$$ /$$$$$$$ |   ', 0Dh, 0Ah
                   DB '    | /$$__  $$ /$$__  $$| $$__  $$|__  $$__/| $$_____/| $$__  $$|   ', 0Dh, 0Ah
                   DB '    || $$  \__/| $$  \ $$| $$  \ $$   | $$   | $$      | $$  \ $$|   ', 0Dh, 0Ah
                   DB '    ||  $$$$$$ | $$  | $$| $$$$$$$/   | $$   | $$$$$   | $$$$$$$/|   ', 0Dh, 0Ah
                   DB '    | \____  $$| $$  | $$| $$__  $$   | $$   | $$__/   | $$__  $$|   ', 0Dh, 0Ah
                   DB '    | /$$  \ $$| $$  | $$| $$  \ $$   | $$   | $$      | $$  \ $$|   ', 0Dh, 0Ah
                   DB '    ||  $$$$$$/|  $$$$$$/| $$  | $$   | $$   | $$$$$$$$| $$  | $$|   ', 0Dh, 0Ah
                   DB '    | \______/  \______/ |__/  |__/   |__/   |________/|__/  |__/|   ', 0Dh, 0Ah
                   DB '    --------------------------------------------------------------   ', 0Dh, 0Ah, 0

   
   
   
    N               DW  ?                   ; Number of students
    GRADE           DB 10 DUP (?)           ; Marks of students (max 10 students)
    ID              DB 10 DUP (?)           ; IDs of students (max 10 students)
    NAME_INITIALS   DB 10 DUP ('$')         ; Initials of students (max 10 students)
    
    MSG_TITLE       DB 0Dh, 0Ah, '*********************** Student Grades Management System ***********************$', 0
    MSG1            DB 'Enter the number of students (DOES NOT EXCEED 9): $', 0
    MSG2            DB 0Dh, 0Ah, 'Enter the ID of student: $', 0
    MSG3            DB 0Dh, 0Ah, 'Enter the grade of student: $', 0
    MSG5            DB 0Dh, 0Ah, 'Enter the name initial of student: $', 0   
    HR              DB 0Dh, 0Ah, '*******************Sorted Marks***********************$', 0
    MSG4            DB 0Dh, 0Ah, 'ID    INITIAL    GRADE    REMARKS$', 0Dh, 0Ah, 0
    PASSED_MSG      DB 'PASSED$', 0
    FAILED_MSG      DB 'FAILED$', 0
    THANK_YOU_MSG   DB 0Dh, 0Ah, 'Thank you for using the Student Grades Management System!$', 0

.code
main proc
    mov ax, @data
    mov ds, ax
    
    ; Print welcome message
    LEA  SI, WELCOME_MSG
    CALL PRINT_STRING
    
    ; Display title
    mov dx, offset MSG_TITLE
    mov ah, 09h
    int 21h
    
    ; Add line spacing
    mov dl, 0DH    ; CR character
    mov ah, 02h    ; Function to output character
    int 21h
    
    mov dl, 0AH    ; LF character
    int 21h
    
    ; Read number of students
    lea dx, MSG1
    mov ah, 09h
    int 21h

    ; Input number of students
    mov ah, 01h
    int 21h
    sub al, '0'
    xor ah, ah
    mov N, ax

    ; Loop to read ID, initials, and grades for each student
    xor di, di

input_loop:
    ; Read ID
    lea dx, MSG2
    mov ah, 09h
    int 21h

    ; Input ID
    mov ah, 01h
    int 21h
    mov ID[di], al

    ; Read initial
    lea dx, MSG5
    mov ah, 09h
    int 21h

    ; Input initial
    mov ah, 01h
    int 21h
    mov NAME_INITIALS[di], al

    ; Read grades
    lea dx, MSG3
    mov ah, 09h
    int 21h

    ; Input grades
    mov ah, 01h
    int 21h
    sub al, '0'
    mov GRADE[di], al

    ; Print new line
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    

    inc di
    cmp di, N
    jne input_loop

    ; SORTING THEM ACCORDING TO IDS USING BUBBLE SORT 
    dec N            
    mov cx, N       

outer:
    mov si, 0       

inner:
    mov al, ID[si]
    mov dl, GRADE[si]
    mov bl, NAME_INITIALS[si]
    inc si
    cmp ID[si], al
    ja skip
    xchg al, ID[si]
    mov ID[si-1], al
    xchg dl, GRADE[si]
    mov GRADE[si-1], dl
    xchg bl, NAME_INITIALS[si]
    mov NAME_INITIALS[si-1], bl

skip:
    cmp si, cx
    jl inner
    loop outer

    inc N

    ; Display student data
    mov dx, offset MSG4
    mov ah, 09h
    int 21h
    
    mov dl, ' '
    call print_char
    
    ; Loop to display data
    xor di, di

display_loop:
    ; New line
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    
    ; New line
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    ; Display ID
    mov dl, ID[di]
    call print_char

    ; Display spaces
    mov dl, ' '
    call print_char
    call print_char
    call print_char
    call print_char
    call print_char

    ; Display initial
    mov dl, NAME_INITIALS[di]
    call print_char

    ; Display spaces
    mov dl, ' '
    call print_char
    call print_char
    call print_char
    call print_char
    call print_char
    call print_char
    call print_char
    call print_char
    call print_char
    call print_char

    ; Display grades
    mov dl, GRADE[di]
    add dl, '0'
    call print_char

    ; Display spaces
    mov dl, ' '
    call print_char
    call print_char
    call print_char
    call print_char
    call print_char
    call print_char
    call print_char
    call print_char

    ; Check grade and display remarks
    mov al, GRADE[di]
    cmp al, 1
    jg  passed
    lea dx, FAILED_MSG
    mov ah, 09h
    int 21h
    jmp continue_display

passed:
    lea dx, PASSED_MSG
    mov ah, 09h
    int 21h

continue_display:
    ; New line
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    inc di
    cmp di, N
    jne display_loop

    ; Display thank you message
    mov dx, offset THANK_YOU_MSG
    mov ah, 09h
    int 21h

    ; New line
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    ; Exit program
    mov ah, 4Ch
    int 21h

main endp
 
print_line proc
    mov ah, 09h     ; Function to print string
    int 21h
    ret
print_line endp

DEFINE_PRINT_STRING

print_char proc
    mov ah, 02h
    int 21h
    ret
print_char endp

end main
