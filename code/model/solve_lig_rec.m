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

%% Bound ligand (pM)
% Find index containing each ligand name
ind_VA = contains(params_struct.species_names, 'VA_');
ind_VB = contains(params_struct.species_names, 'VB_');
ind_Pl = contains(params_struct.species_names, 'Pl_');
ind_PDAA = contains(params_struct.species_names, 'PDAA_');
ind_PDAB = contains(params_struct.species_names, 'PDAB_');
ind_PDBB = contains(params_struct.species_names, 'PDBB_');

% Record the concentration
result.VA_bound = sum(sol(:, ind_VA), 2);
result.VB_bound = sum(sol(:, ind_VB), 2);
result.Pl_bound = sum(sol(:, ind_Pl), 2);
result.PDAA_bound = sum(sol(:, ind_PDAA), 2);
result.PDAB_bound = sum(sol(:, ind_PDAB), 2);
result.PDBB_bound = sum(sol(:, ind_PDBB), 2);

%% Free receptors (pM)
% Find index for free receptors
ind_R1 = strcmp(params_struct.species_names, 'R1');
ind_R1_N1 = strcmp(params_struct.species_names, 'R1_N1');
ind_R2 = strcmp(params_struct.species_names, 'R2');
ind_N1 = strcmp(params_struct.species_names, 'N1');
ind_PDRa = strcmp(params_struct.species_names, 'PDRa');
ind_PDRb = strcmp(params_struct.species_names, 'PDRb');

% Record concentration
result.R1_free = ( sol(:, ind_R1) + sol(:, ind_R1_N1) );
result.R2_free = sol(:, ind_R2);
result.N1_free = sol(:, ind_N1);
result.PDRa_free = sol(:, ind_PDRa);
result.PDRb_free = sol(:, ind_PDRb);

%% Bound receptors (pM)
% Find index for bound receptors
ind_R1 = contains(params_struct.species_names, '_R1');
ind_R2 = contains(params_struct.species_names, '_R2');
ind_N1 = (contains(params_struct.species_names, '_N1') & ~strcmp(params_struct.species_names, 'R1_N1'));
ind_PDRa = contains(params_struct.species_names, '_PDRa');
ind_PDRb = contains(params_struct.species_names, '_PDRb');

% Record concentration
result.R1_bound = sum(sol(:, ind_R1), 2);
result.R2_bound = sum(sol(:, ind_R2), 2);
result.N1_bound = sum(sol(:, ind_N1), 2);
result.PDRa_bound = sum(sol(:, ind_PDRa), 2);
result.PDRb_bound = sum(sol(:, ind_PDRb), 2);

end