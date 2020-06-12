clear

// Constructor for filter
function newfilt = filter_new (a, b, x)
    newfilt = struct('a', a, 'b', b, 'x', x);
endfunction

// Compute filter function
function [y] = compute(filt)
    m = size(filt.x, "c");
    y = zeros(1, m);
    for n=3:m
        y(n) = filt.b(1)* filt.x(n) + filt.b(2) * filt.x(n-1) + filt.b(3) * filt.x(n-2) + filt.a(1) * y(n-1) + filt.a(2) * y(n-2);
    end
endfunction

// Load music sample
snd = loadwave('resources/Violin_Viola_Cello_Bass.wav');

// Create and compute lowpass filter
low_a = [1.9733442497812987, -0.9736948719763];
low_b = [0.00008765554875401547, 0.00017531109750803094, 0.00008765554875401547];

lw_filt = filter_new(low_a, low_b, snd);
lw_custom = compute(lw_filt);

// Plot computed and provided lowpass filter outputs
figure
plot(lw_custom);
title('lowpass: Custom filter algorithm','FontSize', 2);

figure
lw_right = loadwave('resources/proc_low.wav');
plot(lw_right);
title('lowpass: Given correct representation', 'FontSize', 2);

// Create and compute highpass filter
high_a = [-0.3769782747249014, -0.19680764477614976];
high_b = [0.40495734254626874, -0.8099146850925375, 0.4049573425462687];

hg_filt = filter_new(high_a, high_b, snd);
hg_custom = compute(hg_filt);

//Plot computed and provided highpass filter outputs
figure
plot(hg_custom);
title('highpass: Custom filter algorithm', 'FontSize', 2);

figure
hg_right = loadwave('resources/proc_high.wav');
plot(hg_right);
title('highpass: Given correct representation','FontSize', 2);
