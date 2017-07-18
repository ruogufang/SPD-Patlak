% Experiment: Vertical profile
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

x = 320; x1 = 101; x2 = 420; y1 = -0.1; y2 = 3.5;

ref = im(:,x);
patlak = imnoise(:,x);
hdi = imout_bp(:,x);

% Compare groundtruth and Patlak
figure;
plot(ref,'k','LineWidth',3);
hold on;
plot(patlak,'b--','LineWidth',3);
xlabel('Pixel Position','FontSize',20);
ylabel('Intensity (HU)','FontSize',20);
axis([x1 x2 y1 y2]);
set(gca,'FontSize',20);
h_legend=legend('high-dose (Patlak)','low-dose (Patlak)');
set(h_legend,'FontSize',20,'Box','off','Location','NorthWest');

% Show thumbnail of the brain
y0 = 61; x0 = 101; w0 = 320; h0 = 380;
I = im(y0:y0+h0-1,x0:x0+w0-1);
% I(y1:y2,x0-1:x0+1)=10;
axes('position',[0.6,0.7,0.2,0.2]);
ctshow(I,[],[0 5]);hold on;
line([x-x0 x-x0],[1 h0],'Color','w','LineStyle','-','LineWidth',1);

% Compare groundtruth and shd-Patlak
figure;
plot(ref,'k','LineWidth',3);
hold on;
plot(hdi,'r--','LineWidth',3);
xlabel('Pixel Position','FontSize',20);
ylabel('Intensity (HU)','FontSize',20);
axis([x1 x2 y1 y2]);
set(gca,'FontSize',20);
h_legend=legend('high-dose (Patlak)','low-dose (shd-Patlak)');
set(h_legend,'FontSize',20,'Box','off','Location','NorthWest');

% Show thumbnail of the brain
y0 = 61; x0 = 101; w0 = 320; h0 = 380;
I = im(y0:y0+h0-1,x0:x0+w0-1);
% I(y1:y2,x0-1:x0+1)=10;
axes('position',[0.6,0.7,0.2,0.2]);
ctshow(I,[],[0 5]);hold on;
line([x-x0 x-x0],[1 h0],'Color','w','LineStyle','-','LineWidth',1);

% Lin's concordant coefficients
[p1 ci1] = pct_lincon(patlak,ref)
[p2 ci2] = pct_lincon(hdi,ref)
