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
engine.flow.M    = 0.78;        % Cruise Mach
engine.flow.h    = 10668;       % Cruise altitude     [m]

engine.air.gamma = 1.4;         % Air
engine.air.cp    = 1000;        % Air specific heat

engine.gas.gamma = 1.33;        % Exhausted gases
engine.gas.cp    = 1150;        % Exhausted gases specific heat

% Pressure
P0 = engine.flow.P;
P0_tot = 35635.6;
P2 = 34922.9;
P21 = 48892;
P25 = 83116.5;
P3 = 1038956.3;

% Temperature ideal
T0 = engine.flow.T;
T0_tot = 245.4;
T2 = 245.4;

% Temperature ideal
T21_id = 270.2;
T25_id = 317.6;
T3_id = 661.6;

% Temperature real
T21_re = 272.9;
T25_re = 321.5;
T3_re = 691.2;

% Entropy function
s = @(P,T) 1000 + engine.air.cp * log(T./engine.flow.T) - engine.flow.R * log(P./engine.flow.P);

P_vect = [P0_tot,P2,P21,P25,P3];
T_vect_id = [T0_tot,T2,T21_id,T25_id,T3_id];
T_vect_re = [T0_tot,T2,T21_re,T25_re,T3_re];

s_vect_id = s(P_vect,T_vect_id);
s_vect_re = s(P_vect,T_vect_re);

figure('Name','T-s diagram','NumberTitle','off')
hold on
grid on
box on

T_dom = linspace(engine.flow.T,engine.C.Texit);

% References for pressure
plot(s(P0,T_dom),T_dom,':k','LineWidth',1)
plot(s(P0_tot,T_dom),T_dom,':k','LineWidth',1)
plot(s(P2,T_dom),T_dom,':k','LineWidth',1)
plot(s(P21,T_dom),T_dom,':k','LineWidth',1)
plot(s(P25,T_dom),T_dom,':k','LineWidth',1)
plot(s(P3,T_dom),T_dom,':k','LineWidth',1)

% Initial point
scatter(s_vect_id,T_vect_id,'r','filled')
scatter(s_vect_re(3:end),T_vect_re(3:end),'b','filled')

% Axis
xlim([800,1500])
xlabel('$\mathbf{s} \ \left[\frac{J}{Kg \cdot K}\right]$','Interpreter','latex')
ylabel('$\mathbf{T} \ \left[K\right]$','Interpreter','latex')
title(['T-s diagram of ',engine.name])