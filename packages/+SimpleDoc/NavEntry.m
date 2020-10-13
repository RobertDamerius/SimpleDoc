classdef NavEntry
    %SimpleDoc.NavEntry An entry for the navigation bar. This class can be used to create a custom navigation bar when the
    % documentation is created with SimpleDoc.Make.
    % 
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Version     Author                 Changes
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % 20201013    Robert Damerius        Initial release.
    % 
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    properties
        type;    % The type of the navigation entry of datatype SimpleDoc.NavEntryType.
        name;    % A character vector representing the name of the navigation entry.
        link;    % A character vector representing the link address.
    end
    methods
        function this = NavEntry(type, name, link)
            %SimpleDoc.NavEntry.NavEntry Create a navigation entry.
            % 
            % PARAMETERS
            % type  ... The type of the navigation entry of datatype SimpleDoc.NavEntryType. Default value is SimpleDoc.NavEntryType.none.
            % name  ... A character vector representing the name of the navigation entry. Default value is ''.
            % link  ... A character vector representing the link address. Default value is ''.
            this.type = SimpleDoc.NavEntryType.none;
            this.name = char.empty();
            this.link = char.empty();
            if(nargin), this.type = type; end
            if(nargin > 1), this.name = name; end
            if(nargin > 2), this.link = link; end
            assert(this.IsValid(),'Invalid datatype for parameter "type", "name" and/or "link"!');
        end
        function valid = IsValid(this)
            %SimpleDoc.NavEntry.IsValid Check whether the properties of this navigation entry are valid or not.
            % 
            % RETURN
            % valid ... True if all properties of this class are valid, false otherwise.
            valid = isa(this.type, 'SimpleDoc.NavEntryType') && ischar(this.name) && ischar(this.link);
        end
    end
end

