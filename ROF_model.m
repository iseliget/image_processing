% This code tries to implement the Rudin-Osher-Fatemi model
% We discretize the model using the method presented in the following
% http://www.math.ucla.edu/~lvese/285j.1.05s/ROFScheme.pdf

% Load image in BMP format
u = imread('Lena.bmp'); % Do not use double quote
u = double(u); % Convert to double so you can add noise later
% u = double(u);
[M, N] =size(u);

% Display image with scaled colors
imagesc(u);
axis image;
axis off;
colormap(gray);

% Generate noise
noise = randn(size(u));
u0 = u + 30*noise; % Multiply by 1 the noise is too small to notice
