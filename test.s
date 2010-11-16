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
	subu	$sp, $sp, 16
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	sw	$t0, 4($sp)
	sw	$t1, 0($sp)
	addu	$fp, $sp, 16

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

	# x = _temp13
	sw	$t0, _x

_mainReturn:
	lw	$t1, 0($sp)
	lw	$t0, 4($sp)
	lw	$fp, 8($sp)
	lw	$ra, 12($sp)
	addu	$sp, $sp, 16
	jr	$ra

.text

_noVariables:
	subu	$sp, $sp, 16
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	sw	$t0, 4($sp)
	sw	$t1, 0($sp)
	addu	$fp, $sp, 16

_noVariablesReturn:
	lw	$t1, 0($sp)
	lw	$t0, 4($sp)
	lw	$fp, 8($sp)
	lw	$ra, 12($sp)
	addu	$sp, $sp, 16
	jr	$ra

.text

_parametersAndLocals:
	subu	$sp, $sp, 48
	sw	$ra, 44($sp)
	sw	$fp, 40($sp)
	sw	$t0, 36($sp)
	sw	$t1, 32($sp)
	addu	$fp, $sp, 48
	lw	$t0, 0($fp)		# storing local variable p1
	sw	$t0, 28($sp)
	lw	$t0, 4($fp)		# storing local variable p2
	sw	$t0, 24($sp)
	lw	$t0, 8($fp)		# storing local variable p3
	sw	$t0, 20($sp)
	lb	$t0, 12($fp)		# storing parameter p4
	sb	$t0, 16($sp)
	# initializing local variables
	sw	$0, 12($sp)
	sw	$0, 8($sp)
	sw	$0, 4($sp)
	sw	$0, 0($sp)

_parametersAndLocalsReturn:
	lw	$t1, 32($sp)
	lw	$t0, 36($sp)
	lw	$fp, 40($sp)
	lw	$ra, 44($sp)
	addu	$sp, $sp, 48
	jr	$ra

.text

_onlyLocals:
	subu	$sp, $sp, 32
	sw	$ra, 28($sp)
	sw	$fp, 24($sp)
	sw	$t0, 20($sp)
	sw	$t1, 16($sp)
	addu	$fp, $sp, 32
	# initializing local variables
	sw	$0, 12($sp)
	sw	$0, 8($sp)
	sw	$0, 4($sp)
	sw	$0, 0($sp)

_onlyLocalsReturn:
	lw	$t1, 16($sp)
	lw	$t0, 20($sp)
	lw	$fp, 24($sp)
	lw	$ra, 28($sp)
	addu	$sp, $sp, 32
	jr	$ra

.text

_onlyParameters:
	subu	$sp, $sp, 32
	sw	$ra, 28($sp)
	sw	$fp, 24($sp)
	sw	$t0, 20($sp)
	sw	$t1, 16($sp)
	addu	$fp, $sp, 32
	lw	$t0, 0($fp)		# storing local variable param1
	sw	$t0, 12($sp)
	lw	$t0, 4($fp)		# storing local variable param2
	sw	$t0, 8($sp)
	lb	$t0, 8($fp)		# storing parameter param3
	sb	$t0, 4($sp)
	lw	$t0, 12($fp)		# storing local variable param4
	sw	$t0, 0($sp)

_onlyParametersReturn:
	lw	$t1, 16($sp)
	lw	$t0, 20($sp)
	lw	$fp, 24($sp)
	lw	$ra, 28($sp)
	addu	$sp, $sp, 32
	jr	$ra

.text

_takeIntArray:
	subu	$sp, $sp, 20
	sw	$ra, 16($sp)
	sw	$fp, 12($sp)
	sw	$t0, 8($sp)
	sw	$t1, 4($sp)
	addu	$fp, $sp, 20
	lw	$t0, 0($fp)		# storing local variable n
	sw	$t0, 0($sp)

	# return
	j	_takeIntArrayReturn

_takeIntArrayReturn:
	lw	$t1, 4($sp)
	lw	$t0, 8($sp)
	lw	$fp, 12($sp)
	lw	$ra, 16($sp)
	addu	$sp, $sp, 20
	jr	$ra

.text

_takeCharArray:
	subu	$sp, $sp, 20
	sw	$ra, 16($sp)
	sw	$fp, 12($sp)
	sw	$t0, 8($sp)
	sw	$t1, 4($sp)
	addu	$fp, $sp, 20
	lw	$t0, 0($fp)		# storing local variable c
	sw	$t0, 0($sp)

_takeCharArrayReturn:
	lw	$t1, 4($sp)
	lw	$t0, 8($sp)
	lw	$fp, 12($sp)
	lw	$ra, 16($sp)
	addu	$sp, $sp, 20
	jr	$ra

.text

_make10:
	subu	$sp, $sp, 20
	sw	$ra, 16($sp)
	sw	$fp, 12($sp)
	sw	$t0, 8($sp)
	sw	$t1, 4($sp)
	addu	$fp, $sp, 20
	lw	$t0, 0($fp)		# storing local variable n
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

	# pushing parameter _temp16
	la	$t0, __temp16
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
	lw	$t1, 4($sp)
	lw	$t0, 8($sp)
	lw	$fp, 12($sp)
	lw	$ra, 16($sp)
	addu	$sp, $sp, 20
	jr	$ra

.text

_make5:
	subu	$sp, $sp, 20
	sw	$ra, 16($sp)
	sw	$fp, 12($sp)
	sw	$t0, 8($sp)
	sw	$t1, 4($sp)
	addu	$fp, $sp, 20
	lw	$t0, 0($fp)		# storing local variable n
	sw	$t0, 0($sp)

	# pushing parameter _temp19
	la	$t0, __temp19
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling print_string
	jal	_print_string

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
	lw	$t1, 4($sp)
	lw	$t0, 8($sp)
	lw	$fp, 12($sp)
	lw	$ra, 16($sp)
	addu	$sp, $sp, 20
	jr	$ra

.text

_printX:
	subu	$sp, $sp, 20
	sw	$ra, 16($sp)
	sw	$fp, 12($sp)
	sw	$t0, 8($sp)
	sw	$t1, 4($sp)
	addu	$fp, $sp, 20
	lw	$t0, 0($fp)		# storing local variable x
	sw	$t0, 0($sp)

	# pushing parameter _temp22
	la	$t0, __temp22
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
	lw	$t1, 4($sp)
	lw	$t0, 8($sp)
	lw	$fp, 12($sp)
	lw	$ra, 16($sp)
	addu	$sp, $sp, 20
	jr	$ra

.text

_printA:
	subu	$sp, $sp, 20
	sw	$ra, 16($sp)
	sw	$fp, 12($sp)
	sw	$t0, 8($sp)
	sw	$t1, 4($sp)
	addu	$fp, $sp, 20
	lw	$t0, 0($fp)		# storing local variable a
	sw	$t0, 0($sp)

	# pushing parameter _temp23
	la	$t0, __temp23
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
	lw	$t1, 4($sp)
	lw	$t0, 8($sp)
	lw	$fp, 12($sp)
	lw	$ra, 16($sp)
	addu	$sp, $sp, 20
	jr	$ra

.data

__temp23:
	.asciiz	"a = "

__temp22:
	.asciiz	"x = "

__temp20:
	.asciiz	"n = "

__temp19:
	.asciiz	"making 5...\n"

__temp16:
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
