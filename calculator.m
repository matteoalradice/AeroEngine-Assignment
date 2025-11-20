function [results] = calculator(engine)

m_core = engine.flow.mass/(engine.flow.BPR + 1);
m_bypass = m_core*engine.flow.BPR;
fprintf('m_core:     %.2f kg/s\n', m_core);
fprintf('m_bypass:     %.2f kg/s\n', m_bypass);

T = struct();
P = struct();
W = struct();

T.T1 = engine.flow.T;
fprintf('T.T1   (Static Temp):     %.2f K\n', T.T1);

P.P1 = engine.flow.P;
fprintf('P.P1   (Static Press):    %.2f Pa\n', P.P1);

T.Tt1 = T.T1 * (1 + (engine.air.gamma-1)/2 * engine.flow.M^2);
fprintf('T.Tt1  (Total Temp 1):    %.2f K\n', T.Tt1);

P.Pt1 = P.P1 * (T.Tt1/T.T1)^(engine.air.gamma/(engine.air.gamma-1));
fprintf('P.Pt1  (Total Press 1):   %.2f Pa\n', P.Pt1);

T.Tt2 = T.Tt1;
fprintf('T.Tt2  (Total Temp 2):    %.2f K\n', T.Tt2);

P.Pt2 = engine.I.eta * P.Pt1;
fprintf('P.Pt2  (Total Press 2):   %.2f Pa\n', P.Pt2);

P.Pt21 = engine.air.gamma * P.Pt2; 
fprintf('P.Pt21 (Fan Exit Press):  %.2f Pa\n', P.Pt21);

T.Tt21 = T.Tt2 * (1 + 1/engine.F.eta * ((P.Pt21/P.Pt2)^((engine.air.gamma-1)/engine.air.gamma) - 1));
fprintf('T.Tt21 (Fan Exit Temp):   %.2f K\n', T.Tt21);

P.Pt13 = P.Pt21;
fprintf('P.Pt13 (Bypass Press):    %.2f Pa\n', P.Pt13);

T.Tt13 = T.Tt21;
fprintf('T.Tt13 (Bypass Temp):     %.2f K\n', T.Tt13);

W.W_F = engine.flow.mass * engine.air.cp * (T.Tt21 - T.Tt2);
fprintf('W.Wfan (Fan Work):        %.2f Watts\n', W.W_F);

P.Pt25 = engine.LPC.beta*P.Pt21;
T.Tt25 = T.Tt21 * (1 + 1/engine.LPC.eta * ((P.Pt25/P.Pt21)^((engine.air.gamma-1)/engine.air.gamma) - 1));

m_25 = m_core;

W.W_LPC = m_25*engine.air.cp*(T.Tt25 - T.Tt21);

P.Pt3 = engine.HPC.beta*P.Pt25;
T.Tt3 = T.Tt25 * (1 + 1/engine.HPC.eta * ((P.Pt3/P.Pt25)^((engine.air.gamma-1)/engine.air.gamma) - 1));
fprintf('T.Tt3  (Total Temp 3):    %.2f K\n', T.Tt3);
m_3 = m_25;
W.W_HPC = m_3 * engine.air.cp * (T.Tt3 - T.Tt25);
fprintf('W.W_HPC (HPC Work):       %.2f Watts\n', W.W_HPC);

T.Tt4 = engine.C.Texit;
m_f = (m_3 * engine.gas.cp * (T.Tt4 - T.Tt3))/(engine.C.eta * engine.gas.LHV);

m_4 = m_3 + m_f;

P.Pt4 = P.Pt3 * engine.C.beta;
T.Tt45 = T.Tt4 - W.W_HPC/(engine.eta*m_4*engine.gas.cp);
T.Tt45_id = T.Tt4 - (T.Tt4 - T.Tt45)/engine.HPT.eta;
P.Pt45 = P.Pt4 * (T.Tt4/T.Tt45_id)^(engine.gas.gamma/(1-engine.gas.gamma));

fprintf('T.Tt45:       %.2f K\n', T.Tt45);

m_45 = m_4;


T.Tt5 = T.Tt45 - (W.W_LPC + W.W_F)/(engine.eta * m_45 * engine.gas.cp);
fprintf('T.Tt5:       %.2f K\n', T.Tt5);
T.Tt5_id = T.Tt45 - (T.Tt45 - T.Tt5)/engine.LPT.eta;
fprintf('T.Tt5_id:       %.2f K\n', T.Tt5_id);
P.Pt5 = P.Pt45 * (T.Tt45/T.Tt5_id)^(engine.gas.gamma/(1-engine.gas.gamma));
fprintf('P.Pt5:       %.2f Pa\n', P.Pt5);

P_tot = engine.flow.P * (1 + (engine.gas.gamma - 1)/2)^(engine.gas.gamma/(engine.gas.gamma - 1));
fprintf('P.P tot:       %.2f Pa\n', P_tot);

P.Pt7 = P.Pt5;
T.Tt7 = T.Tt5;

if P.Pt7 > P_tot
    % nozzle is choked
    T.T8 = T.Tt7*1/(1+(engine.gas.gamma-1)/2);
    P.P8 = P.Pt7*1/(1-1/engine.N.eta*((engine.gas.gamma-1)/(engine.gas.gamma+1)))^(-engine.gas.gamma/(engine.gas.gamma-1));
    fprintf('T.T8:       %.2f K\n', T.T8);
    fprintf('P.P8:       %.2f Pa\n', P.P8);
    
    V8 = sqrt(engine.gas.gamma*engine.flow.R*engine.flow.T);
    rho_8 = P.P8/(engine.flow.R*T.T8);
else
end









results = struct();

results.T = T;
results.P = P;

end