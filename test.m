% Only for processing the log_irat_red dataset 

fileName = 'C:\RatSLAM-Dataset\log_irat_red.avi';

 v = VideoReader (fileName);

%numFrames = video.NumberOfFrames;
frame= read(v,[1 5]);

F = getframe;
[X,map] = frame2im(F);

% raw_image = read (video);
% START_FRAME = 1;
% BLOCK_READ = 10;
    %imshow (raw_image);
%mov = read(video,[1 11]);
% frame=10;
% BLOCK_READ =100;
%     rgb_im_index = mod(frame, BLOCK_READ) + 1;



%     im = rgb2gray(rgb_im);
% imshow(im);


FOV_DEG = 50;

% size (x,n) if n==1, return num of rows, if n==2, return num of column 
dpp = FOV_DEG / size(raw_image, 2);

% image size is 240(Y Row)*416(X Column)*3
IMAGE_VTRANS_Y_RANGE = 75:240; % Row
IMAGE_ODO_X_RANGE = 100:400; % Column

% vtrans 
% sub_image = raw_image(10:150, 100:400);
% sub_image = raw_image(IMAGE_VTRANS_Y_RANGE, IMAGE_ODO_X_RANGE,:);  % include RGB
sub_image = raw_image(IMAGE_VTRANS_Y_RANGE, IMAGE_ODO_X_RANGE);  % not inlcude RGB

% sum(x) sum of every column
% sum(x,2) sum of every row
% sum(x(:)) sum of matrix
image_x_sums = sum(sub_image);
avint = sum(image_x_sums) / size(image_x_sums, 2);
% image_x_sums = image_x_sums/avint;
