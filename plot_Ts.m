clear
close
clc

engine.name      = 'LEAP-1A';

engine.I.beta    = 0.98;        % Pressure ratio @ Inlet

engine.F.beta    = 1.4;         % Pressure ratio @ Fan
engine.F.eta     = 0.9;         % Isentropic efficiency @ Fan

engine.LPC.beta  = 1.7;         % Pressure ratio @ Low-Pressure Compressor
engine.LPC.eta   = 0.92;        % Isentropic efficiency @ Low-Pressure Compressor

engine.HPC.beta  = 12.5;        % Pressure ratio @ High-Pressure Compressor
engine.HPC.eta   = 0.92;        % Isentropic efficiency @ High-Pressure Compressor

engine.C.beta    = 0.96;        % Pressure ratio @ Combustor
engine.C.eta     = 0.995;       % Combustion efficiency @ Combustor 
engine.C.Qfuel   = 43e6;        % Fuel Low Heating Value  [J]
engine.C.Texit   = 1400;        % Temperature @ Combustor [K]

engine.N.eta     = 0.98;        % Isentropic efficiency @ Nozzle

engine.eta       = 0.99;        % Mechanical efficiency

engine.flow.BPR  = 12;          % ByPass Ratio
engine.flow.mass = 173;         % Massflow            [kg/s]
engine.flow.T    = 218.8;       % Ambient Temperature [K]
engine.flow.P    = 23842;       % Ambient Pressure    [Pa]
engine.flow.R    = 287;         % Gas constant

engine.air.gamma = 1.4;         % Air
engine.air.cp    = 1000;        % Air specific heat

engine.gas.gamma = 1.33;        % Exhausted gases
engine.gas.cp    = 1150;        % Exhausted gases specific heat

figure('Name','T-s diagram','NumberTitle','off')
hold on
grid on
box on

% Axis
xlabel('$\mathbf{s} \ \left[\frac{J}{Kg \cdot K}\right]$','Interpreter','latex')
ylabel('$\mathbf{T} \ \left[K\right]$','Interpreter','latex')
title(['T-s diagram of ',engine.name])