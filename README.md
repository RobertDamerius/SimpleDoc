# SimpleDoc

Documentation is an important and helpful component to describe additional information for a project.
Web-based documentation is particularly advantageous because many media data can be easily integrated and displayed in modern browsers.
In addition, links to other sites can be easily implemented.
Many tools also offer an HTML export so that it is possible to create a complete documentation.
SimpleDoc is a MATLAB package that allows you to create a very simple HTML-based documentation.
The documentation is designed so that no additional applications need to be installed.
As long as a web browser is available, the documentation created can be displayed offline on any device.
The directory structure of this repository is as follows.

| File / Directory   | Description                                                                            |
| :----------------- | :------------------------------------------------------------------------------------- |
| examples           | contains a sample documentaion                                                         |
| packages           | contains the SimpleDoc MATLAB-package                                                  |
| LICENSE            | license information                                                                    |
| README.md          | this file                                                                              |
| install.m          | MATLAB script to install the package                                                   |
| uninstall.m        | MATLAB script to uninstall the package                                                 |


### Revision History
| Date        | Version  | Description                           |
| :---------- | :------- | :------------------------------------ |
| 2020-10-10  | 1.0      | Initial release                       |


## How To Install
Clone this repository into a desired directory and execute the `install.m` script in MATLAB.
The script simply adds the `packages` directory to the MATLAB path.
If the path should be removed again, the `uninstall.m` script can be called.


## How To Use
Call the function `SimpleDoc.Make` and enter the title for the documentation and the input and output directory.
All text files in the input directory are read and then written to the corresponding HTML files with the same name in the output directory.
The navigation bar is created automatically.
Each page is included in the navigation bar.
The file name is used to sort the entries of the navigation bar.
The displayed text corresponds to the first main title (`<h1></h1>`) that appears on a page, or the file name if there is no main title.


### MathJax
The MATLAB package contains [MathJax](https://github.com/mathjax/MathJax) which is used to draw mathematical equations.
