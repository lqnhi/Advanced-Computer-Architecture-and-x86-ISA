.data 0
.global inputs
1 0 1

.data 32
.global weights
2 -1 3

.data 80
.global bias
-2

.data 96
.global result
0

.data 144
.global zero_const
0

.program 0
li R1, inputs     
li R2, weights    
li R3, 3          

li R11, zero_const
li R12, (R11)
move R10, R12      

.loop
li r4, (r1)    --Load input[i] from memory address in R1 into R4
li r5, (r2)    --Load weight[i] from memory address in R2 into R5
mult r6, r4, r5 -- Multiply R4 and R5, store result in R6
add r10, r10, r6 -- Add R6 (product) to accumulator R10
add r1, r1, 1
add r2, r2, 1
sub r3, r3, 1
brnz r3, loop
nop  -- This is the delay slot
li r7, bias
li r7, (r7)
add r10, r10, r7


brp r10, positive
li r8, 0
br store_result

.positive
li r8, 1

.store_result
li r9, result
si (r9), r8

exit
.end