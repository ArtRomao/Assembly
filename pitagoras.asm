###########################################################################
###                                                                     ###
###    Calculadora da medida de hiponenusas em triângulos retângulos    ###
###                         Teorema de Pitágoras                        ###
###             Arthur Romão Barreto | RA: 2474050                      ###
###                                                                     ###
###########################################################################

.data
	header:		.asciiz "========= Calculadora do Teorema de Pitagoras =========\n\n"
	prompt1:	.asciiz "Insira a medida do primeiro cateto (Numero inteiro): "
	prompt2:	.asciiz "Insira a medida do segundo cateto (Numero inteiro): "
	result:		.asciiz "Medida da hipotenusa: "
	
.text
main:
	
	# Cabeçalho do programa
	li		$v0,4
	la		$a0,header
	syscall
	
	# Armazena o valor do primeiro cateto
	li		$v0,4
	la		$a0,prompt1
	syscall
	li		$v0,5
	syscall
	move		$s0, $v0
	
	# Armazena o valor do segundo cateto
	li		$v0,4
	la		$a0,prompt2
	syscall
	li		$v0,5
	syscall
	move		$s1, $v0
	
	# Soma o quadrado dos catetos e os armazena em $s2
	mul		$s0, $s0, $s0
	mul		$s1, $s1, $s1
	add 		$s2, $s0, $s1
	
	# Converte a soma em float e realiza a raiz quadrada
	mtc1		$s2, $f12
    	cvt.s.w		$f12, $f12
    	sqrt.s		$f0, $f12

    	# Imprime a medida da hipotenusa
    	li		$v0, 4
    	la		$a0, result
    	syscall
    	li		$v0, 2
    	mov.s		$f12, $f0
    	syscall
    	
    	# Finaliza
    	li		$v0, 10
    	syscall