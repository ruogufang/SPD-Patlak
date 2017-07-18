% function Main_shdPatlak
%Main_shdPatlak is the main function of Sparsity High-dose Induced Patlak
%Model
%
%   Ruogu Fang 4/5/2013
%   Advanced Multimedia Processing (AMP) Lab
%   Department of Electrical and Computer Engineering
%   Cornell University
%
%  Main_shdPatlak reads a PCT data, adds random white noise and denoises it
%  using online dictionary learning and Lasso. The input and output RMSE
%  are compared, and the trained dictionary is displayed.
%
% Reference:
%
% Ruogu Fang, Kolbeinn Karlsson, Tsuhan Chen, Pina C. Sanelli. Improving
% Low-Dose Blood-Brain Barrier Permeability Quantification Using Sparse
% High-Dose Induced Prior for Patlak Model. Medical Image Analysis, Volume
% 18, Issue 6, Pages 866-880, 2014.
%
% Please cite the above papers if you use code in this SPD package.


% Initialization
clear; close all; clc;
warning('off');

% Set paths
addpath(genpath('Utilities')); % Add utilities folder to path
addpath('Data'); % Add data folder to path

%% =================================
% Parameters for you to change
mA = 15; % Low-dose X-ray tube current level

x0 = 1; y0 = 1; w = 512; h = 512; % Whole brain region
% x0 = 200; y0 = 200; w = 80; h = 80; % RACA
% x0 = 155; y0 = 170; w = 60; h = 170; % RMCA
% ==================================

% Load CTP data
load('IRB_015.mat');
load acf;
% Data format:
%   V: CTP data [T x X x Y] AIFx, AIFy, VOFx, VOFy: aif and vof
%   coordinations PRE: Pre-enhancement cutoff (first frame included in
%   calc's) POST: Post-enhancement cutoff (last frame included in calc's)

% Noisy Level
mA0 = 190;
sigma = pct_mA2sigma(mA,mA0);

% Remove negative values
V(V<0) = 0;

% Add specral noise
B = squeeze(mean(V(1:10,:,:),1));
Mask = pct_brainMask(B,0,120);

% Add Gaussian noise to simulate low-dose
Vn = pct_noise(permute(V,[2 3 1]),acf,sigma,'g',Mask);
Vn = permute(Vn,[3 1 2]);

% PCT preprocess
[C0,AIF0] = pct_preprocess(V, PRE, POST, AIFx,AIFy,VOFx,VOFy); % noiseless data
[C,AIF1] = pct_preprocess(Vn, PRE, POST, AIFx,AIFy,VOFx,VOFy); % noisy data

% Crop data to Region of Interest
C0 = C0(:,y0:y0+h-1,x0:x0+w-1);
C = C(:,y0:y0+h-1,x0:x0+w-1);
Mask = Mask(y0:y0+h-1,x0:x0+w-1);

% Find the minimum bounding box
bb = pct_minBoundingBox(Mask);
C0 = C0(:,bb(1,1):bb(1,2),bb(2,1):bb(2,3));
C = C(:,bb(1,1):bb(1,2),bb(2,1):bb(2,3));
Mask = Mask(bb(1,1):bb(1,2),bb(2,1):bb(2,3));

%% Method 1: cTSVD Unnoisy
[BBBP0_TSVD] = pct_bbbmap(C0, AIF0, Mask);

% Noisy
[BBBP_TSVD, X, YMAP] = pct_bbbmap(C, AIF1, Mask);

clear AIF AIF0 AIF1 AIFx AIFy C C0 POST PRE R V VOF VOFx VOFy Vn acf mask mask0

%% Method 2: Sparse PCT

% set parameters %
im = BBBP0_TSVD;
imnoise = BBBP_TSVD;
params.x = imnoise;
params.K = 256; % dictionary size
params.iter = 20;  % let us see what happens after 20 iterations.
params.sigma = sigma;
params.maxval = max(imnoise(:));
params.trainnum = 20;
params.verbose = false;
params.X = X;
params.YMAP = YMAP;
params.mixture = 0.1; % weight of input signal
params.blocksize = 5;
overlap = 3; % patch overlap
params.stepsize = params.blocksize - overlap;
params.searchwindow = 11; % windowsize for the search
params.PRE_bbbp = 30; %First frame in BBBP calculation
params.POST_bbbp = 90; %Last frame in BBBP calculation
params.round = 1; % Number of iterations in the solver
params.mode = 2;
params.lambda = 2; % lambda (L1 parameter)
% params.lambda2 = 0.1; % lambda2 (L2 parameter)
params.beta = 1; % mu (Hdi prior weight)
params.J = []; % energy function

% Training data of 2 subjects
ntrain = 2;
imtrain = zeros([size(im),ntrain]);
load BBBP_001.mat
BBBP = BBBP(y0:y0+h-1,x0:x0+w-1);
BBBP = BBBP(bb(1,1):bb(1,2),bb(2,1):bb(2,3));
imtrain(:,:,1) = BBBP;
load BBBP_002.mat
BBBP = BBBP(y0:y0+h-1,x0:x0+w-1);
BBBP = BBBP(bb(1,1):bb(1,2),bb(2,1):bb(2,3));
imtrain(:,:,2) = BBBP;
params.xdic = double(imtrain);

% sparsity high-dose induced Patlak Model
tid_bp = tic;
disp('Performing BBBP Enhancement Using High-dose Induced Prior ...');
[imout_bp, params_new] = bplasso_map(params); % sparse perfuison using MAP
t_bp = toc(tid_bp);

% Filter non brain tissue of the maps
imnoise = BBBP_TSVD;
im = pct_mask(im,Mask);
imnoise = pct_mask(imnoise,Mask);
imout_bp = pct_mask(imout_bp, Mask);

% Show images
cmax = 20;
figure;ctshow(im,Mask,[0 cmax]);
figure;ctshow(imnoise,Mask,[0 cmax]);
figure;ctshow(imout_bp,Mask,[0 cmax]);

% LSNR
lsnr_TSVD = pct_lsnr(imnoise(Mask))
lsnr_bp = pct_lsnr(imout_bp(Mask))

% RMSE
rmse_TSVD = pct_rmse(imnoise(Mask),im(Mask))
rmse_bp = pct_rmse(imout_bp(Mask),im(Mask))

% SSIM
% rectangle
K = [0.01 0.03];
window = fspecial('gaussian', 11, 1.5);
L = max(im(:))-min(im(:));
if Mask(1,1)
    % Mask is a rectangle
    ssim_TSVD = pct_ssim(im,imnoise,K,window,L)
    ssim_bp = pct_ssim(im,imout_bp,K,window,L)
else
    % Find the maximum inscribed rectangle in the mask if Mask is not a
    S = FindLargestSquares(Mask);
    [C,H,W] = FindLargestRectangles(Mask, [0 0 1]);
    [~, pos] = max(C(:));
    [r,c] = ind2sub(size(S), pos);
    ssim_TSVD = pct_ssim(im(r:r+H(r,c)-1,c:c+W(r,c)-1),imnoise(r:r+H(r,c)-1,c:c+W(r,c)-1),K,window,L)
    ssim_bp = pct_ssim(im(r:r+H(r,c)-1,c:c+W(r,c)-1),imout_bp(r:r+H(r,c)-1,c:c+W(r,c)-1),K,window,L)
end

fprintf('BP Denoising time: %.2f\n',t_bp);

save(fullfile('Data',['P15_',num2str(mA),'mA_test.mat']),'im','imnoise','imout_bp','Mask');

% end
