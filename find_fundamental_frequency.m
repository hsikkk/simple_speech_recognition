function [f1,D,hpos,a]=find_fundamental_frequency(d,fs,fmin,fmax)
% A simple estimator for the fundamental frequency based on fft.
% Input arguments
%   d: signal vector
%   fs: sampling rate in Hz
%   fmin: minimum frequency in Hz
%   fmax: maximum frequency in Hz
% Output arguments
%   f1: estimated fundamental frequency in Hz
%   (optional) D: FFT of d in dB
% Written by Sae-Young Chung, 2016

n=length(d);    % length of vector d
n2=floor(n/2);
d=reshape(d,1,n);   % reshape d as a 1xn vector

% window function to smooth the edges
if n2*2==n
    w=0.5*(1+cos(((-n2:n2-1)+0.5)*2*pi/n));
else
    w=0.5*(1+cos((-n2:n2)*2*pi/n));
end

fft_size=2^ceil(log2(n));   % nearest power of 2
D=20*log10(abs(fft(d.*w,fft_size)));    % perform FFT after windowing
    % D: power in dB in the freq. domain

max_harmonic=10;    % up to 10th harmonic
os=max_harmonic;    % over-sampling factor for estimating the fundamental frequency

kmin=round(fmin*fft_size/fs);   % convert the min. freq. to sample index
kmax=round(fmax*fft_size/fs);   % convert the max. freq. to sample index

a=zeros(1,kmax*os)-1000;
maxa=-1000;
f1=fmin;
for j=kmin*os:kmax*os
    k=j/os;
    z=round((1:max_harmonic)*k);    % freq. indices up to 10th harmonic
    for p=1:length(z)
        if z(p)>fft_size/2-2
            z=z(1:p-1);             % to prevent going over the max. length
            break;
        end
    end
    [dmax,idx]=max([D(z);D(z+1);D(z+2)]);   % find the peak within +/-1 of z (1 is added since matlab index starts from 1)
    a(j)=mean(dmax)-mean(D(1:max(z)));      % measure the mean peakness of harmonics with respect to the average
    if a(j)>maxa
        maxa=a(j);
        f1=k*fs/fft_size;   % estimated fundamental freq.
        hpos=z+idx-2;       % set of positions of harmonics (1 needs to be added if this is to be used as matlab indices)
    end
end
