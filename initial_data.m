function [JT8D, Leap1B, general, Leap1A, validation] = initial_data()
% Engine 1: JT 8D Data Structure 
JT8D = struct();
JT8D.Name = 'JT 8D';
JT8D.BPR = 1.62;
JT8D.CoreMassFlowRate = 90.2;   % corrected kg/s
JT8D.PR_fan = 1.9;
JT8D.PR_HPC = 3.5;
JT8D.T_turbine_inlet = 1150;    % Kelvin
JT8D.PR_total = 17;
JT8D.eta_fan_lpc_hpc = 0.85;    % Isentropic Efficiency
JT8D.eta_lpt_hpt = 0.88;        % Isentropic Efficiency
JT8D.eta_cc = 0.985;
JT8D.Stages = '2+6+7 / 1+3';    % Compressor / Turbine
JT8D.D = 1.25;                  % meters

% Engine 2: Leap-1B Data Structure
Leap1B = struct();
Leap1B.Name = 'Leap-1B';
Leap1B.BPR = 8.6;
Leap1B.CoreMassFlowRate = 50;       % corrected kg/s
Leap1B.PR_fan = 1.5;
Leap1B.PR_HPC = 10;
Leap1B.T_turbine_inlet = 1450;     % Kelvin
Leap1B.PR_total = 40;
Leap1B.eta_fan_lpc_hpc = 0.92;  % Isentropic Efficiency
Leap1B.eta_lpt_hpt = 0.92;     % Isentropic Efficiency
Leap1B.eta_cc = 0.995;
Leap1B.Stages = '1+3+10 / 2+5';     % Compressor / Turbine
Leap1B.D = 1.75;             % meters

% general Characteristics Structure
general = struct();
general.eta_intake = 0.99;       % Isentropic Efficiency
general.PR_inlet = NaN;          % Not specified for general (Validation uses 0.98)
general.eta_mech = 0.99;
general.PR_comb = 0.96;          % Combustor Pressure Ratio
general.eta_nozzle = 0.99;
general.T_amb = 220;             % Kelvin
general.P_amb = 23842;           % Pa
general.h = 10668;               % meters
general.M = 0.78;
general.R = 287;                 % J/kg K
general.LHVf = 43e6;             % J/kg
general.Cp_Air = 1000;
general.Kappa_Air = 1.4;
general.Cp_Gas = 1150;
general.Kappa_Gas = 1.33;


% VALIDATION
Leap1A = struct();
Leap1A.Name = 'Leap-1A';
Leap1A.BPR = 12;
Leap1A.CoreMassFlowRate = 173;      % NOTE: "Engine air mass flow rate" (Total), not Core
Leap1A.PR_fan = 1.4;
Leap1A.PR_HPC = 12.5;               % Note: LPC Pressure Ratio is 1.7
Leap1A.T_turbine_inlet = 1400;      % Kelvin (Tt4)
Leap1A.PR_total = 29.75;            % Calculated: 1.4 (Fan) * 1.7 (LPC) * 12.5 (HPC)
Leap1A.eta_fan_lpc_hpc = 0.92;      % LPC & HPC Isentropic Eff. (Fan Eff is 0.90)
Leap1A.eta_lpt_hpt = 0.90;          % Isentropic Efficiency
Leap1A.eta_cc = 0.995;
Leap1A.Stages = '';                 % Not specified in provided data
Leap1A.D = 0;                       % Not specified in provided data

validation = struct();
validation.eta_intake = NaN;     % Not specified (general uses 0.99)
validation.PR_inlet = 0.98;      % Inlet Pressure Ratio
validation.eta_mech = 0.99;
validation.PR_comb = 0.96;
validation.eta_nozzle = 0.98;
validation.T_amb = 218.8;        % Kelvin (Ta)
validation.P_amb = 23842;        % Pa (pa)
validation.h = 10668;            % meters
validation.M = 0.78;
validation.R = 287;              % J/kg K
validation.LHVf = 43e6;          % J/kg
validation.Cp_Air = 1000;        % Standardized from Cp_a
validation.Kappa_Air = 1.4;
validation.Cp_Gas = 1150;        % Standardized from Cp_g
validation.Kappa_Gas = 1.33;

end