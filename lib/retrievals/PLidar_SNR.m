function [SNR] = PLidar_SNR(signal, bg, varargin)
% PLIDAR_SNR calculate the SNR
% USAGE:
%    [SNR] = PLidar_SNR(signal, bg)
%
% INPUTS:
%    signal: array
%        signal.
%    bg: array
%        background. (bg should have the same size as signal)
%
% KEYWORDS:
%    detectMode: char
%        detection mode.
%        - pc: photon counting mode
%        - ad: analogue-digiter convertor
%
% OUTPUTS:
%    SNR: array
%        signal-noise-ratio. For negative signal, the SNR was set to be 0.
%
% HISTORY:
%    2018-09-01: first edition by Zhenping
% .. Authors: - zp.yin@whu.edu.cn

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