obj-m += mai_practice5.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
	gcc rawexample.c -o rawexample

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
	rm -f rawexample
