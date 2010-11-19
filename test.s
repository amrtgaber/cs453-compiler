
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

	# pushing parameter _temp0
	la	$t0, __temp0
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
.data

_LEFT:
	.word 0
_X:
	.word 0
_UNMARK:
	.word 0
_MARK:
	.word 0
_NOP:
	.word 0
_ERASE:
	.word 0
_RIGHT:
	.word 0

.data

_head:
	.word 0

.data

_EPSILON:
	.byte 0
_charString:
	.space 2
_DASH:
	.byte 0
_SPACE:
	.byte 0

.data

_currentSymbol:
	.byte 0

.data

_tape:
	.space 100


.text

_printState:
	subu	$sp, $sp, 16
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addu	$fp, $sp, 16
	# initializing local variables
	sw	$0, 4($sp)
	sw	$0, 0($sp)

	# calling pn
	jal	_pn

	# EPSILON == currentSymbol
	lb	$t1, _currentSymbol
	lb	$t0, _EPSILON
	seq	$t0, $t0, $t1
	sw	$t0, __temp1

	lw	$t0, __temp1
	bgtz	$t0, __label2

	j	__label3

__label2:

	# pushing parameter _temp2
	la	$t0, __temp2
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	j	__label4

__label3:

	# pushing parameter _temp3
	la	$t0, __temp3
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# charString[0]
	li	$t1, 0
	la	$t0, _charString
	add	$t0, $t0, $t1
	sw	$t0, __temp5

	# _temp5 = currentSymbol
	lb	$t0, _currentSymbol
	lw	$t1, __temp5
	sb	$t0, 0($t1)

	# pushing parameter charString
	la	$t0, _charString
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

__label4:

	# pushing parameter _temp6
	la	$t0, __temp6
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# i = 0
	li	$t0, 0
	sw	$t0, 4($sp)

	j	__label0

__label1:

	# pushing parameter _temp11
	la	$t0, __temp11
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# 1 + i
	li	$t0, 1
	lw	$t1, 4($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp10

	# i = _temp10
	lw	$t0, __temp10
	sw	$t0, 4($sp)

__label0:

	# head < i
	lw	$t1, 4($sp)
	lw	$t0, _head
	slt	$t0, $t1, $t0
	sw	$t0, __temp8

	lw	$t0, __temp8
	bgtz	$t0, __label1

	# pushing parameter _temp12
	la	$t0, __temp12
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter _temp13
	la	$t0, __temp13
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter tape
	la	$t0, _tape
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal	_pn

__printStateReturn:
	lw	$fp, 8($sp)
	lw	$ra, 12($sp)
	addu	$sp, $sp, 16
	jr	$ra

.text

_readSymbol:
	subu	$sp, $sp, 8
	sw	$ra, 4($sp)
	sw	$fp, 0($sp)
	addu	$fp, $sp, 8

	# tape[head]
	lw	$t1, _head
	la	$t0, _tape
	add	$t0, $t0, $t1
	sw	$t0, __temp14

	# return _temp14
	lw	$t0, __temp14
	lb	$t0, 0($t0)
	add	$v0, $t0, $0
	j	__readSymbolReturn

__readSymbolReturn:
	lw	$fp, 0($sp)
	lw	$ra, 4($sp)
	addu	$sp, $sp, 8
	jr	$ra

.text

_transition:
	subu	$sp, $sp, 16
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addu	$fp, $sp, 16
	lw	$t0, 0($fp)		# storing parameter motion
	sw	$t0, 4($sp)
	lw	$t0, 4($fp)		# storing parameter action
	sw	$t0, 0($sp)

	# ERASE == action
	lw	$t1, 0($sp)
	lw	$t0, _ERASE
	seq	$t0, $t0, $t1
	sw	$t0, __temp15

	lw	$t0, __temp15
	bgtz	$t0, __label16

	j	__label17

__label16:

	# tape[head]
	lw	$t1, _head
	la	$t0, _tape
	add	$t0, $t0, $t1
	sw	$t0, __temp16

	# _temp16 = SPACE
	lb	$t0, _SPACE
	lw	$t1, __temp16
	sb	$t0, 0($t1)

__label17:

	# MARK == action
	lw	$t1, 0($sp)
	lw	$t0, _MARK
	seq	$t0, $t0, $t1
	sw	$t0, __temp17

	lw	$t0, __temp17
	bgtz	$t0, __label14

	j	__label15

__label14:

	# tape[head]
	lw	$t1, _head
	la	$t0, _tape
	add	$t0, $t0, $t1
	sw	$t0, __temp18

	# _temp18 - 32
	li	$t0, 32
	lw	$t1, __temp18
	sub	$t0, $t1, $t0
	sw	$t0, __temp20

	# tape[head]
	lw	$t1, _head
	la	$t0, _tape
	add	$t0, $t0, $t1
	sw	$t0, __temp21

	# _temp21 = _temp20
	lw	$t0, __temp20
	lw	$t1, __temp21
	sb	$t0, 0($t1)

__label15:

	# UNMARK == action
	lw	$t1, 0($sp)
	lw	$t0, _UNMARK
	seq	$t0, $t0, $t1
	sw	$t0, __temp22

	lw	$t0, __temp22
	bgtz	$t0, __label12

	j	__label13

__label12:

	# tape[head]
	lw	$t1, _head
	la	$t0, _tape
	add	$t0, $t0, $t1
	sw	$t0, __temp23

	# 32 + _temp23
	li	$t0, 32
	lw	$t1, __temp23
	add	$t0, $t0, $t1
	sw	$t0, __temp25

	# tape[head]
	lw	$t1, _head
	la	$t0, _tape
	add	$t0, $t0, $t1
	sw	$t0, __temp26

	# _temp26 = _temp25
	lw	$t0, __temp25
	lw	$t1, __temp26
	sb	$t0, 0($t1)

__label13:

	# X == action
	lw	$t1, 0($sp)
	lw	$t0, _X
	seq	$t0, $t0, $t1
	sw	$t0, __temp27

	lw	$t0, __temp27
	bgtz	$t0, __label10

	j	__label11

__label10:

	# tape[head]
	lw	$t1, _head
	la	$t0, _tape
	add	$t0, $t0, $t1
	sw	$t0, __temp28

	# _temp28 = DASH
	lb	$t0, _DASH
	lw	$t1, __temp28
	sb	$t0, 0($t1)

__label11:

	# LEFT == motion
	lw	$t1, 4($sp)
	lw	$t0, _LEFT
	seq	$t0, $t0, $t1
	sw	$t0, __temp29

	lw	$t0, __temp29
	bgtz	$t0, __label7

	j	__label8

__label7:

	# 0 > head
	li	$t0, 0
	lw	$t1, _head
	sgt	$t0, $t1, $t0
	sw	$t0, __temp31

	lw	$t0, __temp31
	bgtz	$t0, __label5

	j	__label6

__label5:

	# head - 1
	li	$t0, 1
	lw	$t1, _head
	sub	$t0, $t1, $t0
	sw	$t0, __temp33

	# head = _temp33
	lw	$t0, __temp33
	sw	$t0, _head

__label6:

	j	__label9

__label8:

	# 1 + head
	li	$t0, 1
	lw	$t1, _head
	add	$t0, $t0, $t1
	sw	$t0, __temp35

	# head = _temp35
	lw	$t0, __temp35
	sw	$t0, _head

__label9:

__transitionReturn:
	lw	$fp, 8($sp)
	lw	$ra, 12($sp)
	addu	$sp, $sp, 16
	jr	$ra

.text

_setTape:
	subu	$sp, $sp, 16
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addu	$fp, $sp, 16
	lw	$t0, 0($fp)		# storing parameter contents
	sw	$t0, 4($sp)
	# initializing local variables
	sw	$0, 0($sp)

	# i = 0
	li	$t0, 0
	sw	$t0, 0($sp)

	j	__label18

__label19:

	# contents[i]
	lw	$t1, 0($sp)
	lw	$t0, 4($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp42

	# tape[i]
	lw	$t1, 0($sp)
	la	$t0, _tape
	add	$t0, $t0, $t1
	sw	$t0, __temp43

	# _temp43 = _temp42
	lw	$t0, __temp42
	lb	$t0, 0($t0)
	lw	$t1, __temp43
	sb	$t0, 0($t1)

	# 1 + i
	li	$t0, 1
	lw	$t1, 0($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp41

	# i = _temp41
	lw	$t0, __temp41
	sw	$t0, 0($sp)

__label18:

	# contents[i]
	lw	$t1, 0($sp)
	lw	$t0, 4($sp)
	add	$t0, $t0, $t1
	sw	$t0, __temp37

	# '\0' != _temp37
	li	$t0, 0		# 0 is ascii value for '\0'
	lw	$t1, __temp37
	lb	$t1, 0($t1)
	sne	$t0, $t0, $t1
	sw	$t0, __temp39

	lw	$t0, __temp39
	bgtz	$t0, __label19

	# tape[i]
	lw	$t1, 0($sp)
	la	$t0, _tape
	add	$t0, $t0, $t1
	sw	$t0, __temp45

	# _temp45 = '\0'
	li	$t0, 0		# 0 is ascii value for '\0'
	lw	$t1, __temp45
	sb	$t0, 0($t1)

__setTapeReturn:
	lw	$fp, 8($sp)
	lw	$ra, 12($sp)
	addu	$sp, $sp, 16
	jr	$ra

.text

main:
	subu	$sp, $sp, 8
	sw	$ra, 4($sp)
	sw	$fp, 0($sp)
	addu	$fp, $sp, 8

	# LEFT = 0
	li	$t0, 0
	sw	$t0, _LEFT

	# RIGHT = 1
	li	$t0, 1
	sw	$t0, _RIGHT

	# ERASE = 2
	li	$t0, 2
	sw	$t0, _ERASE

	# NOP = 3
	li	$t0, 3
	sw	$t0, _NOP

	# MARK = 4
	li	$t0, 4
	sw	$t0, _MARK

	# UNMARK = 5
	li	$t0, 5
	sw	$t0, _UNMARK

	# X = 6
	li	$t0, 6
	sw	$t0, _X

	# EPSILON = '\0'
	li	$t0, 0		# 0 is ascii value for '\0'
	sb	$t0, _EPSILON

	# SPACE = ' '
	li	$t0, ' '
	sb	$t0, _SPACE

	# DASH = '-'
	li	$t0, '-'
	sb	$t0, _DASH

	# charString[1]
	li	$t1, 1
	la	$t0, _charString
	add	$t0, $t0, $t1
	sw	$t0, __temp58

	# _temp58 = '\0'
	li	$t0, 0		# 0 is ascii value for '\0'
	lw	$t1, __temp58
	sb	$t0, 0($t1)

	# head = 0
	li	$t0, 0
	sw	$t0, _head

	# currentSymbol = EPSILON
	lb	$t0, _EPSILON
	sb	$t0, _currentSymbol

	# pushing parameter _temp60
	la	$t0, __temp60
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling setTape
	jal	_setTape

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling printState
	jal	_printState

	j	__label35

__label36:

	# calling readSymbol
	jal	_readSymbol

	# retrieve return value from readSymbol
	sb	$v0, __temp64

	# currentSymbol = _temp64
	lb	$t0, __temp64
	sb	$t0, _currentSymbol

	# calling printState
	jal	_printState

	# pushing parameter X
	lw	$t0, _X
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# pushing parameter RIGHT
	lw	$t0, _RIGHT
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling transition
	jal	_transition

	# popping pushed parameters
	addu	$sp, $sp, 8

	j	__label33

__label34:

	# pushing parameter NOP
	lw	$t0, _NOP
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# pushing parameter RIGHT
	lw	$t0, _RIGHT
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling transition
	jal	_transition

	# popping pushed parameters
	addu	$sp, $sp, 8

__label33:

	# calling readSymbol
	jal	_readSymbol

	# retrieve return value from readSymbol
	sb	$v0, __temp65

	# '#' != _temp65
	li	$t0, '#'
	lb	$t1, __temp65
	sne	$t0, $t0, $t1
	sw	$t0, __temp67

	lw	$t0, __temp67
	bgtz	$t0, __label34

	# pushing parameter NOP
	lw	$t0, _NOP
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# pushing parameter RIGHT
	lw	$t0, _RIGHT
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling transition
	jal	_transition

	# popping pushed parameters
	addu	$sp, $sp, 8

	j	__label31

__label32:

	# pushing parameter NOP
	lw	$t0, _NOP
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# pushing parameter RIGHT
	lw	$t0, _RIGHT
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling transition
	jal	_transition

	# popping pushed parameters
	addu	$sp, $sp, 8

__label31:

	# calling readSymbol
	jal	_readSymbol

	# retrieve return value from readSymbol
	sb	$v0, __temp68

	# DASH == _temp68
	lb	$t1, __temp68
	lb	$t0, _DASH
	seq	$t0, $t0, $t1
	sw	$t0, __temp69

	lw	$t0, __temp69
	bgtz	$t0, __label32

	# calling printState
	jal	_printState

	# calling readSymbol
	jal	_readSymbol

	# retrieve return value from readSymbol
	sb	$v0, __temp70

	# currentSymbol != _temp70
	lb	$t1, __temp70
	lb	$t0, _currentSymbol
	sne	$t0, $t0, $t1
	sw	$t0, __temp71

	lw	$t0, __temp71
	bgtz	$t0, __label29

	j	__label30

__label29:

	# pushing parameter _temp72
	la	$t0, __temp72
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# return
	j	__mainReturn

__label30:

	# pushing parameter X
	lw	$t0, _X
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# pushing parameter LEFT
	lw	$t0, _LEFT
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling transition
	jal	_transition

	# popping pushed parameters
	addu	$sp, $sp, 8

	j	__label27

__label28:

	# pushing parameter NOP
	lw	$t0, _NOP
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# pushing parameter LEFT
	lw	$t0, _LEFT
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling transition
	jal	_transition

	# popping pushed parameters
	addu	$sp, $sp, 8

__label27:

	# calling readSymbol
	jal	_readSymbol

	# retrieve return value from readSymbol
	sb	$v0, __temp73

	# '#' != _temp73
	li	$t0, '#'
	lb	$t1, __temp73
	sne	$t0, $t0, $t1
	sw	$t0, __temp75

	lw	$t0, __temp75
	bgtz	$t0, __label28

	j	__label25

__label26:

	# pushing parameter NOP
	lw	$t0, _NOP
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# pushing parameter LEFT
	lw	$t0, _LEFT
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling transition
	jal	_transition

	# popping pushed parameters
	addu	$sp, $sp, 8

__label25:

	# calling readSymbol
	jal	_readSymbol

	# retrieve return value from readSymbol
	sb	$v0, __temp76

	# DASH != _temp76
	lb	$t1, __temp76
	lb	$t0, _DASH
	sne	$t0, $t0, $t1
	sw	$t0, __temp77

	lw	$t0, __temp77
	bgtz	$t0, __label26

	# pushing parameter NOP
	lw	$t0, _NOP
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# pushing parameter RIGHT
	lw	$t0, _RIGHT
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling transition
	jal	_transition

	# popping pushed parameters
	addu	$sp, $sp, 8

	# currentSymbol = EPSILON
	lb	$t0, _EPSILON
	sb	$t0, _currentSymbol

__label35:

	# calling readSymbol
	jal	_readSymbol

	# retrieve return value from readSymbol
	sb	$v0, __temp61

	# '#' != _temp61
	li	$t0, '#'
	lb	$t1, __temp61
	sne	$t0, $t0, $t1
	sw	$t0, __temp63

	lw	$t0, __temp63
	bgtz	$t0, __label36

	# pushing parameter NOP
	lw	$t0, _NOP
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# pushing parameter RIGHT
	lw	$t0, _RIGHT
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling transition
	jal	_transition

	# popping pushed parameters
	addu	$sp, $sp, 8

	j	__label23

__label24:

	# pushing parameter NOP
	lw	$t0, _NOP
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# pushing parameter RIGHT
	lw	$t0, _RIGHT
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling transition
	jal	_transition

	# popping pushed parameters
	addu	$sp, $sp, 8

__label23:

	# calling readSymbol
	jal	_readSymbol

	# retrieve return value from readSymbol
	sb	$v0, __temp78

	# DASH == _temp78
	lb	$t1, __temp78
	lb	$t0, _DASH
	seq	$t0, $t0, $t1
	sw	$t0, __temp79

	lw	$t0, __temp79
	bgtz	$t0, __label24

	# calling printState
	jal	_printState

	# calling readSymbol
	jal	_readSymbol

	# retrieve return value from readSymbol
	sb	$v0, __temp80

	# SPACE == _temp80
	lb	$t1, __temp80
	lb	$t0, _SPACE
	seq	$t0, $t0, $t1
	sw	$t0, __temp81

	lw	$t0, __temp81
	bgtz	$t0, __label20

	j	__label21

__label20:

	# pushing parameter _temp82
	la	$t0, __temp82
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	j	__label22

__label21:

	# pushing parameter _temp72
	la	$t0, __temp72
	subu	$sp, $sp, 4
	sw	$t0, 0($sp)

	# calling ps
	jal	_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

__label22:

__mainReturn:
	lw	$fp, 0($sp)
	lw	$ra, 4($sp)
	addu	$sp, $sp, 8
	jr	$ra

.data

__temp81:
	.word 0

__temp80:
	.byte 0

__temp79:
	.word 0

__temp78:
	.byte 0

__temp77:
	.word 0

__temp76:
	.byte 0

__temp75:
	.word 0

__temp73:
	.byte 0

__temp71:
	.word 0

__temp70:
	.byte 0

__temp69:
	.word 0

__temp68:
	.byte 0

__temp67:
	.word 0

__temp65:
	.byte 0

__temp64:
	.byte 0

__temp63:
	.word 0

__temp61:
	.byte 0

__temp58:
	.word 0

__temp45:
	.word 0

__temp43:
	.word 0

__temp42:
	.word 0

__temp41:
	.word 0

__temp39:
	.word 0

__temp37:
	.word 0

__temp35:
	.word 0

__temp33:
	.word 0

__temp31:
	.word 0

__temp29:
	.word 0

__temp28:
	.word 0

__temp27:
	.word 0

__temp26:
	.word 0

__temp25:
	.word 0

__temp23:
	.word 0

__temp22:
	.word 0

__temp21:
	.word 0

__temp20:
	.word 0

__temp18:
	.word 0

__temp17:
	.word 0

__temp16:
	.word 0

__temp15:
	.word 0

__temp14:
	.word 0

__temp10:
	.word 0

__temp8:
	.word 0

__temp5:
	.word 0

__temp1:
	.word 0

__temp82:
	.asciiz	"\nACCEPT\n\n"

__temp72:
	.asciiz	"\nREJECT\n\n"

__temp60:
	.asciiz	"abaabb#abaabb "

__temp13:
	.asciiz	"Tape: "

__temp12:
	.asciiz	"|\n"

__temp11:
	.asciiz	" "

__temp6:
	.asciiz	"Head: "

__temp3:
	.asciiz	"Symbol: "

__temp2:
	.asciiz	"Symbol: none\n"

__temp0:
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
