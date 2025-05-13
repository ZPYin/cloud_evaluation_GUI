function [sigStd] = ADSigStd(signal, winLen)
% ADSIGSTD calculate signal uncertainty in analog mode.
%
% USAGE:
%    [sigStd] = ADSigStd(signal, winLen)
%
% INPUTS:
%    signal: numeric
%    winLen: integer
%
% OUTPUTS:
%    sigStd: numeric
%
% HISTORY:
%    2021-07-22: first edition by Zhenping
% .. Authors: - zhenping@tropos.de

sigStd = NaN(size(signal));

if winLen > length(signal)
    warning('winLen is larger than the size of signal.');
    return;
end

if winLen < 3
    warning('winLen is too small');
    winLen = 3;
end

sigStdLeading = nanstd(signal(1:winLen));
sigStdTail = nanstd(signal((end - winLen + 1):end));

sigStd = NaN(size(signal));

for iBin = (floor(winLen / 2) + 1):(length(signal) - floor(winLen / 2))
    ind = (iBin - floor(winLen / 2)):(iBin + floor(winLen / 2));

    % remove linear trend
    [~, ~, ~, ~, ~, ~, sigNoise] = chi2fit(1:length(ind), ...
        reshape(signal(ind), 1, length(ind)), ones(size(ind)));
    sigStd(iBin) = nanstd(sigNoise);
end

sigStd(1:floor(winLen / 2)) = sigStdLeading;
sigStd((end - floor(winLen / 2) + 1):end) = sigStdTail;

end