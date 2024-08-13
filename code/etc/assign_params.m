function [] = assign_params(parameter_struct)
names = fieldnames(parameter_struct);
for i = 1:length(names)
    assignin("caller", names{i}, parameter_struct.(names{i}));
end