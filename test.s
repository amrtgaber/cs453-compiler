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


	# char1 = #
	li	$t0, '#'
	sb	$t0, _char1

	# char2 = '\n'
	li	$t0, 12		# 12 is ascii value for '\n'
	sb	$t0, _char2

	# char3 = '\0'
	li	$t0, 0		# 0 is ascii value for '\0'
	sb	$t0, _char3

	# x = 5
	li	$t0, 5
	sw	$t0, _x

	# pushing parameter x
	subu	$sp, $sp, 4
	lw	$t0, _x
	sw	$t0, 0($sp)

	# calling printX
	jal	_printX

	# a = 42
	li	$t0, 42
	sw	$t0, _a

	# pushing parameter a
	subu	$sp, $sp, 4
	lw	$t0, _a
	sw	$t0, 0($sp)

	# calling printA
	jal	_printA

	# x = a
	lw	$t0, _a
	sw	$t0, _x

	# pushing parameter x
	subu	$sp, $sp, 4
	lw	$t0, _x
	sw	$t0, 0($sp)

	# calling printX
	jal	_printX

	# pushing parameter a
	subu	$sp, $sp, 4
	lw	$t0, _a
	sw	$t0, 0($sp)

	# calling printA
	jal	_printA

	# pushing parameter 100
	li	$t0, 100
	sw	$t0, 0($sp)

	# calling print_int
	jal	_print_int

	# pushing parameter _temp6
	subu	$sp, $sp, 4
	la	$t0, __temp6
	sw	$t0, 0($sp)

	# calling print_string
	jal	_print_string

	# pushing parameter x
	subu	$sp, $sp, 4
	lw	$t0, _x
	sw	$t0, 0($sp)

	# calling make10
	jal	_make10

	# pushing parameter x
	subu	$sp, $sp, 4
	lw	$t0, _x
	sw	$t0, 0($sp)

	# calling printX
	jal	_printX

	lw	$ra, 32($sp)
	lw	$fp, 28($sp)
	addu	$sp, $sp, 36
	jr	$ra

.text

_make10:
	subu	$sp, $sp, 12
	sw	$ra, 8($sp)
	sw	$fp, 4($sp)
	addu	$fp, $sp, 12

	lw	$t0, 0($fp)
	sw	$t0, 0($sp)

	# pushing parameter x
	subu	$sp, $sp, 4
	lw	$t0, _x
	sw	$t0, 0($sp)

	# calling make5
	jal	_make5

	# pushing parameter x
	subu	$sp, $sp, 4
	lw	$t0, _x
	sw	$t0, 0($sp)

	# calling make5
	jal	_make5

	# pushing parameter _temp7
	subu	$sp, $sp, 4
	la	$t0, __temp7
	sw	$t0, 0($sp)

	# calling print_string
	jal	_print_string

	# n = 10
	li	$t0, 10
	sw	$t0, 8($sp)

	# x = 10
	li	$t0, 10
	sw	$t0, _x

	lw	$ra, 20($sp)
	lw	$fp, 16($sp)
	addu	$sp, $sp, 24
	jr	$ra

.text

_make5:
	subu	$sp, $sp, 12
	sw	$ra, 8($sp)
	sw	$fp, 4($sp)
	addu	$fp, $sp, 12

	lw	$t0, 0($fp)
	sw	$t0, 0($sp)

	# pushing parameter _temp10
	subu	$sp, $sp, 4
	la	$t0, __temp10
	sw	$t0, 0($sp)

	# calling print_string
	jal	_print_string

	# n = 5
	li	$t0, 5
	sw	$t0, 8($sp)

	# x = n
	lw	$t0, 8($sp)
	sw	$t0, _x

	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addu	$sp, $sp, 16
	jr	$ra

.text

_printX:
	subu	$sp, $sp, 12
	sw	$ra, 8($sp)
	sw	$fp, 4($sp)
	addu	$fp, $sp, 12

	lw	$t0, 0($fp)
	+
	sw	$t0, 0($sp)

	# pushing parameter _temp12
	subu	$sp, $sp, 4
	la	$t0, __temp12
	sw	$t0, 0($sp)

	# calling print_string
	jal	_print_string

	# pushing parameter x
	subu	$sp, $sp, 4
	lw	$t0, 8($sp)
	sw	$t0, 0($sp)

	# calling print_int
	jal	_print_int

	# pushing parameter _temp13
	subu	$sp, $sp, 4
	la	$t0, __temp13
	sw	$t0, 0($sp)

	# calling print_string
	jal	_print_string

	lw	$ra, 20($sp)
	lw	$fp, 16($sp)
	addu	$sp, $sp, 24
	jr	$ra

.text

_printA:
	subu	$sp, $sp, 12
	sw	$ra, 8($sp)
	sw	$fp, 4($sp)
	addu	$fp, $sp, 12

	lw	$t0, 0($fp)
	sw	$t0, 0($sp)

	# pushing parameter _temp14
	subu	$sp, $sp, 4
	la	$t0, __temp14
	sw	$t0, 0($sp)

	# calling print_string
	jal	_print_string

	# pushing parameter a
	subu	$sp, $sp, 4
	lw	$t0, 8($sp)
	sw	$t0, 0($sp)

	# calling print_int
	jal	_print_int

	# pushing parameter _temp15
	subu	$sp, $sp, 4
	la	$t0, __temp15
	sw	$t0, 0($sp)

	# calling print_string
	jal	_print_string

	lw	$ra, 20($sp)
	lw	$fp, 16($sp)
	addu	$sp, $sp, 24
	jr	$ra

.data

__temp15:
	.asciiz	"\n"

__temp14:
	.asciiz	"a = "

__temp13:
	.asciiz	"\n"

__temp12:
	.asciiz	"x = "

__temp10:
	.asciiz	"making 5...\n"

__temp7:
	.asciiz	"making 10...\n"

__temp6:
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
