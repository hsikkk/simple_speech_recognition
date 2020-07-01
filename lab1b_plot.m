function lab1b_plot(src, event, h)
try
    d=event.Data(:,1);      % take data from the first audio channel
    set(h, 'YData', d);     % update 'YData'
    drawnow                 % draw figure now
catch
    stop(src)
end
end
