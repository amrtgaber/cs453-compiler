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

	# pushing parameter _temp3
	la	$t0, __temp3
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter _temp4
	la	$t0, __temp4
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
	sw	$t0, __temp7

	# _temp7 = 5
	li	$t0, 5
	lw	$t1, __temp7
	sw	$t0, 0($t1)

	# localArray[1]
	li	$t1, 1
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, 12($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp10

	# _temp10 = 10
	li	$t0, 10
	lw	$t1, __temp10
	sw	$t0, 0($t1)

	# localArray[2]
	li	$t1, 2
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, 12($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp13

	# _temp13 = 15
	li	$t0, 15
	lw	$t1, __temp13
	sw	$t0, 0($t1)

	# localArray[3]
	li	$t1, 3
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, 12($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp16

	# _temp16 = 20
	li	$t0, 20
	lw	$t1, __temp16
	sw	$t0, 0($t1)

	# pushing parameter _temp17
	la	$t0, __temp17
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
	sw	$t0, __temp19

	# pushing parameter _temp19
	lw	$t0, __temp19
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp20
	la	$t0, __temp20
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

	# localArray[2]
	li	$t1, 2
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

	# localArray[3]
	li	$t1, 3
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

	# intArray1[0]
	li	$t1, 0
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, _intArray1
	add	$t0, $t0, $t1
	sw	$t0, __temp32

	# _temp32 = 1
	li	$t0, 1
	lw	$t1, __temp32
	sw	$t0, 0($t1)

	# intArray1[1]
	li	$t1, 1
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, _intArray1
	add	$t0, $t0, $t1
	sw	$t0, __temp35

	# _temp35 = 2
	li	$t0, 2
	lw	$t1, __temp35
	sw	$t0, 0($t1)

	# intArray1[2]
	li	$t1, 2
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, _intArray1
	add	$t0, $t0, $t1
	sw	$t0, __temp38

	# _temp38 = 3
	li	$t0, 3
	lw	$t1, __temp38
	sw	$t0, 0($t1)

	# intArray1[3]
	li	$t1, 3
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, _intArray1
	add	$t0, $t0, $t1
	sw	$t0, __temp41

	# _temp41 = 4
	li	$t0, 4
	lw	$t1, __temp41
	sw	$t0, 0($t1)

	# pushing parameter _temp42
	la	$t0, __temp42
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
	sw	$t0, __temp44

	# pushing parameter _temp44
	lw	$t0, __temp44
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp45
	la	$t0, __temp45
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
	sw	$t0, __temp47

	# pushing parameter _temp47
	lw	$t0, __temp47
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp48
	la	$t0, __temp48
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
	sw	$t0, __temp50

	# pushing parameter _temp50
	lw	$t0, __temp50
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp51
	la	$t0, __temp51
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
	sw	$t0, __temp53

	# pushing parameter _temp53
	lw	$t0, __temp53
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp54
	la	$t0, __temp54
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
	sw	$t0, __temp57

	# _temp57 = char1
	lb	$t0, _char1
	lw	$t1, __temp57
	sb	$t0, 0($t1)

	# pushing parameter _temp58
	la	$t0, __temp58
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
	sw	$t0, __temp61

	# _temp61 = char2
	lb	$t0, _char2
	lw	$t1, __temp61
	sb	$t0, 0($t1)

	# pushing parameter _temp62
	la	$t0, __temp62
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
	sw	$t0, __temp65

	# _temp65 = char3
	lb	$t0, _char3
	lw	$t1, __temp65
	sb	$t0, 0($t1)

	# pushing parameter _temp66
	la	$t0, __temp66
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

	# pushing parameter _temp67
	la	$t0, __temp67
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

	# pushing parameter _temp73
	la	$t0, __temp73
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
	sw	$t0, __temp76

	# a = _temp76
	lw	$t0, __temp76
	sw	$t0, _a

	# a / 2
	li	$t0, 2
	lw	$t1, _a
	div	$t0, $t1, $t0
	sw	$t0, __temp78

	# local1 = _temp78
	lw	$t0, __temp78
	sw	$t0, 8($sp)

	# local2 = 3
	li	$t0, 3
	sw	$t0, 4($sp)

	# x * 2
	li	$t1, 2
	lw	$t0, _x
	mul	$t0, $t0, $t1
	sw	$t0, __temp81

	# _temp81 - x
	lw	$t1, __temp81
	lw	$t0, _x
	sub	$t0, $t1, $t0
	sw	$t0, __temp82

	# _temp82 / a
	lw	$t1, __temp82
	lw	$t0, _a
	div	$t0, $t1, $t0
	sw	$t0, __temp83

	# _temp83 / local1
	lw	$t1, __temp83
	lw	$t0, 8($sp)
	div	$t0, $t1, $t0
	sw	$t0, __temp84

	# local2 * _temp84
	lw	$t1, __temp84
	lw	$t0, 4($sp)
	mul	$t0, $t0, $t1
	sw	$t0, __temp85

	# _temp85 - 38
	li	$t0, 38
	lw	$t1, __temp85
	sub	$t0, $t1, $t0
	sw	$t0, __temp87

	# 10 + _temp87
	li	$t0, 10
	lw	$t1, __temp87
	add	$t0, $t0, $t1
	sw	$t0, __temp89

	# x = _temp89
	lw	$t0, __temp89
	sw	$t0, _x

	# pushing parameter x
	lw	$t0, _x
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling printX
	jal	_printX

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter _temp90
	la	$t0, __temp90
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling return5
	jal	_return5

	# retrieve return value from return5
	sw	$v0, __temp91

	# x = _temp91
	lw	$t0, __temp91
	sw	$t0, _x

	# pushing parameter x
	lw	$t0, _x
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling printX
	jal	_printX

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter _temp92
	la	$t0, __temp92
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling return5
	jal	_return5

	# retrieve return value from return5
	sw	$v0, __temp94

	# _temp94 + 100
	li	$t1, 100
	lw	$t0, __temp94
	add	$t0, $t0, $t1
	sw	$t0, __temp95

	# calling return5
	jal	_return5

	# retrieve return value from return5
	sw	$v0, __temp96

	# _temp96 + _temp95
	lw	$t1, __temp95
	lw	$t0, __temp96
	add	$t0, $t0, $t1
	sw	$t0, __temp97

	# 10 + _temp97
	li	$t0, 10
	lw	$t1, __temp97
	add	$t0, $t0, $t1
	sw	$t0, __temp99

	# x = _temp99
	lw	$t0, __temp99
	sw	$t0, _x

	# pushing parameter x
	lw	$t0, _x
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling printX
	jal	_printX

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter _temp100
	la	$t0, __temp100
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

	# pushing parameter _temp17
	la	$t0, __temp17
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
	sw	$t0, __temp103

	# pushing parameter _temp103
	lw	$t0, __temp103
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp20
	la	$t0, __temp20
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
	sw	$t0, __temp105

	# pushing parameter _temp105
	lw	$t0, __temp105
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

	# localArray[2]
	li	$t1, 2
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, 12($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp107

	# pushing parameter _temp107
	lw	$t0, __temp107
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

	# localArray[3]
	li	$t1, 3
	sll	$t1, $t1, 2		# index * 4 (size of int)
	la	$t0, 12($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp109

	# pushing parameter _temp109
	lw	$t0, __temp109
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
	sw	$t0, __temp111

	# pushing parameter _temp111
	lw	$t0, __temp111
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

	# pushing parameter _temp42
	la	$t0, __temp42
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
	sw	$t0, __temp113

	# pushing parameter _temp113
	lw	$t0, __temp113
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp45
	la	$t0, __temp45
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
	sw	$t0, __temp115

	# pushing parameter _temp115
	lw	$t0, __temp115
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp48
	la	$t0, __temp48
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
	sw	$t0, __temp117

	# pushing parameter _temp117
	lw	$t0, __temp117
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp51
	la	$t0, __temp51
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
	sw	$t0, __temp119

	# pushing parameter _temp119
	lw	$t0, __temp119
	lw	$t0, 0($t0)
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling pi
	jal	_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

	# pushing parameter _temp120
	la	$t0, __temp120
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
	sw	$v0, __temp122

	# x = _temp122
	lw	$t0, __temp122
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

_psReturn:
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

_piReturn:
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

	# pushing parameter _temp123
	la	$t0, __temp123
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling print_string
	jal	_print_string

	# popping pushed parameters
	addu	$sp, $sp, 4

_pnReturn:
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
	sw	$t0, __temp124

	# return _temp124
	lw	$t0, __temp124
	lw	$t0, 0($t0)
	add	$v0, $t0, $0
	j	_indexReturn

_indexReturn:
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
	sw	$t0, __temp127

	# factor * _temp127
	lw	$t1, __temp127
	lw	$t1, 0($t0)
	lw	$t0, 0($sp)
	mul	$t0, $t0, $t1
	sw	$t0, __temp128

	# array[0]
	li	$t1, 0
	sll	$t1, $t1, 2		# index * 4 (size of int)
	lw	$t0, 4($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp129

	# _temp129 = _temp128
	lw	$t0, __temp128
	lw	$t1, __temp129
	sw	$t0, 0($t1)

	# array[1]
	li	$t1, 1
	sll	$t1, $t1, 2		# index * 4 (size of int)
	lw	$t0, 4($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp132

	# factor * _temp132
	lw	$t1, __temp132
	lw	$t1, 0($t0)
	lw	$t0, 0($sp)
	mul	$t0, $t0, $t1
	sw	$t0, __temp133

	# array[1]
	li	$t1, 1
	sll	$t1, $t1, 2		# index * 4 (size of int)
	lw	$t0, 4($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp134

	# _temp134 = _temp133
	lw	$t0, __temp133
	lw	$t1, __temp134
	sw	$t0, 0($t1)

	# array[2]
	li	$t1, 2
	sll	$t1, $t1, 2		# index * 4 (size of int)
	lw	$t0, 4($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp137

	# factor * _temp137
	lw	$t1, __temp137
	lw	$t1, 0($t0)
	lw	$t0, 0($sp)
	mul	$t0, $t0, $t1
	sw	$t0, __temp138

	# array[2]
	li	$t1, 2
	sll	$t1, $t1, 2		# index * 4 (size of int)
	lw	$t0, 4($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp139

	# _temp139 = _temp138
	lw	$t0, __temp138
	lw	$t1, __temp139
	sw	$t0, 0($t1)

	# array[3]
	li	$t1, 3
	sll	$t1, $t1, 2		# index * 4 (size of int)
	lw	$t0, 4($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp142

	# factor * _temp142
	lw	$t1, __temp142
	lw	$t1, 0($t0)
	lw	$t0, 0($sp)
	mul	$t0, $t0, $t1
	sw	$t0, __temp143

	# array[3]
	li	$t1, 3
	sll	$t1, $t1, 2		# index * 4 (size of int)
	lw	$t0, 4($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp144

	# _temp144 = _temp143
	lw	$t0, __temp143
	lw	$t1, __temp144
	sw	$t0, 0($t1)

_scaleReturn:
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
	j	_return5Return

_return5Return:
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

_printX:
	subu	$sp, $sp, 12
	sw	$ra, 8($sp)
	sw	$fp, 4($sp)
	addu	$fp, $sp, 12
	lw	$t0, 0($fp)		# storing parameter x
	sw	$t0, 0($sp)

	# pushing parameter _temp146
	la	$t0, __temp146
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

	# pushing parameter _temp147
	la	$t0, __temp147
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

_printAReturn:
	lw	$fp, 4($sp)
	lw	$ra, 8($sp)
	addu	$sp, $sp, 12
	jr	$ra

.data

__temp144:
	.word 0

__temp143:
	.word 0

__temp142:
	.word 0

__temp139:
	.word 0

__temp138:
	.word 0

__temp137:
	.word 0

__temp134:
	.word 0

__temp133:
	.word 0

__temp132:
	.word 0

__temp129:
	.word 0

__temp128:
	.word 0

__temp127:
	.word 0

__temp124:
	.word 0

__temp122:
	.word 0

__temp119:
	.word 0

__temp117:
	.word 0

__temp115:
	.word 0

__temp113:
	.word 0

__temp111:
	.word 0

__temp109:
	.word 0

__temp107:
	.word 0

__temp105:
	.word 0

__temp103:
	.word 0

__temp99:
	.word 0

__temp97:
	.word 0

__temp96:
	.word 0

__temp95:
	.word 0

__temp94:
	.word 0

__temp91:
	.word 0

__temp89:
	.word 0

__temp87:
	.word 0

__temp85:
	.word 0

__temp84:
	.word 0

__temp83:
	.word 0

__temp82:
	.word 0

__temp81:
	.word 0

__temp78:
	.word 0

__temp76:
	.word 0

__temp65:
	.word 0

__temp61:
	.word 0

__temp57:
	.word 0

__temp53:
	.word 0

__temp50:
	.word 0

__temp47:
	.word 0

__temp44:
	.word 0

__temp41:
	.word 0

__temp38:
	.word 0

__temp35:
	.word 0

__temp32:
	.word 0

__temp28:
	.word 0

__temp25:
	.word 0

__temp22:
	.word 0

__temp19:
	.word 0

__temp16:
	.word 0

__temp13:
	.word 0

__temp10:
	.word 0

__temp7:
	.word 0

__temp2:
	.word 0

__temp147:
	.asciiz	"a = "

__temp146:
	.asciiz	"x = "

__temp123:
	.asciiz	"\n"

__temp120:
	.asciiz	"\nLet's wrap an array indexing operation...\n"

__temp100:
	.asciiz	"\nLet's use functions to modify some arrays...\n"

__temp92:
	.asciiz	"\nNow for a double call with simple addition...\n"

__temp90:
	.asciiz	"\nNow for a function call...\n"

__temp73:
	.asciiz	"\nNow for an expr...\n"

__temp67:
	.asciiz	"\nInitializing some ints...\n"

__temp66:
	.asciiz	"char3 = "

__temp62:
	.asciiz	"char2 = "

__temp58:
	.asciiz	"char1 = "

__temp54:
	.asciiz	"\nInitializing some chars...\n"

__temp51:
	.asciiz	"intArray1[3] = "

__temp48:
	.asciiz	"intArray1[2] = "

__temp45:
	.asciiz	"intArray1[1] = "

__temp42:
	.asciiz	"intArray1[0] = "

__temp29:
	.asciiz	"\nInitializing global array...\n"

__temp26:
	.asciiz	"localArray[3] = "

__temp23:
	.asciiz	"localArray[2] = "

__temp20:
	.asciiz	"localArray[1] = "

__temp17:
	.asciiz	"localArray[0] = "

__temp4:
	.asciiz	"\nInitializing local int array...\n"

__temp3:
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
