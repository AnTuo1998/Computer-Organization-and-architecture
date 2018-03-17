########################################################################
#
#	计算机组成和体系结构  第一次互评作业 
#	第一题 ：用系统功能调用实现简单输入输出
#	Name: DSC 
#
########################################################################
.data 
upper: 		.asciiz
		"Alpha ","Bravo ","China ","Delta ","Echo ","Foxtrot ",
		"Golf ","Hotel ","India ","Juliet ","Kilo ","Lima ",
		"Mary ","November ","Oscar ","Paper ","Quebec ","Research ",
		"Sierra ","Tango ","Uniform ","Victor ","Whisky ","X-ray ",
		"Yankee ","Zulu "
lower:		.asciiz
		"alpha ","bravo ","china ","delta ","echo ","foxtrot ",
		"golf ","hotel ","india ","juliet ","kilo ","lima ",
		"mary ","november ","oscar ","paper ","quebec ","research ",
		"sierra ","tango ","uniform ","victor ","whisky ","x-ray ",
		"yankee ","zulu "
number:		.asciiz
		"zero ", "First ", "Second ", "Third ", "Fourth ",
		"Fifth ", "Sixth ", "Seventh ","Eighth ","Ninth "
al_offset: 	.word
		0,7,14,21,28,34,43,49,56,63,71,77,83,89,99,
		106,113,121,131,139,146,155,163,171,178,186
n_offset: 	.word 
		0,6,13,21,28,36,43,50,59,67
star:		.asciiz 
		"*"	
endl:		.asciiz
		"\r\n"
.text
.globl main
main:
	li	$v0, 12 	# $v0 contains character read
	syscall
	li	$v1, 63
	beq	$v0, $v1, rtback
	move	$t7, $v0
	li	$v0, 4
	la	$a0, endl
	syscall	
	
isupper:
	li	$t0, 65
	slt	$t1, $t7, $t0 	# v0>=65 means possilby a upper letter t1=0 
	bnez 	$t1, islower	# if $t1!=0 means not a upper letter, jump  
	li	$t0, 90
	slt	$t1, $t0, $t7
	bnez	$t1, islower
		
	#it is a upper letter in v0
	sub	$t0, $t7, 65
	sll 	$t0, $t0, 2
	la	$t8, al_offset
	add	$t8, $t8, $t0
	lw	$t9, ($t8)

	la	$t8, upper
	add	$t8, $t8, $t9
	j 	printline
						
islower:
	li	$t0, 97
	slt	$t1, $t7, $t0 	# v0>=97 means possilby a lower letter t1=0 
	bnez 	$t1, isnumber	# if $t1!=0 means not a lower letter, jump  
	li	$t0, 122
	slt	$t1, $t0, $t7
	bnez	$t1, isnumber
	
	sub	$t0, $t7, 97
	sll 	$t0, $t0, 2	# get offset in array n_offset and calculate bytes
	la	$t8, al_offset
	add	$t8, $t8, $t0	
	lw	$t9, ($t8)	# load upper[n_offset[char-97]]

	la	$t8, lower
	add	$t8, $t8, $t9
	j	printline

isnumber:
	li	$t0, 48
	slt	$t1, $t7, $t0 	# v0>=65 means possilby a number and t1=0 
	bnez 	$t1, default	# if $t1!=0 means not a number, jump  
	li	$t0, 57
	slt	$t1, $t0, $t7
	bnez	$t1, default
	
	sub	$t0, $t7, 48
	sll 	$t0, $t0, 2
	la	$t8, n_offset
	add	$t8, $t8, $t0
	lw	$t9, ($t8)

	la	$t8, number
	add	$t8, $t8, $t9
	j	printline

default:
	la	$t8, star
	
printline:	
	li	$v0, 4
	move	$a0, $t8
	syscall
	la	$a0, endl
	syscall		#endline
	j	main
	
rtback:
	li	$v0, 10
	syscall		#ret
