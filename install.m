fprintf('\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n I N S T A L L   -  SimpleDoc\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n');

% Add directories to MATLAB path
addpath('packages');

% Save path
str = input('Save path? [y]:  ','s');
if(strcmp('y',str))
    fprintf('Saving path\n');
    savepath;
else
    fprintf('Path is not saved\n');
end
fprintf('Installation completed\n');