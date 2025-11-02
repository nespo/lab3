# Lab 3: Frequency-Domain Filtering with fft2
**Course:** Mathematical Algorithms (DSP) — Image Processing Labs  

---

## Objective
- Understand how spatial convolution relates to frequency multiplication (Convolution Theorem).  
- Visualize and apply Ideal and Gaussian Low-Pass (LP) filters in the frequency domain.  
- Compare results of spatial-domain vs frequency-domain Gaussian filtering.  
- Explore the effect of High-Pass filtering by complementing a Gaussian LP filter.

---

## Steps and Results

### 1️⃣ Magnitude Spectrum
- Performed 2D FFT (`fft2`) and shifted with `fftshift` to center the DC component.  
- Displayed the **log-magnitude spectrum** to visualize low and high frequencies.  
- **Figure:** `figures/spectrum.png`

### 2️⃣ Ideal & Gaussian Low-Pass Filters
- Created frequency grids using `meshgrid`.  
- Designed:
  - **Ideal LP:** circular mask with cutoff radius `D0 = 40`.
  - **Gaussian LP:** smooth exponential falloff (`σ = 20`).
- **Figure:** `figures/lp_compare.png`

### 3️⃣ Filtering in Frequency Domain
- Multiplied the centered spectrum with each filter and took inverse FFT (`ifft2`).  
- Ideal LP shows **ringing (Gibbs effect)**.  
- Gaussian LP gives a **smooth blur**.

### 4️⃣ Gaussian High-Pass Filtering
- Computed `H_HP = 1 - H_LP`.  
- Result highlights **edges and fine textures**.  
- **Figure:** `figures/gauss_hp.png`

### 5️⃣ Spatial vs Frequency Gaussian LP
- Applied `fspecial('gaussian')` + `imfilter()` for spatial Gaussian blur.  
- Compared with frequency-domain Gaussian LP — both produce similar outputs.  
- **Figure:** `figures/gauss_spatial_vs_freq.png`

---

## Reflection Questions

1. **Why does the Ideal LP cause ringing (Gibbs phenomenon)?**  
   Because its abrupt frequency cutoff corresponds to a sinc-like response in space, which oscillates near sharp transitions.

2. **What does `fftshift` do visually?**  
   It shifts the zero frequency (DC) component to the center, making spectra easier to interpret.

3. **When is frequency-domain filtering preferable?**  
   When filter kernels are large — FFT-based convolution (`O(N log N)`) is more efficient than direct spatial convolution (`O(N × k²)`).

---

## How to Run
1. Open **`lab3.m`** in MATLAB.  
2. Make sure an image (e.g. `peppers.png`) is in the working directory.  
3. Run the script.  
4. Processed figures will be automatically saved in a folder named **`figures/`**.

---

**Submitted Files:**
- `lab3.m`
- `README.md`
- `figures/` (contains output screenshots)
