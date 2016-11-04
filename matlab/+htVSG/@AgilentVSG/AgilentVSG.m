classdef AgilentVSG < htVSG.VisaVSG
% Initially built for Rigol DG4162.


    properties

        % device
        % channels

    end



    methods


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Class setup/teardown
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Contstructor. Returns new instance of this class.
        function [this] = AgilentVSG(unique_id)
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
            this@htVSG.VisaVSG('GPIB', unique_id, channels)


        end % AgilentVSG


        % Deconstructor. Cleans up when class is destroyed.
        % (inherited from htVSG.VisaVSG)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Standard Interface.
%       Overloaded functions inherited from GenericPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%









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
            %% do nothing.
        end

    end % hidden methods

end % classdef
