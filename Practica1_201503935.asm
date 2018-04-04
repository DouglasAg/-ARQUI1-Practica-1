
ORG 100h

inicio:
    xor eax, eax
    mov [numcarcalcu], eax
    mov [numcarfactor], eax
    mov [numcarcarga], eax
    jmp menu

menu:
    mov edi, [cero]
    call limpiar
    mov dx, encabezado
    call escribir
    mov dx, mostrarmenu
    call escribir


    xor eax, eax



    mov [num1], eax
    mov [num2], eax
    mov [resultado], eax
    xor ax, ax
    mov [signum1], ax
    mov [signum2], ax
    mov [sigres], ax

    mov ah, 01
    int 21h

    cmp al, 49
    je cargar

    cmp al, 50
    je modocalculadora

    cmp al, 51
    je factorial

    cmp al, 52
    je reporte

    cmp al, 53
    je salir  
    jne opcionno


%macro leerarchivo 3
    ; 1 ruta archivo, 2 contenedor de los datos archivo
    ; 3 se pondra el numero de caracteres leidos
    ;limpiar ax,cx,dx
    xor ax, ax
    xor cx, cx
    xor dx, dx
    ;abrir archivo
    mov ah, 3dh
    mov cx, 00
    mov dx, %1
    int 21h
    ;archivo no existe
    jc noarchivo
    ;archivo si existe se lee
    mov bx, ax
    mov ah, 3fh
    mov cx, 255
    mov dx, [%2]
    int 21h

    ;numero de caracteres
    mov [%3], ax

    mov ah, 3eh
    int 21h
%endmacro

%macro escribir_reporte 3
    ; 1 nombre archivo, 2 numero de caracters,
    ; 3 texto a escribir
    ; crear archivo
    mov ah, 3ch
    mov cx, 0
    mov dx, %1
    int 21h
    jc menu
    mov bx, ax
    mov ah, 3eh
    int 21h

    ;abrir el archivo
    mov ah,3dh
    mov al,1h ;Abrimos el archivo en solo escritura.
    mov dx, %1
    int 21h
    jc menu ;Si hubo error

    ;Escritura de archivo
    mov bx,ax ; mover hadfile
    mov cx,[%2] ;num de caracteres a grabar
    mov dx,%3
    mov ah,40h
    int 21h
    
    cmp cx,ax
    jne menu ;error salir
    mov ah,3eh  ;Cierre de archivo 
    int 21h
%endmacro

cargar:
    call limpiar
    mov dx, iniciocarga
    call escribir
    mov dl, [cero]
    mov [sinerror], dl
    mov [numcar], dl
    
    xor ecx, ecx
    xor esi, esi
    xor eax, eax
    xor ebx, ebx
    xor edx, edx

    mov [num1], eax
    mov [num2], eax
    mov [resultado], eax
    xor ax, ax
    mov [signum1], ax
    mov [signum2], ax
    mov [sigres], ax

    mov ah, 3fh
    mov bx, 00
    mov cx, 100
    mov dx, [textoentrada]
    int 21h
    
    leerarchivo rutaprueba, textoleido, numcaracteres
   
    mov esi, [textoleido]
    jmp comporbarcaracter
    

comporbarcaracter:
    lodsb
    cmp al, 32
    je repetircomp
    cmp al, 43
    je repetircomp
    cmp al, 42
    je repetircomp
    cmp al, 45
    je repetircomp
    cmp al, 47
    je repetircomp
    cmp al, 48
    je repetircomp
    cmp al, 49
    je repetircomp
    cmp al, 50
    je repetircomp
    cmp al, 51
    je repetircomp
    cmp al, 52
    je repetircomp
    cmp al, 53
    je repetircomp
    cmp al, 54
    je repetircomp
    cmp al, 55
    je repetircomp
    cmp al, 56
    je repetircomp
    cmp al, 57
    je repetircomp
    cmp al, 59
    je repetircomp
    jne caracternovalido

caracternovalido:
    mov [carac], al
    mov dx, msjcaracterinvalid
    call escribir
    mov ah, 02h
    mov dl, [carac]
    int 21h
    mov al,[uno]
    mov [sinerror], al
    jmp repetircomp


repetircomp:
    mov dl, [numcar]
    add dl, [uno]
    mov [numcar], dl
    

    mov al, [numcar]
    mov bl, [numcaracteres]
    cmp al, bl
    je cargacomp
    jne comporbarcaracter

cargacomp:
    mov ah, 08
    int 21h
    mov al, [sinerror]
    cmp al, [cero]
    je cargaintermedio
    jne cargar

cargaintermedio:
    mov dl, [cero]
    mov [numcar], dl
    xor si, si
    mov si, [textoleido]
    jmp cargaoperar

cargaoperar:
    lodsb
    cmp al, 32 ;espacio
    je cargasiguiente
    cmp al, 43; +
    je cargaoperdor
    cmp al, 42; *
    je cargaoperdor
    cmp al, 45; -
    je cargaoperdor
    cmp al, 47; /
    je cargaoperdor
    cmp al, 48;48=0 - 57=9
    je carganumero
    cmp al, 49
    je carganumero
    cmp al, 50
    je carganumero
    cmp al, 51
    je carganumero
    cmp al, 52
    je carganumero
    cmp al, 53
    je carganumero
    cmp al, 54
    je carganumero
    cmp al, 55
    je carganumero
    cmp al, 56
    je carganumero
    cmp al, 57
    je carganumero
    cmp al, 59; 59=;
    je cargasiguiente
 
carganumero:
    mov bl, [cero]
    mov [signum1], bl
    sub al, 30h
    mov [decenas], al
    lodsb
    sub al, 30h
    mov [unidades], al
    xor eax, eax
    mov eax, [decenas]
    mul dword [diez]
    add eax, [unidades]

    
    push eax

    mov dl, [numcar]
    add dl, [uno]
    mov [numcar], dl

    xor ax, ax
    mov ax, [signum1]
    push ax
    jmp cargasiguiente

cargaoperdor:
    mov [operacionseigno], al
    xor ax, ax
    xor al, al
    pop ax
    mov [signum2], al
 
    xor eax, eax
    pop eax
    mov [num2], eax


    xor ax, ax
    xor al, al
    pop ax
    mov [signum1], al
  
    xor eax, eax
    pop eax
    mov [num1], eax
   

    mov al, [operacionseigno]
   
    cmp al, 43; +
    je suma2
    cmp al, 45
    je resta2
    cmp al, 42
    je multiplicacion2
    cmp al, 47
    je division2

cargapila:
    xor eax, eax
    mov eax, [resultado]
    push eax
    xor al, al
    xor ax, ax
    mov al, [sigres]
    push ax
    jmp cargasiguiente
 
cargasiguiente:
    mov dl, [numcar]
    add dl, [uno]
    mov [numcar], dl
    

    mov al, [numcar]
    mov bl, [numcaracteres]
    cmp al, bl
    je concatenarcarga
    jne cargaoperar

concatenarcarga:
    mov bx, 0
    mov [connum], bx
    mov [numcarcarga], bx
    mov si, concatcarga 
    mov di, msjrepcarga1
    mov bx, [numcarcarga]
    jmp concatecarga

concatecarga:
    mov cl, [connum]
    cmp cl, 19
    jne continuaconcatecarga
    je concatenarontenidocarga

continuaconcatecarga:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cl, [connum]
    add cl, 1
    mov [connum], cl
    jmp concatecarga

concatenarontenidocarga:
    mov [numcarcarga], bx
    mov bx, 0
    mov [connum], bx
    mov si, concatcarga 
    mov di, [textoleido]
    mov bx, [numcarcarga]
    jmp concatetextoentrada

concatetextoentrada:
    mov cx, [connum]
    mov ax, [numcaracteres]
    cmp cx, ax
    jne continuaconcatetextoentrada
    je concatenarresultadocarga

continuaconcatetextoentrada:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cx, [connum]
    add cx, 1
    mov [connum], cx
    jmp concatetextoentrada

concatenarresultadocarga:
    mov [numcarcarga], bx
    mov bx, 0
    mov [connum], bx
    mov si, concatcarga 
    mov di, msjrepcarga2
    mov bx, [numcarcarga]
    jmp concatenarrescarga

concatenarrescarga:
    mov cx, [connum]
    mov ax, 12
    cmp cx, ax
    jne continuaconcatenarrescarga
    je concatenarresuldelacarga

continuaconcatenarrescarga:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cx, [connum]
    add cx, 1
    mov [connum], cx
    jmp concatenarrescarga

concatenarresuldelacarga:
    mov al, [sigres]
    cmp al, [uno]
    je concatmenosrescarga

    mov edi, [cero]
    mov eax, [resultado]
    mov [valor],eax
    call separarnumero
    mov [numedi], edi
    jmp concatnumerorescarga

concatmenosrescarga:
    mov dl, [menos]
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov eax, [resultado]
    mov [valor],eax
    call separarnumero
    mov [numedi], edi
    jmp concatnumerorescarga

concatnumerorescarga:
    mov edi, [numedi]
	mov eax, [valormostrar  + edi]
	mov [digt],eax
    mov dl,[digt]
    
    mov [si + bx], dl
    inc bx
    xor edi,edi
    mov edi, [numedi]
	sub edi,1
    mov [numedi], edi
	cmp edi,0
	jge concatnumerorescarga
	je fincarrga


fincarrga:
    mov [numcarcarga], bx
    pop ax
    pop eax
     
    mov dx, msjcargaresultado
    call escribir

    call mostrarresultado

    mov ah, 08
    int 21h
    
    jmp menu

suma2:
    xor eax, eax
    xor ebx, ebx
    xor edx, edx
    mov bl, [signum1]
    cmp bl, [uno]
    je sumapmenos2
    
    mov bl, [signum2]
    cmp bl, [uno]
    je sumasmenos2

    mov eax, [num1]
    mov edx, [num2]
    add eax, edx
    mov [resultado], eax
    
    xor ax, ax
    mov al, [cero]
    mov [sigres], al
    
    
    call mostrarresultado
    jmp cargapila

sumapmenos2:
    xor bx, bx
    mov bl, [signum2]
    cmp bl, [uno]
    je sumapmesme2
    xor eax, eax
    xor edx, edx
    mov eax, [num1]
    mov edx, [num2]
    cmp eax, edx
    je numerosigualesresta2
    ja sprmensegmas2
    jb ssegmaspmenos2

sprmensegmas2:
    xor eax, eax
    xor edx, edx
    mov eax, [num1]
    mov edx, [num2]
    sub eax, edx
    mov [resultado], eax
    
    xor ax, ax
    mov al, [uno]
    mov [sigres], al
    
    call mostrarresultado
    jmp cargapila

ssegmaspmenos2:
    xor eax, eax
    xor edx, edx
    mov eax, [num2]
    mov edx, [num1]
    sub eax, edx
    mov [resultado], eax
    
    xor ax, ax
    mov al, [cero]
    mov [sigres], al
    
    call mostrarresultado
    jmp cargapila


numerosigualesresta2:
    xor eax, eax
    xor edx, edx
    mov eax, [cero]
    mov [resultado], eax
    
    xor ax, ax
    mov al, [cero]
    mov [sigres], al
    
    call mostrarresultado
    jmp cargapila

sumapmesme2:
    xor eax, eax
    xor edx, edx
    mov eax, [num1]
    mov edx, [num2]
    add eax, edx
    mov [resultado], eax
    
    xor ax, ax
    mov al, [uno]
    mov [sigres], al
    
    call mostrarresultado
    jmp cargapila

sumasmenos2:
    xor eax, eax
    xor edx, edx
    mov eax, [num1]
    mov edx, [num2]
    cmp eax, edx
    je numerosigualesresta2
    ja ssegmemenpmas2
    jb ssegmemaypmas2
    

ssegmemaypmas2:
    xor eax, eax
    xor edx, edx
    mov eax, [num2]
    mov edx, [num1]
    sub eax, edx
    mov [resultado], eax
    
    xor ax, ax
    mov al, [uno]
    mov [sigres], al
    
    call mostrarresultado
    jmp cargapila

ssegmemenpmas2:
    xor eax, eax
    xor edx, edx
    mov eax, [num1]
    mov edx, [num2]
    sub eax, edx
    mov [resultado], eax
    
    xor ax, ax
    mov al, [cero]
    mov [sigres], al
    
    call mostrarresultado
    jmp cargapila

resta2:
    xor ax, ax
    xor bx, bx
    mov al, [signum2]
    mov bl, [uno]
    xor al, bl
    mov [sigres], al
    mov [signum2], al
    mov eax, [num2]
   
    jmp suma2


multiplicacion2:
    xor eax, eax
    xor ebx, ebx
    xor edx, edx
    mov eax, [num1]
    mov ebx, [num2]
    mul ebx
    mov [resultado], eax
    
    xor al, al
    xor bl, bl
    mov al, [signum1]
    mov bl, [signum2]
    xor al, bl
    mov [sigres], al
    
    call mostrarresultado
    jmp cargapila

division2:
    xor eax, eax
    xor ebx, ebx
    xor edx, edx
    mov eax, [num1]
    mov ebx, [num2]
    div ebx
    mov [resultado], eax
    
    xor al, al
    xor bl, bl
    mov al, [signum1]
    mov bl, [signum2]
    xor al, bl
    mov [sigres], al
    
    call mostrarresultado
    jmp cargapila

noarchivo:
    mov dx, msjnoarchivo
    call escribir
    mov ah, 08
    int 21h
    jmp menu

creararvi:
    mov ah, 3ch
    mov cx, 0
    mov dx, nombreprueba
    int 21h
    jc menu
    mov bx, ax
    mov ah, 3eh
    int 21h

strlen:            ; IN:DI OUT:AX
    mov  al, '$'
    mov  cx, 100
    cld
    repne scasb
    sub  cx, 100
    neg  cx
    ret 


talvez:
    mov eax, ecx
    mov [valor],eax
    call separarnumero
    call imprimirnumero

modocalculadora:
    call limpiar
    mov dx, pmensajecal
    call escribir

    mov ah, 01h
    int 21h

    cmp al, 97
    je ponera

    cmp al, 45
    je signomenosnumero1
    jne signonumero1

ponera:
    mov ebx, [resultado]
    mov [num1], ebx
    mov bl, [sigres]
    mov [signum1], bl
    jmp pedirsigno

poneran2:
    mov ebx, [resultado]
    mov [num2], ebx
    mov bl, [sigres]
    mov [signum2], bl
    jmp operarcal

pedirsigno:
    mov dx, smensajecal
    call escribir

    mov ah, 01h
    int 21h
    mov [operacionseigno], al

    mov dx, tmensajecal
    call escribir

    mov ah, 01h
    int 21h

    cmp al, 97
    je poneran2

    cmp al, 45
    je signomenosnumero2
    jne signonumero2

    
operarcal:
   mov al, [operacionseigno]
   cmp al, 43
   je suma 
   cmp al, 45
   je resta
   cmp al, 42
   je multiplicacion
   cmp al, 47
   je division

continuarcal:
    mov ah, 08h
    int 21h
    call limpiar
    mov dx, msjcontinuar
    call escribir
    jmp concatenarcalcu
    
    

salircal:
    jmp menu

signonumero1:
    mov bl, [cero]
    mov [signum1], bl
    sub al, 30h
    mov [decenas], al
    mov ah, 01h
    int 21h
    sub al, 30h
    mov [unidades], al

    mov al, [decenas]
    mul dword [diez]
    add al, [unidades]
    mov [num1], al
    jmp pedirsigno

signonumero2:
    mov bl, [cero]
    mov [signum2], bl
    sub al, 30h
    mov [decenas], al
    mov ah, 01h
    int 21h
    sub al, 30h
    mov [unidades], al

    mov al, [decenas]
    mul dword [diez]
    add al, [unidades]
    mov [num2], al
    jmp operarcal

signomenosnumero1:
    mov bl, [uno]
    mov [signum1], bl
    mov ah, 01h
    int 21h
    cmp al, 97
    je negaran
    sub al, 30h
    mov [decenas], al
    mov ah, 01h
    int 21h
    sub al, 30h
    mov [unidades], al

    mov al, [decenas]
    mul dword [diez]
    add al, [unidades]
    mov [num1], al
    jmp pedirsigno

negaran:
    mov ebx, [resultado]
    mov [num1], ebx
    mov al, [sigres]
    mov bl, [uno]
    xor al, bl
    mov [signum1], al
    jmp pedirsigno

negaran2:
    mov ebx, [resultado]
    mov [num2], ebx
    mov al, [sigres]
    mov bl, [uno]
    xor al, bl
    mov [signum2], al
    jmp operarcal


signomenosnumero2:
    mov bl, [uno]
    mov [signum2], bl
    mov ah, 01h
    int 21h
    cmp al, 97
    je negaran2
    sub al, 30h
    mov [decenas], al
    mov ah, 01h
    int 21h
    sub al, 30h
    mov [unidades], al

    mov al, [decenas]
    mul dword [diez]
    add al, [unidades]
    mov [num2], al
    jmp operarcal

suma:
    mov bl, [signum1]
    cmp bl, [uno]
    je sumapmenos
    
    mov bl, [signum2]
    cmp bl, [uno]
    je sumasmenos

    mov eax, [num1]
    mov edx, [num2]
    add eax, edx
    mov [resultado], eax
    mov bl, [cero]
    mov [sigres], bl
    call mostrarresultado
    jmp continuarcal

sumapmenos:
    mov bl, [signum2]
    cmp bl, [uno]
    je sumapmesme
    mov eax, [num1]
    mov edx, [num2]
    cmp eax, edx
    je numerosigualesresta
    ja sprmensegmas
    jb ssegmaspmenos

sprmensegmas:
    mov eax, [num1]
    mov edx, [num2]
    sub eax, edx
    mov [resultado], eax
    mov bl, [uno]
    mov [sigres], bl
    call mostrarresultado
    jmp continuarcal

ssegmaspmenos:
    mov eax, [num2]
    mov edx, [num1]
    sub eax, edx
    mov [resultado], eax
    mov bl, [cero]
    mov [sigres], bl
    call mostrarresultado
    jmp continuarcal


numerosigualesresta:
    mov eax, [cero]
    mov [resultado], eax
    mov bl, [cero]
    mov [sigres], bl
    call mostrarresultado
    jmp continuarcal

sumapmesme:
    mov eax, [num1]
    mov edx, [num2]
    add eax, edx
    mov [resultado], eax
    mov bl, [uno]
    mov [sigres], bl
    call mostrarresultado
    jmp continuarcal

sumasmenos:
    mov eax, [num1]
    mov edx, [num2]
    cmp eax, edx
    je numerosigualesresta
    ja ssegmemenpmas
    jb ssegmemaypmas
    

ssegmemaypmas:
    mov eax, [num2]
    mov edx, [num1]
    sub eax, edx
    mov [resultado], eax
    mov bl, [uno]
    mov [sigres], bl
    call mostrarresultado
    jmp continuarcal

ssegmemenpmas:
    mov eax, [num1]
    mov edx, [num2]
    sub eax, edx
    mov [resultado], eax
    mov bl, [cero]
    mov [sigres], bl
    call mostrarresultado
    jmp continuarcal

resta:
    mov al, [signum2]
    mov bl, [uno]
    xor al, bl
    mov [signum2], al
    jmp suma

multiplicacion:
    mov eax, [num1]
    mov ebx, [num2]
    mul ebx
    mov [resultado], eax
    mov al, [signum1]
    mov bl, [signum2]
    xor al, bl
    mov [sigres], al
    call mostrarresultado
    jmp continuarcal

division:
    mov eax, [num1]
    mov ebx, [num2]
    div ebx
    mov [resultado], eax
    mov al, [signum1]
    mov bl, [signum2]
    xor al, bl
    mov [sigres], al
    call mostrarresultado
    jmp continuarcal

mostrarresultado:
    mov dx, msjresultado
    call escribir

    mov edi, [cero]
    mov bl, [sigres]
    cmp bl, [uno]
    je imprimirmenos
    mov eax, [resultado]
    mov [valor],eax
    call separarnumero
    call imprimirnumero
    ret

imprimirmenos:
    mov dx, menos
    call escribir
    mov eax, [resultado]
    mov [valor],eax
    call separarnumero
    call imprimirnumero
    ret 2

concatenarcalcu:
    mov bx, 0
    mov [connum], bx
    mov si, concatcalcu ;aqui le pones un texto
    mov di, tmensajecal  ;aqui lo que vas a concatenar
    mov bx, [numcarcalcu]
    jmp concatca

; mov esi, [mensaje]
; mov edi
; cx = 0

concatca:
    mov cl, [connum]
    cmp cl, 11
    jne continuaconcatca
    je concatenarnum1

continuaconcatca:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cl, [connum]
    add cl, 1
    mov [connum], cl
    jmp concatca

concatenarnum1:
    mov al, [signum1]
    cmp al, [uno]
    je concatmenos

    mov edi, [cero]
    mov eax, [num1]
    mov [valor],eax
    call separarnumero
    mov [numedi], edi
    jmp concatnumero

concatmenos:
    mov dl, [menos]
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov eax, [num1]
    mov [valor],eax
    call separarnumero
    mov [numedi], edi
    jmp concatnumero

concatnumero:
    mov edi, [numedi]
	mov eax, [valormostrar  + edi]
	mov [digt],eax
	
	
    mov dl,[digt]
    

    mov [si + bx], dl
    inc bx

    
    xor edi,edi
    mov edi, [numedi]

	sub edi,1
    mov [numedi], edi

	cmp edi,0
	jge concatnumero
	je concatenarsignocal


concatenarsignocal:
    mov [numcarcalcu], bx
    mov bx, 0
    mov [connum], bx
    mov si, concatcalcu
    mov di, smensajecal  
    mov bx, [numcarcalcu]
    jmp concatca2


concatca2:
    mov cl, [connum]
    cmp cl, 24
    jne continuaconcatca2
    je concatenarsino

continuaconcatca2:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cl, [connum]
    add cl, 1
    mov [connum], cl
    jmp concatca2

concatenarsino:     
    mov dl,[operacionseigno]
    mov [si + bx], dl
    inc bx
    mov [numcarcalcu], bx
    jmp concatnumerodos

concatnumerodos:
    mov [numcarcalcu], bx
    mov bx, 0
    mov [connum], bx
    mov si, concatcalcu ;aqui le pones un texto
    mov di, tmensajecal  ;aqui lo que vas a concatenar
    mov bx, [numcarcalcu]
    jmp concatca3

concatca3:
    mov cl, [connum]
    cmp cl, 11
    jne continuaconcatca3
    je concatenarnum2

continuaconcatca3:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cl, [connum]
    add cl, 1
    mov [connum], cl
    jmp concatca3


concatenarnum2:
    mov al, [signum2]
    cmp al, [uno]
    je concatmenos2

    mov edi, [cero]
    mov eax, [num2]
    mov [valor],eax
    call separarnumero
    mov [numedi], edi
    jmp concatnumero2

concatmenos2:
    mov dl, [menos]
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov eax, [num2]
    mov [valor],eax
    call separarnumero
    mov [numedi], edi
    jmp concatnumero2

concatnumero2:
    mov edi, [numedi]
	mov eax, [valormostrar  + edi]
	mov [digt],eax
	
	
    mov dl,[digt]
    

    mov [si + bx], dl
    inc bx

    
    xor edi,edi
    mov edi, [numedi]

	sub edi,1
    mov [numedi], edi

	cmp edi,0
	jge concatnumero2
	je concatenarresultadocal

concatenarresultadocal:
    mov [numcarcalcu], bx
    mov bx, 0
    mov [connum], bx
    mov si, concatcalcu ;aqui le pones un texto
    mov di, msjresultado  ;aqui lo que vas a concatenar
    mov bx, [numcarcalcu]
    jmp concatca4

concatca4:
    mov cl, [connum]
    cmp cl, 13
    jne continuaconcatca4
    je concatenarnumrescal

continuaconcatca4:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cl, [connum]
    add cl, 1
    mov [connum], cl
    jmp concatca4

concatenarnumrescal:
    mov al, [sigres]
    cmp al, [uno]
    je concatmenos3

    mov edi, [cero]
    mov eax, [resultado]
    mov [valor],eax
    call separarnumero
    mov [numedi], edi
    jmp concatnumero5

concatmenos3:
    mov dl, [menos]
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov eax, [resultado]
    mov [valor],eax
    call separarnumero
    mov [numedi], edi
    jmp concatnumero5

concatnumero5:
    mov edi, [numedi]
	mov eax, [valormostrar  + edi]
	mov [digt],eax
	
	
    mov dl,[digt]
    

    mov [si + bx], dl
    inc bx

    
    xor edi,edi
    mov edi, [numedi]

	sub edi,1
    mov [numedi], edi

	cmp edi,0
	jge concatnumero5
	je finconcatcalcu

finconcatcalcu:
    mov [numcarcalcu], bx
    
    mov ah, 01h
    int 21h
    cmp al, 49
    je salircal
    jne modocalculadora

factorial:
    call limpiar
    mov dx, iniciofac
    call escribir

    mov ah, 01h
    int 21h
    sub al, 30h
    mul dword [diez]
    mov [decenas], al
    mov ah, 01h
    int 21h
    sub al, 30h
    mov [unidades], al
    mov al, [decenas]
    add al, [unidades]

    mov [numfac], al

    mov eax, [facresul]
    xor eax, eax
    mov [facresul], eax
    mov al, [uno]
    mov [facresul], al
    
    

    mov dx, msjoperacion
    call escribir

    xor al, al
    mov [repfact], al
    mov al, [numfac]
    inc al
    mov [repfactfalso], al
    jmp factrepetir



factrepetir:
    ; espacio
    mov ah, 02h
    mov dl, 32
    int 21h
    ;numero
    mov ah, 02h
    mov dl, [repfact]
    add dl, 30h
    int 21h
    ;n!
    mov ah, 02h
    mov dl, 33
    int 21h
    ;n!=
    mov ah, 02h 
    mov dl, 61
    int 21h
    ;n!=1
    mov dl, [uno]   
    mov [digfac], dl
    mov ah, 02h
    mov dl, [digfac]
    add dl, 30h
    int 21h

    xor al, al
    mov al, [uno]
    mov [facresul], al

    
    xor al, al
    xor dl, dl
    mov al, [repfact]
    mov [numfac], al
    xor al, al
    mov al, [numfac]
    mov dl, [uno]
    cmp al, dl
    je facunocero
    ja facmayoruno
    jb facunocero

factcomp:
    mov dl, [repfact]
    add dl, [uno]
    mov [repfact], dl
    

    mov al, [repfact]
    mov bl, [repfactfalso]
    cmp al, bl
    je concatenarfactorial
    jne factrepetir
    
facunocero:;n!=1;
    mov ah, 02h
    mov dl, 59
    int 21h
    xor al, al
    mov al, [uno]
    mov [facresul], al
    jmp factcomp

facmayoruno:;n!=1*2*3...=N;
    xor cx, cx
    xor ax, ax
    xor bx, bx
    mov al, [numfac]
    mov bl, [uno]
    sub al, bl
    mov [num1], al
    
    xor ax, ax
    inc ax
    mov [facresul], ax
    
    mov cx, [num1]
    call operacionfactorial
    
    
    
    xor ax, ax
    xor bx, bx
    mov ax, [facresul]
    mov bx, [numfac]
    mul bx
    mov [facresul], ax
    
    mov ah, 02h 
    mov dl, 61
    int 21h

    mov edi, [cero]
    xor eax, eax
    mov eax, [facresul]
    mov [valor],eax
    call separarnumero
    call imprimirnumero

    mov ah, 02h 
    mov dl, 59
    int 21h
    jmp factcomp

operacionfactorial:
    xor ax, ax
    xor bx, bx
    mov ax, [facresul]
    mov bx, cx
    mul bx
    mov [facresul], ax

    mov dl, [digfac]
    add dl, [uno]
    mov [digfac], dl

    mov ah, 02h
    mov dx, 42
    int 21h

    mov ah, 02h
    mov dx, [digfac]
    add dx, 30h
    int 21h

loop operacionfactorial
    ret

concatenarfactorial:
    mov al, [numfac]
    cmp al, 0
    je concatcero
    cmp al, 1
    je concatuno
    cmp al, 2
    je concatdos 
    cmp al, 3
    je concattres
    cmp al, 4
    je concatcuatro
    cmp al, 5
    je concatcinco
    cmp al, 6
    je concatseis
    cmp al, 7
    je concatsiete
    jne finfactorial

concatcero:
    mov bx, 0
    mov [connum], bx
    mov si, concatfactorial 
    mov di, fcero 
    mov bx, [numcarfactor]
    jmp concatceroo

concatceroo:
    mov cl, [connum]
    cmp cl, 48
    jne continuaconcatceroo
    je finfactorial

continuaconcatceroo:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cl, [connum]
    add cl, 1
    mov [connum], cl
    jmp concatceroo

concatuno:
    mov bx, 0
    mov [connum], bx
    mov si, concatfactorial 
    mov di, funo
    mov bx, [numcarfactor]
    jmp concateuno

concateuno:
    mov cl, [connum]
    cmp cl, 53
    jne continuaconcateuno
    je finfactorial

continuaconcateuno:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cl, [connum]
    add cl, 1
    mov [connum], cl
    jmp concateuno

concatdos:
    mov bx, 0
    mov [connum], bx
    mov si, concatfactorial 
    mov di, fdos
    mov bx, [numcarfactor]
    jmp concatedos

concatedos:
    mov cl, [connum]
    cmp cl, 62
    jne continuaconcatedos
    je finfactorial

continuaconcatedos:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cl, [connum]
    add cl, 1
    mov [connum], cl
    jmp concatedos

concattres:
    mov bx, 0
    mov [connum], bx
    mov si, concatfactorial 
    mov di, ftres
    mov bx, [numcarfactor]
    jmp concatetres

concatetres:
    mov cl, [connum]
    cmp cl, 72
    jne continuaconcatetres
    je finfactorial

continuaconcatetres:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cl, [connum]
    add cl, 1
    mov [connum], cl
    jmp concatetres

concatcuatro:
    mov bx, 0
    mov [connum], bx
    mov si, concatfactorial 
    mov di, fcuatro
    mov bx, [numcarfactor]
    jmp concatecuatro

concatecuatro:
    mov cl, [connum]
    cmp cl, 88
    jne continuaconcatecuatro
    je finfactorial

continuaconcatecuatro:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cl, [connum]
    add cl, 1
    mov [connum], cl
    jmp concatecuatro

concatcinco:
    mov bx, 0
    mov [connum], bx
    mov si, concatfactorial 
    mov di, fcinco
    mov bx, [numcarfactor]
    jmp concatecinco

concatecinco:
    mov cl, [connum]
    cmp cl, 105
    jne continuaconcatecinco
    je finfactorial

continuaconcatecinco:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cl, [connum]
    add cl, 1
    mov [connum], cl
    jmp concatecinco

concatseis:
    mov bx, 0
    mov [connum], bx
    mov si, concatfactorial 
    mov di, fseis
    mov bx, [numcarfactor]
    jmp concateseis

concateseis:
    mov cl, [connum]
    cmp cl, 124
    jne continuaconcateseis
    je finfactorial

continuaconcateseis:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cl, [connum]
    add cl, 1
    mov [connum], cl
    jmp concateseis

concatsiete:
    mov bx, 0
    mov [connum], bx
    mov si, concatfactorial 
    mov di, fsiete
    mov bx, [numcarfactor]
    jmp concatesiete

concatesiete:
    mov cx, [connum]
    cmp cx, 146
    jne continuaconcatesiete
    je finfactorial

continuaconcatesiete:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cx, [connum]
    add cx, 1
    mov [connum], cx
    jmp concatesiete


finfactorial:
    mov [numcarfactor], bx
    mov eax, [facresul]
    mov [resultado], eax
    mov bl, [cero]
    mov [sigres], bl

    call mostrarresultado
    mov ah, 08
    int 21h
    mov al, [uno]
    mov [facresul], al
    jmp menu

reporte:
    call limpiar
    mov dx, iniciorep
    call escribir

    xor ax, ax
    xor bx, bx
    xor si, si
     
    jmp concatenarencabezadoreporte

finrep:
    mov [numtodo], bx
    

    escribir_reporte nombreprueba, numtodo,  concatenartodo
    mov ah, 08
    int 21h
    mov bx, 0
    mov [connum], bx


    jmp menu

; mov esi, [mensaje]
; cx = 0
;add bx, 0
  
 ;   mov si, msjcon2 
  ;  mov di, encabezadoreporte 

concat:
    mov cl, [connum]
    cmp cl, 249
    jne continuaconcat
    je concatenarencabezadoreporte

continuaconcat:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cl, [connum]
    add cl, 1
    mov [connum], cl
    jmp concat


concatenarencabezadoreporte:
    mov bx, 0
    mov [connum], bx
    mov [numtodo], bx

    mov si, concatenartodo 
    mov di, encabezadoreporte  
    jmp concatencabezadorep

concatencabezadorep:
    mov cx, [connum]
    cmp cx, 249
    jne continuaconcatencabezadorep
    je concatenarcargareporte2

continuaconcatencabezadorep:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cx, [connum]
    add cx, 1
    mov [connum], cx
    jmp concatencabezadorep

concatenarcargareporte2:
    mov [numtodo], bx
    mov bx, 0
    mov [connum], bx
    
    mov si, concatenartodo 
    mov di, concatcarga  
    mov bx, [numtodo]
    jmp concatenarcargareporte

concatenarcargareporte:
    mov cx, [connum]
    cmp cx, [numcarcarga]
    jne continuaconcatenarcargareporte
    je concatenarcaluladorarep

continuaconcatenarcargareporte:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cx, [connum]
    add cx, 1
    mov [connum], cx
    jmp concatenarcargareporte

concatenarcaluladorarep:
    mov [numtodo], bx
    mov bx, 0
    mov [connum], bx
    

    mov si, concatenartodo 
    mov di, concatcalcu  
    mov bx, [numtodo]
    jmp concatenarcalcureporte

concatenarcalcureporte:
    mov cx, [connum]
    cmp cx, [numcarcalcu]
    jne continuaconcatenarcalcureporte
    je concatenarfactorialrepo

continuaconcatenarcalcureporte:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cx, [connum]
    add cx, 1
    mov [connum], cx
    jmp concatenarcalcureporte



concatenarfactorialrepo:
    mov [numtodo], bx
    mov bx, 0
    mov [connum], bx
    

    mov si, concatenartodo 
    mov di, concatfactorial  
    mov bx, [numtodo]
    jmp concatenarfacctorialrep

concatenarfacctorialrep:
    mov cx, [connum]
    cmp cx, [numcarfactor]
    jne continuaconcatenarfacctorialrep
    je finrep

continuaconcatenarfacctorialrep:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cx, [connum]
    add cx, 1
    mov [connum], cx
    jmp concatenarfacctorialrep



opcionno:
    call limpiar
    jmp menu


escribir:
    mov ah, 09h
    int 21h
    ret 

separarnumero:
    mov edx,0
    mov eax,[valor]
    div dword [diez]
    mov [digt],edx
    mov [valor],eax

    mov eax,[digt]
    add eax,48

    mov [valormostrar + edi], eax

    inc edi

    mov eax,[valor]
    cmp eax,0
    jnz separarnumero
    ret

imprimirnumero:
	mov eax, [valormostrar  + edi]
	mov [digt],eax
	
	mov ah,02h
    mov dl,[digt]
    int 21h
	

	sub edi,1

	cmp edi,0
	jge imprimirnumero
	ret



limpiar:
    mov ax,0600h ;limpiar pantalla
    mov bh,0fh ;0 color de fondo negro, f color de letra blanco
    mov cx,0000h
    mov dx,184Fh
    int 10h

    mov ah,02h
    mov bh,00
    mov dh,00
    mov dl,00
    int 10h
    ret 

salir:
    mov ah, 4Ch
    int 21h

;------------------------------- DATOS -------------------------------;
section .data
encabezado              db 'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',13,10
                        db 'FACULTAD DE INGENIERIA',13,10
                        db 'ESCUELA DE CIENCIAS Y SISTEMAS',13,10
                        db 'ARQUITECTURA DE COMPUTADORAS Y ENSAMBLADORES 1 A',13,10
                        db 'PRIMER SEMESTRE 2018',13,10
                        db 'Douglas Daniel Aguilar Cuque',13,10
                        db '201503935',13,10
                        db 'PRIMERA PRACTICA',13,10,'$'

mostrarmenu             db 13,10,'|---------- MENU ----------|',13,10
                        db '|                          |',13,10
                        db '|1. Cargar Archivo         |',13,10
                        db '|2. Modo Calculadora       |',13,10
                        db '|3. Factorial              |',13,10
                        db '|4. Crear Reporte          |',13,10
                        db '|5. Salir                  |',13,10
                        db '|--------------------------|',13,10
                        db 'Ingrese una opcion: $',13,10

iniciocarga             db ' Ingresar ruta del archivo: $',13,10

iniciocalcu             db '|---------- Calculadora ----------|',13,10,'$'

iniciofac               db ' Factorial: $',13,10

iniciorep               db '|---------- Reporte ----------|',13,10,'$'

pmensajecal             db ' Numero: $',13,10

smensajecal             db 13,10,' Operador aritmetico: $',13,10

tmensajecal             db 13,10,' Numero: $',13,10

msjresultado            db 13,10,' Resultado: $',13,10

operacionseigno         db 0

msjcontinuar            db ' Regresar al menu: ',13,10
                        db ' 1. Si ',13,10
                        db ' 2. No ',13,10
                        db ' Ingrese una opcion: $',13,10

salto                   db  '*--------*',13,10,'$'

diez                    dd 10

cero:                   dd 0

uno                     db 1

menos                   db '-','$'

digfac                  db 0

repfact                 db 0

repfactfalso            db 0

msjoperacion            db 13,10,' Operacion: $',13,10

arreglonum              times 100 dd 0

arreglosigno            times 100 db 0

connum                  db 0

msjcargaresultado:      db 13,10,' Resultado del archivo: $',13,10

textoentrada:           times 100 dw '$', 00h

textoleido:             times 256 db "$"

fcero:                  db 13,10,'Factorial: 0',13,10
                        db 'Operaciones: 0!=1',13,10
                        db 'Resultado: 1',13,10

funo:                   db 13,10,'Factorial: 1',13,10
                        db 'Operaciones: 0!=1 1!=1',13,10
                        db 'Resultado: 1',13,10

fdos:                   db 13,10,'Factorial: 2',13,10
                        db 'Operaciones: 0!=1 1!=1 2!=1*2=2',13,10
                        db 'Resultado: 2',13,10

ftres:                  db 13,10,'Factorial: 3',13,10
                        db 'Operaciones: 0!=1 1!=1 2!=1*2=2 3!=1*2*3=6',13,10
                        db 'Resultado: 6',13,10

fcuatro:                db 13,10,'Factorial: 4',13,10
                        db 'Operaciones: 0!=1 1!=1 2!=1*2=2 3!=1*2*3=6 4!=1*2*3*4=24',13,10
                        db 'Resultado: 24',13,10

rutaprueba:             dw "archivo.arq",0

nombreprueba:           dw "reporte.rep",0

msjnoarchivo            db 'Error en la lectura del archivo',13,10,'$'

completo:               times 100 dw 0

msjcaracterinvalid:     db 13,10,'Caracter invalido: $',13,10

fcinco:                 db 13,10,'Factorial: 5',13,10
                        db 'Operaciones: 0!=1 1!=1 2!=1*2=2 3!=1*2*3=6 4!=1*2*3*4=24 5!=1*2*3*4*5=120',13,10
                        db 'Resultado: 120',13,10

fseis:                  db 13,10,'Factorial: 6',13,10
                        db 'Operaciones: 0!=1 1!=1 2!=1*2=2 3!=1*2*3=6 4!=1*2*3*4=24 5!=1*2*3*4*5=120 6=1*2*3*4*5*6=720',13,10
                        db 'Resultado: 720',13,10


encabezadoreporte:      db 'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',13,10
                        db 'FACULTAD DE INGENIERIA',13,10
                        db 'ESCUELA DE CIENCIAS Y SISTEMAS',13,10
                        db 'ARQUITECTURA DE COMPUTADORAS Y ENSAMBLADORES 1 A',13,10
                        db 'PRIMER SEMESTRE 2018',13,10
                        db 'Douglas Daniel Aguilar Cuque',13,10
                        db '201503935',13,10
                        db 'Reporte Practica No 1',13,10,
                        db 'Fecha: 02/04/2018',13,10,'$'

fsiete:                 db 13,10,'Factorial: 7',13,10
                        db 'Operaciones: 0!=1 1!=1 2!=1*2=2 3!=1*2*3=6 4!=1*2*3*4=24 5!=1*2*3*4*5=120 6=1*2*3*4*5*6=720 7!=1*2*3*4*5*6*7=5040',13,10
                        db 'Resultado: 5040',13,10

msjcon1                 db 'mensaje 1 ',13,10,'$'
tammjscon1              equ $-msjcon1

msjcon2                 times 500 db '',13,10,'$'

msjcon3                 times 100 db '$'

concatcalcu             times 500 db '',13,10,'$'

concatfactorial         times 500 db '',13,10,'$'

concatcarga             times 500 db '',13,10,'$'

concatenartodo          times 1500 db '',13,10,'$'

msjrepcarga1            db 13,10,'Archivo enstrada: $',13,10

msjrepcarga2            db 13,10,'Resultado: $',13,10

section .bss
decenas:                resb 8

unidades:               resb 8

num1:                   resb 10

num2:                   resb 10

resultado:              resb 10

valormostrar:           resd 20

valor:                  resd 10

digt:                   resd 1

signum1:                resb 1

signum2:                resb 1

sigres:                 resb 1

facresul:               resb 10

numfac:                 resb 10

numcaracteres:          resb 10

sinerror:               resb 1

carac:                  resd 1

numcar:                 resb 10

numcarcalcu:            resb 10

numedi:                 resb 10

numcarfactor:           resb 10

numcarcarga:            resb 10

numtodo:                resb 10