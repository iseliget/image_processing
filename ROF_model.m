% This code tries to implement the Rudin-Osher-Fatemi model
% We discretize the model using the method presented in the following
% http://www.math.ucla.edu/~lvese/285j.1.05s/ROFScheme.pdf


% PREPROCESSING
% Load image in BMP format
img = imread('Lena.bmp'); % Do not use double quote
img = double(img); % Convert to double so you can add noise later
[M, N] =size(img);

% Display image with scaled colors
imagesc(img);
axis image;
axis off;
colormap(gray);

% Generate noise
noise = rand(size(img));
u0 = img + 20*noise; % Multiply by 1 the noise is too small to notice


% NOISE REDUCTION
% Implement the boundary condition
u = padarray(img,[1 1]);
u(1,2:size(u,2)-1) = img(1,:); % First row
u(size(u,1),2:size(u,2)-1) = img(size(img,1),:); % Last row
u(2:size(u,1)-1,1) = img(:,1); % First column
u(size(u,2),2:size(u,1)-1) = img(:,size(img,2)); % Last column
