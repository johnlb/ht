classdef Agilent16802A < htLogicAnalyzers.GenericLA


    properties
        LA
        datapath
        exepath
        sample_depth
        bus_name
    end


    methods

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Class setup/teardown
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Constructor.
        function [this] = Agilent16802A(sample_depth, bus_name)

            this.bus_name = bus_name;

            LA.ProgID = 'AgtLA.Connect';
            LA.IP = 'localhost';

            try
                LA.hConnect = actxserver(LA.ProgID);
            catch
                error('Unable to creat the local COM object.');
            end

            try
                LA.hInst = get(LA.hConnect, 'Instrument', LA.IP);
            catch
                error('Unable to connect to the remote instrument.');
            end

            LA.hModules = LA.hInst.get('Modules');
            strAna = 'Z';

            for i = 0 : (LA.hModules.Count - 1)     
                LA.hModule = get(LA.hModules, 'Item', int32(i));    
                strName = LA.hModule.Name;
                strModel = LA.hModule.Model;
                strType = LA.hModule.Type;
                strSlot = LA.hModule.Slot;
                strStatus = LA.hModule.Status;
                if (strcmp(strModel, '16911A'))
                    strAna = strSlot;
                end
                display([   'Module ' int2str(i) ' "' strName '" is a ' ...
                            strModel ' ' strType ' installed in slot '  ...
                            strSlot ' and is ' strStatus '.'            ]);
            end

            if (strAna ~= 'Z')
                LA.h16911A = get(LA.hModules, 'Item', strAna);       
            end

            this.LA             = LA;
            this.sample_depth   = sample_depth;

        end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Standard Interface.
%       Overloaded functions inherited from GenericPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function run(this)

            display('Running the analyzer...');
            this.LA.hInst.Run(int32(0));
            try
                this.LA.hInst.WaitComplete(100); 
            catch                          
                display ('Timed out.');
            end
            display ('Done.');

        end


        function [data, header] = get_data(this)

            this.LA.hAnalyzerSigs = get(this.LA.h16911A, 'BusSignals');

            this.LA.hData1 = get( ...
                get(this.LA.hAnalyzerSigs, 'Item', this.bus_name), ...
                    'BusSignalData');


            getStart = 0;
            getEnd = this.sample_depth - 1;

            data = this.LA.hData1.GetDataBySample(getStart, getEnd, 3);

            header = {''};

        end


        function [data, header] = run_and_get_data(this)

            this.run()
            [data, header] = this.get_data();

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

    methods(Access=private, Hidden=true)

    end % hidden methods

end % classdef