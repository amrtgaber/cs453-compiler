.data

_x:
	.word 0
_intArray3:
	.space 400
_intArray2:
	.space 40
_int5:
	.word 0
_intArray1:
	.space 20
_int4:
	.word 0
_int3:
	.word 0
_int2:
	.word 0
_int1:
	.word 0
_a:
	.word 0

.data

_char1:
	.byte 0
_charArray2:
	.space 255
_char5:
	.byte 0
_char4:
	.byte 0
_charArray1:
	.space 26
_char3:
	.byte 0
_char2:
	.byte 0

.text

main:
	subu	$sp, $sp, 8
	sw	$ra, 4($sp)
	sw	$fp, 0($sp)
	addu	$fp, $sp, 8


	li	$t0, '#'
	sb	$t0, _char1

	li	$t0, 12
	sb	$t0, _char2

	li	$t0, 5
	sw	$t0, _x

	subu	$sp, $sp, 4
	la	$t0, __temp3
	sw	$t0, 0($sp)

	jal	_print_string

	subu	$sp, $sp, 4
	lw	$t0, _x
	sw	$t0, 0($sp)

	jal	_print_int

	subu	$sp, $sp, 4
	la	$t0, __temp4
	sw	$t0, 0($sp)

	jal	_print_string

	li	$t0, 42
	sw	$t0, _a

	subu	$sp, $sp, 4
	la	$t0, __temp6
	sw	$t0, 0($sp)

	jal	_print_string

	subu	$sp, $sp, 4
	lw	$t0, _a
	sw	$t0, 0($sp)

	jal	_print_int

	subu	$sp, $sp, 4
	la	$t0, __temp7
	sw	$t0, 0($sp)

	jal	_print_string

	lw	$t0, _a
	sw	$t0, _x

	subu	$sp, $sp, 4
	la	$t0, __temp8
	sw	$t0, 0($sp)

	jal	_print_string

	subu	$sp, $sp, 4
	lw	$t0, _x
	sw	$t0, 0($sp)

	jal	_print_int

	subu	$sp, $sp, 4
	la	$t0, __temp9
	sw	$t0, 0($sp)

	jal	_print_string

	subu	$sp, $sp, 4
	la	$t0, __temp10
	sw	$t0, 0($sp)

	jal	_print_string

	subu	$sp, $sp, 4
	lw	$t0, _a
	sw	$t0, 0($sp)

	jal	_print_int

	subu	$sp, $sp, 4
	la	$t0, __temp11
	sw	$t0, 0($sp)

	jal	_print_string

	li	$t0, 100
	sw	$t0, 0($sp)

	jal	_print_int

	subu	$sp, $sp, 4
	la	$t0, __temp13
	sw	$t0, 0($sp)

	jal	_print_string

	lw	$ra, 56($sp)
	lw	$fp, 52($sp)
	addu	$sp, $sp, 60
	jr	$ra

.data

__temp13:
	.asciiz	"\n"

__temp11:
	.asciiz	"\n"

__temp10:
	.asciiz	"a = "

__temp9:
	.asciiz	"\n"

__temp8:
	.asciiz	"x = "

__temp7:
	.asciiz	"\n"

__temp6:
	.asciiz	"a = "

__temp4:
	.asciiz	"\n"

__temp3:
	.asciiz	"x = "

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
