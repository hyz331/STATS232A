from PIL import Image
import numpy as np
import scipy.ndimage as ndi

m = np.array(Image.open('../natural_scene_1.jpg').convert('L'))
flt = np.array([[0, 0, 0], [1, 0, -1], [0, 0, 0]])
t = ndi.convolve(m, flt, output=np.float64, mode='nearest')
k = Image.fromarray(t)
k.convert('RGB').save('cov.png')


# Load and cast image
m = np.array(Image.open('../natural_scene_1.jpg').convert('L'))
m = (m * 1.0) / 255 * 32
m = m.astype('uint8')
print m
m = Image.fromarray(m)

# Apply filter and save
flt = np.array([[0, 0, 0], [1, 0, -1], [0, 0, 0]])
t = ndi.convolve(m, flt, output=np.float64, mode='nearest')
m_filtered = Image.fromarray(t)
m_filtered = np.array(m_filtered)

np.save('filtered_img', m_filtered)
