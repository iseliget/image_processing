% This code implements the Rudin-Osher-Fatemi model
% We discretize the model using the method presented in the following
% http://www.math.ucla.edu/~lvese/285j.1.05s/ROFScheme.pdf


% img: original image
% f: image with noise
% u: denoised image

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
f = img + 20*noise; % If multiply by 1 then the noise is too small to notice

imagesc(f);
axis image;
axis off;
colormap(gray);


% NOISE REDUCTION
% Implement the boundary condition
% u = padarray(img,[1 1]); 
% If you don't have the function padarray then you might have to use loops
u = zeros(size(f)+2);
u(2:size(u)-1,1) = f(:,1); % First column
u(2:size(u)-1,size(u,2)) = f(:,size(f,2)); % Last column
u(1,2:size(u,2)-1) = f(1,:); % First row
u(size(u,1),2:size(u,2)-1) = f(size(f,1),:); % Last row
for i = 2:size(u)-1
    u(2:size(u)-1,i) = f(:,i-1);
end

% Pad f
f = padarray(f,[1 1]);

% Implement the scheme for interior points
delta_t = 1;
lambda = 20;
h = 1;
e = realim; % smallest float in Matlab

for iteration = 1:100
    for i = 2:size(u)-1
        for j = 2:size(u)-1
            c1 = 1/sqrt(e^2 + ((u(i+1,j)-u(i,j))/h)^2 + ((u(i,j+1)-u(i,j))/h)^2);
            c2 = 1/sqrt(e^2 + ((u(i,j)-u(i-1,j))/h)^2 + ((u(i-1,j+1)-u(i-1,j))/h)^2);
            c3 = 1/sqrt(e^2 + ((u(i+1,j)-u(i,j))/h)^2 + ((u(i,j+1)-u(i,j))/h)^2);
            c4 = 1/sqrt(e^2 + ((u(i+1,j-1)-u(i,j-1))/h)^2 + ((u(i,j)-u(i,j-1))/h)^2);
            u(i,j) = (1/(1+delta_t+delta_t*(c1+c2+c3+c4)/2*lambda*h^2))*...
                (u(i,j)+delta_t*f(i,j)+delta_t*(c1*u(i+1,j)+c2*u(i-1,j)+c3*u(i,j+1)+c4*u(i,j-1))/2*lambda*h^2);
        end
    end
end

figure; % open new window
imagesc(u);
axis image;
axis off;
colormap(gray);
