function Make(title, inputDirectory, outputDirectory, layoutNavBar)
    %SimpleDoc.Make Generate an HTML documentation from input text files. The plain text is embedded directly into the HTML page. HTML commands
    % can be written into the input text file. SimpleDoc.Make generates some HTML around the input text and also generates a navigation bar.
    % 
    % 
    % PARAMETER
    % =========
    % title            ... Title of the documentation.
    % inputDirectory   ... Input directory containing the text files to be converted.
    % outputDirectory  ... Output directory in which the html files should be written.
    % layoutNavBar     ... A list of SimpleDoc.NavEntry objects that represent a custom navigation bar layout.
    % 
    % 
    % NAVIGATION BAR
    % ==============
    % The navigation bar is created automatically. Each page is included in the navigation bar. The file name is used to sort the
    % entries of the navigation bar. The displayed text corresponds to the first main title (<h1></h1>) that appears on a page, or
    % the file name if there is no main title.
    % If the customNavBar parameter is specified, the navigation bar is created based on this list.
    % 
    % 
    % HOW TO USE
    % ==========
    % Add all text files to the input folder and run SimpleDoc.Make.
    % 
    % 
    % NOTES
    % =====
    % Only txt files are processed. All text files in the input directory are converted to html files in the output directory. The
    % output directory is deleted and created anew each time. Relative links always refer to the output directory.
    % 
    % 
    % USEFUL COMMANDS
    % ===============
    % Heading (layer 1)             ...   <h1>Heading</h1>
    % 
    % Heading (layer 2)             ...   <h2>Heading</h2>
    % 
    % Heading (layer 3)             ...   <h3>Heading</h3>
    % 
    % Heading (layer 4)             ...   <h4>Heading</h4>
    % 
    % Line break                    ...   <br>
    % 
    % Code section                  ...   <code>Text with code style</code>
    % 
    % Link to another page          ...   <a href="another_page.html">click me</a>
    % 
    % Image (relative to output)    ...   <img src="path/to/image.jpg">
    % 
    % SVG (relative to output)      ...   <object data="path/to.svg" type="image/svg+xml"></object>
    % 
    % Note section (blue)           ...   <div class="note-blue">
    %                                     <h3 class="note-blue">Blue Note</h3>
    %                                     This is an example for a blue note.
    %                                     </div>
    % 
    % Note section (green)          ...   <div class="note-green">
    %                                     <h3 class="note-green">Green Note</h3>
    %                                     This is an example for a green note.
    %                                     </div>
    % 
    % Note section (orange)         ...   <div class="note-orange">
    %                                     <h3 class="note-orange">Orange Note</h3>
    %                                     This is an example for an orange note.
    %                                     </div>
    % 
    % Note section (red)            ...   <div class="note-red">
    %                                     <h3 class="note-red">Red Note</h3>
    %                                     This is an example for a red note.
    %                                     </div>
    % 
    % Directory/File list           ...   <ul class="dir">
    %                                         <li>Directory A</li>
    %                                         <li>Directory B</li>
    %                                     </ul>
    %                                     <ul class="file">
    %                                         <li>File A</li>
    %                                         <li>File B</li>
    %                                     </ul>
    % 
    % Equation                      ...   \[ E = m c^2 \]
    %                                     \( E = m c^2 \)
    % 
    % 
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Version     Author                 Changes
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % 20201010    Robert Damerius        Initial release.
    % 20201012    Robert Damerius        fwrite() is now writing with UTF-8, rmdir() now removes non-empty directories. Equations
    %                                    are enumerated automatically.
    % 20201013    Robert Damerius        Added custom navigation bar.
    % 
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % Get absolute path to data directory
    fullpath = mfilename('fullpath');
    filename = mfilename();
    thisDirectory = fullpath(1:(end-length(filename)));

    % Check for correct arguments
    strTitle = '';
    strInput = '';
    strOutput = 'html';
    navBar = SimpleDoc.NavEntry.empty();
    if(nargin > 0), strTitle = title; end
    if(nargin > 1), strInput = inputDirectory; end
    if(nargin > 2), strOutput = outputDirectory; end
    if(nargin > 3), navBar = layoutNavBar; end
    assert((ischar(strTitle)) && (size(strTitle,1) < 2), 'Input "title" must be a character vector!');
    assert((ischar(strInput)) && (size(strInput,1) < 2), 'Input "input" must be a character vector!');
    assert((ischar(strOutput)) && (size(strOutput,1) < 2), 'Input "output" must be a character vector!');
    assert(isa(navBar,'SimpleDoc.NavEntry'), 'Input "layoutNavBar" must be a vector of SimpleDoc.NavEntry elements!');
    if(~isempty(navBar))
        assert((1 == size(navBar,1)) || (1 == size(navBar,2)), 'Input "layoutNavBar" must be vector of dimension N-by-1 or 1-by-N!');
    end
    if(isempty(strInput)), strInput = '.'; end
    if(isempty(strOutput)), strOutput = '.'; end
    if(strInput(end) ~= filesep), strInput = [strInput filesep]; end
    if(strOutput(end) ~= filesep), strOutput = [strOutput filesep]; end
    title = strTitle;
    inputDirectory = strInput;
    outputDirectory = strOutput;
    layoutNavBar = navBar;
    fprintf('\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n');
    fprintf('%s\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n',filename);
    fprintf('title:  "%s"\ninput:  "%s"\noutput: "%s"\n\n',title,inputDirectory,outputDirectory);

    % Delete and create output directory
    [~,~] = rmdir(strOutput,'s');
    [~,~] = mkdir(strOutput);

    % Unzip core data (Desgin, MathJax) to output directory
    unzip([thisDirectory 'core.zip'], [outputDirectory 'core' filesep]);

    % Scan input directory
    listing = dir([inputDirectory '*.txt']);
    inputFiles = cell.empty();
    for i = 1:length(listing)
        if(listing(i).isdir)
            continue;
        end
        inputFiles = [inputFiles; {listing(i).name}];
    end

    % Get navigation bar entries
    navBarEntryNames = GetNavBarEntryNames(inputDirectory, inputFiles);

    % Process all files
    htmlVersion = GenerateVersionString();
    for i = 1:length(inputFiles)
        % Get input filename without path and extension
        filenameOnly = inputFiles{i}(1:end-4);
        fprintf('Generating "%s": ',filenameOnly);

        % Generate navigation bar
        htmlNavigationBar = GenerateHTMLNavigation(layoutNavBar, navBarEntryNames, inputFiles, i);

        % Generate content from input text file
        htmlContent = GenerateHTMLContent(inputDirectory, inputFiles{i});

        % Create final HTML page
        html = GenerateHTML(title, htmlVersion, htmlNavigationBar, htmlContent);
        outputFile = [outputDirectory filenameOnly '.html'];
        fileID = fopen(outputFile, 'w', 'native', 'UTF-8');
        fwrite(fileID,unicode2native(html, 'UTF-8'));
        fclose(fileID);
        fprintf('OK\n');
    end
    fprintf('\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n');
end


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% PRIVATE HELPER FUNCTIONS
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function navBarEntryNames = GetNavBarEntryNames(inputDirectory, inputFiles)
    navBarEntryNames = inputFiles;
    for i = 1:length(inputFiles)
        % Fallback name (file name without extension)
        navBarEntryNames{i} = inputFiles{i}(1:end-4);

        % Read content of input text file
        inputFile = [inputDirectory inputFiles{i}];
        [fileID,errmsg] = fopen(inputFile,'r');
        if(fileID < 0)
            warning(['Could not open "' filename '": ' errmsg]);
            continue;
        end
        txtContent = fread(fileID,'*char')';
        fclose(fileID);

        % Search for first h1 caption and use it as name
        idxStart = strfind(txtContent,'<h1>');
        idxEnd = strfind(txtContent,'</h1>');
        if(~isempty(idxStart) && ~isempty(idxEnd))
            navBarEntryNames{i} = txtContent((idxStart(1) + 4):(idxEnd(1) - 1));
        end
    end
end

function htmlVersion = GenerateVersionString()
    localTime = datetime();
    htmlVersion = sprintf('Version %04d%02d%02d',localTime.Year,localTime.Month,localTime.Day);
end

function htmlNavigationBar = GenerateHTMLNavigation(layoutNavBar, navBarEntryNames, inputFiles, idxCurrent)
    % Begin navigation bar
    LF = char(uint8(10));
    htmlNavigationBar = ['<ul class="ulnav">' LF];

    % If custom navigation bar layout is empty create navigation based on sorted file names
    if(isempty(layoutNavBar))
        % Sort file names
        inputFiles = sort(inputFiles);

        % Generate entries
        for i = 1:length(inputFiles)
            % Relative link address
            destination = [inputFiles{i}(1:end-3) 'html'];

            % Name of navigation bar entry
            name = navBarEntryNames{i};

            % Generate HTML string
            if(strcmp(inputFiles{idxCurrent},inputFiles{i}))
                htmlNavigationBar = [htmlNavigationBar '<li class="linav_active"><a href="' destination '">' name '</a></li>' LF];
            else
                htmlNavigationBar = [htmlNavigationBar '<li class="linav"><a href="' destination '">' name '</a></li>' LF];
            end
        end
    else
        % HTML filename of this file
        thisName = [inputFiles{idxCurrent}(1:end-3) 'html'];

        % Generate entries based on layout
        for i = 1:length(layoutNavBar)
            switch(layoutNavBar(i).type)
                case SimpleDoc.NavEntryType.none
                    htmlNavigationBar = [htmlNavigationBar '<li class="linone"></li>' LF];
                case SimpleDoc.NavEntryType.line
                    htmlNavigationBar = [htmlNavigationBar '<li class="liline"></li>' LF];
                case SimpleDoc.NavEntryType.text
                    htmlNavigationBar = [htmlNavigationBar '<li class="litext">' layoutNavBar(i).name '</li>' LF];
                case SimpleDoc.NavEntryType.link
                    if(strcmp(thisName, layoutNavBar(i).link))
                        htmlNavigationBar = [htmlNavigationBar '<li class="linav_active"><a href="' layoutNavBar(i).link '">' layoutNavBar(i).name '</a></li>' LF];
                    else
                        htmlNavigationBar = [htmlNavigationBar '<li class="linav"><a href="' layoutNavBar(i).link '">' layoutNavBar(i).name '</a></li>' LF];
                    end
            end
        end
    end

    % End navigation bar
    htmlNavigationBar = [htmlNavigationBar '</ul>' LF];
end

function htmlContent = GenerateHTMLContent(inputDirectory, inputFile)
    % Absolute path to input file
    filename = [inputDirectory inputFile];

    % Open file and read data
    [fileID,errmsg] = fopen(filename,'r');
    if(fileID < 0)
        warning(['Could not open "' filename '": ' errmsg]);
        return;
    end
    txtContent = fread(fileID,'*char')';
    fclose(fileID);

    % Replace non-printable characters by LF
    HT = char(uint8(9));
    LF = char(uint8(10));
    for i = 1:length(txtContent)
        if(uint8(HT) == uint8(txtContent(i))), continue; end
        %if(uint8(LF) == uint8(txtContent(i))), continue; end
        if(uint8(txtContent(i)) >= uint8(32)), continue; end
        txtContent(i) = LF;
    end
    htmlContent = txtContent;
end

function html = GenerateHTML(title, htmlVersion, htmlNavigation, htmlContent)
    LF = char(uint8(10));
    html = [ ...
        '<!DOCTYPE html>' LF ...
        '<html>' LF ...
        '<head>' LF ...
        '<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>' LF ...
        '<meta name="viewport" content="width=device-width, initial-scale=1"/>' LF ...
        '<title>' title '</title>' LF ...
        '<link rel="stylesheet" href="core/design.css">' LF ...
        '<script>MathJax = { tex: {tags: ''ams''}};</script>' LF ...
        '<script id="MathJax-script" async src="core/mathjax/tex-chtml.js"></script>' LF ...
        '</head>' LF ...
        '<body>' LF ...
        '<header>' LF ...
        '<div class="header_title">' title '</div>' LF ...
        '<div class="header_version">' htmlVersion '</div>' LF ...
        '</header>' LF ...
        '<button onclick="PageToTop()" id="buttonToTop"></button>' LF ...
        '<div class="wrapper">' LF ...
        '<div class="navigation">' LF ...
        htmlNavigation LF ...
        '</div>' LF ...
        '<div class="content">' LF ...
        htmlContent LF ...
        '</div>' LF ...
        '</div>' LF ...
        '<script src="core/script.js"></script>' LF ...
        '</body>' LF ...
        '</html>' LF ...
        ];
end

