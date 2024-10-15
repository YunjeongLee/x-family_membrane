function params_struct = change_unit_mg(params_tbl)
%% Find the parameters that has molecule/cell unit
idx = strcmp(params_tbl.Unit, 'rec/cell');

%% Change the unit, molecule/cell, to M
avogadro = 6.02214e23;  % molecule/mol
EC_area = 1e-5; % cm2

params_tbl{idx, 'value'} = params_tbl{idx, 'value'} / avogadro / EC_area;

%% Change table to a structure
params = table2cell(params_tbl);
params_struct = cell2struct(params(:, 2), params(:, 1));

%% Define receptor insertion rate
params_struct.s_R1 = params_struct.kint_free * params_struct.R10;
params_struct.s_R2 = params_struct.kint_free * params_struct.R20;

end