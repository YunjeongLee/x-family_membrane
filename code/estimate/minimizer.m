function [theta, cost_val, cal_time] = minimizer(data, cost, params, theta0, lb, ub, nonlcon)
options = optimset();
tic;
if(nargin < 5) || ( isempty(lb) && ( isempty(ub) ) )
    [theta, ~] = fminsearch(@(theta) cost( data, params, theta ), theta0, options );
elseif (nargin < 7) || isempty(nonlcon)
    [theta, ~] = fminsearchbnd(@(theta) cost( data, params, theta ), theta0, lb, ub, options );
else
    [theta, ~] = fminsearchcon(@(theta) cost( data, params, theta ), theta0, lb, ub, [], [], nonlcon, options);
end
cost_val = cost( data, params, theta );
cal_time = toc;