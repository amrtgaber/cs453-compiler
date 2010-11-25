
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
	subu	$sp, $sp, 32
	sw	$ra, 28($sp)
	sw	$fp, 24($sp)
	addu	$fp, $sp, 32
	# initializing local variables
	sw	$0, 20($sp)
	sw	$0, 16($sp)
	sw	$0, 12($sp)
	sw	$0, 8($sp)
	sw	$0, 4($sp)
	sw	$0, 0($sp)

	# calling pn
	jal	_pn

	# currentSymbol == EPSILON
	lb	$t1, _currentSymbol
	lb	$t0, _EPSILON
	seq	$t0, $t1, $t0
	sw	$t0, 0($sp)

	lw	$t0, 0($sp)
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
	sw	$t0, 4($sp)

	# _temp5 = currentSymbol
	lb	$t0, _currentSymbol
	lw	$t1, 4($sp)
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
	sw	$t0, 20($sp)

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

	# i + 1
	li	$t0, 1
	lw	$t1, 20($sp)
	add	$t0, $t1, $t0
	sw	$t0, 12($sp)

	# i = _temp10
	lw	$t0, 12($sp)
	sw	$t0, 20($sp)

__label0:

	# i < head
	lw	$t1, 20($sp)
	lw	$t0, _head
	slt	$t0, $t1, $t0
	sw	$t0, 8($sp)

	lw	$t0, 8($sp)
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
	lw	$fp, 24($sp)
	lw	$ra, 28($sp)
	addu	$sp, $sp, 32
	jr	$ra

.text

_readSymbol:
	subu	$sp, $sp, 12
	sw	$ra, 8($sp)
	sw	$fp, 4($sp)
	addu	$fp, $sp, 12
	# initializing local variables
	sw	$0, 0($sp)

	# tape[head]
	lw	$t1, _head
	la	$t0, _tape
	add	$t0, $t0, $t1
	sw	$t0, 0($sp)

	# return _temp14
	lw	$t0, 0($sp)
	lb	$t0, 0($t0)
	add	$v0, $t0, $0
	j	__readSymbolReturn

__readSymbolReturn:
	lw	$fp, 4($sp)
	lw	$ra, 8($sp)
	addu	$sp, $sp, 12
	jr	$ra

.text

_transition:
	subu	$sp, $sp, 80
	sw	$ra, 76($sp)
	sw	$fp, 72($sp)
	addu	$fp, $sp, 80
	lw	$t0, 0($fp)		# storing parameter motion
	sw	$t0, 68($sp)
	lw	$t0, 4($fp)		# storing parameter action
	sw	$t0, 64($sp)
	# initializing local variables
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

	# action == ERASE
	lw	$t1, 64($sp)
	lw	$t0, _ERASE
	seq	$t0, $t1, $t0
	sw	$t0, 4($sp)

	lw	$t0, 4($sp)
	bgtz	$t0, __label16

	j	__label17

__label16:

	# tape[head]
	lw	$t1, _head
	la	$t0, _tape
	add	$t0, $t0, $t1
	sw	$t0, 0($sp)

	# _temp16 = SPACE
	lb	$t0, _SPACE
	lw	$t1, 0($sp)
	sb	$t0, 0($t1)

__label17:

	# action == MARK
	lw	$t1, 64($sp)
	lw	$t0, _MARK
	seq	$t0, $t1, $t0
	sw	$t0, 20($sp)

	lw	$t0, 20($sp)
	bgtz	$t0, __label14

	j	__label15

__label14:

	# tape[head]
	lw	$t1, _head
	la	$t0, _tape
	add	$t0, $t0, $t1
	sw	$t0, 12($sp)

	# _temp18 - 32
	li	$t0, 32
	lw	$t1, 12($sp)
	lb	$t1, 0($t1)
	sub	$t0, $t1, $t0
	sw	$t0, 8($sp)

	# tape[head]
	lw	$t1, _head
	la	$t0, _tape
	add	$t0, $t0, $t1
	sw	$t0, 16($sp)

	# _temp21 = _temp20
	lw	$t0, 8($sp)
	lw	$t1, 16($sp)
	sb	$t0, 0($t1)

__label15:

	# action == UNMARK
	lw	$t1, 64($sp)
	lw	$t0, _UNMARK
	seq	$t0, $t1, $t0
	sw	$t0, 36($sp)

	lw	$t0, 36($sp)
	bgtz	$t0, __label12

	j	__label13

__label12:

	# tape[head]
	lw	$t1, _head
	la	$t0, _tape
	add	$t0, $t0, $t1
	sw	$t0, 28($sp)

	# _temp23 + 32
	li	$t0, 32
	lw	$t1, 28($sp)
	lb	$t1, 0($t1)
	add	$t0, $t1, $t0
	sw	$t0, 24($sp)

	# tape[head]
	lw	$t1, _head
	la	$t0, _tape
	add	$t0, $t0, $t1
	sw	$t0, 32($sp)

	# _temp26 = _temp25
	lw	$t0, 24($sp)
	lw	$t1, 32($sp)
	sb	$t0, 0($t1)

__label13:

	# action == X
	lw	$t1, 64($sp)
	lw	$t0, _X
	seq	$t0, $t1, $t0
	sw	$t0, 44($sp)

	lw	$t0, 44($sp)
	bgtz	$t0, __label10

	j	__label11

__label10:

	# tape[head]
	lw	$t1, _head
	la	$t0, _tape
	add	$t0, $t0, $t1
	sw	$t0, 40($sp)

	# _temp28 = DASH
	lb	$t0, _DASH
	lw	$t1, 40($sp)
	sb	$t0, 0($t1)

__label11:

	# motion == LEFT
	lw	$t1, 68($sp)
	lw	$t0, _LEFT
	seq	$t0, $t1, $t0
	sw	$t0, 56($sp)

	lw	$t0, 56($sp)
	bgtz	$t0, __label7

	j	__label8

__label7:

	# head > 0
	li	$t0, 0
	lw	$t1, _head
	sgt	$t0, $t1, $t0
	sw	$t0, 52($sp)

	lw	$t0, 52($sp)
	bgtz	$t0, __label5

	j	__label6

__label5:

	# head - 1
	li	$t0, 1
	lw	$t1, _head
	sub	$t0, $t1, $t0
	sw	$t0, 48($sp)

	# head = _temp33
	lw	$t0, 48($sp)
	sw	$t0, _head

__label6:

	j	__label9

__label8:

	# head + 1
	li	$t0, 1
	lw	$t1, _head
	add	$t0, $t1, $t0
	sw	$t0, 60($sp)

	# head = _temp35
	lw	$t0, 60($sp)
	sw	$t0, _head

__label9:

__transitionReturn:
	lw	$fp, 72($sp)
	lw	$ra, 76($sp)
	addu	$sp, $sp, 80
	jr	$ra

.text

_setTape:
	subu	$sp, $sp, 40
	sw	$ra, 36($sp)
	sw	$fp, 32($sp)
	addu	$fp, $sp, 40
	lw	$t0, 0($fp)		# storing parameter contents
	sw	$t0, 28($sp)
	# initializing local variables
	sw	$0, 24($sp)
	sw	$0, 20($sp)
	sw	$0, 16($sp)
	sw	$0, 12($sp)
	sw	$0, 8($sp)
	sw	$0, 4($sp)
	sw	$0, 0($sp)

	# i = 0
	li	$t0, 0
	sw	$t0, 24($sp)

	j	__label18

__label19:

	# contents[i]
	lw	$t1, 24($sp)
	lw	$t0, 28($sp)
	add	$t0, $t0, $t1
	sw	$t0, 0($sp)

	# tape[i]
	lw	$t1, 24($sp)
	la	$t0, _tape
	add	$t0, $t0, $t1
	sw	$t0, 4($sp)

	# _temp43 = _temp42
	lw	$t0, 0($sp)
	lb	$t0, 0($t0)
	lw	$t1, 4($sp)
	sb	$t0, 0($t1)

	# i + 1
	li	$t0, 1
	lw	$t1, 24($sp)
	add	$t0, $t1, $t0
	sw	$t0, 16($sp)

	# i = _temp41
	lw	$t0, 16($sp)
	sw	$t0, 24($sp)

__label18:

	# contents[i]
	lw	$t1, 24($sp)
	lw	$t0, 28($sp)
	add	$t0, $t0, $t1
	sw	$t0, 12($sp)

	# _temp37 != '\0'
	li	$t0, 0		# 0 is ascii value for '\0'
	lw	$t1, 12($sp)
	lb	$t1, 0($t1)
	sne	$t0, $t1, $t0
	sw	$t0, 8($sp)

	lw	$t0, 8($sp)
	bgtz	$t0, __label19

	# tape[i]
	lw	$t1, 24($sp)
	la	$t0, _tape
	add	$t0, $t0, $t1
	sw	$t0, 20($sp)

	# _temp45 = '\0'
	li	$t0, 0		# 0 is ascii value for '\0'
	lw	$t1, 20($sp)
	sb	$t0, 0($t1)

__setTapeReturn:
	lw	$fp, 32($sp)
	lw	$ra, 36($sp)
	addu	$sp, $sp, 40
	jr	$ra

.text

main:
	subu	$sp, $sp, 80
	sw	$ra, 76($sp)
	sw	$fp, 72($sp)
	addu	$fp, $sp, 80
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
	sw	$t0, 0($sp)

	# _temp58 = '\0'
	li	$t0, 0		# 0 is ascii value for '\0'
	lw	$t1, 0($sp)
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
	sb	$v0, 4($sp)

	# currentSymbol = _temp64
	lb	$t0, 4($sp)
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
	sb	$v0, 12($sp)

	# _temp65 != '#'
	li	$t0, '#'
	lb	$t1, 12($sp)
	sne	$t0, $t1, $t0
	sw	$t0, 8($sp)

	lw	$t0, 8($sp)
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
	sb	$v0, 20($sp)

	# _temp68 == DASH
	lb	$t1, 20($sp)
	lb	$t0, _DASH
	seq	$t0, $t1, $t0
	sw	$t0, 16($sp)

	lw	$t0, 16($sp)
	bgtz	$t0, __label32

	# calling printState
	jal	_printState

	# calling readSymbol
	jal	_readSymbol

	# retrieve return value from readSymbol
	sb	$v0, 28($sp)

	# _temp70 != currentSymbol
	lb	$t1, 28($sp)
	lb	$t0, _currentSymbol
	sne	$t0, $t1, $t0
	sw	$t0, 24($sp)

	lw	$t0, 24($sp)
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
	sb	$v0, 36($sp)

	# _temp73 != '#'
	li	$t0, '#'
	lb	$t1, 36($sp)
	sne	$t0, $t1, $t0
	sw	$t0, 32($sp)

	lw	$t0, 32($sp)
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
	sb	$v0, 44($sp)

	# _temp76 != DASH
	lb	$t1, 44($sp)
	lb	$t0, _DASH
	sne	$t0, $t1, $t0
	sw	$t0, 40($sp)

	lw	$t0, 40($sp)
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
	sb	$v0, 52($sp)

	# _temp61 != '#'
	li	$t0, '#'
	lb	$t1, 52($sp)
	sne	$t0, $t1, $t0
	sw	$t0, 48($sp)

	lw	$t0, 48($sp)
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
	sb	$v0, 60($sp)

	# _temp78 == DASH
	lb	$t1, 60($sp)
	lb	$t0, _DASH
	seq	$t0, $t1, $t0
	sw	$t0, 56($sp)

	lw	$t0, 56($sp)
	bgtz	$t0, __label24

	# calling printState
	jal	_printState

	# calling readSymbol
	jal	_readSymbol

	# retrieve return value from readSymbol
	sb	$v0, 68($sp)

	# _temp80 == SPACE
	lb	$t1, 68($sp)
	lb	$t0, _SPACE
	seq	$t0, $t1, $t0
	sw	$t0, 64($sp)

	lw	$t0, 64($sp)
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
	lw	$fp, 72($sp)
	lw	$ra, 76($sp)
	addu	$sp, $sp, 80
	jr	$ra

.data

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
