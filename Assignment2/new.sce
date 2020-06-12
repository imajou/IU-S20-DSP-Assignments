
function[dirac] = GenerateDirac()
    discretization = 192000;
    sin_amp = 1;
    sin_freq = 440;

    sin_step = sin_freq * (2 * %pi) / discretization;
    sin_samples = [1:discretization / 8] * sin_step;
    sin_sig = sin_amp * sin(sin_samples);
    z = zeros(1, 192000);
    
    dirac = [z, sin_sig, z]
endfunction

