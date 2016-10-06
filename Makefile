######################################################################
# EE425 Lab1 Makefile

yakk.bin:	lab4final.s
		nasm lab4final.s -o yakk.bin -l yakk.lst        		# Step 4, Assemble

lab4final.s:	clib.s yakk.s lab4ASM.s lab4b_app.s
		cat clib.s yakk.s lab4ASM.s lab4b_app.s > lab4final.s   # Step 3, Concatenate

yakk.s:	yakk.c
		cpp yakk.c yakk.i                             			# Step 1, Preprocess
		c86 -g yakk.i yakk.s                          			# Step 2, Compile

lab4b_app.s:	lab4b_app.c
		cpp lab4b_app.c lab4b_app.i                             # Step 1, Preprocess
		c86 -g lab4b_app.i lab4b_app.s                          # Step 2, Compile


clean:
		rm yakk.bin yakk.lst lab4final.s yakk.s yakk.i lab4b_app.i lab4b_app.s


