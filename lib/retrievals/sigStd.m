function [uncertainty] = sigStd(signal, varargin)
% SIGSTD calculate signal uncertainty.
% USAGE:
%    [uncertainty] = sigStd(signal, varargin)
% INPUTS:
%    signal: array
%        lidar signal.
% KEWYRORDS:
%    detectMode: char
%        detection mode.
%        - pc: photon counting mode
%        - ad: analogue-digiter convertor
% OUTPUTS:
%    uncertainty: array
%        signal uncertainty.
% EXAMPLE:
% HISTORY:
%    2021-07-24: first edition by Zhenping
% .. Authors: - zhenping@tropos.de

p = inputParser;
p.KeepUnmatched = true;

addRequired(p, 'signal', @isnumeric);
addParameter(p, 'detectMode', 'PC', @ischar);
addParameter(p, 'winLen', 8, @isnumeric);

parse(p, signal, varargin{:});

switch lower(p.Results.detectMode)
case 'pc'
    uncertainty = sqrt(signal);
case 'ad'
    uncertainty = ADSigStd(signal, p.Results.winLen);
otherwise
    error('unknown detection mode: %s', p.Results.detectMode);
end

end