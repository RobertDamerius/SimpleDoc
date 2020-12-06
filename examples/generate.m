% If the SimpleDoc package is not in path
addpath(['..' filesep 'packages']);

% Set title and directories
title           = 'Example';
inputDirectory  = 'input';
outputDirectory = 'output';

% Custom navigation bar layout
layoutNavBar = [
    SimpleDoc.NavEntry(SimpleDoc.NavEntryType.none);
    SimpleDoc.NavEntry(SimpleDoc.NavEntryType.text, 'Custom Text');
    SimpleDoc.NavEntry(SimpleDoc.NavEntryType.link, 'Template', 'template.html');
    SimpleDoc.NavEntry(SimpleDoc.NavEntryType.link, 'Lorem Ipsum', 'loremipsum.html');
    SimpleDoc.NavEntry(SimpleDoc.NavEntryType.none);
    SimpleDoc.NavEntry(SimpleDoc.NavEntryType.line);
    SimpleDoc.NavEntry(SimpleDoc.NavEntryType.text, 'EXTERN LINK');
    SimpleDoc.NavEntry(SimpleDoc.NavEntryType.link, 'SimpleDoc Repository', 'https://github.com/RobertDamerius/SimpleDoc');
];

% Generate HTML documentation
SimpleDoc.Make(title, inputDirectory, outputDirectory, layoutNavBar);

% View documentation in MATLAB browser
open([outputDirectory filesep 'loremipsum.html']);
