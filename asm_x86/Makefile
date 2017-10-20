solution: solution.o
	ld -arch i386 -macosx_version_min 10.7.0 -no_pie -e start -o solution solution.o
	rm solution.o
	chmod +x solution 

solution.o: solution.asm
	nasm -f macho solution.asm

hello: helloworld.o
	ld -arch i386 -macosx_version_min 10.7.0 -no_pie -e start -o helloworld helloworld.o
	rm helloworld.o
	chmod +x helloworld

helloworld.o: helloworld.asm
	nasm -f macho helloworld.asm
