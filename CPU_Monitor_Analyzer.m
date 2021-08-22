%----------------------------------------------%
% Universidad de Costa Rica
% Engineering Faculty
% Electrical Engineering School
% Graduation project: 
% SLAM Algorithms comparison 
% using ROS nodes
%
% Created by: Kevin Trejos Vargas
% email: kevin.trejosvargas@ucr.ac.cr
%
% Description: This script takes a bag file
%     containing SLAM algorithm CPU and MEM usage 
%     messages, then plots and calculates some
%     relevant statistics about them.
%
%
% Instructions for use:
%     1. Modify the bagFilePath to point to your rosbag.
%     2. Modify the cpuMonitorTopic and memMonitorTopic
%        to point to your CPU and MEM tracking topics.
%
% Notes: 
%     1. CPU and MEM usage are taken by using the following repo:
%           https://github.com/alspitz/cpu_monitor.git
%----------------------------------------------%

%% Remove old analysis files

if exist('CPU_MEM_Statistics.png', 'file') == 2
    delete('CPU_MEM_Statistics.png')
end

clear

bagFilePath     = '~/Documents/Pruebas_SLAM/Full Factorial/Tratamiento_9/KartoSLAM_FullFactorial_Tratamiento9_2021-08-21-08-32-17.bag';
cpuMonitorTopic = '/cpu_monitor/slam_karto/cpu';
memMonitorTopic = '/cpu_monitor/slam_karto/mem';

bagselect = rosbag(bagFilePath);

SLAM_CPU_Topic = select(bagselect, 'Topic', cpuMonitorTopic);
SLAM_MEM_Topic = select(bagselect, 'Topic', memMonitorTopic);

CPU_messages = readMessages(SLAM_CPU_Topic, 'DataFormat','struct');
MEM_messages = readMessages(SLAM_MEM_Topic, 'DataFormat','struct');

CPU_Data    = cellfun(@(m) double(m.Data), CPU_messages);
MEM_Data    = cellfun(@(m) double(m.Data), MEM_messages);
MEM_Data_MB = MEM_Data/(1024*1024);                                        % RAM Memory usage in MB

% Generate a figure with all the relevant statistics
f = figure('visible','off');
subplot(2,2,1)
plot(CPU_Data)
ylabel('CPU usage (%)') 
xlabel('Sample') 
title("CPU usage (%)")
subplot(2,2,2)
plot(MEM_Data_MB)
ylabel('Memory usage (MB)') 
xlabel('Sample')  
title("Memory usage (MB)")
subplot(2,2,3)
text(0,0.96,"\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_"  ); axis off
text(0,0.95,"\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_"  ); axis off
text(0,0.8 ,"Mean: "                   ); axis off
text(0.4,0.8, string(mean(CPU_Data))   ); axis off
text(0,0.7 ,"Samples: "                ); axis off
text(0.4,0.7, string(length(CPU_Data)) ); axis off
text(0,0.6 ,"Stdev: "                  ); axis off
text(0.4,0.6, string(std(CPU_Data))    ); axis off
text(0,0.5 ,"Min: "                    ); axis off
text(0.4,0.5, string(min(CPU_Data))    ); axis off
text(0,0.4 ,"Max: "                    ); axis off
text(0.4,0.4, string(max(CPU_Data))    ); axis off
text(0,0.3 ,"Mode: "                   ); axis off
text(0.4,0.3, string(mode(CPU_Data))   ); axis off
text(0,0.2 ,"Median: "                 ); axis off
text(0.4,0.2, string(median(CPU_Data)) ); axis off
text(0,0.16,"\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_"  ); axis off
text(0,0.15,"\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_"  ); axis off
subplot(2,2,4)
text(0,0.96,"\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_"  ); axis off
text(0,0.95,"\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_"  ); axis off
text(0,0.8 ,"Mean: "                     ); axis off
text(0.4,0.8, string(mean(MEM_Data_MB))  ); axis off
text(0,0.7 ,"Samples: "                  ); axis off
text(0.4,0.7, string(length(MEM_Data))   ); axis off
text(0,0.6 ,"Stdev: "                    ); axis off
text(0.4,0.6, string(std(MEM_Data_MB))   ); axis off
text(0,0.5 ,"Min: "                      ); axis off
text(0.4,0.5, string(min(MEM_Data_MB))   ); axis off
text(0,0.4 ,"Max: "                      ); axis off
text(0.4,0.4, string(max(MEM_Data_MB))   ); axis off
text(0,0.3 ,"Mode: "                     ); axis off
text(0.4,0.3, string(mode(MEM_Data_MB))  ); axis off
text(0,0.2 ,"Median: "                   ); axis off
text(0.4,0.2, string(median(MEM_Data_MB))); axis off
text(0,0.16,"\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_"  ); axis off
text(0,0.15,"\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_"  ); axis off
saveas(f,'CPU_MEM_Statistics','png')
