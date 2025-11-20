function [results] = calculator(engine)

% Mass flow
m_core = engine.flow.mass/(engine.flow.BPR + 1);
m_bypass = m_core*engine.flow.BPR;

fprintf('m_core:     %.2f kg/s\n', m_core);
fprintf('m_bypass:     %.2f kg/s\n', m_bypass);

% % % % % % % % % % % % % % Ambient stage % % % % % % % % % % % % % % % % %
% Static quantities
T_amb = engine.flow.T;
fprintf('T_amb   (Static Temp):     %.2f K\n', T_amb);

P_amb = engine.flow.P;
fprintf('P_amb   (Static Press):    %.2f Pa\n', P_amb);

% Total quantities
Tt1 = T_amb * (1 + (engine.air.gamma-1)/2 * engine.flow.M^2);
fprintf('Tt1  (Total Temp 1):    %.2f K\n', Tt1);

Pt1 = P_amb * (Tt1/T_amb)^(engine.air.gamma/(engine.air.gamma-1));
fprintf('Pt1  (Total Press 1):   %.2f Pa\n', Pt1);

% % % % % % % % % % % % % % % Inlet stage % % % % % % % % % % % % % % % % %
Tt2 = Tt1;
fprintf('Tt2  (Total Temp 2):    %.2f K\n', Tt2);

Pt2 = engine.I.eta * Pt1;
fprintf('Pt2  (Total Press 2):   %.2f Pa\n', Pt2);

% % % % % % % % % % % % % % % Fan stage % % % % % % % % % % % % % % % % % %
% Pt21 = engine.F.beta * Pt2; 
% fprintf('Pt21 (Fan Exit Press):  %.2f Pa\n', Pt21);
% 
% Tt21 = Tt2 * (1 + 1/engine.F.eta * ((Pt21/Pt2)^((engine.air.gamma-1)/engine.air.gamma) - 1));
% fprintf('Tt21 (Fan Exit Temp):   %.2f K\n', Tt21);

[Pt21,Tt21,Tt21_id] = compressor(Pt2,Tt2,engine.air.gamma,engine.F.beta,engine.F.eta);

W_F = engine.flow.mass * engine.air.cp * (Tt21 - Tt2);
fprintf('Wfan (Fan Work):        %.2f Watts\n', W_F);

% % % % % % % % % % % % % % Bypass stage % % % % % % % % % % % % % % % % %
Pt13 = Pt21;
fprintf('Pt13 (Bypass Press):    %.2f Pa\n', Pt13);

Tt13 = Tt21;
fprintf('Tt13 (Bypass Temp):     %.2f K\n', Tt13);

% % % % % % % % % % % % % % % LPC stage % % % % % % % % % % % % % % % % % %
% Pt25 = engine.LPC.beta*Pt21;
% Tt25 = Tt21 * (1 + 1/engine.LPC.eta * ((Pt25/Pt21)^((engine.air.gamma-1)/engine.air.gamma) - 1));

[Pt25,Tt25,Tt25_id] = compressor(Pt21,Tt21,engine.air.gamma,engine.LPC.beta,engine.LPC.eta);

m_25 = m_core;

W_LPC = m_25*engine.air.cp*(Tt25 - Tt21);

% % % % % % % % % % % % % % % HPC stage % % % % % % % % % % % % % % % % % %
% Pt3 = engine.HPC.beta*Pt25;
% Tt3 = Tt25 * (1 + 1/engine.HPC.eta * ((P.Pt3/Pt25)^((engine.air.gamma-1)/engine.air.gamma) - 1));
[Pt3,Tt3,Tt3_id] = compressor(Pt25,Tt25,engine.air.gamma,engine.HPC.beta,engine.HPC.eta);

fprintf('Tt3  (Total Temp 3):    %.2f K\n', Tt3);
m_3 = m_25;
W_HPC = m_3 * engine.air.cp * (Tt3 - Tt25);
fprintf('W_HPC (HPC Work):       %.2f Watts\n', W_HPC);

% % % % % % % % % % % % % % Combustor stage % % % % % % % % % % % % % % % %
Pt4 = Pt3 * engine.C.beta;
Tt4 = engine.C.Texit;
m_f = (m_3 * engine.gas.cp * (Tt4 - Tt3))/(engine.C.eta * engine.gas.LHV);

m_4 = m_3 + m_f;


% % % % % % % % % % % % % % % HPT stage % % % % % % % % % % % % % % % % % %
Tt45 = Tt4 - W_HPC/(engine.eta*m_4*engine.gas.cp);

[Pt45,Tt45_id] = turbine(Pt4,Tt4,Tt45,engine.gas.gamma,engine.HPT.eta);

% Tt45_id = Tt4 - (Tt4 - Tt45)/engine.HPT.eta;
% Pt45 = Pt4 * (Tt4/Tt45_id)^(engine.gas.gamma/(1-engine.gas.gamma));

fprintf('Tt45:       %.2f K\n', Tt45);

m_45 = m_4;

% % % % % % % % % % % % % % % LPT stage % % % % % % % % % % % % % % % % % %
Tt5 = Tt45 - (W_LPC + W_F)/(engine.LPT.eta * m_45 * engine.gas.cp);
fprintf('Tt5:       %.2f K\n', Tt5);

[Pt5,Tt5_id] = turbine(Pt45,Tt45,Tt5,engine.gas.gamma,engine.LPT.eta);

% Tt5_id = Tt45 - (Tt45 - Tt5)/engine.LPT.eta;
% fprintf('Tt5_id:       %.2f K\n', Tt5_id);
% Pt5 = Pt45 * (Tt45/Tt5_id)^(engine.gas.gamma/(1-engine.gas.gamma));
fprintf('Pt5:       %.2f Pa\n', Pt5);

% % % % % % % % % % % % % % Nozzle stage % % % % % % % % % % % % % % % % %

% Critical total pressure
P_tot = engine.flow.P * (1 + (engine.gas.gamma - 1)/2)^(engine.gas.gamma/(engine.gas.gamma - 1));
fprintf('P tot:       %.2f Pa\n', P_tot);

Pt7 = Pt5;
Tt7 = Tt5;


if Pt7 > P_tot
    % nozzle is choked
    T8 = Tt7*1/(1+(engine.gas.gamma-1)/2);
    P8 = Pt7*1/(1-1/engine.N.eta*((engine.gas.gamma-1)/(engine.gas.gamma+1)))^(-engine.gas.gamma/(engine.gas.gamma-1));
    fprintf('T8:       %.2f K\n', T8);
    fprintf('P8:       %.2f Pa\n', P8);
    
    V8 = sqrt(engine.gas.gamma*engine.flow.R*T8);
    fprintf('V8:       %.2f m/s\n', V8);
    rho_8 = P.P8/(engine.flow.R*T8);
    fprintf('rho_8:       %.2f kg/m^3\n', rho_8);
    A_core = (m_core + m_f)/(rho_8 * V8);
    fprintf('A_core:       %.2f m^2\n', A_core);
else
end

% bypass

if Pt21 > P_tot
    % bypass nozzle is choked
    T18 = Tt21*1/(1+(engine.air.gamma-1)/2);
    P18 = Pt21*1/(1-1/engine.N.eta*((engine.air.gamma-1)/(engine.air.gamma+1)))^(-engine.air.gamma/(engine.air.gamma-1));
    fprintf('T18:       %.2f K\n', T18);
    fprintf('P18:       %.2f Pa\n', P18);
    
    V18 = sqrt(engine.air.gamma*engine.flow.R*T18);
    fprintf('V_18:       %.2f m/s\n', V18);
    rho_18 = P.P18/(engine.flow.R*T18);
    fprintf('rho_18:       %.2f kg/m^3\n', rho_18);
    A_bypass = (m_bypass)/(rho_18 * V18);
    fprintf('A_bypass:       %.2f m^2\n', A_bypass);
else
end

v_inf = engine.flow.M*sqrt(engine.air.gamma*engine.flow.R*engine.flow.T);

F_core = (m_core + m_f)*(V8-v_inf) + A_core*(P8-P_amb);

F_bypass = m_bypass*(V18 - v_inf) + A_bypas*(P18-P_amb);

F_total = F_core + F_bypass;

TSFC = m_f / F_total;










results = struct();

results.T = [];
results.P = P;

end