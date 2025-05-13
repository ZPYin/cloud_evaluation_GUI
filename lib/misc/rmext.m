function [filename] = rmext(file)
% RMEXT remove the file extension.
%
% USAGE:
%    [filename] = rmext(file)
%
% INPUTS:
%    file: char
%        file.
%        e.g., 'polly_data.txt'
%
% OUTPUTS:
%    filename: char
%        if there is no extension label, the 'file' will be treated to be no 
%        extension then it will be directly returned. Otherwise, the 
%        extension will be removed.
%        e.g., 'polly_data'
%
% HISTORY:
%    2018-12-29: first edition by Zhenping
% .. Authors: - zp.yin@whu.edu.cn

res = strsplit(file, '.');

if length(res) >= 3
    filename = strjoin(res(1:(end - 1)), '.');
elseif length(res) == 2
    filename = res{1};
else
    filename = thisBasename;
end

end