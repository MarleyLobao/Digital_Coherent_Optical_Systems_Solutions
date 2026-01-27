clear; clc;

f = -200e3:1:200e3;
delta_v = 100e3;

sigma_nfi_sq = 2*pi*delta_v;

Sl = sigma_nfi_sq./((sigma_nfi_sq/2)^2 + (2*pi*f).^2);
Sl_dB = 10*log10(Sl/max(Sl));

cutoff_3dB = -3*ones(length(f),1);

figure(1)
plot(f,Sl_dB,'b',f,cutoff_3dB,'r');
title(['Lorentzian spectrum with ', num2str(delta_v/1e3), ' kHz linewidth']);
xlabel('f (Hz)');
ylabel('Sl [dB]');
legend('Sl(f)','FWHM (-3 dB)');