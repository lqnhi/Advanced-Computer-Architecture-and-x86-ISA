.data 0
.global a
1 1 1 1 1 1 1 1
2 2 2 2 2 2 2 2
3 3 3 3 3 3 3 3
4 4 4 4 4 4 4 4
5 5 5 5 5 5 5 5
6 6 6 6 6 6 6 6
7 7 7 7 7 7 7 7
8 8 8 8 8 8 8 8
.data 64
.global b
1 1 1 1 1 1 1 1
2 2 2 2 2 2 2 2
3 3 3 3 3 3 3 3
4 4 4 4 4 4 4 4
5 5 5 5 5 5 5 5
6 6 6 6 6 6 6 6
7 7 7 7 7 7 7 7
8 8 8 8 8 8 8 8
.data 128
.global c
0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0
.alias SIZE 8             -- Size of the matrices (8x8)
.program 0
    add R0, 0, 0          -- R0 = base address of matrix a (address 0)
    add R1, 0, 64         -- R1 = base address of matrix b (address 64)
    add R2, 0, 128        -- R2 = base address of matrix c (address 128)
    add R3, 0, 0          -- R3 = i = 0 (row index for matrix a and c)
.RowLoop                  -- Start of outer loop (for each row in A)
.L1
    add R4, 0, 0          -- R4 = j = 0 (column index for matrix b and c)
.ColumnLoop               -- Start of middle loop (for each column in B)
.L2
    add R5, 0, 0          -- R5 = sum = 0 (accumulator for dot product)
    add R6, 0, 0          -- R6 = k = 0 (index for inner dimension)
.DotProductLoop           -- Start of inner loop (calculate dot product)
.L3
    mult R7, R3, SIZE     -- R7 = i * SIZE (row offset in A)
    add R7, R7, R6        -- R7 = i * SIZE + k (element offset in A)
    add R7, R0, R7        -- R7 = base_a + (i * SIZE + k)
    li R8, (R7)           -- R8 = a[i][k]
    add R9, R5, 0         -- Delay slot: Preserve R5 (safe copy)

    mult R10, R6, SIZE    -- R10 = k * SIZE (row offset in B)
    add R10, R10, R4      -- R10 = k * SIZE + j (element offset in B)
    add R10, R1, R10      -- R10 = base_b + (k * SIZE + j)
    li R11, (R10)         -- R11 = b[k][j]
    add R12, R6, 0        -- Delay slot: Preserve R6 (safe copy)

    mult R13, R8, R11     -- R13 = a[i][k] * b[k][j]
    add R5, R5, R13       -- sum += a[i][k] * b[k][j]

    add R6, R6, 1         -- k++
    sub R12, R6, SIZE     -- R12 = k - SIZE
    brnz R12, L3          -- If k < SIZE, continue inner loop
    add R13, R5, 0        -- Delay slot: Preserve R5 (safe copy)

    mult R14, R3, SIZE    -- R14 = i * SIZE (row offset in C)
    add R14, R14, R4      -- R14 = i * SIZE + j (element offset in C)
    add R14, R2, R14      -- R14 = base_c + (i * SIZE + j)
    si (R14), R5          -- c[i][j] = sum
    add R15, R3, 0        -- Delay slot: Preserve R3 (safe copy)

    add R4, R4, 1         -- j++
    sub R14, R4, SIZE     -- R14 = j - SIZE
    brnz R14, L2          -- If j < SIZE, continue middle loop
    add R15, R4, 0        -- Delay slot: Preserve R4 (safe copy)

    add R3, R3, 1         -- i++
    sub R15, R3, SIZE     -- R15 = i - SIZE
    brnz R15, L1          -- If i < SIZE, continue outer loop
    add R6, R3, 0         -- Delay slot: Preserve R3 in R6 (safe copy)

    exit                  -- End program
.end