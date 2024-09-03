function [c, f, s] = pdefun(x, t, u, dudx, params)
%% Assign parameters
assign_params(params)

%% Define states
V = u(1);
P = u(2);
R1 = u(3);
R2 = u(4);
VR1 = u(5);
PR1 = u(6);
VR2 = u(7);

%% Define c(x, t, u, du/dx)
c = ones(length(u), 1);

%% Define f(x, t, u, du/dx)
f = [Dv; Dp; zeros(length(u)-2, 1)] .* dudx;

%% Define s(x, t, u, du/dx)
s = [0; 0; ...
     s_R1 - kint_free * R1 - (konVR1 * V * R1 - koffVR1 * VR1) - (konPR1 * P * R1 - koffPR1 * PR1); ...
     s_R2 - kint_free * R2 - (konVR2 * V * R2 - koffVR2 * VR2);...
     - kint_bound * VR1 + (konVR1 * V * R1 - koffVR1 * VR1); ...
     - kint_bound * PR1 + (konPR1 * P * R1 - koffPR1 * PR1); ...
     - kint_bound * VR2 + (konVR2 * V * R2 - koffVR2 * VR2); ...
    ];

end