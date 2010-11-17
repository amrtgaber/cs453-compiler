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

	# char1 = '#'
	li	$t0, '#'
	sb	$t0, _char1

	# char2 = '\n'
	li	$t0, 10		# 10 is ascii value for '\n'
	sb	$t0, _char2

	# char3 = '\0'
	li	$t0, 0		# 0 is ascii value for '\0'
	sb	$t0, _char3

	# x = 5
	li	$t0, 5
	sw	$t0, _x

	# pushing parameter x
	lw	$t0, _x
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling printX
	jal	_printX

	# popping pushed parameters
	addu	$sp, $sp, 4

	# a = 42
	li	$t0, 42
	sw	$t0, _a

	# pushing parameter a
	lw	$t0, _a
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling printA
	jal	_printA

	# popping pushed parameters
	addu	$sp, $sp, 4

	# x = a
	lw	$t0, _a
	sw	$t0, _x

	# pushing parameter x
	lw	$t0, _x
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling printX
	jal	_printX

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter a
	lw	$t0, _a
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling printA
	jal	_printA

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter 100
	subu	$sp, $sp, 4
	li	$t0, 100
	sw	$t0, 0($sp)

	# calling print_int
	jal	_print_int

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter _temp6
	la	$t0, __temp6
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling print_string
	jal	_print_string

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter x
	lw	$t0, _x
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling make10
	jal	_make10

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter x
	lw	$t0, _x
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling printX
	jal	_printX

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter intArray3
	la	$t0, _intArray3
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling takeIntArray
	jal	_takeIntArray

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter charArray2
	la	$t0, _charArray2
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling takeCharArray
	jal	_takeCharArray

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling onlyLocals
	jal	_onlyLocals

	# pushing parameter charArray1
	la	$t0, _charArray1
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# pushing parameter intArray1
	la	$t0, _intArray1
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# pushing parameter char1
	lb	$t0, _char1
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# pushing parameter int1
	lw	$t0, _int1
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling onlyParameters
	jal	_onlyParameters

	# popping pushed parameters
	addu	$sp, $sp, 16

	# pushing parameter intArray1
	la	$t0, _intArray1
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# pushing parameter charArray1
	la	$t0, _charArray1
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# pushing parameter 1
	subu	$sp, $sp, 4
	li	$t0, 1
	sw	$t0, 0($sp)

	# pushing parameter 'a'
	subu	$sp, $sp, 4
	li	$t0, 'a'
	sw	$t0, 0($sp)

	# calling parametersAndLocals
	jal	_parametersAndLocals

	# popping pushed parameters
	addu	$sp, $sp, 16

	# calling noVariables
	jal	_noVariables

	# a = 5
	li	$t0, 5
	sw	$t0, _a

	# int1 = 2
	li	$t0, 2
	sw	$t0, _int1

	# int2 = 3
	li	$t0, 3
	sw	$t0, _int2

	# x * 2
	li	$t1, 2
	lw	$t0, _x
	mul	$t0, $t0, $t1
	sw	$t0, __temp13

	# _temp13 - x
	lw	$t1, __temp13
	lw	$t0, _x
	sub	$t0, $t1, $t0
	sw	$t0, __temp14

	# _temp14 / a
	lw	$t1, __temp14
	lw	$t0, _a
	div	$t0, $t1, $t0
	sw	$t0, __temp15

	# _temp15 / int1
	lw	$t1, __temp15
	lw	$t0, _int1
	div	$t0, $t1, $t0
	sw	$t0, __temp16

	# int2 * _temp16
	lw	$t1, __temp16
	lw	$t0, _int2
	mul	$t0, $t0, $t1
	sw	$t0, __temp17

	# x = _temp17
	lw	$t0, __temp17
	sw	$t0, _x

	# pushing parameter x
	lw	$t0, _x
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling printX
	jal	_printX

	# popping pushed parameters
	addu	$sp, $sp, 4

_mainReturn:
	lw	$fp, 0($sp)
	lw	$ra, 4($sp)
	addu	$sp, $sp, 8
	jr	$ra

.text

_noVariables:
	subu	$sp, $sp, 8
	sw	$ra, 4($sp)
	sw	$fp, 0($sp)
	addu	$fp, $sp, 8

_noVariablesReturn:
	lw	$fp, 0($sp)
	lw	$ra, 4($sp)
	addu	$sp, $sp, 8
	jr	$ra

.text

_parametersAndLocals:
	subu	$sp, $sp, 96
	sw	$ra, 92($sp)
	sw	$fp, 88($sp)
	addu	$fp, $sp, 96
	lw	$t0, 0($fp)		# storing parameter p1
	sw	$t0, 84($sp)
	lw	$t0, 4($fp)		# storing parameter p2
	sw	$t0, 80($sp)
	lw	$t0, 8($fp)		# storing parameter p3
	sw	$t0, 76($sp)
	lb	$t0, 12($fp)		# storing parameter p4
	sb	$t0, 72($sp)
	# initializing local variables
	sw	$0, 68($sp)
	sw	$0, 64($sp)
	sw	$0, 60($sp)
	sw	$0, 56($sp)
	sw	$0, 52($sp)
	sw	$0, 48($sp)
	sw	$0, 44($sp)
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

_parametersAndLocalsReturn:
	lw	$fp, 88($sp)
	lw	$ra, 92($sp)
	addu	$sp, $sp, 96
	jr	$ra

.text

_onlyLocals:
	subu	$sp, $sp, 24
	sw	$ra, 20($sp)
	sw	$fp, 16($sp)
	addu	$fp, $sp, 24
	# initializing local variables
	sw	$0, 12($sp)
	sw	$0, 8($sp)
	sw	$0, 4($sp)
	sw	$0, 0($sp)

_onlyLocalsReturn:
	lw	$fp, 16($sp)
	lw	$ra, 20($sp)
	addu	$sp, $sp, 24
	jr	$ra

.text

_onlyParameters:
	subu	$sp, $sp, 24
	sw	$ra, 20($sp)
	sw	$fp, 16($sp)
	addu	$fp, $sp, 24
	lw	$t0, 0($fp)		# storing parameter param1
	sw	$t0, 12($sp)
	lw	$t0, 4($fp)		# storing parameter param2
	sw	$t0, 8($sp)
	lb	$t0, 8($fp)		# storing parameter param3
	sb	$t0, 4($sp)
	lw	$t0, 12($fp)		# storing parameter param4
	sw	$t0, 0($sp)

_onlyParametersReturn:
	lw	$fp, 16($sp)
	lw	$ra, 20($sp)
	addu	$sp, $sp, 24
	jr	$ra

.text

_takeIntArray:
	subu	$sp, $sp, 12
	sw	$ra, 8($sp)
	sw	$fp, 4($sp)
	addu	$fp, $sp, 12
	lw	$t0, 0($fp)		# storing parameter n
	sw	$t0, 0($sp)

	# return
	j	_takeIntArrayReturn

_takeIntArrayReturn:
	lw	$fp, 4($sp)
	lw	$ra, 8($sp)
	addu	$sp, $sp, 12
	jr	$ra

.text

_takeCharArray:
	subu	$sp, $sp, 12
	sw	$ra, 8($sp)
	sw	$fp, 4($sp)
	addu	$fp, $sp, 12
	lw	$t0, 0($fp)		# storing parameter c
	sw	$t0, 0($sp)

_takeCharArrayReturn:
	lw	$fp, 4($sp)
	lw	$ra, 8($sp)
	addu	$sp, $sp, 12
	jr	$ra

.text

_make10:
	subu	$sp, $sp, 12
	sw	$ra, 8($sp)
	sw	$fp, 4($sp)
	addu	$fp, $sp, 12
	lw	$t0, 0($fp)		# storing parameter n
	sw	$t0, 0($sp)

	# pushing parameter 3
	subu	$sp, $sp, 4
	li	$t0, 3
	sw	$t0, 0($sp)

	# calling make5
	jal	_make5

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter 50
	subu	$sp, $sp, 4
	li	$t0, 50
	sw	$t0, 0($sp)

	# calling make5
	jal	_make5

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter _temp20
	la	$t0, __temp20
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling print_string
	jal	_print_string

	# popping pushed parameters
	addu	$sp, $sp, 4

	# n = 10
	li	$t0, 10
	sw	$t0, 0($sp)

	# x = 10
	li	$t0, 10
	sw	$t0, _x

	# return
	j	_make10Return

_make10Return:
	lw	$fp, 4($sp)
	lw	$ra, 8($sp)
	addu	$sp, $sp, 12
	jr	$ra

.text

_make5:
	subu	$sp, $sp, 12
	sw	$ra, 8($sp)
	sw	$fp, 4($sp)
	addu	$fp, $sp, 12
	lw	$t0, 0($fp)		# storing parameter n
	sw	$t0, 0($sp)

	# pushing parameter _temp23
	la	$t0, __temp23
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling print_string
	jal	_print_string

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter _temp24
	la	$t0, __temp24
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling print_string
	jal	_print_string

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter n
	lw	$t0, 0($sp)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling print_int
	jal	_print_int

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter _temp6
	la	$t0, __temp6
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling print_string
	jal	_print_string

	# popping pushed parameters
	addu	$sp, $sp, 4

	# n = 5
	li	$t0, 5
	sw	$t0, 0($sp)

	# x = n
	lw	$t0, 0($sp)
	sw	$t0, _x

_make5Return:
	lw	$fp, 4($sp)
	lw	$ra, 8($sp)
	addu	$sp, $sp, 12
	jr	$ra

.text

_printX:
	subu	$sp, $sp, 12
	sw	$ra, 8($sp)
	sw	$fp, 4($sp)
	addu	$fp, $sp, 12
	lw	$t0, 0($fp)		# storing parameter x
	sw	$t0, 0($sp)

	# pushing parameter _temp26
	la	$t0, __temp26
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling print_string
	jal	_print_string

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter x
	lw	$t0, 0($sp)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling print_int
	jal	_print_int

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter _temp6
	la	$t0, __temp6
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling print_string
	jal	_print_string

	# popping pushed parameters
	addu	$sp, $sp, 4

_printXReturn:
	lw	$fp, 4($sp)
	lw	$ra, 8($sp)
	addu	$sp, $sp, 12
	jr	$ra

.text

_printA:
	subu	$sp, $sp, 12
	sw	$ra, 8($sp)
	sw	$fp, 4($sp)
	addu	$fp, $sp, 12
	lw	$t0, 0($fp)		# storing parameter a
	sw	$t0, 0($sp)

	# pushing parameter _temp27
	la	$t0, __temp27
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling print_string
	jal	_print_string

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter a
	lw	$t0, 0($sp)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling print_int
	jal	_print_int

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter _temp6
	la	$t0, __temp6
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling print_string
	jal	_print_string

	# popping pushed parameters
	addu	$sp, $sp, 4

_printAReturn:
	lw	$fp, 4($sp)
	lw	$ra, 8($sp)
	addu	$sp, $sp, 12
	jr	$ra

.data

__temp17:
	.word 0

__temp16:
	.word 0

__temp15:
	.word 0

__temp14:
	.word 0

__temp13:
	.word 0

__temp27:
	.asciiz	"a = "

__temp26:
	.asciiz	"x = "

__temp24:
	.asciiz	"n = "

__temp23:
	.asciiz	"making 5...\n"

__temp20:
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
