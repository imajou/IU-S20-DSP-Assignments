function [signal_clipped] = clip_signal(signal, threshold)
    signal_clipped = signal
    for i = 1:length(signal)
        if (abs(signal(i)) > threshold) then
            signal_clipped(i) = threshold * sign(signal(i))
        end
    end
endfunction

function [signal_distorted] = distort_signal(signal, volume_gain, distortion_gain)
    signal_distorted = signal
    for i = 1:length(signal)
        signal_distorted(i) = volume_gain * atan(distortion_gain * signal(i))
    end
endfunction

function plot_results(signal_original, signal, signal_fs, name)
    // To prevent of "bigger" signal overlapping "smaller" signal, choose "bigger" signal
    // signal_original will always be blue
    if mean(abs(signal_original)) > mean(abs(signal)) then
        first_to_plot = signal_original
        second_to_plot = signal
        first_to_plot_color = 'blue'
        second_to_plot_color = 'red'
    else
        first_to_plot = signal
        second_to_plot = signal_original
        first_to_plot_color = 'red'
        second_to_plot_color = 'blue'
    end
    
    figure()
    title(name)
    gcf().background = color('white')
    
    // Plot in temporal domain two signals
    subplot(2, 1, 1)
    plot2d('nn', 0 : length(first_to_plot) - 1, first_to_plot, color(first_to_plot_color))
    plot2d('nn', 0 : length(second_to_plot) - 1, second_to_plot, color(second_to_plot_color))
    xlabel('time, samples')
    ylabel('amp')
    
    // Plot in spectral domain two signals
    frequencies = (0 : length(abs(fft(signal))) - 1) / length(abs(fft(signal))) * signal_fs
    subplot(2, 1, 2)
    plot2d('nl', frequencies, abs(fft(first_to_plot)), color(first_to_plot_color))
    plot2d('nl', frequencies, abs(fft(second_to_plot)), color(second_to_plot_color))
    xlabel('freq, Hz')
    ylabel('amp')
    
    // Save to PNG
    xs2png(gcf(), "out_img/" + name + ".png");
endfunction

function main(filename, clip_amplitude, distort_amplitude)
    [signal, signal_fs, _] = wavread(filename)
    
    signal_clipped = clip_signal(signal, clip_amplitude)
    signal_distorted = distort_signal(signal, distort_amplitude, 64)
    
    plot_results(signal, signal_clipped, signal_fs, filename + "_clipped")
    plot_results(signal, signal_distorted, signal_fs, filename + "_distorted")
    plot_results(signal_clipped, signal_distorted, signal_fs, filename + "_clipped_vs_distorted")
    
    savewave("out_wav/clipped_" + filename, signal_clipped, signal_fs)
    savewave("out_wav/distorted_" + filename, signal_distorted, signal_fs)
endfunction

//main("sovietanthem.wav", 0.1)
main("guitar.wav", 0.075)
