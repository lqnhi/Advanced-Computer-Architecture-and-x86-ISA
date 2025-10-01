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
li R10, (R11)        

li R7, bias         
li R7, (R7)         

.loop
li R4, (R1)         
li R5, (R2)          
mult R6, R4, R5     
add R10, R10, R6     

add R1, R1, 1        
add R2, R2, 1      
sub R3, R3, 1        
brnz R3, loop      

nop                 

add R10, R10, R7    

brp R10, positive   
li R8, 0             
br store_result      

.positive
li R8, 1             

.store_result
li R9, result        
si (R9), R8          

exit
.end

