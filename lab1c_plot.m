function lab1c_plot(src, event, h1, h2)
persistent ht ht2
try
    fs=src.Rate;    % sampling rate
    sz=size(event.Data);
    if sz(2)>1
        d=(event.Data(:,1)+event.Data(:,2))/2;  % if stereo, convert to mono
    else
        d=event.Data;   % if mono
    end

    f1_min=50;
    f1_max=1000;
    [f1,D,hpos]=find_fundamental_frequency(d,fs,f1_min,f1_max);
    fft_size=length(D);

    if isempty(ht)  % if not initialized yet
        ht=text(1500, 50, '');
        set(ht,'FontSize',20);
        ht2=text(1500, 30, '');
        set(ht2, 'FontSize', 20);
    end
    set(ht,'String',sprintf('f1=%d[Hz]', round(f1)));
    set(ht2, 'String', lab1_exp1(f1, D(hpos+1)));

    set(h1, 'YData', d);     % update 'YData' for time-domain signal
    set(h2(1), 'YData', D(1:fft_size/2));   % update spectrum
    set(h2(2), 'XData', hpos*fs/fft_size, 'YData', D(hpos+1));  % update spectrum peaks
    drawnow                 % draw figure now
catch
    stop(src)               % something's wrong. stop
end
end
