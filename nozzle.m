function [P,T_id] = nozzle(P_old,T_old,T,gamma,eta)
% This function computes pressure after a nozzle expansion of the fluid

% INPUT: -> P_old = previous stage pressure    [Pa]
%        -> T_old = previous stage temperature [K]
%        -> T = current stage temperature      [K]
%        -> gamma = cp/cv gas ratio            [-] 
%        -> eta = isentropic efficiency        [-]
% 
% OUTPUT: -> P = current stage pressure          [Pa]
%         -> T_id = current stage ideal pressure [K]

T_id = T_old - (T_old - T) / eta;

P = P_old * (T_old/T_id)^(gamma/(1-gamma));