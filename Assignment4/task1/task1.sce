function [filter] = create_lowpass_filter(N, cutoff, thres)
    N = (N - modulo(N, 2)) / 2
    cutoff = floor(2 * N * cutoff)
    filter = ones(1, N) * thres
    filter(1, 1 : cutoff) = 1.0
    filter = [1. filter flipdim(filter, 2)]
endfunction

function [filter] = create_highpass_filter(N, cutoff, thres)
    N = (N - modulo(N, 2)) / 2
    cutoff = floor(2 * N * cutoff)
    filter = ones(1, N) * thres
    filter(1, cutoff + 1 : N) = 1.0
    filter = [filter flipdim(filter, 2)]
endfunction

function [result] = create_filter(filter, fs)
    frequencies = (0:length(filter) - 1) / length(filter) * fs; // Frequency response
    result = real(ifft(filter)) // Impulse response
    result = fftshift(result) // Shift filter
    result = result .* window('kr', length(result), 8) // Apply window function
endfunction


load("signal_with_noise_and_filtered.sod")

signal = signal_with_noise
signal = signal(1, :)

signal_fs = Fs

highpass = create_filter(create_highpass_filter(8192, 0.005, 0.0), signal_fs)
lowpass = create_filter(create_lowpass_filter(512, 0.2, 0.0), signal_fs)
result = convol(signal, highpass)
result = convol(result, lowpass)

frequencies = (0:length(signal) - 1) / length(signal) * signal_fs
freq_length = length(frequencies) / 2
x = frequencies(1:freq_length)
y1 = abs(fft(signal))(1:freq_length)
y2 = abs(fft(result))(1:freq_length)

clf
plot2d("nl", x, y1, color("blue"))
plot2d("nl", x, y2, color("red"))
xlabel("freq (hz)", 'fontsize', 2)
ylabel("amp", 'fontsize', 2)
title("Resulting signal (freq)", 'fontsize', 3)
xs2png(0, "result_freq.png")

clf
plot2d("nn", (1:length(signal)), signal(1:length(signal)), color("blue"))
plot2d("nn", (1:length(signal)), result(1:length(signal)), color("red"))
xlabel("time (sample)", 'fontsize', 2)
ylabel("amp", 'fontsize', 2)
title("Resulting signal (track)", 'fontsize', 3)
xs2png(0, "result_track.png")

savewave("result", result, signal_fs)
