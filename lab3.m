%% Lab 3: Frequency-Domain Filtering with fft2
% Course: Mathematical Algorithms (DSP) — Image Processing Labs
% -------------------------------------------------------------------------
% - Ideal LP causes ringing (Gibbs) due to hard cutoff.
% - Convolution theorem: spatial convolution <-> frequency multiplication.
% - Compare spatial vs frequency-domain Gaussian LP (should match closely).
% HOW TO SUBMIT: include screenshots and short explanations for each section in the GitHub.
% -------------------------------------------------------------------------
close all; clear; clc;

%% I/O setup (safe saving)
save_figs = true;
outdir = fullfile(pwd,'figures');
if save_figs && ~exist(outdir,'dir')
    mkdir(outdir);
end

%% Load image
if exist('peppers.png','file')
    I0 = imread('peppers.png');
else
    I0 = repmat(imread('cameraman.tif'),1,1,3);
end
I = im2double(rgb2gray(I0));
[M,N] = size(I);

%% 1) Magnitude spectrum (log-scale)
F = fft2(I);
Fshift = fftshift(F);
S = log(1 + abs(Fshift));

f1 = figure;
subplot(1,2,1); imshow(I,[]); title('Image');
subplot(1,2,2); imshow(S,[]); title('Log-magnitude spectrum (centered)');
if save_figs
    if ~exist(outdir,'dir'), mkdir(outdir); end
    exportgraphics(f1, fullfile(outdir,'spectrum.png'));
end

%% 2) Ideal & Gaussian Low-pass filters
[u,v] = meshgrid( (-floor(N/2)):(ceil(N/2)-1), ...
                  (-floor(M/2)):(ceil(M/2)-1) );
D = sqrt(u.^2 + v.^2);

D0 = 40;                      % cutoff radius
H_ideal_LP = double(D <= D0);
sigma_f = 20;
H_gauss_LP = exp(-(D.^2)/(2*sigma_f^2));

%% 3) Apply LP filters
G_ideal = real(ifft2(ifftshift(H_ideal_LP .* Fshift)));
G_gauss = real(ifft2(ifftshift(H_gauss_LP .* Fshift)));

f2 = figure;
montage({I, G_ideal, G_gauss}, 'Size',[1 3], 'BorderSize',[10 10]);
title('Original | Ideal LP (ringing) | Gaussian LP (smooth)');
if save_figs
    if ~exist(outdir,'dir'), mkdir(outdir); end
    exportgraphics(f2, fullfile(outdir,'lp_compare.png'));
end

%% 4) Gaussian High-pass
H_gauss_HP = 1 - H_gauss_LP;
G_hp = real(ifft2(ifftshift(H_gauss_HP .* Fshift)));
G_hp = mat2gray(G_hp);

f3 = figure;
montage({I, G_hp}, 'Size',[1 2], 'BorderSize',[10 10]);
title('Original | Gaussian High-pass result');
if save_figs
    if ~exist(outdir,'dir'), mkdir(outdir); end
    exportgraphics(f3, fullfile(outdir,'gauss_hp.png'));
end

%% 5) Compare spatial vs frequency Gaussian LP
g1d = fspecial('gaussian',[1 15],2.0);
I_spatial_gauss = imfilter(I, g1d'*g1d, 'replicate');

f4 = figure;
montage({mat2gray(I_spatial_gauss), mat2gray(G_gauss)}, ...
        'Size',[1 2], 'BorderSize',[10 10]);
title('Spatial Gaussian LP | Frequency-domain Gaussian LP');
if save_figs
    if ~exist(outdir,'dir'), mkdir(outdir); end
    exportgraphics(f4, fullfile(outdir,'gauss_spatial_vs_freq.png'));
end
