

for houseKeeping = 1:1
    if (exist('FPGA','var'))
        if(isopen(FPGA))
            fprintf('closing FrontPanel connection before code start (housekeeping)\n')
            calllib('okFrontPanel', 'okFrontPanel_Destruct', kill_ptr);
            %Prevent MatLab crashing by future references of these
            clear FPGA kill_ptr
        end
    end
    
    
    close all
    clear all
    clc
    format shorteng
end

% ---------------------- Configurations  ----------------------

isLoadFPGA = 1; % Do you want to load the FPGA bitfile ('program') ?
isVerbose = 1; % want matlab error & flow messages ?
isDebug = 1; % prints even more messages, for trouble shooting


% ---------------------- Setup the FPGA (you need to change paths for your project) ----------------------

for initialization = 1:1
    % stuff for OpalKelly
    path(path, 'C:\Users\johnlb\Desktop\OpalKelly_SPI\FPGA test') % this folder has the code for talking with the FPGA
    Testing_top_dir = 'C:\Users\johnlb\Desktop\OpalKelly_SPI'; % the folder you run your testing from
    FPGA_bit_file = 'C:\Users\johnlb\Desktop\OpalKelly_SPI\FPGA test\fp_to_ok_top.bit'; % the location/name of the bitfile
    
    % to use Yong's LA code
    % path(path, 'C:\Users\fbuhler\Desktop\My Stuff\CS\Matlab\ISSCC_2016_CS\Yongs_Code')
    
    cd(Testing_top_dir);
    
    %  Get the FPGA ready for talking to the IC
    try
        [FPGA, kill_ptr] = setup_FPGA_CS(isLoadFPGA, FPGA_bit_file);
    catch ME
        if (exist('FPGA','var'))
            fprintf('\n\nError found, closing FrontPanel connection \n\n');
            cd('@okusbfrontpanel')
            calllib('okFrontPanel', 'okFrontPanel_Destruct', kill_ptr);
            cd(Testing_top_dir)
        else
            fprintf('\n\nError found, can''t close FrontPanel connection,\n please cycle FPGA power\n\n');
        end
        str = sprintf('%s\n%s\n\n',ME.identifier, ME.message);
        fprintf(str)
        rethrow(ME);
    end %try/catch
    
    % return to core directory (because the FPGA function changes it)
    cd(Testing_top_dir);
end



SPI_EN_CH = 0; % only one SPI device
data_len = 33;

% --- SPI register address (7 bit) and data (24 bit) --- %

RW = 1; % 0: Read, 1: Write
if RW==0
    set_RW = '0';
else
    set_RW = '1';
end
set_address = ['000' '0001'];
set_data = ['0000' '0000' '0000' '0000' '1111' '1101'];

% ------------------------------------------------------ %


        % packet = fliplr(['1', dec2bin(0,7), '0000' '0000' '0000' '0000' '0000' '0000' '0']);
        % MISO = send_CS_SPI_Packet(isDebug, FPGA, SPI_EN_CH, packet, data_len) % SPI parameters can be changed inside this function


        packet = fliplr(['1', dec2bin(1,7), '0000' '0000' '0000' '0000' '0000' '0000' '0']);
        MISO = send_CS_SPI_Packet(isDebug, FPGA, SPI_EN_CH, packet, data_len) % SPI parameters can be changed inside this function


        % packet = fliplr(['1', dec2bin(1,7), '0000' '0000' '0000' '0000' '0000' '1000' '0']);
        % MISO = send_CS_SPI_Packet(isDebug, FPGA, SPI_EN_CH, packet, data_len) % SPI parameters can be changed inside this function


% end

if RW==0
    DataOut = [fliplr(MISO(20:23)) ' ' fliplr(MISO(16:19)) ' ' fliplr(MISO(12:15)) ' ' ...
        fliplr(MISO(8:11)) ' ' fliplr(MISO(4:7)) ' ' fliplr(MISO(1:3)) 'x']
end

for cleanUp = 1:1
    clearvars initialization
    % Close the FrontPannel connection if no error occured
    cd(Testing_top_dir);
    if (exist('FPGA','var'))
        if(isopen(FPGA))
            if(isVerbose)
                fprintf('Code finished, closing FrontPanel connection...\n')
            end
            calllib('okFrontPanel', 'okFrontPanel_Destruct', kill_ptr);
            %Prevent MatLab crashing by future references of these
            clear FPGA kill_ptr
        end
    end
end
clearvars cleanUp doStuff











