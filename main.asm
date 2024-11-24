.data 
filename:	.asciiz "helloworld.asm"
buffer:		.space 1024 #pensar sobre isso depois
newline:	.asciiz "\n"
err_msg:	.asciiz "Erro ao abrir.\n"

.text
main:
	#Abir com syscall 13
	li $v0, 13
	la $a0, filename
	li $a1, 0	#Mode de abertutra : 0 for read-only
	li $a2, 0
	syscall
	
	move $s0, $v0 # salvando o conteudo
	bltz $s0, file_error # se for zero pular para erro
	
read_loop:
	li $v0, 14 # syscall 14 para ler arquivo
	move $a0, $s0 #conteudo do arquivo
	la $a1, buffer
	li $a2, 1024
	syscall
	
	move $t0, $v0 # numero de bytes lidos
	beq $t0, 0, close_file # se for zero fim do arquivo
	
	la $t1, buffer # inicio do buffer
	add $t2, $t1, $t0 #  endereco final do buffer

print_loop:
	lb $t3, 0($t1) # primeiro byte do buffer
	beq $t1, $t2, read_loop # final do buffer, volta para ler mais
	
	li $v0, 11 # syscall 11 print character
	move $a0, $t3
	syscall
	
	addi $t1, $t1, 1 # incrementar o ponteiro
	j print_loop
	
close_file:
	li $v0, 16 #syscall para fechar arquivo
	move $a0, $s0 # movendo conteudo
	syscall
	j end_program

file_error:
	li $v0, 4 #syscall para print
	la $a0, err_msg
	syscall
	j end_program
	
end_program:
	li $v0, 10 # syscall para exit
	syscall