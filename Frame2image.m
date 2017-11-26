% Only for test VideoReader

fileName = 'C:\RatSLAM-Dataset\lab_rotation.mp4';

v = VideoReader (fileName);

frames= read(v,[1 100]);
mov = immovie(frames);
% i=1;
% im = mov(20).cdata;
% imshow(im);
for i=1:100
    im = rgb2gray(mov(i).cdata);
    i=i+1;
    imshow(im);
end