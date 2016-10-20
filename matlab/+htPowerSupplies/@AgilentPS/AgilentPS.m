classdef AgilentPS < htPowerSupplies.VisaPS
% Tested with E3631A

    properties

        % device
        % channels

    end

    methods


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Class setup/teardown
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Contstructor. Returns new instance of this class.
        function [this] = AgilentPS(unique_id)
            % This is what's in the manual...
            channels = {
                % Left-to-Right,
                % as you see it from the front.
                    'P6V',
                    'P25V',
                    'N25V'
                };
            this@FlynnPowerSupplies.VisaPS('GPIB', unique_id, channels)
        end % AgilentPS


        % Deconstructor. Cleans up when class is destroyed.
        % function delete(this)
            
        % end % delete



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Standard Interface.
%       Overload whichever functions you wish to implement.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        

        %% status_channel: Integer indicating status of channel 'ch_name'
        function [status] = status_channel(this, ch_name)
            %% +2 if channel is in CV Mode.
            %% +1 if channel is in CC Mode.
            %%  0 if channel is OFF.
            %% -1 if channel is Unregulated.
            ch_num = this.to_string( this.find_channel_num(ch_name) );
            fprintf(this.device, [':STAT:QUES:INST:ISUM' ch_num ':COND?']);
            status = str2num( fscanf(this.device) );
            if status==3
                status = -1
            end
        end

        function set_channel_current(this, ch_name, amps)
            warning(['Inside "set_channel_current":   ' ...
                    'Aglient E3631A Does not support Isource-mode. Ignored.'])
        end
        

        function set_channel_vlimit(this, ch_name, volts)
            warning(['Inside "set_channel_vlimit":   ' ...
                    'Aglient E3631A Does not support Voltage-limiting. Ignored.'])
        end
        
        function set_channel_source_type(this, ch_name)
            warning(['Inside "set_channel_source_type":   ' ...
                    'Aglient E3631A only supports voltage-source-mode. Ignored.'])
        end

        function set_channel_ilimit(this, ch_name, amps)
            this.select_channel(ch_name)
            cmd_str = [':SOUR:CURR:LEV:IMM:AMPL ' this.to_string(amps) 'A'];
            fprintf(this.device, cmd_str)
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

    methods(Access=protected, Hidden=true)
        %% find_channel_num: finds index of corresponding channel name
        function [ch_num] = find_channel_num(this, ch_name)
            ch_num = -1;
            for ii = 1:length(this.channels)
                if strcmp(this.channels{ii}.ch_name,ch_name)
                    ch_num = ii;
                    break;
                end
            end
       
            if ch_num<0
                error(['Invalid Channel Name "' ch_name '"']) 
            end
        end
    end % hidden methods



end % classdef
