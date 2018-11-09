
% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% This toolbox uses the Biomechanical ToolKit for .c3d importation
% (https://code.google.com/p/b-tk/) 
% and the kinematics/dynamics toolbox developed by Rapha�l Dumas 
% (https://nl.mathworks.com/matlabcentral/fileexchange/...
% 58021-3d-kinematics-and-inverse-dynamics)
% =========================================================================
% File name:    LAUNCHER
% -------------------------------------------------------------------------
% Subject:      Set parameters for CGA
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

% =========================================================================
% Initialisation
% =========================================================================
clearvars;
warning('off','All');
clc;
disp('==================================================================');
disp('            REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX             ');
disp('==================================================================');
disp('              Authors: F. Moissenet, C. Schreiber                 ');
disp('                         Version: 2018                            ');
disp('                  Date of creation: 16/05/2018                    ');
disp('==================================================================');
disp(' ');

% =========================================================================
% Set toolbox folders
% =========================================================================
disp('Initialisation ...');
toolboxFolder = 'C:\Users\celine.schreiber\Documents\MATLAB\Posturo\CGA_Rehazenter_Toolbox';
normativeFile = 'C:\Users\celine.schreiber\Documents\MATLAB\Posturo\CGA_Rehazenter_Toolbox\norm\Normes spontanee.mat';
reportFolder = 'X:\Reports';
addpath(toolboxFolder);
addpath(genpath([toolboxFolder,'\module']));
addpath(genpath([toolboxFolder,'\toolbox']));
disp(' ');

% =========================================================================
% Set patient folder
% =========================================================================
c3dFolder = 'C:\Users\celine.schreiber\Documents\MATLAB\Posturo\CGA_Rehazenter_Toolbox\example_foot';
matFolder = c3dFolder;

% =========================================================================
% Active modules % 0: inactive | 1: active
% =========================================================================
% Kinematic chains
Module.lowerLimb = 1;
Module.upperLimb = 0;
% Setting.posture_PLUGIN = 0;
% Setting.emg_PLUGIN = 0;
% Setting.foot_PLUGIN = 0;
% Setting.baropodo_PLUGIN = 0;
% Setting.statistics_PLUGIN = 0;
% Setting.report_PLUGIN = 0;
% Setting.database_PLUGIN = 0;

% =========================================================================
% Start Clinical Gait Analysis
% =========================================================================
startCGA(toolboxFolder,c3dFolder,matFolder,Module);
% if Setting.report == 1
%     report_PLUGIN();
% end