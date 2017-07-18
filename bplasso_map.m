function [y,params] = bplasso_map(params)
%BPLASSO_MAP optimizes 2-D signals of permeability map using Maximum A Posterior. Steepest descent optimiation is used.
% Optimization of Patlak model with high-dose induced prior using steepest
% descent
%
%   Ruogu Fang 4/5/2013

for i = 1 : params.round
    params = bplasso_map_prior(params);
    params = bplasso_map_sd(params);
end

y = params.x;


