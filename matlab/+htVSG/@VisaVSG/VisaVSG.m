classdef VisaVSG < htVSG.GenericVSG
% Implements many common functions for VISA-Based power supplies.

% Note: Need to inherit from 'handle' to ensure deconstructor gets called
%       durring e.g. 'clear all'


    properties

        device
        channels

    end



    methods


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Class setup/teardown
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Contstructor. Returns new instance of this class.
        function [this] = VisaVSG(comm_type, unique_id, channel_names)
            % Ex: Instrument address is 'GPIB0::6::INSTR'
            %
            % comm_type = 'GPIB'
            % unique_id = '6'

            comm_type = upper(comm_type);
            hwinfo = instrhwinfo('visa', 'ni');

            constructors = hwinfo.ObjectConstructorName;
            constructor_text = '';
            for ii = 1:length(constructors)
                c = constructors{ii};
                res = regexp(c, [comm_type '.*::' unique_id '::']);
                if ~isempty(res)
                    constructor_text = c;
                    break
                end
            end

            if strcmp(constructor_text,'')
                error(['Can''t find ' comm_type ' Device ''', ...
                        unique_id '''. ', 'Is is powered on & plugged in?'])
            end

            this.device = eval(constructor_text);
            fopen(this.device)


            % create channels
            this.channels = {};
            for ii = 1:length(channel_names)
                this.channels{ii} = htVSG.Channel(this, ...
                                            channel_names{ii});
            end


        end % VisaVSG


        % Deconstructor. Cleans up when class is destroyed.
        function delete(this)
            if ~isempty(this.device)
                fclose(this.device)
            end
        end % delete


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Standard Interface.
%       Overloaded functions inherited from GenericPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %% set_channel_freq: Set RF frequency
        function set_channel_freq(this, ch_name, freq)
            this.select_channel(ch_name)
            cmd_str = sprintf(':SOURce:FREQ:FIX %f', freq);
            fprintf(this.device, cmd_str)
        end


        %% set_channel_ampl_dbm: Set RF amplitude, in dBm
        function set_channel_ampl_dbm(this, ch_name, ampl)
            this.select_channel(ch_name)
            cmd_str = sprintf(':SOURce:POWer:LEVel:IMM:AMPL %fDBM', ampl);
            fprintf(this.device, cmd_str)
        end


        %% set_channel_ampl: Set RF amplitude, in volts
        function set_channel_ampl_volts(this, ch_name, ampl)
            this.select_channel(ch_name)
            cmd_str = sprintf(':SOURce:POWer:LEVel:IMM:AMPL %fV', ampl);
            fprintf(this.device, cmd_str)
        end


        %% set_ref_clk: sets reference clk for device.
        %%              "source" can be "INT" or "EXT"
        function set_ref_clk(this, source)
            this.select_channel(ch_name)
            cmd_str = [':SYSTem:ROSCillator:SOURce ' source];
            fprintf(this.device, cmd_str)
        end
        

        function turn_on_channel(this, ch_name)
            this.select_channel(ch_name)
            cmd_str = [':OUTP:STAT ON'];
            fprintf(this.device, cmd_str)
        end
        

        function turn_off_channel(this, ch_name)
            this.select_channel(ch_name)
            cmd_str = [':OUTP:STAT OFF'];
            fprintf(this.device, cmd_str)
        end
        

        function [state] = channel_is_on(this, ch_name)
            this.select_channel(ch_name)
            cmd_str = [':OUTP:STAT?'];
            fprintf(this.device, cmd_str)
            state = fscanf(this.device);
            state = str2num(state) > 0;
        end



        %% reset: send global reset to awg
        function reset(this)
            fprintf(this.device, '*RST')
        end


        %% get_channel: returns the initialized Channel obj for channel ch_num
        %%              ch_num can be 1..N, where ch_num(1) is leftmost channel
        %%              and ch_num(N) is rightmost channel on the front pannel
        function [channel] = get_channel(this, ch_num)
            channel = this.channels{ch_num};
        end % get_channel

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

    methods(Access=protected, Hidden=true)

        function select_channel(this, ch_name)
            if strcmp(ch_name,'')
                return
            end
            fprintf(this.device, [':INST:SEL ' ch_name]);
        end

        function str = to_string(this, num)
            str = sprintf('%f',num);
        end

    end % hidden methods

end % classdef
