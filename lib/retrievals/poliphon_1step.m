function [dustInfo, nondustInfo] = poliphon_1step(parBsc, parBscStd, parDepol, parDepolStd, lrd)
% POLIPHON_1STEP Separate dust and nondust with POLIPHON 1-step method.
% Example:
%    [dustInfo, nondustInfo] = poliphon_1step(parBsc, parBscStd, parDepol, parDepolStd)
% Inputs:
%    parBsc: matrix (height * time)
%        particle backscatter coefficient. (m^-1sr^-1)
%    parBscStd: matrix (height * time)
%        uncertainty of particle backscatter coefficient. (m^-1sr^-1)
%    parDepol: matrix (height * time)
%        particle depolarization ratio.
%    parDepolStd: matrix (height * time)
%        uncertainty of particle depolarization ratio.
%    lrd: float
%        dust lidar ratio (default: 51). (sr)
% Outputs:
%    dustInfo: struct
%        parBsc: matrix (height * time)
%            particle backscatter coefficient. (m^-1sr^-1)
%        parBscStd: matrix (height * time)
%            uncertainty of particle backscatter coefficient. (m^-1sr^-1)
%        parExt: matrix (height * time)
%            particle extinction coefficient. (m^-1)
%        parExtStd: matrix (height * time)
%            uncertainty of particle extinction coefficient. (m^-1)
%        massConc: matrix (height * time)
%            particle mass. (kgm^-3)
%        massConcStd: matrix (height * time)
%            uncertainty of particle mass. (kgm^-3)
%    nondustInfo: struct
%        (as above)
% References:
%    1. Mamouri, R., and A. Ansmann (2014), Fine and coarse dust separation with
%       polarization lidar, Atmospheric Measurement Techniques, 7(11), 3717-3735.
%    2. Mamouri, R.-E., and A. Ansmann (2017), Potential of polarization/Raman
%       lidar to separate fine dust, coarse dust, maritime, and anthropogenic
%       aerosol profiles, Atmospheric Measurement Techniques, 10(9), 3403-3427.
%    3. Ansmann, A., R. E. Mamouri, J. Hofer, H. Baars, D. Althausen, and
%       S. F. Abdullaev (2019), Dust mass, cloud condensation nuclei, and
%       ice-nucleating particle profiling with polarization lidar: updated
%       POLIPHON conversion factors from global AERONET analysis, Atmos. Meas.
%       Tech., 12(9), 4849-4865, doi:10.5194/amt-12-4849-2019.
% History:
%    2020-04-08. First Edition by Zhenping
% Contact:
%    zp.yin@whu.edu.cn

if ~ exist('lrd', 'var')
    lrd = 51;   % lidar ratio of dust (sr)
end

%% initialization
dustParDepol = 0.31;   % particle depolarization ratio for dust at 532 nm
nondustParDepol = 0.05;   % particle depolarization ratio for non-dust at 532 nm
vcd = 0.77e-6;   % volume conversion factor for dust at 532 nm (ref. 3) (m^-1)
vcnd = 0.41e-6;   % volume conversion factor for non-dust at 532 nm (ref. 2) (m^-1)
rhod = 2.6e3;   % density of dust (kg*m^-3)
rhond = 1.55e3;   % density of non-dust (kg*m^-3)
lrnd = 50;   % lidar ratio of non-dust (sr)

%% Separation
dustParBsc = NaN(size(parBsc));
flagLowParDepol = (parDepol <= nondustParDepol);
flagHighParDepol = (parDepol >= dustParDepol);
dustParBsc(flagLowParDepol) = 0;
dustParBsc(flagHighParDepol) = parBsc(flagHighParDepol);
flagMixture = (~ flagLowParDepol) & (~flagHighParDepol);
dustParBsc(flagMixture) = parBsc(flagMixture) .* (parDepol(flagMixture) - nondustParDepol) .* (1 + dustParDepol) ./ (dustParDepol - nondustParDepol) ./ (1 + parDepol(flagMixture));
nondustParBsc = parBsc - dustParBsc;

dustParExt = dustParBsc .* lrd;
nondustParExt = nondustParBsc .* lrnd;

dustMassConc = dustParExt .* vcd .* rhod;
nondustMassConc = nondustParExt .* vcnd .* rhond;

%% Uncertainty
dustParBscStd = dustParBsc .* 0.2;   % ref. 1
nondustParBscStd = nondustParBsc .* 0.2;
dustParExtStd = dustParExt .* 0.3;
nondustParExtStd = nondustParExt .* 0.3;
dustMassConcStd = dustMassConc .* 0.45;
nondustMassConcStd = nondustMassConc .* 0.45;

dustInfo.parBsc = dustParBsc;
dustInfo.parBscStd = dustParBscStd;
dustInfo.parExt = dustParExt;
dustInfo.parExtStd = dustParExtStd;
dustInfo.massConc = dustMassConc;
dustInfo.massConcStd = dustMassConcStd;
nondustInfo.parBsc = nondustParBsc;
nondustInfo.parBscStd = nondustParBscStd;
nondustInfo.parExt = nondustParExt;
nondustInfo.parExtStd = nondustParExtStd;
nondustInfo.massConc = nondustMassConc;
nondustInfo.massConcStd = nondustMassConcStd;

end