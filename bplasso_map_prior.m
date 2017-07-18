function [params] = bplasso_map_prior(params)
%BPLASSO_MAP_PRIOR computes the sparsity prior for the BBBP enhancement
%algorithm
%
%   Ruogu Fang 4/5/2013
%

tic;
% parse input arguments %
x = params.x;
p = ndims(x);
xdic = params.xdic;
blocksize = params.blocksize;
searchwindow = params.searchwindow;
radius = floor(searchwindow/2);
sigma = params.sigma; % estimated noise standard deviation
ntrain = size(xdic,3); % number of training images
trainnum = params.trainnum; % number of trainining
expand = 10; % expand the search radius if training data is empty

% blocksize %
if (numel(blocksize)==1)
    blocksize = ones(1,2)*blocksize;
end

% maxval %
if (isfield(params,'maxval'))
    maxval = params.maxval;
else
    maxval = 1;
end

% stepsize %
if (isfield(params,'stepsize'))
    stepsize = params.stepsize;
    if (numel(stepsize)==1)
        stepsize = ones(1,2)*stepsize;
    end
else
    stepsize = ones(1,2);
end
if (any(stepsize<1))
    error('Invalid step size.');
end

% mixture %
if (isfield(params,'mixture'))
    mixture = params.mixture;
else
    mixture = maxval/(10*sigma);
end


% denoise the signal %

k = 0; % counter

% the denoised signal
y = zeros(size(x));
blocknum = prod(floor((size(x)-blocksize)./stepsize) + 1);

for j = 1:stepsize(2):size(y,2)-blocksize(2)+1
    k = k+1;
    
    % the current batch of blocks
    blocks = im2colstep(x(:,j:j+blocksize(2)-1),blocksize,stepsize);
    
    % remove DC
    [blocks, dc] = remove_dc(blocks,'columns');
    
    % denoise the blocks using Lasso
    cleanblocks = zeros(size(blocks));
    if any(blocks(:))
        %%% Construct adaptive dictionary %%%
        for i = 1 : size(blocks,2)
            if any(blocks(:,i))
                D = [];
                for tt = 1 : ntrain
                    ids = cell(p,1);
                    
                    % find the location of the block of interest in the image
                    y_coor = (i-1)*stepsize(1)+round(blocksize(1)/2);
                    x_coor = j-1+round(blocksize(2)/2);
                    xdicsearch = [];
                    radius_curr=radius;
                    
                    while sum(xdicsearch~=0)<size(blocks,1) & radius_curr <= min(size(xdic,1),size(xdic,2))
                        % deal with boundary conditions
                        ymin = max(y_coor-radius_curr,1);
                        ymax = min(y_coor+radius_curr,size(xdic,1));
                        xmin = max(x_coor-radius_curr,1);
                        xmax = min(x_coor+radius_curr,size(xdic,2));
                        xdicsearch = xdic(ymin:ymax,xmin:xmax,tt);
                        radius_curr = radius_curr*expand;
                    end
                    
                    trainnum_curr = round(numel(xdicsearch)/sum(sum(xdicsearch==0))*trainnum);
                    [ids{:}] = reggrid(size(xdicsearch)-blocksize+1, trainnum_curr, 'eqdist');
                    d = sampgrid(xdicsearch,blocksize,ids{:});
                    zeroid = sum(d)==0;
                    d(:,zeroid)=[];
                    if size(d,2)>trainnum
                        id = randperm(size(d,2));
                        d=d(:,id(1:trainnum));
                    end
                    D = [D d];
                end
                
                D = normcols(D);
                
                % compute G %
                G = D'*D;
                
                % verify dictionary normalization %
                
                if (isempty(G))
                    atomnorms = sum(D.*D);
                else
                    atomnorms = diag(G);
                end
                if (any(abs(atomnorms-1) > 1e-2))
                    error('Dictionary columns must be normalized to unit length');
                end
                
                D = remove_dc(D,'columns');
                
                gamma = mexLasso(blocks(:,i),D,params);
                if ~isempty(gamma)
                    cleanblocks(:,i) = D*gamma;
                end
            end
        end
        cleanblocks = add_dc(cleanblocks, dc, 'columns');
        blocks = cleanblocks;
    end
    
    cleanim = col2imstep(cleanblocks,[size(y,1) blocksize(2)],blocksize,stepsize);
    y(:,j:j+blocksize(2)-1) = y(:,j:j+blocksize(2)-1) + cleanim;
    
    printf('%d/%d blocks processed.\n',size(blocks,2)*k, blocknum);
end

% average the denoised and noisy signals
cnt = countcover(size(x),blocksize,stepsize);
y = (y + mixture*x)./(cnt + mixture);
y(y<0)=0;
params.hdi = y;

t_test = toc;
printf('Lasso denoising time:%.2f sec\n',t_test);

