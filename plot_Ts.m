function [] = plot_Ts(results,engine)

P0 = engine.flow.P;

P_vect_re = results.P_re;
P_vect_id = results.P_id;

T_vect_re = results.T_re;
T_vect_id = results.T_id;

% Entropy function
s0 = 1000;
s = @(P,T) s0 + engine.air.cp * log(T./engine.flow.T) - engine.flow.R * log(P./engine.flow.P);

s_vect_id = s(P_vect_id,T_vect_id);
s_vect_re = s(P_vect_re,T_vect_re);

% Domain vector for plots
x = linspace(0,1,100);
T_dom = (T_vect_id - 20)' * (1 - x) + (T_vect_re + 20)' * x;

figure('Name','T-s diagram','NumberTitle','off')
hold on
grid on
box on

% References for pressure
plot(s(P0,linspace(engine.flow.T-100,engine.C.Texit)),linspace(engine.flow.T-100,engine.C.Texit),'--r','LineWidth',1)

for j = 1:length(T_dom(:,1))
    plot(s(P_vect_id(j),T_dom(j,:)),T_dom(j,:),':k','LineWidth',1)
end

% Intermediate points
scatter(s_vect_id,T_vect_id,'r','filled')

% Real thermodynamic transformations
plot(s_vect_re(1:end-2),T_vect_re(1:end-2),'ok-.','MarkerFaceColor','b','MarkerEdgeColor','b')
plot(s_vect_re([2,end]),T_vect_re([2,end]),'ok--','MarkerFaceColor','b','MarkerEdgeColor','b')
plot(s_vect_re([8,end-1]),T_vect_re([8,end-1]),'ok--','MarkerFaceColor','b','MarkerEdgeColor','b')

% Axis
xlim([s0 - 200,2 * s0 + 200])
ylim([0,engine.C.Texit + 100])
xlabel('$\mathbf{s} \ \left[\frac{J}{Kg \cdot K}\right]$','Interpreter','latex')
ylabel('$\mathbf{T} \ \left[K\right]$','Interpreter','latex')
title(['T-s diagram of ',engine.name])