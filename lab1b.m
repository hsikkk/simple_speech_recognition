% A simple oscilloscope using a sound card
% Configure your PC to use microphone as input and adjust the mic volume.
% Written by Sae-Young Chung, 2013
% Last update: 2016/2/29

fs=11025;	    % sampling rate
period=0.02;    % update figure every 20msec
duration=0.02;	% duration of samples to show (20 msec)

n=floor(fs*period);	% # of samples in each update
t=(0:n-1)/fs;		% time vector

d=daq.getDevices;   % list of data acquisition (daq) devices
dev=d(1);           % select the first one

s=daq.createSession('directsound'); % create a daq session
addAudioInputChannel(s, dev.ID, 1:2);  % add audio channel
s.IsContinuous=true;    % continuous mode for continuously capturing audio
s.Rate=fs;              % set the sampling rate
s.NotifyWhenDataAvailableExceeds=n;
    % If 's.NotifyWhenDataAvailableExceeds' samples are available,
    % 'DataAvailable' event occurs.

figure                  % start a new plot
h=plot(1000*t,zeros(1,n));   	% initial plot
title('Oscilloscope')   % title
xlabel('Time [msec]')   % x label
ylabel('Amplitude')     % y label
grid on                 % turn on the grid
axis([0 1000*duration -1 1]) % set the ranges of x and y axes

if ~exist('lab1b_plot.m')
    error('File lab1b_plot.m does not exit. Make sure all required files are in the current working directory of matlab.');
end

clear lab1b_plot plotFunc       % clear if they already exist in the cache

plotFunc = @(src, event) lab1b_plot(src, event, h);
    % define a function plotFunc that calls lab1b_plot.m
    % passing 'h' in addition to 'src' and 'event' that are passed
    % by the event handler
listener=addlistener(s, 'DataAvailable', plotFunc);
    % call plotFunc every time 'DataAvailable' event occurs
    % 'DataAvailable' event will occur whenever s.NotifyWhenDataAvailableExceeds
    % samples are available

startBackground(s)
    % start background data acquisition
    % now the figure will be updated in real time
    