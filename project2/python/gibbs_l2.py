import numpy as np
import matplotlib.pyplot as plt
import math
import random
import scipy.io as sio
from PIL import Image
import sys

def clique_potential(I, x, y, beta):
	gx = lambda i, j: I[i][j] - I[i][j-1]
	gy = lambda i, j: I[i][j] - I[i-1][j]
	E = lambda i, j: (gx(i, j) ** 2) + (gy(i, j) ** 2)
	H = beta * (E(i, j) + E(i-1, j) + E(i, j-1) + E(i-1, j-1))
	return H

def sample_pixel(I, x, y, beta):
	# precompute pixel probabilities
	pixel_prob = [0 for i in range(0, 256)]
	for i in range(0, 256):
		I[x, y] = i
		pixel_prob[i] = math.exp(-clique_potential(I, x, y, beta))
	Z = sum(pixel_prob)
	pixel_prob = np.array(pixel_prob) / Z

	# sample value
	n = random.random()
	prob = 0
	for val in range(0, 256):
		prob = prob + pixel_prob[val]
		if (prob > n):
			return val
	return 255	

I = np.array(Image.open('distroted_image.bmp'))
M = np.array(Image.open('mask_image.bmp'))
O = np.array(Image.open('original_image.bmp'))
I = (I[:, :, 0]).astype(int)
O = (O[:, :, 0]).astype(int)

[h, w] = M.shape
for sweep in range(0, 20):
	for i in range(0, h): 
		for j in range(0, w):
			if (M[i][j] > 0):
				I[i][j] = sample_pixel(I, i, j, 1)
	print np.linalg.norm(O - I) **2 / sum(sum(M > 0))

sio.savemat('recover_gibbs_l2.mat', {'image': I.astype(long)})
plt.imshow(I)
plt.show()
