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

W.Wfan = engine.flow.mass * engine.air.cp * (T.Tt21 - T.Tt2);
fprintf('W.Wfan (Fan Work):        %.2f Watts\n', W.Wfan);











results = struct();

results.T = T;
results.P = P;

end