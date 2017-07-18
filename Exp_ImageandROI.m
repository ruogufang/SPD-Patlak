% Experiment: Plot BBBP map with ROI zoomed in the right bottom corner
%
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

y1 = 161; x1 = 41; w = 70; h = 70; % ROI
x0=91; y0=60; w0 = 330; h0=380;

I = im;
I = I(y0:y0+h0-1,x0:x0+w0-1);
ROI = I(y1:y1+h-1,x1:x1+w-1);
ROI_large = imresize(ROI,2,'nearest');
im_roi = I;
im_roi(end-2*h+1:end,end-2*w+1:end)=ROI_large;


I = imnoise;
I = I(y0:y0+h0-1,x0:x0+w0-1);
ROI = I(y1:y1+h-1,x1:x1+w-1);
ROI_large = imresize(ROI,2,'nearest');
imnoise_roi = I;
imnoise_roi(end-2*h+1:end,end-2*w+1:end)=ROI_large;

I = imout_bp;
I = I(y0:y0+h0-1,x0:x0+w0-1);
ROI = I(y1:y1+h-1,x1:x1+w-1);
ROI_large = imresize(ROI,2,'nearest');
imout_roi = I;
imout_roi(end-2*h+1:end,end-2*w+1:end)=ROI_large;

I = [im_roi imnoise_roi imout_roi];

ctshow(I,[],[0 5]);
hold on;
rectangle('Position',[x1 y1 w h],'EdgeColor','y','LineWidth',2);
rectangle('Position',[w0-2*w+1 h0-2*h+1 2*w 2*h],'EdgeColor','w','LineWidth',1);
rectangle('Position',[x1+w0 y1 w h],'EdgeColor','y','LineWidth',2);
rectangle('Position',[2*w0-2*w+1 h0-2*h+1 2*w 2*h],'EdgeColor','w','LineWidth',1);
rectangle('Position',[x1+2*w0 y1 w h],'EdgeColor','y','LineWidth',2);
rectangle('Position',[3*w0-2*w+1 h0-2*h+1 2*w 2*h],'EdgeColor','w','LineWidth',1);



