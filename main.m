clear all
close all
clc

engine_case = {'Leap1A'}; %{'JT8D', 'Leap1B', 'Leap1A'}; 

n_engines = length(engine_case);
for i = 1:n_engines
    % Get engine data
    engine = initial_data(engine_case{i});
    
    % Calculate results
    results = calculator(engine);
    
    % Store results
    if i == 1
        all_res = results;
    else
        all_res(i) = results;
    end

    % Plot
    plot_Ts(results,engine)
end