function [results] = calculator(engine)

T = struct();
P = struct();

T.T1 = engine.flow.T;
P.P1 = engine.flow.P;

T.Tt1 = T.T1*(1+(engine.air.gamma-1)/2*engine.flow.M^2);
P.Pt1 = P.P1*(T.Tt1/T.T1)^(engine.air.gamma/(engine.air.gamma-1));

T.Tt2 = T.Tt1;
P.Pt2 = engine.I.eta*P.Pt1;













results = struct();

results.T = T;
results.P = P;

end