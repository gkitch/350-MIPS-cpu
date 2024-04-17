# Processor
## NAME (NETID)
Gavin Kitch (gik4)

## Description of Design
This processor follows the standard 5-stage pipeline design, with a latch between each stage to store the relevant information (instruction, PC, etc.). In the Fetch stage, we use our jump/branch logic to determine what our next instruction address should be (either we take this branch / jump, or increment +1). Then, we use this address to retrieve the instruction from imem, passing it into the latch. In the Decode stage, we take this

## Bypassing
I used a combination of checks of opcodes and equivalency comparisons between $rd in future registers and current $rd/$rs/$rt depending on the instruction type. These were used to select between the control values of a mux, and then was passed in as the control bits to select between the 3 possible inputs (M stage value, data_writeReg, or the default pass through for no bypassing).

## Stalling
I used the provided equation in the slides to stall the first stage, as well as standard multdiv stalling. In addition, in my (partially successful) efforts to debug the sort test, I implemented a technique of selectively stalling and feeding in nop instructions for the small subset of cases (mem --> branch/jr) that were throwing errors for me in the sort test.

## Bugs
I still have a few bugs in my sort test that I have been unable to figure out. If you look at my sort_test.s file, there are a few nops that I inserted, with which the proper values are being stored in $13 and $14. These seem to be right after branches to a stage where there is a SW instruction, but I have been unable to successfully debug and solve the issue after quite a lot of various attempts.

I also had a very minor error with my multdiv that I couldn't figure out——it was not initializing the values properly, and therefore repeatedly propagating 'x' values. I worked on it for quite some time with TAs before the last checkpoint, and finally this week was able to get things to work with the provided multdiv.