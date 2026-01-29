clear; clc;

pkg load signal

addpath '..\Digital_Coherent_Optical_Systems\Tx\SymbolGeneration'
addpath '..\Digital_Coherent_Optical_Systems\Tx\PulseShaping'
addpath '..\Digital_Coherent_Optical_Systems\Common'
addpath '..\Digital_Coherent_Optical_Systems\OpticalModeling'
addpath '..\Digital_Coherent_Optical_Systems\Rx\Decision'

%% a)

ModFormat = 'QPSK';
NSymb = 100;

[Bits,x] = SymbolGeneration(ModFormat,NSymb);

figure(1)
plot(real(x), imag(x), 'o');
title(['Constellation Diagram - ', ModFormat, ' Modulation']);
xlabel("Re(x)")
ylabel("Im(x)")
grid on

%% b)

ParamFilter.Rolloff = 0.1;
ParamFilter.Span = 20;
SpS = 16;

xb = PulseShaping(x,SpS,ParamFilter);

figure(2)
plot(real(xb(1:SpS:end,1)), imag(xb(1:SpS:end,1)), 'o');
title(['Constellation Diagram - ', ModFormat, ' Modulation (with Pulse Shaping)']);
xlabel("Re(x)")
ylabel("Im(x)")
grid on

%% c)

switch ModFormat
    case {'QPSK'}
        ModBits = 2;
    case '16QAM'
        ModBits = 4;
    otherwise
        error('The supported modulation formats are QPSK and 16-QAM;');
end

SNRb_dB = 15;

r = NoiseInsertion(xb,ModBits,SNRb_dB,SpS);

figure(3)
plot(real(r(1:SpS:end,1)), imag(r(1:SpS:end,1)), 'o');
title(['Constellation Diagram - ', ModFormat, ' Modulation (with AWGN)']);
xlabel("Re(x)")
ylabel("Im(x)")
grid on

fm = RRC(ParamFilter.Span,SpS,ParamFilter.Rolloff);
xb_fm = conv(r,fm,'same');
xb_fm = xb_fm/sqrt(mean(abs(xb_fm).^2));

figure(4)
plot(real(xb_fm(1:SpS:end,1)), imag(xb_fm(1:SpS:end,1)), 'o');
title(['Constellation Diagram - ', ModFormat, ' Modulation (after Matched Filter)']);
xlabel("Re(x)")
ylabel("Im(x)")
grid on

xb_ds = downsample(xb_fm,SpS);

figure(5)
plot(real(xb_ds), imag(xb_ds), 'o');
title(['Constellation Diagram - ', ModFormat, ' Modulation (after downsampling)']);
xlabel("Re(x)")
ylabel("Im(x)")
grid on

%% d)

BitsOutput = 0;

Decided = Decision(xb_ds,ModFormat,BitsOutput);

figure(6)
plot(real(Decided), imag(Decided), 'o');
title(['Constellation Diagram - ', ModFormat, ' Modulation (after Map Decision)']);
xlabel("Re(x)")
ylabel("Im(x)")
grid on

SNR_b_dB = 6:0.5:11;
switch ModFormat
    case {'QPSK'}
        M = 4;
    case '16QAM'
        M = 16;
    otherwise
        error('The supported modulation formats are QPSK and 16-QAM;');
end
BER = 2*(1-1/sqrt(M))*erfc(sqrt((3/(M-1))*SNR_b_dB));

figure(7)
semilogy(SNR_b_dB, BER, 'o');
title({['Bit error rate (BER) of the ', ModFormat, ' format']; 'over an AWGN channel, assuming Gray mapping'});
xlabel("SNR_b [dB]")
ylabel("BER")
grid on
