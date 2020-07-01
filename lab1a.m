% a simple animation in matlab
t=0:0.01:1;	% time variable
k=0;
f=sin(2*pi*(t-k/100));
h=plot(t,f);	% initial plot. 'h' contains the handle for the plot
axis([0 1 -1 1])   % set the ranges of x and y axes, i.e., [0,1] for x axis and [-1,1] for y axis
for k=1:200,
    f=sin(2*pi*(t-k/100));
    set(h,'YData',f);	% update y data for the plot 'h'
    drawnow	    % draw immediately without waiting until the end of the loop
    pause(0.05)		% pause for 0.05 second
end
