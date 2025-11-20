function [P,T,T_id] = compressor(P_old,T_old,gamma,beta,eta)
% This function computes pressure after a compressor work application on 
% the fluid

% INPUT: -> P_old = previous stage pressure    [Pa]
%        -> T_old = previous stage temperature [K]
%        -> gamma = cp/cv gas ratio            [-] 
%        -> eta = isentropic efficiency        [-]
%        -> beta = pressure ratio              [-]
% 
% OUTPUT: -> P = current stage pressure          [Pa]
%         -> T_id = current stage ideal pressure [K]

P = P_old * beta;

T_id = T_old * (P_old / P)^((1 - gamma) / gamma);

T = T_old + (T_id - T_old) / eta;


