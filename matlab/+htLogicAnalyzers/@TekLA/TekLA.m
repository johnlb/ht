classdef TekLA < htLogicAnalyzers.GenericLA


    properties
        listname
        datapath
        exepath
        sample_depth
    end

    methods

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Class setup/teardown
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %% Constructor.
        function [this] = TekLA(sample_depth, datapath, listname)
            this.sample_depth   = sample_depth;
            this.datapath       = datapath;
            this.listname       = listname;

            % get current path for data dump & exe location
            mpath = mfilename('fullpath');
            pos = strfind(mpath,'\');
            this.exepath = mpath(1:pos(end));

            % Make sure the config file exists in the data directory.
            if not (exist([this.datapath 'tex.config'], 'file') == 2)
                system(['cp ' this.exepath 'tex.config ' this.datapath]);
            end
        end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Standard Interface.
%       Overloaded functions inherited from GenericLA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %% run: runs the logic analyzer
        function run(this)
            runcode = 're';
            system(['"' this.exepath,'tex.exe" ',this.datapath,' ',runcode,' ',this.listname]);
        end
        

        %% get_data: get current data in the logic analyzer's buffer.
        function [data, header] = get_data(this)
            % write data to temp file
            fprintf(1,'reflowing...\n');
            system(['"' this.exepath,'reflow.exe" ' this.datapath]);

            % wait for execution to finish
            % TODO: need to make this automatic
            % pause(5)
            pause(1);
            
            % import temp datafile into matlab
            fprintf(1,'importing data...\n');
            imp = importdata([this.datapath,'tex.txt']);
            header = imp.textdata;
            data = imp.data;

        end


        %% run_and_get_data: runs the logic analyzer & returns data.
        function [data, header] = run_and_get_data(this)
            this.run();
            [data, header] = this.get_data;
        end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Non-Standard Interface.
%       Functions not in Standard Interface.
%       Be careful! These functions are not resuable b/w Power Supplies!
%
%       When adding features, prefer to build into standard interface
%       rather than add non-standard features when it makes sense.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Try not to add things here. 

    end % methods


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Device-Specific Methods.
%       Only use these within other methods. Not part of the interface.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % methods(Access=private, Hidden=true)

    % end % hidden methods

end % classdef