from PIL import Image
import numpy as np
import scipy.ndimage as ndi

# Load and cast image
m = Image.open('../natural_scene_1.jpg').convert('L')
(h, w) = m.size
m = m.resize((h/4, w/4), Image.LINEAR)
m = np.array(m)
m = (m * 1.0) / 255 * 32
m = m.astype('uint8')
m = Image.fromarray(m)

# Apply filter and save
flt = np.array([[0, 0, 0], [1, 0, -1], [0, 0, 0]])
t = ndi.convolve(m, flt, output=np.float64, mode='nearest')
m_filtered = Image.fromarray(t)
m_filtered = np.array(m_filtered)

np.save('filtered_img_s', m_filtered)
