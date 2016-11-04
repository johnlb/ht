classdef GenericVSG < handle
% Empty definitions for standard interface.

% Note: Need to inherit from 'handle' to ensure deconstructor gets called
%       durring e.g. 'clear all'


    % properties

    %     device
    %     channels

    % end

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


        %% set_channel_freq: Set RF frequency
        function set_channel_freq(this, ch_name, freq)
            this.not_implemented('set_channel_freq');
        end


        %% set_channel_freq: Set RF frequency
        function set_channel_ampl_dbm(this, ch_name, ampl)
            this.not_implemented('set_channel_ampl_dbm');
        end


        %% set_channel_freq: Set RF frequency
        function set_channel_ampl_volts(this, ch_name, ampl)
            this.not_implemented('set_channel_ampl_dbm');
        end
        
        

        function turn_on_channel(this, ch_name)
            this.not_implemented('turn_on_channel');
        end
        

        function turn_off_channel(this, ch_name)
            this.not_implemented('turn_off_channel');
        end


        %% set_ref_clk: sets reference clk for device.
        %%              "source" can be "INT" or "EXT"
        function set_ref_clk(this, source)
            this.not_implemented('set_ref_clk');
        end


        function [state] = channel_is_on(this, ch_name)
            this.not_implemented('channel_is_on');
        end
        



        %% reset: send global reset to awg
        function reset(this)
            this.not_implemented('reset');
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
