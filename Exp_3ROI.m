% Experiment: Show BBBP maps with 3 ROIs and compute metrics

%   Ruogu Fang 4/5/2013
%   Advanced Multimedia Processing (AMP) Lab
%   Department of Electrical and Computer Engineering
%   Cornell University

% Initialization
clear; close all; clc;

% Set paths
addpath(genpath('Utilities')); % Add utilities folder to path
addpath('Data'); % Add data folder to path
load('P15_15mA'); % Load PCT maps

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x0=101; y0=60; w0 = 320; h0=380;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
im = im(y0:y0+h0-1,x0:x0+w0-1);
im_noise = imnoise(y0:y0+h0-1,x0:x0+w0-1);
imout_bp = imout_bp(y0:y0+h0-1,x0:x0+w0-1);
Mask = Mask(y0:y0+h0-1,x0:x0+w0-1);

x1=141; y1=121; w1=50; h1=50;
x2=41; y2=171; w2=50; h2=50;
x3=111; y3=271; w3=50; h3=50;
r = 3; % enlarge ratio

im_corner = im(y2:y2+h2-1,x2:x2+w2-1);
im_corner = imresize(im_corner,r,'nearest');
im(end-r*h2+1:end,end-r*w2+1:end)=im_corner;

im_noise_corner = im_noise(y2:y2+h2-1,x2:x2+w2-1);
im_noise_corner = imresize(im_noise_corner,r,'nearest');
im_noise(end-r*h2+1:end,end-r*w2+1:end)=im_noise_corner;

imout_corner = imout_bp(y2:y2+h2-1,x2:x2+w2-1);
imout_corner = imresize(imout_corner,r,'nearest');
imout_bp(end-r*h2+1:end,end-r*w2+1:end)=imout_corner;

I = [im im_noise imout_bp];

ctshow(I,[],[0 5]);
% 3 ROIs rectangle
rectangle('Position',[x1 y1 w1 h1],'EdgeColor','w','LineWidth',2);
rectangle('Position',[x2 y2 w2 h2],'EdgeColor','w','LineWidth',2);
rectangle('Position',[x3 y3 w3 h3],'EdgeColor','w','LineWidth',2);
rectangle('Position',[x1+w0 y1 w1 h1],'EdgeColor','w','LineWidth',2);
rectangle('Position',[x2+w0 y2 w2 h2],'EdgeColor','w','LineWidth',2);
rectangle('Position',[x3+w0 y3 w3 h3],'EdgeColor','w','LineWidth',2);
rectangle('Position',[x1+2*w0 y1 w1 h1],'EdgeColor','w','LineWidth',2);
rectangle('Position',[x2+2*w0 y2 w2 h2],'EdgeColor','w','LineWidth',2);
rectangle('Position',[x3+2*w0 y3 w3 h3],'EdgeColor','w','LineWidth',2);
rectangle('Position',[size(im,2)-r*w2+1 size(im,1)-r*h2+1 r*w2 r*h2],'EdgeColor','w','LineWidth',1);
rectangle('Position',[size(im,2)-r*w2+1+w0 size(im,1)-r*h2+1 r*w2 r*h2],'EdgeColor','w','LineWidth',1);
rectangle('Position',[size(im,2)-r*w2+1+2*w0 size(im,1)-r*h2+1 r*w2 r*h2],'EdgeColor','w','LineWidth',1);
text(x1,y1-15,'ROI1','FontSize',20,'Color','w');
text(x2,y2-15,'ROI2','FontSize',20,'Color','w');
text(x3,y3-15,'ROI3','FontSize',20,'Color','w');

% Whole Brain metrics
% LSNR
lsnr_TSVD = pct_lsnr(im_noise);
lsnr_bp = pct_lsnr(imout_bp);

% RMSE
rmse_TSVD = pct_rmse(im_noise,im);
rmse_bp = pct_rmse(imout_bp,im);

% SSIM
K = [0.01 0.03];
window = fspecial('gaussian', 11, 1.5);
L = max(im(:))-min(im(:));
ssim_TSVD = pct_ssim(im,im_noise,K,window,L);
ssim_bp = pct_ssim(im,imout_bp,K,window,L);

% ROIs metrics
x=x1;y=y1;w=w1;h=h1; % ROI1

im_ROI1 = im(y:y+h-1,x:x+w-1);
im_noise_ROI1 =im_noise(y:y+h-1,x:x+w-1);
imout_ROI1=imout_bp(y:y+h-1,x:x+w-1);

% LSNR
lsnr_TSVD1 = pct_lsnr(im_noise_ROI1);
lsnr_bp1 = pct_lsnr(imout_ROI1);

% RMSE
rmse_TSVD1 = pct_rmse(im_noise_ROI1,im_ROI1);
rmse_bp1 = pct_rmse(imout_ROI1,im_ROI1);

% SSIM
K = [0.01 0.03];
window = fspecial('gaussian', 11, 1.5);
L = max(im(:))-min(im(:));
ssim_TSVD1 = pct_ssim(im_ROI1,im_noise_ROI1,K,window,L);
ssim_bp1 = pct_ssim(im_ROI1,imout_ROI1,K,window,L);

x=x2;y=y2;w=w2;h=h2; % ROI2

im_ROI2 = im(y:y+h-1,x:x+w-1);
im_noise_ROI2 =im_noise(y:y+h-1,x:x+w-1);
imout_ROI2=imout_bp(y:y+h-1,x:x+w-1);

% LSNR
lsnr_TSVD2 = pct_lsnr(im_noise_ROI2);
lsnr_bp2 = pct_lsnr(imout_ROI2);

% RMSE
rmse_TSVD2 = pct_rmse(im_noise_ROI2,im_ROI2);
rmse_bp2 = pct_rmse(imout_ROI2,im_ROI2);

% SSIM
K = [0.01 0.03];
window = fspecial('gaussian', 11, 1.5);
L = max(im(:))-min(im(:));
ssim_TSVD2 = pct_ssim(im_ROI2,im_noise_ROI2,K,window,L);
ssim_bp2 = pct_ssim(im_ROI2,imout_ROI2,K,window,L);


x=x3;y=y3;w=w3;h=h3; % ROI3

im_ROI3 = im(y:y+h-1,x:x+w-1);
im_noise_ROI3 =im_noise(y:y+h-1,x:x+w-1);
imout_ROI3=imout_bp(y:y+h-1,x:x+w-1);

% LSNR
lsnr_TSVD3 = pct_lsnr(im_noise_ROI3);
lsnr_bp3 = pct_lsnr(imout_ROI3);

% RMSE
rmse_TSVD3 = pct_rmse(im_noise_ROI3,im_ROI3);
rmse_bp3 = pct_rmse(imout_ROI3,im_ROI3);

% SSIM
K = [0.01 0.03];
window = fspecial('gaussian', 11, 1.5);
L = max(im(:))-min(im(:));
ssim_TSVD3 = pct_ssim(im_ROI3,im_noise_ROI3,K,window,L);
ssim_bp3 = pct_ssim(im_ROI3,imout_ROI3,K,window,L);

metric = [lsnr_TSVD1 rmse_TSVD1 ssim_TSVD1 lsnr_TSVD2 rmse_TSVD2 ssim_TSVD2 lsnr_TSVD3 rmse_TSVD3 ssim_TSVD3 lsnr_TSVD rmse_TSVD ssim_TSVD;
    lsnr_bp1 rmse_bp1 ssim_bp1 lsnr_bp2 rmse_bp2 ssim_bp2 lsnr_bp3 rmse_bp3 ssim_bp3 lsnr_bp rmse_bp ssim_bp];
