
.text

_ps:
	subu	$sp, $sp, 12
	sw		$ra, 8($sp)
	sw		$fp, 4($sp)
	addu	$fp, $sp, 12
	lw		$t0, 0($fp)		# storing parameter string
	sw		$t0, 0($sp)

	# pushing parameter string
	lw		$t0, 0($sp)
	subu	$sp, $sp, 4
	sw		$t0, 0($sp)

	# calling print_string
	jal		_print_string

	# popping pushed parameters
	addu	$sp, $sp, 4

__psReturn:
	lw		$fp, 4($sp)
	lw		$ra, 8($sp)
	addu	$sp, $sp, 12
	jr		$ra

.text

_pi:
	subu	$sp, $sp, 12
	sw		$ra, 8($sp)
	sw		$fp, 4($sp)
	addu	$fp, $sp, 12
	lw		$t0, 0($fp)		# storing parameter n
	sw		$t0, 0($sp)

	# pushing parameter n
	lw		$t0, 0($sp)
	subu	$sp, $sp, 4
	sw		$t0, 0($sp)

	# calling print_int
	jal		_print_int

	# popping pushed parameters
	addu	$sp, $sp, 4

__piReturn:
	lw		$fp, 4($sp)
	lw		$ra, 8($sp)
	addu	$sp, $sp, 12
	jr		$ra

.text

_pn:
	subu	$sp, $sp, 8
	sw		$ra, 4($sp)
	sw		$fp, 0($sp)
	addu	$fp, $sp, 8

	# pushing parameter _temp0
	la		$t0, __temp0
	subu	$sp, $sp, 4
	sw		$t0, 0($sp)

	# calling print_string
	jal		_print_string

	# popping pushed parameters
	addu	$sp, $sp, 4

__pnReturn:
	lw		$fp, 0($sp)
	lw		$ra, 4($sp)
	addu	$sp, $sp, 8
	jr		$ra

.text

_ri:
	subu	$sp, $sp, 12
	sw		$ra, 8($sp)
	sw		$fp, 4($sp)
	addu	$fp, $sp, 12
	# initializing local variables
	sw		$0, 0($sp)

	# calling read_int
	jal		_read_int

	# retrieve return value from read_int
	sw		$v0, 0($sp)

	# return _temp1
	lw		$t0, 0($sp)
	add		$v0, $t0, $0
	j		__riReturn

__riReturn:
	lw		$fp, 4($sp)
	lw		$ra, 8($sp)
	addu	$sp, $sp, 12
	jr		$ra

.text

_rs:
	subu	$sp, $sp, 12
	sw		$ra, 8($sp)
	sw		$fp, 4($sp)
	addu	$fp, $sp, 12
	lw		$t0, 0($fp)		# storing parameter s
	sw		$t0, 0($sp)

	# pushing parameter s
	lw		$t0, 0($sp)
	subu	$sp, $sp, 4
	sw		$t0, 0($sp)

	# calling read_string
	jal		_read_string

	# popping pushed parameters
	addu	$sp, $sp, 4

__rsReturn:
	lw		$fp, 4($sp)
	lw		$ra, 8($sp)
	addu	$sp, $sp, 12
	jr		$ra
.data

_n:
	.word 0

.data

_s:
	.space 100


.text

main:
	subu	$sp, $sp, 12
	sw		$ra, 8($sp)
	sw		$fp, 4($sp)
	addu	$fp, $sp, 12
	# initializing local variables
	sw		$0, 0($sp)

	# pushing parameter _temp2
	la		$t0, __temp2
	subu	$sp, $sp, 4
	sw		$t0, 0($sp)

	# calling ps
	jal		_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling ri
	jal		_ri

	# retrieve return value from ri
	sw		$v0, 0($sp)

	# n = _temp3
	lw		$t0, 0($sp)
	sw		$t0, _n

	# pushing parameter _temp4
	la		$t0, __temp4
	subu	$sp, $sp, 4
	sw		$t0, 0($sp)

	# calling ps
	jal		_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter n
	lw		$t0, _n
	subu	$sp, $sp, 4
	sw		$t0, 0($sp)

	# calling pi
	jal		_pi

	# popping pushed parameters
	addu	$sp, $sp, 4

	# calling pn
	jal		_pn

	# pushing parameter _temp5
	la		$t0, __temp5
	subu	$sp, $sp, 4
	sw		$t0, 0($sp)

	# calling ps
	jal		_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter s
	la		$t0, _s
	subu	$sp, $sp, 4
	sw		$t0, 0($sp)

	# calling rs
	jal		_rs

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter _temp6
	la		$t0, __temp6
	subu	$sp, $sp, 4
	sw		$t0, 0($sp)

	# calling ps
	jal		_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

	# pushing parameter s
	la		$t0, _s
	subu	$sp, $sp, 4
	sw		$t0, 0($sp)

	# calling ps
	jal		_ps

	# popping pushed parameters
	addu	$sp, $sp, 4

__mainReturn:
	lw		$fp, 4($sp)
	lw		$ra, 8($sp)
	addu	$sp, $sp, 12
	jr		$ra

.data

__temp6:
	.asciiz	"The string you entered is "

__temp5:
	.asciiz	"Enter a string: "

__temp4:
	.asciiz	"The number you entered is "

__temp2:
	.asciiz	"Enter a number: "

__temp0:
	.asciiz	"\n"

.text

_print_int:
	li		$v0, 1
	lw		$a0, 0($sp)
	syscall
	jr		$ra

_print_string:
	li		$v0, 4
	lw		$a0, 0($sp)
	syscall
	jr		$ra
_read_int:
	li		$v0, 5
	syscall
	jr		$ra

_read_string:
	li		$v0, 8
	syscall
	lw		$t0, 0($sp)
__read_string_copy:
	lb		$t1, 0($a0)
	sb		$t1, 0($t0)
	addi	$t0, $t0, 1
	addi	$a0, $a0, 1
	bgtz	$t1, __read_string_copy
	jr		$ra
