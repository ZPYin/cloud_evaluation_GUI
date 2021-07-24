function [SNR] = PLidar_SNR(signal, bg, varargin)
% PLidar_SNR calculate the SNR
% Example:
%    [SNR] = PLidar_SNR(signal, bg)
% Inputs:
%    signal: array
%        signal.
%    bg: array
%        background. (bg should have the same size as signal)
% Keywords:
%    detectMode: char
%        detection mode.
%        - pc: photon counting mode
%        - ad: analogue-digiter convertor
% Outputs:
%    SNR: array
%        signal-noise-ratio. For negative signal, the SNR was set to be 0.
% History:
%    2018-09-01. First edition by Zhenping.
% Contact:
%    zhenping@tropos.de

p = inputParser;
p.KeepUnmatched = true;

addRequired(p, 'signal', @isnumeric);
addRequired(p, 'bg', @isnumeric);
addParameter(p, 'detectMode', 'PC', @ischar);

parse(p, signal, bg, varargin{:});

tot = signal + 2 * bg;
tot(tot <= 0) = NaN;

SNR = signal ./ sigStd(tot, varargin{:});
SNR(SNR <= 0) = 0;
SNR(isnan(SNR)) = 0;

end