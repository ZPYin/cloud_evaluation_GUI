function config = load_settings(settingFile, settingTemplate)
% LOAD_SETTINGS load setting file and overwrite the template settings.
%
% USAGE:
%    config = load_settings(settingFile, settingTemplate)
%
% INPUTS:
%    settingFile: char
%        absolute path of the setting file (YAML).
%    settingTemplate: char
%        absolute path of the template setting file (YAML).
%
% OUTPUTS:
%    config: struct
%        settings.
%
% HISTORY:
%    2020-07-08: First edition by Zhenping.
% .. Authors: - zp.yin@whu.edu.cn

if exist(settingFile, 'file') ~= 2
    error('setting file does not exist.\n%s', settingFile);
end

if exist(settingTemplate, 'file') ~= 2
    error('template setting file does not exist.\n%s', settingTemplate);
end

try
    configTemplate = yaml.ReadYaml(settingTemplate);
catch
    error('Failed to read %s\nCheck the default setting file first.', ...
          settingTemplate);
end

try
    configActive = yaml.ReadYaml(settingFile);
catch
    error('Failed to read %s\nCheck the setting file first.', settingFile);
end

config = fillStruct(configActive, configTemplate);


function config = fillStruct(inStruct, tempStruct)

config = tempStruct;

if (~ isstruct(inStruct)) || (~ isstruct(tempStruct))
    return;
end

for fn = fieldnames(inStruct)'
    if isstruct(tempStruct.(fn{1}))
        config.(fn{1}) = fillStruct(inStruct.(fn{1}), tempStruct.(fn{1}));
    elseif isfield(tempStruct, fn{1})
        config.(fn{1}) = inStruct.(fn{1});
    else
        error('Unknown seting(s): %s', fn{1});
    end
end