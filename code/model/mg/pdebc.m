function [pl, ql, pr, qr] = pdebc(xl, ul, xr, ur, t, params)
%% Assign parameters
assign_params(params)

%% Define states
V = ul(1);
P = ul(2);
R1 = ul(3);
R2 = ul(4);
VR1 = ul(5);
PR1 = ul(6);
VR2 = ul(7);

%% Define outputs for left boundary
pl = [- (konVR1 * V * R1 - koffVR1 * VR1) - (konVR2 * V * R2 - koffVR2 * VR2); ...
      - (konPR1 * P * R1 - koffPR1 * PR1); ...
      zeros(length(ul)-2, 1)];
ql = ones(length(ul), 1);

%% Define outputs for right boundary
pr = zeros(length(ur), 1);
qr = ones(length(ul), 1);

end