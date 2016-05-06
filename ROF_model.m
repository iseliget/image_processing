% This code tries to implement the Rudin-Osher-Fatemi model
% We discretize the model using the method presented in the following
% http://www.math.ucla.edu/~lvese/285j.1.05s/ROFScheme.pdf


% img: original image
% u0: image with noise
% u: image with noise modified according to boundary condition


% PREPROCESSING
% Load image in BMP format
img = imread('Lena.bmp'); % Do not use double quote
img = double(img); % Convert to double so you can add noise later
[M, N] =size(img);

% Display image with scaled colors
%imagesc(img);
%axis image;
%axis off;
%colormap(gray);

% Generate noise
noise = rand(size(img));
u0 = img + 20*noise; % Multiply by 1 the noise is too small to notice


% NOISE REDUCTION
% Implement the boundary condition
% u = padarray(img,[1 1]); 
% If you don't have the function padarray then you might have to use loops
u = zeros(size(u0)+2);
u(2:size(u)-1,1) = u0(:,1); % First column
u(2:size(u)-1,size(u,2)) = u0(:,size(u0,2)); % Last column
u(1,2:size(u,2)-1) = u0(1,:); % First row
u(size(u,1),2:size(u,2)-1) = u0(size(u0,1),:); % Last row
for i=2:size(u)-1
    u(2:size(u)-1,i) = u0(:,i-1);
end

% Implement the scheme for interior points
delta_t = 1;
lambda = 1;
h =1;
c1 = 1;
c2 = 1;
c3 = 1;
c4 = 1;

for i=2:size(u)-1
    for j=2:size(u)-1
        u(i,j) =u(i+1,j) + u(i-1,j);% (1/(1 + delta_t + delta_t*(c1+c2+c3+c4)/2*lambda*h*h))*(u + delta_t*u + delta_t*(c1*u(i+1,j)+c2*u(i-1,j)+c3*u(i,j+1)+c4*u(i,j-1)));
    end
end
% Display denoised image
imagesc(u);
axis image;
axis off;
colormap(gray);
            