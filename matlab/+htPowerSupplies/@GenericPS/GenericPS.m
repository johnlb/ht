classdef GenericPS < handle
% Empty definitions for standard interface.

% Note: Need to inherit from 'handle' to ensure deconstructor gets called
%       durring e.g. 'clear all'


    properties

    %     device
    %     channels

    end

    methods


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Class setup/teardown
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % % Contstructor. Returns new instance of this class.
        % function [this] = RigolPS(unique_id)

        % end % RigolPS


        % % Deconstructor. Cleans up when class is destroyed.
        % function delete(this)
            
        % end % delete



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Standard Interface.
%       Overload whichever functions you wish to implement.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        % Returns voltage, currenet measured at channel 'ch_name'
        function [voltage, current] = measure_channel(this, ch_name)
            this.not_implemented('measure_channel');
        end % measure_channel


        %% status_channel: Integer indicating status of channel 'ch_name'
        function [status] = status_channel(this, ch_name)
            %% 0 if channel is OK
            %% 1 if over-voltage
            %% 2 if over-current
            this.not_implemented('status_channel');
        end
        %% status_channel: Integer indicating status of channel 'ch_name'

        function set_channel_voltage(this, ch_name, volts)
            this.not_implemented('set_channel_voltage');
        end
        

        function set_channel_current(this, ch_name, amps)
            this.not_implemented('set_channel_current');
        end
        

        function set_channel_vlimit(this, ch_name, volts)
            this.not_implemented('set_channel_vlimit');
        end
        

        function set_channel_ilimit(this, ch_name, amps)
            this.not_implemented('set_channel_ilimit');
        end
        

        function set_channel_source_type(this, ch_name)
            this.not_implemented('set_channel_source_type');
        end
        

        function turn_on_channel(this, ch_name)
            this.not_implemented('turn_on_channel');
        end
        

        function turn_off_channel(this, ch_name)
            this.not_implemented('turn_off_channel');
        end
        



        %% get_channel: returns the initialized Channel obj for channel ch_name
        function [channel] = get_channel(this, ch_name)
            this.not_implemented('get_channel');
        end % get_channel

        %% get_name: returns name of this instance.
        function name = get_name(this)
            name = inputname(1);
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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Local Methods
%       Helpers for the GenericPS class itself. Not meant for use in subclass.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods(Access=private, Hidden=true)

        %% not_implemented: displays a warning about non-implemented methods.
        function not_implemented(this, func_name)
            mc = metaclass(this);
            disp(['Inside ' mc.Name ':'])
            disp(['"' func_name '" hasn''t been implemented yet.'])
        end


    end % private methods

end % classdef
