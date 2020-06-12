exec('ADC.sce')

function [recorded_data] = ProcessRecord(n, quant_step, discretization, sin_freq)
    quant_levels = -1:quant_step:1;
    
    recorded_data = ADC(n, quant_levels, discretization);
    recorded_len = length(recorded_data)
    recorded_amp_shift = mean(recorded_data)
    
    sin_amp = 0.1;
    sin_step = sin_freq * (2 * %pi) / discretization;
    sin_samples = [1:recorded_len] * sin_step;
    sin_sig = sin_amp * sin(sin_samples);
    
    recorded_data = recorded_data - recorded_amp_shift - sin_sig'
endfunction

quant_step = 1 / (2^8)
discretization = 24000;
sin_freqs = [200 150 180 120 210 180 120 120 150 210 150 190 140 210];

record = []

for n=1:1:14
  record_n = ProcessRecord(n, quant_step, discretization, sin_freqs(n))
  record = cat(1, record, record_n)
end

 
fig = figure(1);
clf;
gca.data_bounds = [0, -1; discretization, 1];
xlabel('Samples');
ylabel('Amplitude');
plot(record_n, '--o');
xs2png(gcf(),'plot.png');

savewave('record.wav', record, discretization)
