function Rt = diss_func(t, params)
%% Assign params
assign_params(params)

%% Define the function
Rt = R0 .* exp( -koff .* t);
end