// generate sin signal
function result = sin_signal(Fs, time, freqency, amplitude)
    samples = time * Fs
    step_size = (2 * %pi * freqency) / samples
    x = [0:samples-1] * step_size
    result = amplitude * sin(x)
endfunction

// generate cos signal
function result = cos_signal(Fs, time, freqency, amplitude)
    samples = time * Fs
    step_size = (2 * %pi * freqency) / samples
    x = [0:samples-1] * step_size
    result = amplitude * cos(x)
endfunction

// Standard DFT algorithm
function result = DFT(signal)
    if (size(signal, 1) <> 1) then
        signal = conj(signal')
    end

    N = length(signal)
    
    for k = 1:N
        result(k) = 0
        for i = 1:N
            result(k) = result(k) + signal(i) * exp((-2 * %pi * %i * (i - 1) * (k - 1)) / N)
        end
    end
endfunction

function plot_results(signal, dft_signal, T)
    figure()
    
    // signal
    subplot(2, 1, 1)
    plot([0 : length(signal) - 1] * T / length(signal), signal, 'o-')
    xlabel('time, s')
    ylabel('amp')
    
    // frequency response
    subplot(2, 1, 2)
    plot(0 : length(dft_signal) - 1, abs(dft_signal), 'o-')
    xlabel('freq, Hz')
    ylabel('amp')
endfunction


function task1()
    time = 4
    Fs = 64
    sin_freq = 8
    sin_amp = 1
    
    signal = sin_signal(Fs, time, sin_freq, sin_amp)
    dft_custom = DFT(signal)
    dft_original = fft(signal)
    
    figure()

    subplot(3, 1, 1)
    plot([0:length(signal)-1]*time/length(signal), signal, 'o-')
    xlabel('Time, sec')
    ylabel('amp')

    subplot(3, 1, 2)
    plot(0:length(signal)-1, abs(dft_custom), 'o-')
    xlabel('freq, Hz')
    ylabel('amp')

    subplot(3, 1, 3)
    plot(0:length(signal)-1, abs(dft_original), 'o-')
    xlabel('freq, Hz')
    ylabel('amp')
endfunction

//// TASK 2 - SPECTRAL LEAKAGE ////
function[signal, dft_signal, time] = task2()
    time = 2
    Fs = 32
    amp = 1
    
    freq1 = 13.37 // leak 
    freq2 = 22.8 // leak
    freq3 = 6 // non-leak
    
    s1 = sin_signal(Fs, time, freq1, amp)
    s2 = sin_signal(Fs, time, freq2, amp)
    s3 = sin_signal(Fs, time, freq3, amp)
    
    signal = s1 + s2 + s3
    dft_signal = fft(signal)
    
    plot_results(signal, dft_signal, time)
endfunction


function task3(signal, dft_signal, time)
    signal_window = signal .* window("kr", 64, 8) // window
    signal_padding = resize_matrix(signal_window, 1, 256) // padding
    dft_signal = fft(signal_padding)
    
    time = time * 4
    plot_results(signal_padding, dft_signal, time)
endfunction


function task4()
    time = 1
    Fs = 1000
    
    freq1 = 190
    amp1 = 0.5
    freq2 = 10
    amp2 = 2
    
    signal = cos_signal(Fs, time, freq1, amp1) + cos_signal(Fs, time, freq2, amp2)
    dft_signal = fft(signal)
    
    plot_results(signal, dft_signal, time)
endfunction

task1()
[signal, dft_signal, time] = task2()
task3(signal, dft_signal, time)
task4()
