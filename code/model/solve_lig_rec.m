function result = solve_lig_rec(time_stamp, params_struct)
%% Define initial condition
params_cell = struct2cell(params_struct);
y0 = cell2mat(params_cell(1:params_struct.num_state));

%% Solve ODE system
options = odeset('AbsTol', 1e-20, 'RelTol', 1e-9);

[~, sol] = ode15s(@(t, y) ODE_lig_rec(t, y, params_struct), time_stamp, y0, options);

end