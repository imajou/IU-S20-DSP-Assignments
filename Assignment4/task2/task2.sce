function [result] = create_filter(filter, fs)
    frequencies = (0:length(filter) - 1) / length(filter) * fs; // Frequency response
    result = real(ifft(filter)) // Impulse response
    result = fftshift(result) // Shift filter
    result = result .* window('kr', length(result), 8) // Apply window function
endfunction

function [filter] = invert_filter(original_filter)
    filter = 1 ./ fft(original_filter(1, 1:length(original_filter)))
    if (size(filter, 1) <> 1) then
        filter = filter'
    end
endfunction

[signal, signal_fs, _] = wavread("7cef8230.wav")
signal = signal(1, :)

[irc1, irc1_fs, _] = wavread("1a_marble_hall.wav")
irc1 = irc1(1, :)
[irc2, irc2_fs, _] = wavread("irc_kalich.wav")
irc2 = irc2(1, :)

irc1 = create_filter(invert_filter(irc1), irc1_fs)
irc2_filter = create_filter(irc2, irc2_fs)
irc2_inverse = create_filter(invert_filter(irc2), irc2_fs)

result1 = convol(signal, irc1)
result2 = convol(irc2, irc2_inverse)

savewave("result", result1 * 30, signal_fs)

clf
plot2d("nn", 1:length(result2), result2, color("blue"))
xlabel("time (samples)", 'fontsize', 2)
ylabel("amp", 'fontsize', 2)
title("Inverse filter to original filter", 'fontsize', 3)
xs2png(0, "result.png")
