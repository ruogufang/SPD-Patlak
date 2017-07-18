function params = bplasso_map_sd(params)
%BPLASSO_MAP_SD denoising of 2-D signals of permeability map using Maximum
%A Posterior. Steepest descent optimiation is used.
%
% Optimization of Patlak model with high-dose induced prior using steepest
% descent
%   Ruogu Fang 4/5/2013
%

tic;
% parse input arguments %
x = reshape(params.x,[],1); % vecorize x
hdi = reshape(params.hdi,[],1);
beta = params.beta;
YMAP = params.YMAP; % Y = T/AIF is dependent variables of patlak model
X = params.X; % X = interal(AIF)/AIF is the independent variables of patlak model
PRE_bbbp = params.PRE_bbbp; %First frame in BBBP calculation
POST_bbbp = params.POST_bbbp; %Last frame in BBBP calculation
POST_bbbp = min(POST_bbbp,size(YMAP,1)); %Last frame for BBBP cannot exceed the actual last frame

% Truncate to delayed stage
X = X(PRE_bbbp:POST_bbbp);
YMAP = YMAP(PRE_bbbp:POST_bbbp,:,:);
[T,H,W] = size(YMAP);

% Convert the independent variables from mL/100g/min to mL/g/s
X = X / (60 * 100);

% Solve minimize J = beta*||BP-hdi(BP)||_2^2+||Y-X*diag(BP)||_2^2

% Step 1: Data preprocessing
% Sparse version of A and b. Case: p=2
b = sparse([reshape(YMAP,[],1);beta.*hdi]); % Vectorize Y
% Sparse verion of A
idx_y = (1:(T+1)*(H*W))';
idx_x = [reshape(repmat(1:H*W,T,1),[],1);(1:H*W)'];
s = [reshape(repmat(X,1,H*W),[],1);beta.*ones(H*W,1)];
A = sparse(idx_y,idx_x,s);

% Step 2: Steepest descent optimization
e = sparse(A'*(b-A*x));
step=(e'*e)/((A*e)'*(A*e));
x_new = x + step*e;
params.x = reshape(x_new,size(params.x));

% % Sparse version of A and b. Case: 1<p<2
% b = sparse(reshape(YMAP,[],1)); % Vectorize Y
% % Sparse verion of A
% idx_y = (1:T*(H*W))';
% idx_x = reshape(repmat(1:H*W,T,1),[],1);
% s = reshape(repmat(X,1,H*W),[],1);
% A = sparse(idx_y,idx_x,s);

% % Step 2: Steepest descent optimization
% e = sparse(A'*(b-A*x));
% step=(e'*e)/((A*e)'*(A*e));
% dR = p*sign(x-hdi).*abs(x-hdi).^(p-1);
% x_new = x + step*e - beta*dR;
% params.x = reshape(x_new,size(params.x));


% % Non-sparse version of A
% b = sparse(reshape(YMAP,[],1)); % Vectorize Y
% A = sparse(H*W*(T+1),H*W); % Diagnize X
% for i = 1:H*W
%     A((i-1)*T+(1:T),i) = X;
% end
% A(H*W*T+1:end,:) = beta.*eye(H*W);


t=toc;
fprintf('Optimization time:%.2f\n',t);

J_new = norm(b-A*x_new,2)^2+beta*norm(x_new-x,2)^2;
params.J = [params.J J_new];
