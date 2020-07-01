% A simple oscilloscope & spectrum analyzer using a sound card
% Configure your PC to use microphone as input and adjust the mic volume.
% Written by Sae-Young Chung, 2013
% Last update: 2016/2/29

fs=44100;       % sampling rate
period=0.2;    % update figure every 50msec
duration=0.02;	% duration of samples to show (20 msec)

n=floor(fs*period);	% # of samples in each update
t=(0:n-1)/fs;		% time vector
n2=floor(n/2);
fft_size=2^ceil(log2(n));   % nearest power of 2
max_harmonic=10;    % up to 10th harmonic

d=daq.getDevices;   % list of data acquisition (daq) devices
dev=d(1);           % select the first one

s=daq.createSession('directsound'); % create a daq session
addAudioInputChannel(s, dev.ID, 1:2);  % add audio channel
s.IsContinuous=true;    % continuous mode for continuously capturing audio
s.Rate=fs;              % set the sampling rate
s.NotifyWhenDataAvailableExceeds=n;
    % If 's.NotifyWhenDataAvailableExceeds' samples are available,
    % 'DataAvailable' event occurs.

figure		% new figure window
subplot(1,2,1);                 % create a 1x2 figure window & choose the first window
h1=plot(1000*t,zeros(1,n));   	% initial plot for the left figure
title('Oscilloscope')           % title for the left figure
xlabel('Time [msec]')           % x label
ylabel('Amplitude')             % y label
grid on                         % turn on the grid
axis([0 1000*duration -1 1]) % set the ranges of x and y axes

subplot(1,2,2);                 % now choose the second window
h2=plot((0:fft_size/2-1)*fs/fft_size,zeros(1,fft_size/2),zeros(1,max_harmonic),zeros(1,max_harmonic),'o'); 
    % initial plot for the right figure. h2 contains two handles.
    % h2(1) is the handle for the first solid curve, i.e., (0:fft_size/2-1)*fs/fft_size,zeros(1,fft_size/2)
    % h2(2) is the handle for the second 'o' plot, i.e., zeros(1,max_harmonic),zeros(1,max_harmonic),'o'
title('Spectrum Analyzer')      % title for the right figure
xlabel('Frequency [Hz]')        % x label
ylabel('Power [dB]')            % y label
grid on                         % turn on the grid
axis([0 5000 -60 60]) % set the ranges of x and y axes

if ~exist('lab1c_plot.m')
    error('File lab1c_plot.m does not exit. Make sure all required files are in the current working directory of matlab.');
end

clear lab1c_plot plotFunc       % clear if they already exist in the cache

plotFunc = @(src, event) lab1c_plot(src, event, h1, h2);
    % define a function plotFunc that calls lab1c_plot.m
    % passing 'h1' and 'h2' in addition to 'src' and 'event' that are passed
    % by the event handler
listener=addlistener(s, 'DataAvailable', plotFunc);
    % call plotFunc every time 'DataAvailable' event occurs
    % 'DataAvailable' event will occur whenever s.NotifyWhenDataAvailableExceeds
    % samples are available

startBackground(s)
