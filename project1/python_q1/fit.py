from PIL import Image
from matplotlib import pyplot as plt
from scipy.optimize import curve_fit
import numpy as np
import scipy.stats as stats

def normal(x, mu, s):
	return np.exp(-(x-mu)**2/(2*s*s)) / np.sqrt(2*np.pi*s)

# Generate histogram
m = np.load('filtered_img.npy')
plt.subplot(1, 2, 1)
[y, bins, p] = plt.hist(m.flatten(), 63, normed=True, color='white')
plt.title('gradient filter histogram')
x = np.arange(-31, 32)
plt.subplot(1, 2, 2)
plt.plot(x, np.log(y))
plt.title('log histogram')
plt.savefig('q1_1.jpg')
plt.close()

# Compute stats
data = m.flatten()
print 'mean', np.mean(data)
print 'var', np.var(data)
print 'kurtosis', stats.kurtosis(data)

# Define Generalized Gaussian distribution using estimated mean and std
def g_gau(x, *p):
	A, gamma = p
	return A*np.exp(-((abs(x-np.mean(data)))/np.std(data))**gamma)

# Fit Generalized Gaussian
[coeff, var] = curve_fit(g_gau, x, y, p0=[1., 1.])
hist_fit = g_gau(x, *coeff)
plt.hist(m.flatten(), 63, normed=True)
plt.plot(x, hist_fit)
plt.savefig('q1_3.jpg')
plt.close()
print 'gamma', coeff[1]

# Plot Gaussian and superimopse log plots
plt.subplot(1, 2, 1)
plt.title('Gaussian')
plt.plot(x, normal(x, np.mean(data), np.std(data)))
plt.hist(m.flatten(), 63, normed=True, color='white')

plt.subplot(1, 2, 2)
plt.title('log Gaussian')
p1 = plt.plot(x, np.log(normal(x, np.mean(data), np.std(data))), label='original')
p2 = plt.plot(x, np.log(y), label='Gaussian')

plt.savefig('q1_4.jpg')
plt.close()

# Imposing downscaled images
m_m = np.load('filtered_img_m.npy')
m_s = np.load('filtered_img_s.npy')
plt.subplot(1, 2, 1)
plt.hist(m.flatten(), 63, normed=True, alpha=0.5, color='blue')
[y_m, bins, p] = plt.hist(m_m.flatten(), 63, normed=True, alpha=0.5, color='red')
[y_s, bins, p] = plt.hist(m_s.flatten(), 63, normed=True, alpha=0.5, color='yellow')
plt.legend(['original', '2x2 avg', '4x4 avg'])

x_m, x_s = [], []
y_m2, y_s2 = [], []
for i in range(0, len(x)):
	if (y_m[i] > 0): 
		x_m.append(x[i])
		y_m2.append(y_m[i])
	if (y_s[i] > 0): 
		x_s.append(x[i])
		y_s2.append(y_s[i])

plt.subplot(1, 2, 2)
plt.plot(x, np.log(y))
plt.plot(x_m, np.log(y_m2))
plt.plot(x_s, np.log(y_s2))
plt.legend(['original', '2x2 avg', '4x4 avg'])
plt.savefig('q1_5.jpg')
