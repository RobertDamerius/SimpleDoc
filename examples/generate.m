% If the SimpleDoc package is not in path
addpath(['..' filesep 'packages']);

% Set title and directories
title           = 'Example';
inputDirectory  = 'input';
outputDirectory = 'output';

% Custom navigation bar layout
layoutNavBar = SimpleDoc.NavEntry.empty();
layoutNavBar(1) = SimpleDoc.NavEntry(SimpleDoc.NavEntryType.none);
layoutNavBar(2) = SimpleDoc.NavEntry(SimpleDoc.NavEntryType.text, 'Custom Text');
layoutNavBar(3) = SimpleDoc.NavEntry(SimpleDoc.NavEntryType.link, 'Template', 'template.html');
layoutNavBar(4) = SimpleDoc.NavEntry(SimpleDoc.NavEntryType.link, 'Lorem Ipsum', 'loremipsum.html');
layoutNavBar(5) = SimpleDoc.NavEntry(SimpleDoc.NavEntryType.none);
layoutNavBar(6) = SimpleDoc.NavEntry(SimpleDoc.NavEntryType.line);
layoutNavBar(7) = SimpleDoc.NavEntry(SimpleDoc.NavEntryType.text, 'EXTERN LINK');
layoutNavBar(8) = SimpleDoc.NavEntry(SimpleDoc.NavEntryType.link, 'SimpleDoc Repository', 'https://github.com/RobertDamerius/SimpleDoc');

% Generate HTML documentation
SimpleDoc.Make(title, inputDirectory, outputDirectory, layoutNavBar);

% View documentation in MATLAB browser
open([outputDirectory filesep 'loremipsum.html']);
