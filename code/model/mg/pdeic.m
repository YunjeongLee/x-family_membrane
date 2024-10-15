function u0 = pdeic(x, params)
%% Assign parameters
assign_params(params)

%% Define initial condition
u0 = [V0; P0; R10; R20; zeros(3, 1)];

end