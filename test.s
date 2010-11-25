
.text

main:
	subu	$sp, $sp, 52
	sw	$ra, 48($sp)
	sw	$fp, 44($sp)
	addu	$fp, $sp, 52
	# initializing local variables
	sw	$0, 40($sp)
	sw	$0, 36($sp)
	sw	$0, 32($sp)
	sw	$0, 28($sp)
	sw	$0, 24($sp)
	sw	$0, 20($sp)
	sw	$0, 16($sp)
	sw	$0, 12($sp)
	sw	$0, 8($sp)
	sw	$0, 4($sp)
	sw	$0, 0($sp)

	# i = 0
	li	$t0, 0
	sw	$t0, 40($sp)

	# res = 0
	li	$t0, 0
	sw	$t0, 36($sp)

	j	__label6

__label7:

	# res + i
	lw	$t1, 36($sp)
	lw	$t0, 40($sp)
	add	$t0, $t1, $t0
	sw	$t0, 0($sp)

	# res = _temp6
	lw	$t0, 0($sp)
	sw	$t0, 36($sp)

	# i + 1
	li	$t0, 1
	lw	$t1, 40($sp)
	add	$t0, $t1, $t0
	sw	$t0, 8($sp)

	# i = _temp5
	lw	$t0, 8($sp)
	sw	$t0, 40($sp)

__label6:

	# i < 10
	li	$t0, 10
	lw	$t1, 40($sp)
	slt	$t0, $t1, $t0
	sw	$t0, 4($sp)

	lw	$t0, 4($sp)
	bgtz	$t0, __label7

	# i = 0
	li	$t0, 0
	sw	$t0, 40($sp)

	j	__label4

__label5:

	# res + i
	lw	$t1, 36($sp)
	lw	$t0, 40($sp)
	add	$t0, $t1, $t0
	sw	$t0, 12($sp)

	# res = _temp10
	lw	$t0, 12($sp)
	sw	$t0, 36($sp)

	# i + 1
	li	$t0, 1
	lw	$t1, 40($sp)
	add	$t0, $t1, $t0
	sw	$t0, 16($sp)

	# i = _temp12
	lw	$t0, 16($sp)
	sw	$t0, 40($sp)

__label4:

	# i < 10
	li	$t0, 10
	lw	$t1, 40($sp)
	slt	$t0, $t1, $t0
	sw	$t0, 20($sp)

	lw	$t0, 20($sp)
	bgtz	$t0, __label5

	# i = 0
	li	$t0, 0
	sw	$t0, 40($sp)

	j	__label2

__label3:

	# res + i
	lw	$t1, 36($sp)
	lw	$t0, 40($sp)
	add	$t0, $t1, $t0
	sw	$t0, 24($sp)

	# res = _temp16
	lw	$t0, 24($sp)
	sw	$t0, 36($sp)

	# i > 10
	li	$t0, 10
	lw	$t1, 40($sp)
	sgt	$t0, $t1, $t0
	sw	$t0, 28($sp)

	lw	$t0, 28($sp)
	bgtz	$t0, __label0

	j	__label1

__label0:

	# pushing parameter res
	lw	$t0, 36($sp)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling print_int
	jal	_print_int

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter _temp19
	la	$t0, __temp19
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling print_string
	jal	_print_string

	# popping pushed parameters
	addu	$sp, $sp, 4

	# return
	j	__mainReturn

__label1:

	# i + 1
	li	$t0, 1
	lw	$t1, 40($sp)
	add	$t0, $t1, $t0
	sw	$t0, 32($sp)

	# i = _temp15
	lw	$t0, 32($sp)
	sw	$t0, 40($sp)

__label2:

	j	__label3

__mainReturn:
	lw	$fp, 44($sp)
	lw	$ra, 48($sp)
	addu	$sp, $sp, 52
	jr	$ra

.data

__temp19:
	.asciiz	"\n"

.text

_print_int:
	li	$v0, 1
	lw	$a0, 0($sp)
	syscall
	jr	$ra

_print_string:
	li	$v0, 4
	lw	$a0, 0($sp)
	syscall
	jr	$ra
