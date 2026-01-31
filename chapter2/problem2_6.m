clear; clc;

pkg load signal

addpath '..\Digital_Coherent_Optical_Systems\Tx\SymbolGeneration'
addpath '..\Digital_Coherent_Optical_Systems\Tx\PulseShaping'
addpath '..\Digital_Coherent_Optical_Systems\Common'
addpath '..\Digital_Coherent_Optical_Systems\OpticalModeling'

ModFormat = '16QAM';
NSymb = 100;

[Bits,x] = SymbolGeneration(ModFormat,NSymb);

ParamFilter.Rolloff = 0.1;
ParamFilter.Span = 20;
SpS = 16;

xb = PulseShaping(x,SpS,ParamFilter);

xb_ds = downsample(xb,SpS);
xb_ds = xb_ds/sqrt(10);

figure(1)
plot(real(xb_ds), imag(xb_ds), 'o');
title(['Constellation Diagram - ', ModFormat, ' Before IQ Modulator']);
xlabel("Re(x)")
ylabel("Im(x)")
grid on

ParamLaser.Pcw = 0;
ParamLaser.Linewidth = 0;
Rs = 0;
NPol = 1;

EInput = Laser(ParamLaser,SpS,Rs,NSymb,NPol);

ParamMZM.Vpi = 1;
ParamMZM.Bias = -0.7*ParamMZM.Vpi;
ParamMZM.MinExc = -1.5*ParamMZM.Vpi;
ParamMZM.MaxExc = -0.5*ParamMZM.Vpi;

EOutput = IQModulator(xb,EInput,ParamMZM);

Pout = abs(sum((EOutput))).^2
