clear
close
clc

% Engine 1: JT 8D Data Structure
JT8D = struct();
JT8D.Name = 'JT 8D';
JT8D.BypassRatio = 1.62;
JT8D.CoreMassFlowRate = 90.2;       % corrected kg/s
JT8D.FanPressureRatio = 1.9;
JT8D.HPCPressureRatio = 3.5;
JT8D.TurbineInletTemp = 1150;       % Kelvin
JT8D.OverallPressureRatio = 17;
JT8D.FanLpcHpcEfficiency = 0.85;    % Isentropic Efficiency
JT8D.LptHptEfficiency = 0.88;       % Isentropic Efficiency
JT8D.CombustorEfficiency = 0.985;
JT8D.Stages = '2+6+7 / 1+3';        % Compressor / Turbine
JT8D.Diameter = 1.25;               % meters

% Engine 2: Leap-1B Data Structure
Leap1B = struct();
Leap1B.Name = 'Leap-1B';
Leap1B.BypassRatio = 8.6;
Leap1B.CoreMassFlowRate = 50;       % corrected kg/s
Leap1B.FanPressureRatio = 1.5;
Leap1B.HPCPressureRatio = 10;
Leap1B.TurbineInletTemp = 1450;     % Kelvin
Leap1B.OverallPressureRatio = 40;
Leap1B.FanLpcHpcEfficiency = 0.92;  % Isentropic Efficiency
Leap1B.LptHptEfficiency = 0.92;     % Isentropic Efficiency
Leap1B.CombustorEfficiency = 0.995;
Leap1B.Stages = '1+3+10 / 2+5';     % Compressor / Turbine
Leap1B.Diameter = 1.75;             % meters

% General Characteristics Structure
GeneralInfo = struct();
GeneralInfo.Type = 'Two spool turbofan Engine';
GeneralInfo.NozzleType = 'Convergent';
GeneralInfo.IntakeEfficiency = 0.99;       % Isentropic
GeneralInfo.MechanicalEfficiency = 0.99;
GeneralInfo.CombustorPressureRatio = 0.96;
GeneralInfo.NozzleEfficiency = 0.99;
GeneralInfo.AmbientTemp = 220;             % Kelvin
GeneralInfo.Altitude = 10668;              % meters
GeneralInfo.MachNumber = 0.78;
GeneralInfo.AmbientPressure = 23842;       % Pa
GeneralInfo.GasConstant = 287;             % J/kg K
GeneralInfo.FuelLHV = 43e6;                % J/kg (converted from 43 MJ)
GeneralInfo.CpAir = 1000;
GeneralInfo.KappaAir = 1.4;
GeneralInfo.CpGas = 1150;
GeneralInfo.KappaGas = 1.33;