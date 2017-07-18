% Exp: Correlation and Bland?Altman plot

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

% % Select 20 ROIs
% ctshow(im,Mask,[0 5]);
% [x,y]=ginput(20);
% save('data/20ROI_15','x','y');

load('20ROI_15');

N = length(x);
r = 1;
xmax = 2.5;
ytext = 2;
x1 = 0.35;
x2 = 0.6;

% Show ROIs
ctshow(im,Mask,[0 5]);
hold on;
for i = 1 : N
    rectangle('Position',[x(i)-r,y(i)-r,2*r+1,2*r+1],'EdgeColor','w');
end
hold off;

im_roi = zeros(N,1);
imnoise_roi = zeros(N,1);
imout_roi = zeros(N,1);

for i=1:N
    im_roi(i) = mean(mean(im(y(i)-r:y(i)+r,x(i)-r:x(i)+r)));
    imnoise_roi(i) = mean(mean(imnoise(y(i)-r:y(i)+r,x(i)-r:x(i)+r)));
    imout_roi(i) = mean(mean(imout_bp(y(i)-r:y(i)+r,x(i)-r:x(i)+r)));
end

% Correlation Plot
% Patlak
h = im_roi;
l = imnoise_roi;

[P] = polyfit(h,l,1);
R = corr(h,l);
X = 0:0.01:xmax;
Y = polyval(P,X);
figure;plot(h,l,'ob','LineWidth',2,'MarkerSize',10);
hold on; 
plot(X,Y,'b-','LineWidth',3);
xlabel('high-dose (BBBP(mL/100g/min))','FontSize',20);
ylabel('low-dose Patlak BBBP(mL/100g/min)','FontSize',20);
set(gca,'FontSize',20);
eq = sprintf('Y=%.4fX+%.4f\nCorrelation=%.4f',P(1),P(2),R);
text(0.1,ytext,eq,'FontSize',20);
% axis([0 1.5 -0.1 1.5]);

%% Bland Altman plot
m = mean(h-l);
s = 1.96*std(h-l);
figure;
plot((h+l)/2,h-l,'ob','LineWidth',2,'MarkerSize',10);
xlabel('Mean BBBP(mL/100g/min)','FontSize',20);
ylabel('Difference BBBP(mL/100g/min)','FontSize',20);
set(gca,'FontSize',20);
set(gca,'ylim',[-.5 .5]);
line([0 xmax],[m m],'LineWidth',3);
line([0 xmax],[s s],'LineWidth',1,'LineStyle','--');
line([0 xmax],[-s -s],'LineWidth',1,'LineStyle','--');
text(xmax-x1,m+0.05,'Mean','FontSize',20);
text(xmax-x1,m-0.05,sprintf('%.2f',m),'FontSize',20);
text(xmax-x2,s+0.03,'+1.96 SD','FontSize',20);
text(xmax-x1,s-0.03,sprintf('%.2f',s),'FontSize',20);
text(xmax-x2,-s+0.03,'-1.96 SD','FontSize',20);
text(xmax-x1,-s-0.03,sprintf('-%.2f',s),'FontSize',20);


%% shd-Patlak
l = imout_roi;
[P] = polyfit(h,l,1);
R = corr(h,l);
X = 0:0.01:xmax;
Y = polyval(P,X);
figure;plot(h,l,'or','LineWidth',2,'MarkerSize',10);
hold on; 
plot(X,Y,'r-','LineWidth',3);
xlabel('high-dose (BBBP(mL/100g/min))','FontSize',20);
ylabel('low-dose shd-Patlak BBBP(mL/100g/min)','FontSize',20);
set(gca,'FontSize',20);
eq = sprintf('Y=%.4fX+%.4f\nCorrelation=%.4f',P(1),P(2),R);
text(0.1,ytext,eq,'FontSize',20);
% axis([0 1.5 -0.1 1.5]);

% Bland Altman plot
%% Bland Altman plot
m = mean(h-l);
s = 1.96*std(h-l);
figure;
plot((h+l)/2,h-l,'or','LineWidth',2,'MarkerSize',10);
xlabel('Mean BBBP(mL/100g/min)','FontSize',20);
ylabel('Difference BBBP(mL/100g/min)','FontSize',20);
set(gca,'FontSize',20);
axis([0 xmax -0.5 0.5]);
line([0 xmax],[m m],'LineWidth',3,'Color','r');
line([0 xmax],[s s],'LineWidth',1,'LineStyle','--','Color','r');
line([0 xmax],[-s -s],'LineWidth',1,'LineStyle','--','Color','r');
text(xmax-x1,m+0.05,'Mean','FontSize',20);
text(xmax-x1,m-0.05,sprintf('%.2f',m),'FontSize',20);
text(xmax-x2,s+0.03,'+1.96 SD','FontSize',20);
text(xmax-x1,s-0.03,sprintf('%.2f',s),'FontSize',20);
text(xmax-x2,-s+0.03,'-1.96 SD','FontSize',20);
text(xmax-x1,-s-0.03,sprintf('-%.2f',s),'FontSize',20);


