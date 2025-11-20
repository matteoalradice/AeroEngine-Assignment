function [] = plot_Ts(results,engine)

P0 = engine.flow.P;
T0 = engine.flow.T;

P_vect_re = results.P_re;
P_vect_id = results.P_id;

T_vect_re = results.T_re;
T_vect_id = results.T_id;

% Entropy function
s0 = 1000;
s_air = @(P,T) s0 + engine.air.cp * log(T./T0) - engine.flow.R * log(P./P0);
s_gas = @(P,T) s0 + engine.gas.cp * log(T./T0) - engine.flow.R * log(P./P0);

idx = find(T_vect_re == engine.C.Texit,1);

s_vect_id = [s_air(P_vect_id(1:idx-1),T_vect_id(1:idx-1)),...
             s_gas(P_vect_id(idx:end),T_vect_id(idx:end))];
s_vect_re = [s_air(P_vect_re(1:idx-1),T_vect_re(1:idx-1)),...
             s_gas(P_vect_re(idx:end),T_vect_re(idx:end))];

% Domain vector for plots
x = linspace(0,1,100);
T_dom = (T_vect_id - 20)' * (1 - x) + (T_vect_re + 20)' * x;

figure('Name','T-s diagram','NumberTitle','off')
hold on
grid on
box on

% References for pressure
plot(s_air(P0,linspace(T0 - 100,T0 + 200)),linspace(T0 - 100,T0 + 200),'--r','LineWidth',1)
plot(s_gas(P0,linspace(T0 - 100,engine.C.Texit)),linspace(T0 - 100,engine.C.Texit),'--b','LineWidth',1)

for j = 1:length(T_dom(:,1))
    if j < idx
        plot(s_air(P_vect_id(j),T_dom(j,:)),T_dom(j,:),':k','LineWidth',1)
    else
        plot(s_gas(P_vect_id(j),T_dom(j,:)),T_dom(j,:),':k','LineWidth',1)
    end
end

% Intermediate points
scatter(s_vect_id,T_vect_id,'r','filled')

% Real thermodynamic transformations
plot(s_vect_re(1:3),T_vect_re(1:3),'ok-.','MarkerFaceColor','b','MarkerEdgeColor','b')
plot(s_vect_re([2,4]),T_vect_re([2,4]),'ok-.','MarkerFaceColor','b','MarkerEdgeColor','b')
plot(s_vect_re(4:end),T_vect_re(4:end),'ok-.','MarkerFaceColor','b','MarkerEdgeColor','b')

% Axis
xlim([s0 - 50,2 * s0 + 200])
ylim([0,engine.C.Texit + 100])
xlabel('$\mathbf{s} \ \left[\frac{J}{Kg \cdot K}\right]$','Interpreter','latex')
ylabel('$\mathbf{T} \ \left[K\right]$','Interpreter','latex')
title(['T-s diagram of ',engine.name])