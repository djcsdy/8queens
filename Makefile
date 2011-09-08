build/%.o: src/%.c
	gcc -g -o $@ -c $<

build/%.o: src/%.asm
	nasm -f elf -o $@ $<

queens: build/queens.o build/main.o
	gcc -o $@ $^

all: queens
