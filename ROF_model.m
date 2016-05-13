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
f = img + 30*noise; % If multiply by 1 then the noise is too small to notice

%imagesc(f);
%axis image;
%axis off;
%colormap(gray);


% NOISE REDUCTION
% Implement the boundary condition
% You can use padarray() if your Matlab has this function
u = zeros(size(f)+2);
u(2:size(u)-1,1) = f(:,1); % First column
u(2:size(u)-1,size(u,2)) = f(:,size(f,2)); % Last column
u(1,2:size(u,2)-1) = f(1,:); % First row
u(size(u,1),2:size(u,2)-1) = f(size(f,1),:); % Last row
for i = 2:size(u)-1
    u(2:size(u)-1,i) = f(:,i-1);
end

% Pad f to let size(f) = size(u)
f_pad = zeros(size(f)+2);
f_pad(2:size(f_pad)-1,1) = f(:,1); % First column
f_pad(2:size(f_pad)-1,size(f_pad,2)) = f(:,size(f,2)); % Last column
f_pad(1,2:size(f_pad,2)-1) = f(1,:); % First row
f_pad(size(f_pad,1),2:size(f_pad,2)-1) = f(size(f,1),:); % Last row
for i = 2:size(f_pad)-1
    f_pad(2:size(f_pad)-1,i) = f(:,i-1);
end

% Pad img
img_pad = zeros(size(img)+2);
img_pad(2:size(img_pad)-1,1) = img(:,1); % First column
img_pad(2:size(img_pad)-1,size(img_pad,2)) = img(:,size(img,2)); % Last column
img_pad(1,2:size(img_pad,2)-1) = img(1,:); % First row
img_pad(size(img_pad,1),2:size(img_pad,2)-1) = img(size(img,1),:); % Last row
for i = 2:size(img_pad)-1
    img_pad(2:size(img_pad)-1,i) = img(:,i-1);
end

% Implement the scheme for interior points
% Test for different lambda values
figure;

for lambda = 4:12
    delta_t = 1;
    %lambda = 15;
    h = 1;
    e = eps; 

    num_of_iteration = 30;
    energy = zeros(num_of_iteration,1);
    energy2 = zeros(num_of_iteration,1);
    c = 0;

    for iteration = 1:num_of_iteration
        c = c + 1;
        for i = 2:size(u)-1
            for j = 2:size(u)-1
                c1 = 1/sqrt(e^2 + ((u(i+1,j)-u(i,j))/h)^2 + ((u(i,j+1)-u(i,j))/h)^2);
                c2 = 1/sqrt(e^2 + ((u(i,j)-u(i-1,j))/h)^2 + ((u(i-1,j+1)-u(i-1,j))/h)^2);
                c3 = 1/sqrt(e^2 + ((u(i+1,j)-u(i,j))/h)^2 + ((u(i,j+1)-u(i,j))/h)^2);
                c4 = 1/sqrt(e^2 + ((u(i+1,j-1)-u(i,j-1))/h)^2 + ((u(i,j)-u(i,j-1))/h)^2);
                u(i,j) = (1/(1+delta_t+delta_t*(c1+c2+c3+c4)/2*lambda*h^2))*(u(i,j)+delta_t*f_pad(i,j)+delta_t*(c1*u(i+1,j)+c2*u(i-1,j)+c3*u(i,j+1)+c4*u(i,j-1))/2*lambda*h^2);
            end
        end
        % Compute L^2 norm energy wrt original image
        energy(c,1) = sum(sum(abs(img_pad - u),1),2);
    end

    %figure; % open new window
    %imagesc(u);
    %axis image;
    %axis off;
    %colormap(gray);

    subplot(3,3,lambda-3);
    x = plot([1:num_of_iteration],energy,':');
    title_string = sprintf('Lambda = %i',lambda);
    title(title_string);
end
