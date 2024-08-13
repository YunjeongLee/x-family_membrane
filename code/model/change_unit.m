function params_struct = change_unit(params_tbl)
%% Find the parameters that has molecule/cell unit
idx = strcmp(params_tbl.Unit, 'molecule/cell');

%% Change the unit, molecule/cell, to M
avogadro = 6.02214e23;  % molecule/mol
EC_vol = 1e-12; % liter
EC_area = 1e-5; % cm2

params_tbl{idx, 'value'} = params_tbl{idx, 'value'} / avogadro / EC_vol;

%% Find the parameters that has cm2/mol/s unit
idx = strcmp(params_tbl.Unit, 'cm2/mol/s');

%% Change the unit, cm2/mol/s to 1/M/s
params_tbl{idx, 'value'} = params_tbl{idx, 'value'} / EC_area * EC_vol;

%% Change table to a structure
params = table2cell(params_tbl);
params_struct = cell2struct(params(:, 2), params(:, 1));

end