clear all
close all
clc
engine_case = {'GTF'}; %{'GTF', 'Leap1A'}; 

n_engines = length(engine_case);
for i = 1:n_engines
    % Get engine data
    engine = initial_data(engine_case{i});
    fprintf('------------------------------------------------------\n'); 
    fprintf('Engine: \t %s\n\n', engine_case{i}); 

    % Calculate results
    results = calculator(engine);
    fprintf('\n'); 
    % Store results
    if i == 1
        all_res = results;
    else
        all_res(i) = results;
    end

    % Plot
    plot_Ts(results,engine)
end