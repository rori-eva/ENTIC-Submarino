close all;
clear all;
clc;

% Opening Serial Port
delete(instrfind);
instrfind;
s = serial('COM3','BaudRate',9600,'Terminator','CR/LF');
warning('off','MATLAB:serial:fscanf:unsuccessfulRead');

f = figure('Name','ROUV depth'); % Window title
lin = line(nan,nan,'Color','r','LineWidth',1);
xlabel('Time[s]');
ylabel('Depth[m]');
title('Depth[m] and Time[s]');
grid on
hold on
% Starting measures from ROUV
fopen(s);
pause(2);

% Initializing
time=zeros(1,1000); 
depth=zeros(1,1000);
n_samples=1;
max_samples=1000;
samples=1:1:1000;
t=0;
tmax = 200; % = 1000 samples / rate
rate = 5;  % Rate: 5 samples/sec
ylim([-10.5 6]);

disp('Starting measures');

%fprintf(s,'%s\n','S'); 

% Starting reading ROUV
pause(2);
% tic  % Initialize clock, use with t=toc

% Timed Loop
while (n_samples<=max_samples)||(t<=tmax)
    %t=toc;
    t = (n_samples-1)/rate;
    xlim([t-5 t+15]);
    
    % Reading Serial Port
    a = fscanf(s,'%d');
    if isnumeric(a)
    %     data_to_voltage = ((a(1)*5)/147.857)/1023;
        data_to_voltage = (a(1)*5)/161.8627/1023;
        depth(n_samples) = (3/0.006)*(data_to_voltage-0.02);
        time(n_samples) = t;

        % Drawing
        if isvalid(lin)
            set(lin,'YData',depth(1:n_samples),'XData',time(1:n_samples));
        end
        drawnow
    end
    n_samples=n_samples+1;
end
%fprintf(s,'%s','E'); %Stoping reading ROUV

% Closing Serial Port
fclose(s);
delete(s);

% Create and fill "resultats.txt"
disp('Creating and filling "resultats.txt"');
dc=fopen('resultats.txt','w');
for i=1:max_samples
    y=[a;time(i);depth(i)]; %copies int variables a,t and x(i) into variable y
    fprintf(dc, '%3d %6d %9d\n',y);
end
fclose(dc);

% Open and plot "resultats.txt"
disp('Opening and plot "resultats.txt"');
dc=fopen('resultats.txt','r');
formatSpec = '%d %f %f';
size_file = [3 Inf];
A = textscan(dc,formatSpec);

x = A{2:1000}; % Column 2
y = A{3:1000}; % Column 3

f = figure('Name','ROUV depth'); % Window title
xlabel('Time[s]');  ylabel('Depth[m]');
title('Depth[m] and Time[s]');
grid on
hold on
plot(x,y);
fclose(dc);