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

% Labeling
labels_re = {'1','2','18','21','25','3','4','45','5','8'};   % example for results.T_re (length should match T_vect_re)
labels_id = {'','','','21*','25*','3*','','45*','5*',''};        % example for results.T_id (use '' to skip)

% compute small offsets in data units
xl = xlim;
yl = ylim;
dx = 0.003 * (xl(2) - xl(1));  % shift right x-range
dy = 0.015 * (yl(2) - yl(1));  % shift up y-range

% Labels for real points
n_re = length(s_vect_re);
for k = 1:n_re

    if k <= numel(labels_re) && ~isempty(labels_re{k}) && ...
       ~isnan(s_vect_re(k)) && ~isnan(T_vect_re(k))
        if k <= 3
            dx_def = (k-2.5)*dx;
            dy_def = -4*dy;
        else
            dx_def = dx;
            dy_def = dy;
        end
        text(s_vect_re(k) + dx_def, T_vect_re(k) + dy_def, labels_re{k}, ...
             'FontSize',9, 'FontWeight','bold', 'Interpreter','none', ...
             'HorizontalAlignment','left','VerticalAlignment','bottom');
    end
end

% Labels for intermediate (id) points
dx_id = -0.003 * (xl(2) - xl(1));  % shift left x-range
n_id = length(s_vect_id);
for k = 1:n_id
    if k <= numel(labels_id) && ~isempty(labels_id{k}) && ...
       ~isnan(s_vect_id(k)) && ~isnan(T_vect_id(k))
        text(s_vect_id(k) + dx_id, T_vect_id(k) + dy, labels_id{k}, ...
             'FontSize',9, 'Color','r', 'Interpreter','none', ...
             'HorizontalAlignment','left','VerticalAlignment','bottom');
    end
end
% --- end labeling ---


% Axis
xlim([s0 - 50, 2 * s0 + 300])
ylim([0, engine.C.Texit + 100])
xlabel('$\mathbf{s} \ \left[\frac{J}{Kg \cdot K}\right]$','Interpreter','latex')
ylabel('$\mathbf{T} \ \left[K\right]$','Interpreter','latex')
title(['T-s diagram of ', engine.name]);
legend('','','','','','','','','','','','','Ideal','Real','','','Location','northwest');