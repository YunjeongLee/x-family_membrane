function result = solve_lig_rec(time_stamp, params_struct)
%% Define initial condition
params_cell = struct2cell(params_struct);
y0 = cell2mat(params_cell(1:params_struct.num_state));

%% Solve ODE system
options = odeset('AbsTol', 1e-20, 'RelTol', 1e-9);

[~, sol] = ode15s(@(t, y) ODE_lig_rec(t, y, params_struct), time_stamp, y0, options);

%% Save result as structure
for i = 1:length(y0)
    result.(params_struct.species_names{i}) = sol(:, i);
end

%% Free ligand (pM)
% Find index for free ligands
ind_VA = strcmp(params_struct.species_names, 'VA');
ind_VB = strcmp(params_struct.species_names, 'VB');
ind_Pl = strcmp(params_struct.species_names, 'Pl');
ind_PDAA = strcmp(params_struct.species_names, 'PDAA');
ind_PDAB = strcmp(params_struct.species_names, 'PDAB');
ind_PDBB = strcmp(params_struct.species_names, 'PDBB');

% Record the concentration
result.VA_free = sol(:, ind_VA);
result.VB_free = sol(:, ind_VB);
result.Pl_free = sol(:, ind_Pl);
result.PDAA_free = sol(:, ind_PDAA);
result.PDAB_free = sol(:, ind_PDAB);
result.PDBB_free = sol(:, ind_PDBB);

end