classdef KeithleyPS < htPowerSupplies.VisaPS
% Initially built for Rigol DP832.

% Note: Need to inherit from 'handle' to ensure deconstructor gets called
%       durring e.g. 'clear all'


    properties

        % device
        % channels

    end



    methods


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Class setup/teardown
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Contstructor. Returns new instance of this class.
        function [this] = KeithleyPS(unique_id)
            % You can find the DP8xx's unique_id by pressing 'utility'.
            % On the bottom of the screen, you will see something like:
            %
            % USB0::0x1AB1::0x0E11::DP8C161650549::INSTR
            %
            % In this case, the unique_id would be 'DP8C161650549'

            channels = {
                % Left-to-Right,
                % as you see it from the front.
                    ''
                };
            this@htPowerSupplies.VisaPS('GPIB', unique_id, channels)


        end % KeithleyPS


        % % Deconstructor. Cleans up when class is destroyed.
        % function delete(this)
        %     fclose(this.device)
        % end % delete


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Standard Interface.
%       Overloaded functions inherited from GenericPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function set_channel_voltage(this, ch_name, volts)
            this.select_channel(ch_name)
            cmd_str = [':SOUR:VOLT:LEV:IMM:AMPL ' this.to_string(volts)];
            fprintf(this.device, cmd_str)
        end
        

        function set_channel_current(this, ch_name, amps)
            this.select_channel(ch_name)
            cmd_str = [':SOUR:CURR:RANGE ' this.to_string(amps)];
            fprintf(this.device, cmd_str)

            cmd_str = [':SOUR:CURR ' this.to_string(amps)];
            fprintf(this.device, cmd_str)
        end
        

        function set_channel_vlimit(this, ch_name, volts)
            this.select_channel(ch_name)
            cmd_str = [':SENS:VOLT:PROT:LEV ' this.to_string(volts)];
            fprintf(this.device, cmd_str)
        end
        

        function set_channel_ilimit(this, ch_name, amps)
            this.select_channel(ch_name)
            cmd_str = [':SENS:CURR:PROT:LEV ' this.to_string(amps)];
            fprintf(this.device, cmd_str)
        end

        function [status] = status_channel(this, ch_name)
            warning('"status_channel" not implemented yet for KeithleyPS');
            status = 2;
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
