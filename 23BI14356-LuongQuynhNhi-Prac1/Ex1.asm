.data 16
.global Fibo
    0 1 0 0 0 0 0 0 0 0   -- F(0)=0, F(1)=1, rest initialized to 0

.alias N 9    -- Compute up to F(9)

.program 4
    add R0, 0, Fibo    -- R0 points to Fibo[0]
    add R1, R0, 1      -- R1 points to Fibo[1]
    add R2, R0, 2      -- R2 points to Fibo[2]
    add R3, 0, 2       -- i = 2 (start from index 2)
    add R4, 0, N       -- N = 9 (max index)

.L0
    li R5, (R0)        -- load Fibo[i-2]
    li R6, (R1)        -- load Fibo[i-1]
    add R7, R5, R6     -- R7 = Fibo[i-2] + Fibo[i-1]
    si (R2), R7        -- store R7 into Fibo[i]

    add R0, R0, 1      -- move R0 to next (i-1)
    add R1, R1, 1      -- move R1 to next (i)
    add R2, R2, 1      -- move R2 to next (i+1)

    add R3, R3, 1      -- i = i + 1
    sub R8, R3, R4     -- R8 = i - N
    brnz R8, L0        -- if (i != N) continue loop
.end
