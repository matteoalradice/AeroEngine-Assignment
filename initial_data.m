function engine = initial_data(engineID)
% INITIAL_DATA Returns the engine data structure for a specific engine ID.

    % Initialize empty struct
    engine = struct();

    % Normalize input to lowercase for case-insensitive comparison
    switch lower(engineID)
        
        % =================================================================
        % CASE 1: GTF
        % =================================================================
        case {'gtf'}
            engine.name      = 'GTF';
            
            % -- Intake --
            engine.I.beta    = 0.99;         % Assumed perfect/general (0.99 eta implies PR ~1.0 or specific loss)
            engine.I.eta     = 0.99;

            % -- Fan --
            engine.F.beta    = 1.35;
            engine.F.eta     = 0.92;        % Fan, LPC & HPC Eff = 0.85
            
            % -- Low Pressure Compressor --
            % Calculated: OPR (17) / (Fan_PR * HPC_PR) = 17 / (1.9 * 3.5)
            engine.LPC.beta  = 4.5;      
            engine.LPC.eta   = 0.92;
            
            % -- High Pressure Compressor --
            engine.HPC.beta  = 5.5;
            engine.HPC.eta   = 0.91;
            
            % -- Combustor --
            engine.C.beta    = 0.96;        % From General Characteristics
            engine.C.eta     = 0.995;
            engine.C.Texit   = 1600;        % Turbine Inlet Temp [K]
            
            % -- Turbines (Added for completeness based on naming convention) --
            engine.HPT.eta   = 0.91;
            engine.LPT.eta   = 0.91;
            
            % -- Nozzle & Mechanical --
            engine.N.eta     = 0.99;        % From General Characteristics
            engine.eta       = 0.995;        % Mechanical efficiency
            engine.GB.eta    = 0.995;
            
            % -- Flow & Environment --
            engine.flow.BPR  = 12.5;
            % Massflow: Core is 90.2. Total = Core * (1 + BPR)
            engine.flow.mass = 220; %kg /s 90.2 * (1 + 1.62); 
            engine.flow.T    = 216.5;         % Ambient Temp [K]
            engine.flow.P    = 22632;       % Ambient Pressure [Pa]
            engine.flow.R    = 287;         
            engine.flow.M    = 0.78;
            engine.flow.h    = 11000;
            
            % -- Gas Properties --
            engine.air.gamma = 1.4;
            engine.air.cp    = 1000;
            engine.gas.gamma = 1.33;
            engine.gas.cp    = 1150;
            engine.gas.LHV   = 43*10^6;

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
            engine.GB.eta    = 0.1;

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
            engine.gas.LHV   = 43*10^6;
            
        otherwise
            error('Unknown Engine ID. Please use ''JT8D'', ''Leap-1B'', or ''Leap-1A''.');
    end
end