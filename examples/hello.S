	.code16
	.text
	.global _start
_start:
	# write msg to screen using int 10h
	movw	$len, %ax
	movw	$msg, %cx
loop:
	movw	%ax, ctr(,1)
	movw	$4, %ax
	movw	$1, %bx
	movw	$1, %dx
	int	$0x80
	inc	%cx
	movw	ctr, %ax
	dec	%ax
	jnz	loop

	movw	$0, %bx
	movw	$1, %ax
	int	$0x80

	.data
ctr:
	.long 0
msg:
	.ascii	"Hello, from the bootloader."	# message
	len = . - msg				# length of the msg
