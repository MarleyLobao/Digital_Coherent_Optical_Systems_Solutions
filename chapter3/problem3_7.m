clear; clc;

pkg load signal

addpath '..\Digital_Coherent_Optical_Systems\Tx\SymbolGeneration'
addpath '..\Digital_Coherent_Optical_Systems\Tx\PulseShaping'
addpath '..\Digital_Coherent_Optical_Systems\OpticalModeling'

ModFormat = 'QPSK';
NSymb = 10;

[Bits,x] = SymbolGeneration(ModFormat,NSymb);

ParamFilter.Rolloff = 0.1;
ParamFilter.Span = 20;
SpS = 16;

xb = PulseShaping(x,SpS,ParamFilter);

figure(1)
plot(real(xb(1:SpS:end,1)), imag(xb(1:SpS:end,1)), 'o');
title(['Constellation Diagram from Transmission - ', ModFormat, ' Modulation']);
xlabel("Re(x)")
ylabel("Im(x)")
grid on

Rs = 50e9;
D = 17;
CLambda = 1550e-9;
L = 1e3;
NPol = 1;

AOutput = CDInsertion(xb,SpS,Rs,D,CLambda,L,NPol);

figure(2)
plot(real(AOutput(1:SpS:end,1)), imag(AOutput(1:SpS:end,1)), 'o');
title(['Constellation Diagram with Chromatic Dispersion - ', ModFormat, ' Modulation']);
xlabel("Re(x)")
ylabel("Im(x)")
grid on
