########################################################################
#
#	计算机组成和体系结构  第一次互评作业 
#	第二题 ：字符串查找比较
#	Name: DSC 
#
########################################################################
.data
succ:	.asciiz 
	"\r\nSuccess! Location:"
fail:	.asciiz
	"\r\nFail!\r\n"
endl:	.asciiz
	"\r\n"
addr:	.space 100
.text
.globl main
main:
	la	$a0, addr
	li	$a1, 100
	li	$v0, 8 	# $a0 = address of input buffer
			# $a1 = maximum number of characters to read
	syscall
	move	$t8, $a0
getaph:
	li	$v0, 12
	syscall		# $v0 contains character read
	li	$v1, 63
	beq	$v0, $v1, rtback	# judge ?
	li	$v1, 0
loop:
	add	$t9, $t8, $v1
	lb	$t7, ($t9)	# load string[i]
	beq	$t7, '\n', failed

	add	$v1, $v1, 1
	beq	$t7, $v0, matched	# compare string[i] and input char
	j	loop
matched:
	li	$v0, 4
	la	$a0, succ
	syscall
	li	$v0, 1
	move	$a0, $v1
	syscall
	li	$v0, 4
	la	$a0, endl
	syscall
	j	getaph
failed:
	li	$v0, 4
	la	$a0, fail
	syscall
	j	getaph
rtback:
	li	$v0, 10
	syscall		#ret
