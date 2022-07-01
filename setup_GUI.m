% drop this file to MATLAB command line to activate the cloud_evaluation_GUI.
% Or click `run` on the toolbar to execute this script.

projectDir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(projectDir, 'lib')));
addpath(genpath(fullfile(projectDir, 'include')));

cloud_evaluation_GUI;