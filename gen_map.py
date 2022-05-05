import numpy as np

original_arr = np.loadtxt("bitmap.txt", dtype=int)


new_arr = np.repeat(np.repeat(original_arr,60, axis=0), 60, axis=1)

pad_arr = np.zeros((32, 480), dtype = int)

new_arr = np.concatenate((new_arr, pad_arr), axis = 0)


np.savetxt("array.txt", new_arr.astype(int), fmt='%i',delimiter='')






