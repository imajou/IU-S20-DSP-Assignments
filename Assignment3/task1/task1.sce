// Function to generage dirac delta sequence and save it as wave file
function[delta] = GenerateDelta()
    discretization = 192000;
    sin_amp = 1;
    sin_freq = 440;

    sin_step = sin_freq * (2 * %pi) / discretization;
    sin_samples = [1:discretization / 8] * sin_step;
    sin_sig = sin_amp * sin(sin_samples);
    z = zeros(1, 192000);
    
    delta = [z, sin_sig, z];
    savewave('results/delta.wav', delta, discretization);
endfunction

// Custom convolution function
// Using frequency domain multiplication
// Source: https://scilab.in/lab_migration/generate_lab/8/1
function[convolved_custom] = ConvolveCustom(x, h)
    m = length(x);
    n = length(h);
    N = n+m-1;
    x = [x zeros(1, N-m)];
    h = [h zeros(1, N-n)];
    f1 = fft(x);
    f2 = fft(h);
    f3 = f1.*f2;
    convolved_custom = ifft(f3);
endfunction

function[convolved_track] = ConvolveTrack(track_name, ir, save_to)
    [track_wave, track_fs, track_bits] = wavread(track_name); track_fs, track_bits;
    track_wave = track_wave(1, :) - mean(track_wave);
    tic();
    convolved_track = ConvolveCustom(track_wave, ir);
    time = toc();
    savewave(save_to, convolved_track, track_fs);
    disp(time, track_name, 'convolution time');
endfunction


GenerateDelta();

// Load IR
[irc_wave, irc_fs, irc_bits] = wavread('resources/irc_kalich.wav'); irc_fs, irc_bits;
irc_wave = irc_wave(1, :) - mean(irc_wave);

// Convolve given tracks
ConvolveTrack('resources/voice.wav', irc_wave, 'results/voice_convolved')
ConvolveTrack('resources/violin.wav', irc_wave, 'results/violin_convolved')
ConvolveTrack('resources/speech.wav', irc_wave, 'results/speech_convolved')
ConvolveTrack('resources/drums.wav', irc_wave, 'results/drums_convolved')

// Convolve custom track
record_convolved = ConvolveTrack('resources/record.wav', irc_wave, 'results/record_convolved')

// Convolve custom track using built-in function
[track_wave, track_fs, track_bits] = wavread('resources/record.wav'); track_fs, track_bits;
track_wave = track_wave(1, :);
track_convolved_default = convol(track_wave, irc_wave);
savewave('results/record_convolved_default', track_convolved_default, track_fs);

// Plot error
figure
plot(abs(record_convolved - track_convolved_default));
title('Custom vs built-in absolute error', 'FontSize', 2);

