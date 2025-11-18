function engine = initial_data(engineID)
% INITIAL_DATA Returns the engine data structure for a specific engine ID.

    % Initialize empty struct
    engine = struct();

    % Normalize input to lowercase for case-insensitive comparison
    switch lower(engineID)
        
        % =================================================================
        % CASE 1: JT 8D
        % =================================================================
        case {'jt8d', 'jt 8d'}
            engine.name      = 'JT 8D';
            
            % -- Intake --
            engine.I.beta    = 1.0;         % Assumed perfect/general (0.99 eta implies PR ~1.0 or specific loss)
            engine.I.eta     = 0.99;

            % -- Fan --
            engine.F.beta    = 1.9;
            engine.F.eta     = 0.85;        % Fan, LPC & HPC Eff = 0.85
            
            % -- Low Pressure Compressor --
            % Calculated: OPR (17) / (Fan_PR * HPC_PR) = 17 / (1.9 * 3.5)
            engine.LPC.beta  = 2.5564;      
            engine.LPC.eta   = 0.85;
            
            % -- High Pressure Compressor --
            engine.HPC.beta  = 3.5;
            engine.HPC.eta   = 0.85;
            
            % -- Combustor --
            engine.C.beta    = 0.96;        % From General Characteristics
            engine.C.eta     = 0.985;
            engine.C.Qfuel   = 43e6;        % [J/kg]
            engine.C.Texit   = 1150;        % Turbine Inlet Temp [K]
            
            % -- Turbines (Added for completeness based on naming convention) --
            engine.HPT.eta   = 0.88;
            engine.LPT.eta   = 0.88;
            
            % -- Nozzle & Mechanical --
            engine.N.eta     = 0.99;        % From General Characteristics
            engine.eta       = 0.99;        % Mechanical efficiency
            
            % -- Flow & Environment --
            engine.flow.BPR  = 1.62;
            % Massflow: Core is 90.2. Total = Core * (1 + BPR)
            engine.flow.mass = 90.2 * (1 + 1.62); 
            engine.flow.T    = 220;         % Ambient Temp [K]
            engine.flow.P    = 23842;       % Ambient Pressure [Pa]
            engine.flow.R    = 287;         
            engine.flow.M    = 0.78;
            engine.flow.h    = 10668;
            
            % -- Gas Properties --
            engine.air.gamma = 1.4;
            engine.air.cp    = 1000;
            engine.gas.gamma = 1.33;
            engine.gas.cp    = 1150;

        % =================================================================
        % CASE 2: LEAP-1B
        % =================================================================
        case {'leap-1b', 'leap1b'}
            engine.name      = 'Leap-1B';
            
            % -- Intake --
            engine.I.beta    = 1.0;         % General
            engine.I.eta     = 0.99;

            % -- Fan --
            engine.F.beta    = 1.5;
            engine.F.eta     = 0.92;        % Fan Eff
            
            % -- Low Pressure Compressor --
            % Calculated: OPR (40) / (Fan_PR * HPC_PR) = 40 / (1.5 * 10)
            engine.LPC.beta  = 2.6667;
            engine.LPC.eta   = 0.92;
            
            % -- High Pressure Compressor --
            engine.HPC.beta  = 10;
            engine.HPC.eta   = 0.92;
            
            % -- Combustor --
            engine.C.beta    = 0.96;
            engine.C.eta     = 0.995;
            engine.C.Qfuel   = 43e6;
            engine.C.Texit   = 1450;
            
            % -- Turbines --
            engine.HPT.eta   = 0.92;
            engine.LPT.eta   = 0.92;
            
            % -- Nozzle & Mechanical --
            engine.N.eta     = 0.99;
            engine.eta       = 0.99;
            
            % -- Flow & Environment --
            engine.flow.BPR  = 8.6;
            % Massflow: Core is 50. Total = Core * (1 + BPR)
            engine.flow.mass = 50 * (1 + 8.6);
            engine.flow.T    = 220;
            engine.flow.P    = 23842;
            engine.flow.R    = 287;
            engine.flow.M    = 0.78;
            engine.flow.h    = 10668;

            % -- Gas Properties --
            engine.air.gamma = 1.4;
            engine.air.cp    = 1000;
            engine.gas.gamma = 1.33;
            engine.gas.cp    = 1150;

        % =================================================================
        % CASE 3: LEAP-1A
        % =================================================================
        case {'leap-1a', 'leap1a'}
            engine.name      = 'LEAP-1A';
            
            % -- Intake --
            engine.I.beta    = 0.98;        % Specific Validation Data
            engine.I.eta     = 0.98;
            
            % -- Fan --
            engine.F.beta    = 1.4;
            engine.F.eta     = 0.90;        % Specific Fan Eff
            
            % -- Low Pressure Compressor --
            engine.LPC.beta  = 1.7;         % Explicitly given
            engine.LPC.eta   = 0.92;        % Combined LPC/HPC Eff
            
            % -- High Pressure Compressor --
            engine.HPC.beta  = 12.5;
            engine.HPC.eta   = 0.92;
            
            % -- Combustor --
            engine.C.beta    = 0.96;
            engine.C.eta     = 0.995;
            engine.C.Qfuel   = 43e6;
            engine.C.Texit   = 1400;
            
            % -- Turbines --
            engine.HPT.eta   = 0.90;
            engine.LPT.eta   = 0.90;
            
            % -- Nozzle & Mechanical --
            engine.N.eta     = 0.98;        % Specific Validation Data
            engine.eta       = 0.99;
            
            % -- Flow & Environment --
            engine.flow.BPR  = 12;
            engine.flow.mass = 173;         % Given as Total flow
            engine.flow.T    = 218.8;       % Specific Validation Data
            engine.flow.P    = 23842;       % Specific Validation Data
            engine.flow.R    = 287;
            engine.flow.M    = 0.78;
            engine.flow.h    = 10668;

            % -- Gas Properties --
            engine.air.gamma = 1.4;
            engine.air.cp    = 1000;
            engine.gas.gamma = 1.33;
            engine.gas.cp    = 1150;
            
        otherwise
            error('Unknown Engine ID. Please use ''JT8D'', ''Leap-1B'', or ''Leap-1A''.');
    end
end