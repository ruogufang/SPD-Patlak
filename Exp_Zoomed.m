% Experiment: Roomed Brain Region Images
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

x0=101; y0=60; w0 = 320; h0=380; %P17 P11 P15
x0=101; y0=100; w0 = 320; h0=400; % P14

im = im(y0:y0+h0-1,x0:x0+w0-1);
imnoise = imnoise(y0:y0+h0-1,x0:x0+w0-1);
imout_bp = imout_bp(y0:y0+h0-1,x0:x0+w0-1);

x1=11; x2=110; y1=101; y2=200;
I=im(y1:y2,x1:x2);
I=[I imnoise(y1:y2,x1:x2)];
I=[I imout_bp(y1:y2,x1:x2)];
I=imresize(I,3,'nearest');

ctshow(I,[],[0 5]);
set(gca,'FontSize',20);
