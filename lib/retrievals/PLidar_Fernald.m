function [aerBsc, aerBscStd, aerBR, aerBRStd] = PLidar_Fernald(alt, signal, ...
                                            bg, LR_aer, ...
                                            refAlt, refBeta, molBSC, window_size)
%PLidar_Fernald retrieve the aerosol backscattering coefficient with Fernald 
%method. 
%Example:
%   [aerBsc, aerBscStd, aerBR, aerBRStd] = PLidar_Fernald(alt, signal, bg, ...
%                       LR_aer, refAlt, refBeta, molBSC, window_size)
%Inputs:
%   alt: array
%       height. [m]
%   signal: array
%       elastic signal without background. [Photon Count]
%   bg: array
%       background. [Photon Count]
%   LR_aer: float or array
%       aerosol lidar ratio. [Sr]
%   refAlt: float or 2-element array
%       reference altitude or region. [m]
%   refBeta: float
%       aerosol backscatter coefficient at the reference region. 
%       [m^{-1}Sr^{-1}]       
%   molBSC: array
%       molecular backscattering coefficient. Unit: m^{-1}*Sr^{-1}
%   window_size: int32
%       Bins of the smoothing window for the signal. [default, 40 bins]
%Returns:
%   aerBsc: array
%       aerosol backscatter coefficient. [m^{-1}*Sr^{-1}]
%   aerBscStd: array
%       statistical uncertainty of aerosol backscatter. [m^{-1}*Sr^{-1}]
%   aerBR: array
%       aerosol backscatter ratio.l backscatter ratio.
%   aerBRStd: array
%       statistical uncertainty of aerosol backscatter ratio.
%References:
%   1. Fernald, Frederick G. "Analysis of Atmospheric Lidar Observations $
%     - Some Comments." Applied optics 23, no. 5 (1984): 652-653.
%   2. Prof. Yi's PPT: A brief introduction to atmospheric lidars
%History:
%   2018-01-04. First Edition by ZP.Yin
%   2020-04-07. Add uncertainty analysis.
%Contact:
%   zhenping@tropos.de

if nargin < 6
    error('Not enough inputs.');
end

if ~ exist('window_size', 'var')
    window_size = 40;
end

alt = reshape(alt, 1, []);
signal = reshape(signal, 1, []);
molBSC = reshape(molBSC, 1, []);
LR_aer = reshape(LR_aer, 1, []);

alt = alt/1e3 ;   % convert the unit to km.
refAlt = refAlt/1e3;   % convert the unit to km
molBSC = molBSC * 1e3;   % convert the unit to km^{-1}Sr^{-1}
refBeta = refBeta * 1e3;   % convert the unit to km^{-1}*Sr^{-1}

% calculate signal noise according to Poisson distribution
totSig = signal + bg;
totSig(totSig < 0) = 0;
noise = sqrt(totSig);

dAlt = alt(2) - alt(1);
nAlt = length(alt);
% atmospheric molecular radiative parameters
LR_mol = 8 * pi / 3;
LR_mol = ones(1, nAlt)*LR_mol;

% index of the reference altitude 
if length(refAlt) == 1
    if refAlt > alt(end) || refAlt < alt(1)
        error('refAlt is out of range.');
    end
    indRefAlt = find(alt >= refAlt, 1, 'first');
    indRefAlt = ones(1, 2) * indRefAlt;
elseif length(refAlt) == 2
    if (refAlt(1) - alt(end)) * (refAlt(1) - alt(1)) <=0 && ...
        (refAlt(2) - alt(end)) * (refAlt(2) - alt(1)) <=0
        indRefAlt = [floor(refAlt(1) / dAlt), floor(refAlt(2) / dAlt)];
    else
        error('refAlt is out of range.');
    end
end

if (length(LR_aer) == 1) 
    LR_aer = ones(1, nAlt) * LR_aer;
elseif ~(length(LR_aer) == nAlt)
    error('Error in setting LR_aer.');
end

RCS = reshape(signal, 1, numel(signal)) .* reshape(alt, 1, numel(alt)).^2;

indRefMid = int32(mean(indRefAlt));
% smooth the signal at the reference height region
RCS = smooth(RCS, window_size, 'moving');
RCS(indRefMid) = mean(RCS(indRefAlt(1):indRefAlt(2)));

% intialize some parameters and set the value at the reference altitude.
aerBsc = NaN(1, nAlt);
aerBsc(indRefMid) = refBeta;
aerBR = NaN(1, nAlt);
aerBR(indRefMid) = refBeta / molBSC(indRefMid);

% backward and forward processing
% backward
for iAlt = indRefMid-1: -1: 1
    A = ((LR_aer(iAlt+1) - LR_mol(iAlt+1)) * molBSC(iAlt+1) + ...
        (LR_aer(iAlt) - LR_mol(iAlt)) * molBSC(iAlt)) * ...
        abs(alt(iAlt+1) - alt(iAlt));
    numerator = RCS(iAlt) * exp(A);
    denominator1 = RCS(iAlt+1) / (aerBsc(iAlt+1) + molBSC(iAlt+1));
    denominator2 = (LR_aer(iAlt+1) * RCS(iAlt+1) + LR_aer(iAlt) * ...
                   numerator) * abs(alt(iAlt+1) - alt(iAlt));
    aerBsc(iAlt) = numerator/(denominator1 + denominator2) - molBSC(iAlt);
    aerBR(iAlt) = aerBsc(iAlt) / molBSC(iAlt);

    m1 = noise(iAlt + 1) * alt(iAlt + 1).^2 / (aerBsc(iAlt + 1) + molBSC(iAlt + 1)) / numerator;
    m2 = (LR_aer(iAlt + 1) * noise(iAlt + 1) * alt(iAlt + 1).^2 + LR_aer(iAlt) * noise(iAlt) * alt(iAlt).^2 * exp(A)) * abs(alt(iAlt + 1) - alt(iAlt)) / numerator;
    m(iAlt) = m1 + m2;
end

% forward
for iAlt = indRefMid+1: 1: nAlt
    A = ((LR_aer(iAlt-1) - LR_mol(iAlt-1)) * molBSC(iAlt-1) + ...
        (LR_aer(iAlt) - LR_mol(iAlt)) * molBSC(iAlt)) * ...
        abs(alt(iAlt)-alt(iAlt-1));
    numerator = RCS(iAlt) * exp(-A);
    denominator1 = RCS(iAlt-1) / (aerBsc(iAlt-1) + molBSC(iAlt-1));
    denominator2 = (LR_aer(iAlt-1) * RCS(iAlt-1) + LR_aer(iAlt) * ...
                   numerator) * abs(alt(iAlt) - alt(iAlt-1));
    aerBsc(iAlt) = numerator / (denominator1 - denominator2) - molBSC(iAlt);
    aerBR(iAlt) = aerBsc(iAlt) / molBSC(iAlt);

    m1 = noise(iAlt - 1) * alt(iAlt - 1).^2 / (aerBsc(iAlt - 1) + molBSC(iAlt - 1)) / numerator;
    m2 = (LR_aer(iAlt - 1) * noise(iAlt - 1) * alt(iAlt - 1).^2 + LR_aer(iAlt) * noise(iAlt) * alt(iAlt).^2 * exp(-A)) * abs(alt(iAlt) - alt(iAlt - 1)) / numerator;
    m(iAlt) = m1 - m2;
end

aerBsc = aerBsc / 1e3;   % convert the unit to m^{-1}*Sr^{-1}

% statistical uncertainty
aerRelBRStd = abs((1 + noise ./ signal) ./ (1 + m .* (aerBsc + molBSC)) - 1);
aerBRStd = aerRelBRStd .* aerBR;
aerBscStd = aerRelBRStd .* molBSC .* aerBR;

end