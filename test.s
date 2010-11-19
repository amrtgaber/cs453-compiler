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
	.space 16
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
	subu	$sp, $sp, 36
	sw	$ra, 32($sp)
	sw	$fp, 28($sp)
	addu	$fp, $sp, 36
	# initializing local variables
	sw	$0, 24($sp)
	sw	$0, 20($sp)
	sw	$0, 16($sp)
	sw	$0, 12($sp)
	sw	$0, 8($sp)
	sw	$0, 4($sp)
	sw	$0, 0($sp)

	# charString[1]
	li	$t1, 1
	la	$t0, 0($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp2

	# _temp2 = '\0'
	li	$t0, 0		# 0 is ascii value for '\0'
	lw	$t1, __temp2
	sb	$t0, 0($t1)

	# local1 = 5
	li	$t0, 5
	sw	$t0, 8($sp)

	# -5
	li	$t0, 5
	neg	$t0, $t0
	sw	$t0, __temp5

	# local2 = _temp5
	lw	$t0, __temp5
	sw	$t0, 4($sp)

	# local1 == local2
	lw	$t1, 4($sp)
	lw	$t0, 8($sp)
	seq	$t0, $t0, $t1
	sw	$t0, __temp6

	lw	$t0, __temp6
	bgtz	$t0, __label4

	j	__label5

__label4:

	# pushing parameter _temp7
	la	$t0, __temp7
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	j	__label6

__label5:

	# pushing parameter _temp8
	la	$t0, __temp8
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

__label6:

	# pushing parameter _temp9
	la	$t0, __temp9
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# local1 = 0
	li	$t0, 0
	sw	$t0, 8($sp)

	j	__label2

__label3:

	# 1 + local1
	li	$t0, 1
	lw	$t1, 8($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp17

	# _temp17 * 5
	li	$t1, 5
	lw	$t0, __temp17
	mul	$t0, $t0, $t1
	sw	$t0, __temp18

	# localArray[local1]
	lw	$t1, 8($sp)
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, 12($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp19

	# _temp19 = _temp18
	lw	$t0, __temp18
	lw	$t1, __temp19
	sw	$t0, 0($t1)

	# 1 + local1
	li	$t0, 1
	lw	$t1, 8($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp14

	# local1 = _temp14
	lw	$t0, __temp14
	sw	$t0, 8($sp)

__label2:

	# 4 < local1
	li	$t0, 4
	lw	$t1, 8($sp)
	slt	$t0, $t1, $t0
	sw	$t0, __temp12

	lw	$t0, __temp12
	bgtz	$t0, __label3

	# pushing parameter _temp20
	la	$t0, __temp20
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# localArray[0]
	li	$t1, 0
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, 12($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp22

	# pushing parameter _temp22
	lw	$t0, __temp22
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp23
	la	$t0, __temp23
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# localArray[1]
	li	$t1, 1
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, 12($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp25

	# pushing parameter _temp25
	lw	$t0, __temp25
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp26
	la	$t0, __temp26
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# localArray[2]
	li	$t1, 2
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, 12($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp28

	# pushing parameter _temp28
	lw	$t0, __temp28
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp29
	la	$t0, __temp29
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# localArray[3]
	li	$t1, 3
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, 12($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp31

	# pushing parameter _temp31
	lw	$t0, __temp31
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp32
	la	$t0, __temp32
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# local1 = 3
	li	$t0, 3
	sw	$t0, 8($sp)

	j	__label0

__label1:

	# 1 + local1
	li	$t0, 1
	lw	$t1, 8($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp37

	# intArray1[local1]
	lw	$t1, 8($sp)
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, _intArray1
	add	$t0, $t0, $t1
	sw	$t0, __temp38

	# _temp38 = _temp37
	lw	$t0, __temp37
	lw	$t1, __temp38
	sw	$t0, 0($t1)

	# local1 - 1
	li	$t0, 1
	lw	$t1, 8($sp)
	sub	$t0, $t1, $t0
	sw	$t0, __temp40

	# local1 = _temp40
	lw	$t0, __temp40
	sw	$t0, 8($sp)

__label0:

	# 0 >= local1
	li	$t0, 0
	lw	$t1, 8($sp)
	sge	$t0, $t1, $t0
	sw	$t0, __temp35

	lw	$t0, __temp35
	bgtz	$t0, __label1

	# pushing parameter _temp41
	la	$t0, __temp41
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# intArray1[0]
	li	$t1, 0
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, _intArray1
	add	$t0, $t0, $t1
	sw	$t0, __temp43

	# pushing parameter _temp43
	lw	$t0, __temp43
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp44
	la	$t0, __temp44
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# intArray1[1]
	li	$t1, 1
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, _intArray1
	add	$t0, $t0, $t1
	sw	$t0, __temp46

	# pushing parameter _temp46
	lw	$t0, __temp46
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp47
	la	$t0, __temp47
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# intArray1[2]
	li	$t1, 2
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, _intArray1
	add	$t0, $t0, $t1
	sw	$t0, __temp49

	# pushing parameter _temp49
	lw	$t0, __temp49
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp50
	la	$t0, __temp50
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# intArray1[3]
	li	$t1, 3
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, _intArray1
	add	$t0, $t0, $t1
	sw	$t0, __temp52

	# pushing parameter _temp52
	lw	$t0, __temp52
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp53
	la	$t0, __temp53
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# char1 = '#'
	li	$t0, '#'
	sb	$t0, _char1

	# charString[0]
	li	$t1, 0
	la	$t0, 0($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp56

	# _temp56 = char1
	lb	$t0, _char1
	lw	$t1, __temp56
	sb	$t0, 0($t1)

	# pushing parameter _temp57
	la	$t0, __temp57
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter charString
	la	$t0, 0($sp)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# char2 = '\n'
	li	$t0, 10		# 10 is ascii value for '\n'
	sb	$t0, _char2

	# charString[0]
	li	$t1, 0
	la	$t0, 0($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp60

	# _temp60 = char2
	lb	$t0, _char2
	lw	$t1, __temp60
	sb	$t0, 0($t1)

	# pushing parameter _temp61
	la	$t0, __temp61
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter charString
	la	$t0, 0($sp)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# char3 = '\0'
	li	$t0, 0		# 0 is ascii value for '\0'
	sb	$t0, _char3

	# charString[0]
	li	$t1, 0
	la	$t0, 0($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp64

	# _temp64 = char3
	lb	$t0, _char3
	lw	$t1, __temp64
	sb	$t0, 0($t1)

	# pushing parameter _temp65
	la	$t0, __temp65
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter charString
	la	$t0, 0($sp)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp66
	la	$t0, __temp66
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

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

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

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

	# pushing parameter _temp72
	la	$t0, __temp72
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# x = 10
	li	$t0, 10
	sw	$t0, _x

	# x / 2
	li	$t0, 2
	lw	$t1, _x
	div	$t0, $t1, $t0
	sw	$t0, __temp75

	# a = _temp75
	lw	$t0, __temp75
	sw	$t0, _a

	# a / 2
	li	$t0, 2
	lw	$t1, _a
	div	$t0, $t1, $t0
	sw	$t0, __temp77

	# local1 = _temp77
	lw	$t0, __temp77
	sw	$t0, 8($sp)

	# local2 = 3
	li	$t0, 3
	sw	$t0, 4($sp)

	# x * 2
	li	$t1, 2
	lw	$t0, _x
	mul	$t0, $t0, $t1
	sw	$t0, __temp80

	# _temp80 - x
	lw	$t1, __temp80
	lw	$t0, _x
	sub	$t0, $t1, $t0
	sw	$t0, __temp81

	# _temp81 / a
	lw	$t1, __temp81
	lw	$t0, _a
	div	$t0, $t1, $t0
	sw	$t0, __temp82

	# _temp82 / local1
	lw	$t1, __temp82
	lw	$t0, 8($sp)
	div	$t0, $t1, $t0
	sw	$t0, __temp83

	# local2 * _temp83
	lw	$t1, __temp83
	lw	$t0, 4($sp)
	mul	$t0, $t0, $t1
	sw	$t0, __temp84

	# _temp84 - 38
	li	$t0, 38
	lw	$t1, __temp84
	sub	$t0, $t1, $t0
	sw	$t0, __temp86

	# 10 + _temp86
	li	$t0, 10
	lw	$t1, __temp86
	add	$t0, $t0, $t1
	sw	$t0, __temp88

	# x = _temp88
	lw	$t0, __temp88
	sw	$t0, _x

	# pushing parameter x
	lw	$t0, _x
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling printX
	jal	_printX

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter _temp89
	la	$t0, __temp89
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling return5
	jal	_return5

	# retrieve return value from return5
	sw	$v0, __temp90

	# x = _temp90
	lw	$t0, __temp90
	sw	$t0, _x

	# pushing parameter x
	lw	$t0, _x
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling printX
	jal	_printX

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter _temp91
	la	$t0, __temp91
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling return5
	jal	_return5

	# retrieve return value from return5
	sw	$v0, __temp93

	# _temp93 + 100
	li	$t1, 100
	lw	$t0, __temp93
	add	$t0, $t0, $t1
	sw	$t0, __temp94

	# calling return5
	jal	_return5

	# retrieve return value from return5
	sw	$v0, __temp95

	# _temp95 + _temp94
	lw	$t1, __temp94
	lw	$t0, __temp95
	add	$t0, $t0, $t1
	sw	$t0, __temp96

	# 10 + _temp96
	li	$t0, 10
	lw	$t1, __temp96
	add	$t0, $t0, $t1
	sw	$t0, __temp98

	# x = _temp98
	lw	$t0, __temp98
	sw	$t0, _x

	# pushing parameter x
	lw	$t0, _x
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling printX
	jal	_printX

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter _temp99
	la	$t0, __temp99
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter 2
	subu	$sp, $sp, 4
	li	$t0, 2
	sw	$t0, 0($sp)

	# pushing parameter localArray
	la	$t0, 4 + 12($sp)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling scale
	jal	_scale

	# popping pushed parameters
	addu	$sp, $sp, 8

	# pushing parameter _temp20
	la	$t0, __temp20
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# localArray[0]
	li	$t1, 0
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, 12($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp102

	# pushing parameter _temp102
	lw	$t0, __temp102
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp23
	la	$t0, __temp23
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# localArray[1]
	li	$t1, 1
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, 12($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp104

	# pushing parameter _temp104
	lw	$t0, __temp104
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp26
	la	$t0, __temp26
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# localArray[2]
	li	$t1, 2
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, 12($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp106

	# pushing parameter _temp106
	lw	$t0, __temp106
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp29
	la	$t0, __temp29
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# localArray[3]
	li	$t1, 3
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, 12($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp108

	# pushing parameter _temp108
	lw	$t0, __temp108
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# -1
	li	$t0, 1
	neg	$t0, $t0
	sw	$t0, __temp110

	# pushing parameter _temp110
	lw	$t0, __temp110
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# pushing parameter intArray1
	la	$t0, _intArray1
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling scale
	jal	_scale

	# popping pushed parameters
	addu	$sp, $sp, 8

	# pushing parameter _temp41
	la	$t0, __temp41
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# intArray1[0]
	li	$t1, 0
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, _intArray1
	add	$t0, $t0, $t1
	sw	$t0, __temp112

	# pushing parameter _temp112
	lw	$t0, __temp112
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp44
	la	$t0, __temp44
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# intArray1[1]
	li	$t1, 1
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, _intArray1
	add	$t0, $t0, $t1
	sw	$t0, __temp114

	# pushing parameter _temp114
	lw	$t0, __temp114
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp47
	la	$t0, __temp47
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# intArray1[2]
	li	$t1, 2
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, _intArray1
	add	$t0, $t0, $t1
	sw	$t0, __temp116

	# pushing parameter _temp116
	lw	$t0, __temp116
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp50
	la	$t0, __temp50
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# intArray1[3]
	li	$t1, 3
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, _intArray1
	add	$t0, $t0, $t1
	sw	$t0, __temp118

	# pushing parameter _temp118
	lw	$t0, __temp118
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp119
	la	$t0, __temp119
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter 1
	subu	$sp, $sp, 4
	li	$t0, 1
	sw	$t0, 0($sp)

	# pushing parameter localArray
	la	$t0, 4 + 12($sp)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling index
	jal	_index

	# popping pushed parameters
	addu	$sp, $sp, 8

	# retrieve return value from index
	sw	$v0, __temp121

	# x = _temp121
	lw	$t0, __temp121
	sw	$t0, _x

	# pushing parameter x
	lw	$t0, _x
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling printX
	jal	_printX

	# popping pushed parameters
	addu	$sp, $sp, 4

__mainReturn:
	lw	$fp, 28($sp)
	lw	$ra, 32($sp)
	addu	$sp, $sp, 36
	jr	$ra

.text

_ps:
	subu	$sp, $sp, 12
	sw	$ra, 8($sp)
	sw	$fp, 4($sp)
	addu	$fp, $sp, 12
	lw	$t0, 0($fp)		# storing parameter string
	sw	$t0, 0($sp)

	# pushing parameter string
	lw	$t0, 0($sp)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling print_string
	jal	_print_string

	# popping pushed parameters
	addu	$sp, $sp, 4

__psReturn:
	lw	$fp, 4($sp)
	lw	$ra, 8($sp)
	addu	$sp, $sp, 12
	jr	$ra

.text

_pi:
	subu	$sp, $sp, 12
	sw	$ra, 8($sp)
	sw	$fp, 4($sp)
	addu	$fp, $sp, 12
	lw	$t0, 0($fp)		# storing parameter n
	sw	$t0, 0($sp)

	# pushing parameter n
	lw	$t0, 0($sp)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling print_int
	jal	_print_int

	# popping pushed parameters
	addu	$sp, $sp, 4

__piReturn:
	lw	$fp, 4($sp)
	lw	$ra, 8($sp)
	addu	$sp, $sp, 12
	jr	$ra

.text

_pn:
	subu	$sp, $sp, 8
	sw	$ra, 4($sp)
	sw	$fp, 0($sp)
	addu	$fp, $sp, 8

	# pushing parameter _temp122
	la	$t0, __temp122
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling print_string
	jal	_print_string

	# popping pushed parameters
	addu	$sp, $sp, 4

__pnReturn:
	lw	$fp, 0($sp)
	lw	$ra, 4($sp)
	addu	$sp, $sp, 8
	jr	$ra

.text

_index:
	subu	$sp, $sp, 16
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addu	$fp, $sp, 16
	lw	$t0, 0($fp)		# storing parameter array
	sw	$t0, 4($sp)
	lw	$t0, 4($fp)		# storing parameter index
	sw	$t0, 0($sp)

	# array[index]
	lw	$t1, 0($sp)
	sll	$t1, $t1, 2		# index * 4 (size of int)
	lw	$t0, 4($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp123

	# return _temp123
	lw	$t0, __temp123
	lw	$t0, 0($t0)
	add	$v0, $t0, $0
	j	__indexReturn

__indexReturn:
	lw	$fp, 8($sp)
	lw	$ra, 12($sp)
	addu	$sp, $sp, 16
	jr	$ra

.text

_scale:
	subu	$sp, $sp, 16
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addu	$fp, $sp, 16
	lw	$t0, 0($fp)		# storing parameter array
	sw	$t0, 4($sp)
	lw	$t0, 4($fp)		# storing parameter factor
	sw	$t0, 0($sp)

	# array[0]
	li	$t1, 0
	sll	$t1, $t1, 2		# index * 4 (size of int)
	lw	$t0, 4($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp126

	# factor * _temp126
	lw	$t1, __temp126
	lw	$t1, 0($t0)
	lw	$t0, 0($sp)
	mul	$t0, $t0, $t1
	sw	$t0, __temp127

	# array[0]
	li	$t1, 0
	sll	$t1, $t1, 2		# index * 4 (size of int)
	lw	$t0, 4($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp128

	# _temp128 = _temp127
	lw	$t0, __temp127
	lw	$t1, __temp128
	sw	$t0, 0($t1)

	# array[1]
	li	$t1, 1
	sll	$t1, $t1, 2		# index * 4 (size of int)
	lw	$t0, 4($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp131

	# factor * _temp131
	lw	$t1, __temp131
	lw	$t1, 0($t0)
	lw	$t0, 0($sp)
	mul	$t0, $t0, $t1
	sw	$t0, __temp132

	# array[1]
	li	$t1, 1
	sll	$t1, $t1, 2		# index * 4 (size of int)
	lw	$t0, 4($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp133

	# _temp133 = _temp132
	lw	$t0, __temp132
	lw	$t1, __temp133
	sw	$t0, 0($t1)

	# array[2]
	li	$t1, 2
	sll	$t1, $t1, 2		# index * 4 (size of int)
	lw	$t0, 4($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp136

	# factor * _temp136
	lw	$t1, __temp136
	lw	$t1, 0($t0)
	lw	$t0, 0($sp)
	mul	$t0, $t0, $t1
	sw	$t0, __temp137

	# array[2]
	li	$t1, 2
	sll	$t1, $t1, 2		# index * 4 (size of int)
	lw	$t0, 4($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp138

	# _temp138 = _temp137
	lw	$t0, __temp137
	lw	$t1, __temp138
	sw	$t0, 0($t1)

	# array[3]
	li	$t1, 3
	sll	$t1, $t1, 2		# index * 4 (size of int)
	lw	$t0, 4($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp141

	# factor * _temp141
	lw	$t1, __temp141
	lw	$t1, 0($t0)
	lw	$t0, 0($sp)
	mul	$t0, $t0, $t1
	sw	$t0, __temp142

	# array[3]
	li	$t1, 3
	sll	$t1, $t1, 2		# index * 4 (size of int)
	lw	$t0, 4($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp143

	# _temp143 = _temp142
	lw	$t0, __temp142
	lw	$t1, __temp143
	sw	$t0, 0($t1)

__scaleReturn:
	lw	$fp, 8($sp)
	lw	$ra, 12($sp)
	addu	$sp, $sp, 16
	jr	$ra

.text

_return5:
	subu	$sp, $sp, 8
	sw	$ra, 4($sp)
	sw	$fp, 0($sp)
	addu	$fp, $sp, 8

	# return 5
	li	$t0, 5
	add	$v0, $t0, $0
	j	__return5Return

__return5Return:
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

__noVariablesReturn:
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

__parametersAndLocalsReturn:
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

__onlyLocalsReturn:
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

__onlyParametersReturn:
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
	j	__takeIntArrayReturn

__takeIntArrayReturn:
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

__takeCharArrayReturn:
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

	# pushing parameter _temp145
	la	$t0, __temp145
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter x
	lw	$t0, 0($sp)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

__printXReturn:
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

	# pushing parameter _temp146
	la	$t0, __temp146
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter a
	lw	$t0, 0($sp)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

__printAReturn:
	lw	$fp, 4($sp)
	lw	$ra, 8($sp)
	addu	$sp, $sp, 12
	jr	$ra

.data

__temp143:
	.word 0

__temp142:
	.word 0

__temp141:
	.word 0

__temp138:
	.word 0

__temp137:
	.word 0

__temp136:
	.word 0

__temp133:
	.word 0

__temp132:
	.word 0

__temp131:
	.word 0

__temp128:
	.word 0

__temp127:
	.word 0

__temp126:
	.word 0

__temp123:
	.word 0

__temp121:
	.word 0

__temp118:
	.word 0

__temp116:
	.word 0

__temp114:
	.word 0

__temp112:
	.word 0

__temp110:
	.word 0

__temp108:
	.word 0

__temp106:
	.word 0

__temp104:
	.word 0

__temp102:
	.word 0

__temp98:
	.word 0

__temp96:
	.word 0

__temp95:
	.word 0

__temp94:
	.word 0

__temp93:
	.word 0

__temp90:
	.word 0

__temp88:
	.word 0

__temp86:
	.word 0

__temp84:
	.word 0

__temp83:
	.word 0

__temp82:
	.word 0

__temp81:
	.word 0

__temp80:
	.word 0

__temp77:
	.word 0

__temp75:
	.word 0

__temp64:
	.word 0

__temp60:
	.word 0

__temp56:
	.word 0

__temp52:
	.word 0

__temp49:
	.word 0

__temp46:
	.word 0

__temp43:
	.word 0

__temp40:
	.word 0

__temp38:
	.word 0

__temp37:
	.word 0

__temp35:
	.word 0

__temp31:
	.word 0

__temp28:
	.word 0

__temp25:
	.word 0

__temp22:
	.word 0

__temp19:
	.word 0

__temp18:
	.word 0

__temp17:
	.word 0

__temp14:
	.word 0

__temp12:
	.word 0

__temp6:
	.word 0

__temp5:
	.word 0

__temp2:
	.word 0

__temp146:
	.asciiz	"a = "

__temp145:
	.asciiz	"x = "

__temp122:
	.asciiz	"\n"

__temp119:
	.asciiz	"\nLet's wrap an array indexing operation...\n"

__temp99:
	.asciiz	"\nLet's use functions to modify some arrays...\n"

__temp91:
	.asciiz	"\nNow for a double call with simple addition...\n"

__temp89:
	.asciiz	"\nNow for a function call...\n"

__temp72:
	.asciiz	"\nNow for an expr...\n"

__temp66:
	.asciiz	"\nInitializing some ints...\n"

__temp65:
	.asciiz	"char3 = "

__temp61:
	.asciiz	"char2 = "

__temp57:
	.asciiz	"char1 = "

__temp53:
	.asciiz	"\nInitializing some chars...\n"

__temp50:
	.asciiz	"intArray1[3] = "

__temp47:
	.asciiz	"intArray1[2] = "

__temp44:
	.asciiz	"intArray1[1] = "

__temp41:
	.asciiz	"intArray1[0] = "

__temp32:
	.asciiz	"\nInitializing global array...\n"

__temp29:
	.asciiz	"localArray[3] = "

__temp26:
	.asciiz	"localArray[2] = "

__temp23:
	.asciiz	"localArray[1] = "

__temp20:
	.asciiz	"localArray[0] = "

__temp9:
	.asciiz	"\nInitializing local int array...\n"

__temp8:
	.asciiz	"\nTEST PROGRAM:\n"

__temp7:
	.asciiz	"\nTest Program:\n"

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
