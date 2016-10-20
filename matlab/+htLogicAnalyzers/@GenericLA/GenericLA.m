classdef GenericLA < handle
% Empty definitions for standard interface.

% Note: Need to inherit from 'handle' to ensure destructor gets called
%       durring system clean-up (e.g. 'clear all')

    properties
    % Define these in subclass:
        % LA
        % datapath
        % exepath
        % sample_depth
    end

    % properties(Access=private)
        
    % end

    methods

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Class setup/teardown
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % % Constructor.
        % function [this] = Agilent16802A(sample_depth)

        % end

        % % Destructor. Cleans up when class is destroyed.
        % function delete(this)
            
        % end % delete


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Standard Interface.
%       Overloaded functions inherited from GenericPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function run(this)
            this.not_implemented('run');
        end


        function [data, header] = get_data(this)
            this.not_implemented('get_data');
        end


        function [data, header] = run_and_get_data(this)
            this.not_implemented('run_and_get_data');
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












%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Local Methods
%       Helpers for the GenericPS class itself. Not for use in subclass.
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