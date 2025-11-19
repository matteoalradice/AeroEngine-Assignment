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
P4 = 997398.0;
P45 = 307949.5;
P5 = 50961.8;
P8 = 27157.3;
P18 = 25464.6;

% Temperature ideal
T21_id = 270.2;
T25_id = 317.6;
T3_id = 661.6;
T45_id = 1045.9;
T5_id = 692;

% Temperature real
T0 = engine.flow.T;
T0_tot = 245.4;
T2 = 245.4;
T21_re = 272.9;
T25_re = 321.5;
T3_re = 691.2;
T4_re = 1400;
T45_re = 1081.3;
T5_re = 731;
T8_re = 627.5;
T18_re = 227.4;

% Entropy function
s0 = 1000;
s = @(P,T) s0 + engine.air.cp * log(T./engine.flow.T) - engine.flow.R * log(P./engine.flow.P);

% State variable vectors
P_vect_id = [NaN,NaN,P21,P25,P3,NaN,P45,P5,NaN,NaN];
P_vect_re = [P0_tot,P2,P21,P25,P3,P4,P45,P5,P8,P18];

T_vect_id = [NaN,NaN,T21_id,T25_id,T3_id,NaN,T45_id,T5_id,NaN,NaN];
T_vect_re = [T0_tot,T2,T21_re,T25_re,T3_re,T4_re,T45_re,T5_re,T8_re,T18_re];

s_vect_id = s(P_vect_id,T_vect_id);
s_vect_re = s(P_vect_re,T_vect_re);

% Domain vector for plots
x = linspace(0,1,100);
T_dom = (T_vect_id - 20)' * (1 - x) + (T_vect_re + 20)' * x;

figure('Name','T-s diagram','NumberTitle','off')
hold on
grid on
box on

% References for pressure
plot(s(P0,linspace(engine.flow.T-100,engine.C.Texit)),linspace(engine.flow.T-100,engine.C.Texit),'--r','LineWidth',1)

for j = 1:length(T_dom(:,1))
    plot(s(P_vect_id(j),T_dom(j,:)),T_dom(j,:),':k','LineWidth',1)
end

% Intermediate points
scatter(s_vect_id,T_vect_id,'r','filled')

% Real thermodynamic transformations
plot(s_vect_re(1:end-2),T_vect_re(1:end-2),'ok-.','MarkerFaceColor','b','MarkerEdgeColor','b')
plot(s_vect_re([2,end]),T_vect_re([2,end]),'ok--','MarkerFaceColor','b','MarkerEdgeColor','b')
plot(s_vect_re([8,end-1]),T_vect_re([8,end-1]),'ok--','MarkerFaceColor','b','MarkerEdgeColor','b')

% Axis
xlim([s0 - 200,2 * s0 + 200])
ylim([0,engine.C.Texit + 100])
xlabel('$\mathbf{s} \ \left[\frac{J}{Kg \cdot K}\right]$','Interpreter','latex')
ylabel('$\mathbf{T} \ \left[K\right]$','Interpreter','latex')
title(['T-s diagram of ',engine.name])