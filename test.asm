[BITS 16]
mov ax,0x07c0
mov ds,ax


enumerate:
	cmp byte [device_no],0x1F
	je increment_bus_no
	cmp byte [bus_no],0xFF
	je end
	mov eax,0
	or al,[bus_no]
	shl eax,5
	or al,[device_no]
	shl eax,11
	or eax,0x80000000

	mov dx,[CONFIG_ADDRESS]
	out dx,eax
	mov dx,[CONFIG_DATA]
	in eax,dx
	add byte [device_no],1
	cmp eax,0xFFFFFFFF
	je enumerate
increment:
	add byte [device_count],1
	jmp enumerate
increment_bus_no:
	add byte [bus_no],1
	mov byte [device_no],0
	jmp enumerate

end:
	mov dword eax,[device_count]
	jmp end


	

CONFIG_ADDRESS dw 0x0CF8
CONFIG_DATA dw 0x0CFC
bus_no db 0xFF
device_no db 0x1F
device_count db 0x00
times 510-($-$$) db 0x00
db 0x55
db 0xAA
