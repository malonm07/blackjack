.data
.align 2
cartas_jugador1: .space 40 
cartas_jugador2: .space 40
cadenaBienvenida: .asciiz "Bienvenidos al BlackJack, esperamos que disfruten de la partida.\n"
cadenaPlantarse: .asciiz "Introduzca un 2 si desea plantarse, o un 1 si desea volver a pedir una carta."
coma: .asciiz ","
.text
.globl main

main:
	la $a0, cadenaBienvenida
	li $v0, 4
	syscall
	
	
	la $a0, coma
	li $a1, 2		#por que genera dos cartas
	la $a2, cartas_jugador1
	li $a3, 0 #contador de jugadas
	
	jal mostrarCartas
	
	
	
	




















generarCartas:
	# en a0 va el tamaño del array, es decir, el numero de cartas a generar
	# en a1 la direccion de memoria del array
	move $t0, $a0
	move $t1, $a1
	li $t3, 0		#contador
	
	bucle:
	beq $t3, $t0, fin	#cuando el bucle se repita el numero de veces de cartas a generar para
	li $a1, 13 # indicamos el límite máximo. Significa que el número aleatorio está entre 0 y 11
	li $v0, 42
	syscall
	
	addi $a0, $a0, 1 # para que el número aleatorio esté entre 1 y 13
	move $v0, $a0
	add $t3, $t3, 1		#suma uno al contador
	
	fin:
	jr $ra
	









mostrarCartas:
	# en a0 cadena para imprimir una coma
	# en a1 tamaño del array
	# en a2 la direccion de memoria del array de cartas del jugador al que le toque
	
	move $a0, $a1		#ya que en generar cartas pide el tamaño en a0
	move $a1, $a2		#y la direccion en a2
	jal generarCartas
	
	bucleImprimir:
	
		move $t0, $a0
		lb $t1, ($a2)
		beqz $t1, finalMostrarCartas
	
		move $a0,$t0
		li $v0, 4
		syscall
		
		move $a0, $t0
		li $v0, 4
		syscall
		
		addi $a2, $a2, 1
		 
		 j bucleImprimir
		 
		 
	finMostrarCartas:
	
	jr $ra












calcularValor:
	# en a0 array que contiene cartas del jugador
	# en a1 el tamaño de dicho array
	
	suma:
	
	li $t0,0	#inicializa el registro t0 a 0
 	
 	bucle:
 	
 	
 	lw $a2, 0($a0)			#array de words
 	beq $t0, $a1, fin		#cuando haya sumado el numero de veces del tamaño para
 	addi $a0, $a0, 4		#suma 4 ya que cada word son 4 bytes
 	addu $t2,$a2, $t2
 	
 	
 	add $t0, $t0, 1			#suma uno cada vez que hace el bucle
 	j bucle
 	
 	
 	fin:
 	jr $ra
	













preguntarJugador:
	# en a1 direccion de la cadena que solicita al usuario si desea volver a pedir una carta o plantarse
	
	la $a0, cadenaPlantarse
	li $v0, 4			#imprime la cadena
	syscall
	
	li $v0, 5			#lee entero
	syscall
	
	lb $t1, 1
	lb $t2, 2
	beq $t1, $v0, pedirCarta
	beq, $t2, $v0, plantarse










