function [results] = calculator(engine)

gamma_a = engine.air.gamma;
gamma_g = engine.gas.gamma;
M = engine.flow.M;
BPR = engine.flow.BPR;
mass = engine.flow.mass;

% Mass flow
m_core   = mass / (BPR + 1);
m_bypass = m_core * BPR;

fprintf('core flow: \t %.2f  kg/s\n', m_core);
fprintf('bypass flow: \t %.2f kg/s\n\n', m_bypass);

% % % % % % % % % % % % % % Ambient stage % % % % % % % % % % % % % % % % %
% Static quantities
P_amb = engine.flow.P;
T_amb = engine.flow.T;

fprintf(['Ambient pressure    (Static): \t %.2f Pa\n',...
         'Ambient temperature (Static): \t %.2f K\n'], P_amb,T_amb);

% Total quantities
Tt1 = T_amb * (1 + (gamma_a - 1)/2 * M^2);
Pt1 = P_amb * (1 + (gamma_a - 1)/2 * M^2)^(gamma_a / (gamma_a-1));

fprintf(['Ambient pressure    (Total): \t %.2f Pa\n',...
         'Ambient temperature (Total): \t %.2f K\n\n'], Pt1,Tt1);

% % % % % % % % % % % % % % % Inlet stage % % % % % % % % % % % % % % % % %

Pt2 = engine.I.eta * Pt1;
Tt2 = Tt1;

fprintf(['Inlet pressure: \t \t %.2f Pa\n',...
         'Inlet temperature: \t \t %.2f K\n\n'], Pt2,Tt2);

% % % % % % % % % % % % % % % Fan stage % % % % % % % % % % % % % % % % % %

[Pt21,Tt21,Tt21_id] = compressor(Pt2,Tt2,gamma_a,engine.F.beta,engine.F.eta);

fprintf(['Fan pressure: \t \t \t %.2f Pa\n',...
         'Fan temperature: \t \t %.2f K\n'], Pt21,Tt21);

W_F = mass * engine.air.cp * (Tt21 - Tt2);
fprintf('Fan Work: \t \t \t %.2f MW\n\n', W_F / 1e6);

% % % % % % % % % % % % % % % LPC stage % % % % % % % % % % % % % % % % % %

[Pt25,Tt25,Tt25_id] = compressor(Pt21,Tt21,gamma_a,engine.LPC.beta,engine.LPC.eta);

fprintf(['LPCompressor pressure: \t \t %.2f Pa\n',...
         'LPCompressor temperature: \t %.2f K\n'],...
         Pt25,Tt25);

W_LPC = m_core * engine.air.cp * (Tt25 - Tt21);
fprintf('LPCompressor Work: \t \t %.2f MW\n\n', W_LPC / 1e6);

% % % % % % % % % % % % % % % HPC stage % % % % % % % % % % % % % % % % % %

[Pt3,Tt3,Tt3_id] = compressor(Pt25,Tt25,gamma_a,engine.HPC.beta,engine.HPC.eta);

fprintf(['HPCompressor pressure: \t \t %.2f Pa\n',...
         'HPCompressor temperature: \t %.2f K\n'],...
         Pt3,Tt3);

W_HPC = m_core * engine.air.cp * (Tt3 - Tt25);
fprintf('HPCompressor Work: \t \t %.2f MW\n\n', W_HPC / 1e6);

% % % % % % % % % % % % % % Combustor stage % % % % % % % % % % % % % % % %

Pt4 = Pt3 * engine.C.beta;
Tt4 = engine.C.Texit;
m_f = (m_core * engine.gas.cp * (Tt4 - Tt3)) / (engine.C.eta * engine.gas.LHV);

fprintf(['Combustor pressure: \t \t %.2f Pa\n',...
         'Combustor temperature: \t \t %.2f K\n'],...
         Pt4,Tt4);

fprintf('Fuel massflow: \t \t \t %.2f kg/s\n\n', m_f);
m_hot = m_core + m_f;

% % % % % % % % % % % % % % % HPT stage % % % % % % % % % % % % % % % % % %

Tt45 = Tt4 - W_HPC / (engine.eta * m_hot * engine.gas.cp);
[Pt45,Tt45_id] = turbine(Pt4,Tt4,Tt45,gamma_g,engine.HPT.eta);

fprintf(['HPTurbine pressure: \t \t %.2f Pa\n',...
         'HPTurbine temperature: \t \t %.2f K\n\n'],...
         Pt45,Tt45);

% % % % % % % % % % % % % % % LPT stage % % % % % % % % % % % % % % % % % %

Tt5 = Tt45 - (W_LPC + W_F / engine.GB.eta) / (engine.eta * m_hot * engine.gas.cp);
[Pt5,Tt5_id] = turbine(Pt45,Tt45,Tt5,gamma_g,engine.LPT.eta);

fprintf(['LPTurbine pressure: \t \t %.2f Pa\n',...
         'LPTurbine temperature: \t \t %.2f K\n\n'],...
         Pt5,Tt5);

% % % % % % % % % % % % % % Nozzle stage % % % % % % % % % % % % % % % % %

% Critical total pressure
Pt_crit = P_amb * (1 + (gamma_g - 1)/2)^(gamma_g / (gamma_g - 1));
fprintf('Critical Total Pressure: \t %.2f Pa\n\n', Pt_crit);

Pt7 = Pt5;
Tt7 = Tt5;

% Core nozzle
if Pt7 > Pt_crit   % Nozzle is choked
    
    T8 = Tt7 / (1 + (gamma_g - 1) / 2);
    [P8,T8_id] = nozzle(Pt7,Tt7,T8,gamma_g,engine.N.eta);

    fprintf(['Core nozzle exit pressure: \t %.2f Pa\n',...
             'Core nozzle exit temperature: \t %.2f K\n\n'],...
             P8,T8);
    
    % Exit speed
    V8 = sqrt(gamma_g * engine.flow.R * T8);

    % Density
    rho_8 = P8 / (engine.flow.R * T8);

    % Core nozzle area
    A_core = m_hot / (rho_8 * V8);
    fprintf('Core nozzle area: \t \t %.2f m^2\n', A_core);
else
end

% Bypass nozzle
if Pt21 > Pt_crit   % Nozzle is choked

    T18 = Tt21 / (1 + (gamma_a - 1) / 2);
    [P18,T18_id] = nozzle(Pt21,Tt21,T18,gamma_a,engine.N.eta);


    fprintf(['Bypass nozzle exit pressure: \t %.2f Pa\n',...
             'Bypass nozzle exit temperature:  %.2f K\n\n'],...
             P18,T18);
    
    % Exit speed
    V18 = sqrt(gamma_a * engine.flow.R * T18);

    % Density
    rho_18 = P18 / (engine.flow.R * T18);

    % Bypass nozzle area
    A_bypass = m_bypass / (rho_18 * V18);
    fprintf('Bypass nozzle area: \t \t %.2f m^2\n', A_bypass);
else
end

v_inf = M * sqrt(gamma_a * engine.flow.R * T_amb);

F_core = m_hot * (V8 - v_inf) + A_core * (P8 - P_amb);

F_bypass = m_bypass * (V18 - v_inf) + A_bypass * (P18 - P_amb);

F_total = F_core + F_bypass;

TSFC = m_f / F_total;

% Output struct
results = struct();

results.P_re = [Pt1,Pt2,P18,Pt21,Pt25,Pt3,Pt4,Pt45,Pt5,P8];
results.P_id = [NaN,NaN,P18,Pt21,Pt25,Pt3,NaN,Pt45,Pt5,P8];

results.T_re = [Tt1,Tt2,T18,Tt21,Tt25,Tt3,Tt4,Tt45,Tt5,T8];
results.T_id = [NaN,NaN,T18_id,Tt21_id,Tt25_id,Tt3_id,NaN,Tt45_id,Tt5_id,T8_id];

results.T    = F_total;
results.TSFC = TSFC;
end