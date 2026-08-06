import numpy as np
import matplotlib.pyplot as plt
from scipy import signal

w = np.linspace(0, 3, 1000)
wc = 1.0
ideal_magnitude = np.where(w <= wc, 1.0, 0.0)
order = 4
b, a = signal.butter(order, wc, analog=True)
_, h_pract = signal.freqs(b, a, worN=w)
practical_magnitude = np.abs(h_pract)
plt.figure(figsize=(10, 6))
plt.plot(w, ideal_magnitude, label='Ideal Filter (Theoretical Brick-Wall)',
         color='black', linewidth=2.5, linestyle='--')
plt.plot(w, practical_magnitude, label=f'Practical Filter ({order}th-Order Butterworth)',
         color='blue', linewidth=2.5)
plt.axvline(wc, color='red', linestyle=':', linewidth=2, label='Cutoff Frequency ($\omega_c$)')
plt.fill_between(w, 0, ideal_magnitude, alpha=0.1, color='gray')
plt.title('Frequency Response: Ideal vs. Practical Anti-Aliasing Filter', fontsize=14, fontweight='bold')
plt.xlabel('Frequency $\omega$ (Normalized)', fontsize=12)
plt.ylabel('Magnitude $|H(j\omega)|$', fontsize=12)
plt.ylim(-0.05, 1.1)
plt.xlim(0, 2.5)
plt.grid(True, which='both', linestyle='--', alpha=0.7)
plt.legend(loc='upper right', fontsize=11)
plt.tight_layout()
plt.show()