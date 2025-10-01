.data 16
.global In
    9 7 5 3 1 2 4 6 8 0    -- Input array to be sorted
.data 32
.global Out
    0 0 0 0 0 0 0 0 0 0    -- Output array for sorted numbers
.alias N 10                -- Number of elements in the array

.program 4
    add R0, 0, In          -- R0 = address of In (input array)
    add R1, 0, Out         -- R1 = address of Out (output array)
    add R2, 0, N           -- R2 = N (number of elements)
    add R3, 0, 1           -- R3 = swapped flag (1 = true)

.CopyInput                 -- Copy input array to output array
.L0
    li R4, (R0)            -- Load data from In
    nop                    -- Avoid hazard after load
    si (R1), R4            -- Store data into Out
    add R0, R0, 1          -- Increment In pointer
    add R1, R1, 1          -- Increment Out pointer
    sub R2, R2, 1          -- Decrement counter
    brnz R2, L0            -- If counter not zero, loop
    add R2, 0, N           -- Reset R2 = N (number of elements)

.SortLoop                  -- Start of Bubble Sort
.L1
    add R3, 0, 0           -- Reset swapped flag (R3 = 0)
    add R0, 0, Out         -- R0 = address of Out
    sub R2, N, 1           -- R2 = N - 1 (outer loop limit)

.InnerLoop                 -- Inner loop to compare and swap
.L2
    li R4, (R0)            -- Load Out[i] into R4
    nop                    -- Avoid hazard after load
    add R6, R0, 1          -- R6 = address of Out[i+1]
    li R7, (R6)            -- Load Out[i+1] into R7
    nop                    -- Avoid hazard after load
    sub R8, R4, R7         -- Compare Out[i] - Out[i+1]
    brp R8, NoSwap         -- If Out[i] <= Out[i+1], skip swap

    si (R0), R7            -- Swap: Store Out[i+1] into Out[i]
    nop                    -- Avoid hazard after store
    si (R6), R4            -- Swap: Store Out[i] into Out[i+1]
    add R3, 0, 1           -- Set swapped flag (R3 = 1)

.NoSwap
    add R0, R0, 1          -- Increment pointer to next pair
    sub R2, R2, 1          -- Decrement inner loop counter
    brnz R2, L2            -- If inner loop not finished, repeat

    sub R2, N, 1           -- Reset R2 = N - 1 (outer loop limit)
    brnz R3, L1            -- If swapped flag is set, repeat outer loop

.end
