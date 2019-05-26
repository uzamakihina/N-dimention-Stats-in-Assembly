final.s are both CubeCalculations and main-row-first.s in one file.

To run the program,
Make sure spim is installed ( spim is a version of mips)
provide or use the provided input files and use the command 
spim -f final.s < input.txt

#Note on the input

The input format is such that the first number (x) is the dimension of the cube, while the second number (y) is the size of each dimension. So 2 4 would be a 4x4 cube and 3 4 would be a 4x4x4 cube. Then the next x*y numbers below will be the value of each block in the cube.

Then the next numbers will be the test cases such that
the first x numbers will be the starting corner index of the cube.
the x+1 th number will be where to calculate to.

The last -1 is to indicate the end. 

# In human readable format
For example:

2 3 	# dimension and size
1 2 3   # next 3 lines are the value for each space 
4 5 6 
7 8 9
1 1 2   # test case 1 
-1

we would try to calculate starting from [1][1] all the way to [2][2]
5 6 8 9 /4 

# in machine readable format all the numbers would be in a streight line.



