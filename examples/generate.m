% If the SimpleDoc package is not in path
addpath(['..' filesep 'packages']);

% Set title and directories
title           = 'Example';
inputDirectory  = 'input';
outputDirectory = 'output';

% Generate HTML documentation
SimpleDoc.Make(title, inputDirectory, outputDirectory);

% View documentation in MATLAB browser
open([outputDirectory filesep 'loremipsum.html']);
