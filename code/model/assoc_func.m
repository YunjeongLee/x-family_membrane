function Rt = assoc_func(t, params)
%% Assign params
assign_params(params);

%% Define Rt equation
Kd = koff/kon;

Rt = Rmax .* conc ./ (Kd + conc) .* (1 - exp( -(kon .* conc + koff).* t ) );

end