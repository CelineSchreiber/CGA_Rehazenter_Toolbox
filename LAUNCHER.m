% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% This toolbox uses the Biomechanical ToolKit for .c3d imp/exportation
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
disp('                         Version: 2019                            ');
disp('                  Date of creation: 02/05/2019                    ');
disp('==================================================================');
disp(' ');

% =========================================================================
% Set toolbox folders
% =========================================================================
disp('Initialisation ...');
toolboxFolder = 'C:\Users\celine.schreiber\Documents\MATLAB\CGA_Rehazenter_Toolbox';
normativeFile = 'C:\Users\celine.schreiber\Documents\MATLAB\CGA_Rehazenter_Toolbox\norm\Normes spontanee.mat';
reportFolder = 'X:\Reports';
addpath(toolboxFolder);
addpath(genpath([toolboxFolder,'\module']));
addpath(genpath([toolboxFolder,'\toolbox']));
disp(' ');

% =========================================================================
% Set patient folder
% =========================================================================
sessionFolder = 'C:\Users\celine.schreiber\Documents\MATLAB\CGA_Rehazenter_Toolbox\example\patient2';
patientFolder = sessionFolder;

% =========================================================================
% Start Clinical Gait Analysis
% =========================================================================
startCGA(toolboxFolder,sessionFolder,patientFolder);

% =========================================================================
% Matlab Reporting tool
% =========================================================================
startClinicalReport_lowerLimb()

% =========================================================================
% Excel Reporting tool
% =========================================================================
startReport_lowerLimb(toolboxFolder,sessionFolder,patientFolder)