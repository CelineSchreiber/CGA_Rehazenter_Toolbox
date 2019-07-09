% function writeReport()

clearvars;
clc;

toolboxFolder = 'C:\Users\celine.schreiber\Documents\MATLAB\CGA_Rehazenter_Toolbox';
cd(toolboxFolder);

Excel = actxserver ('Excel.Application');
File = 'C:\Users\celine.schreiber\Documents\MATLAB\CGA_Rehazenter_Toolbox\template2.xlsm';
% if ~exist(File,'file')
% ExcelWorkbook = Excel.workbooks.Add;
% ExcelWorkbook.SaveAs(File,1);
% ExcelWorkbook.Close(false);
% end
% invoke(Excel.Workbooks,'Open',File);

cd('C:\Users\celine.schreiber\Documents\MATLAB\CGA_Rehazenter_Toolbox\norm')
norm = load('Normes spontanee.mat');

% NORMATIVE DATA MEAN
% Pelvis kinematics
xlswrite(File,norm.Normatives.Segmentkinematics.L_Pelvis_Angle_FE.mean,'Examen - norm (2)','B6:B106'); 
xlswrite(File,norm.Normatives.Segmentkinematics.L_Pelvis_Angle_FE.std,'Examen - norm (2)','C6:C106'); 
xlswrite(File,norm.Normatives.Segmentkinematics.R_Pelvis_Angle_FE.mean,'Examen - norm (2)','D6:D106'); 
xlswrite(File,norm.Normatives.Segmentkinematics.R_Pelvis_Angle_FE.std,'Examen - norm (2)','E6:E106');
xlswrite(File,norm.Normatives.Segmentkinematics.L_Pelvis_Angle_AA.mean,'Examen - norm (2)','F6:F106');
xlswrite(File,norm.Normatives.Segmentkinematics.L_Pelvis_Angle_AA.std,'Examen - norm (2)','G6:G106');
xlswrite(File,norm.Normatives.Segmentkinematics.R_Pelvis_Angle_AA.mean,'Examen - norm (2)','H6:H106'); 
xlswrite(File,norm.Normatives.Segmentkinematics.R_Pelvis_Angle_AA.std,'Examen - norm (2)','I6:I106'); 
xlswrite(File,norm.Normatives.Segmentkinematics.L_Pelvis_Angle_IER.mean,'Examen - norm (2)','J6:J106');
xlswrite(File,norm.Normatives.Segmentkinematics.L_Pelvis_Angle_IER.std,'Examen - norm (2)','K6:K106');
xlswrite(File,norm.Normatives.Segmentkinematics.R_Pelvis_Angle_IER.mean,'Examen - norm (2)','L6:L106'); 
xlswrite(File,norm.Normatives.Segmentkinematics.R_Pelvis_Angle_IER.std,'Examen - norm (2)','M6:M106'); 

% Hip kinematics
xlswrite(File,norm.Normatives.Jointkinematics.L_Hip_Angle_FE.mean,'Examen - norm (2)','N6:N106'); 
xlswrite(File,norm.Normatives.Jointkinematics.L_Hip_Angle_FE.std,'Examen - norm (2)','O6:O106'); 
xlswrite(File,norm.Normatives.Jointkinematics.R_Hip_Angle_FE.mean,'Examen - norm (2)','P6:P106'); 
xlswrite(File,norm.Normatives.Jointkinematics.R_Hip_Angle_FE.std,'Examen - norm (2)','Q6:Q106');
xlswrite(File,norm.Normatives.Jointkinematics.L_Hip_Angle_AA.mean,'Examen - norm (2)','R6:R106');
xlswrite(File,norm.Normatives.Jointkinematics.L_Hip_Angle_AA.std,'Examen - norm (2)','S6:S106');
xlswrite(File,norm.Normatives.Jointkinematics.R_Hip_Angle_AA.mean,'Examen - norm (2)','T6:T106'); 
xlswrite(File,norm.Normatives.Jointkinematics.R_Hip_Angle_AA.std,'Examen - norm (2)','U6:U106');
xlswrite(File,norm.Normatives.Jointkinematics.L_Hip_Angle_IER.mean,'Examen - norm (2)','V6:V106');
xlswrite(File,norm.Normatives.Jointkinematics.L_Hip_Angle_IER.std,'Examen - norm (2)','W6:W106');
xlswrite(File,norm.Normatives.Jointkinematics.R_Hip_Angle_IER.mean,'Examen - norm (2)','X6:X106'); 
xlswrite(File,norm.Normatives.Jointkinematics.R_Hip_Angle_IER.std,'Examen - norm (2)','Y6:Y106');

% Knee kinematics
xlswrite(File,norm.Normatives.Jointkinematics.L_Knee_Angle_FE.mean,'Examen - norm (2)','Z6:Z106'); 
xlswrite(File,norm.Normatives.Jointkinematics.L_Knee_Angle_FE.std,'Examen - norm (2)','AA6:AA106'); 
xlswrite(File,norm.Normatives.Jointkinematics.R_Knee_Angle_FE.mean,'Examen - norm (2)','AB6:AB106'); 
xlswrite(File,norm.Normatives.Jointkinematics.R_Knee_Angle_FE.std,'Examen - norm (2)','AC6:AC106'); 
xlswrite(File,norm.Normatives.Jointkinematics.L_Knee_Angle_AA.mean,'Examen - norm (2)','AD6:AD106'); 
xlswrite(File,norm.Normatives.Jointkinematics.L_Knee_Angle_AA.std,'Examen - norm (2)','AE6:AE106');
xlswrite(File,norm.Normatives.Jointkinematics.R_Knee_Angle_AA.mean,'Examen - norm (2)','AF6:AF106');
xlswrite(File,norm.Normatives.Jointkinematics.R_Knee_Angle_AA.std,'Examen - norm (2)','AG6:AG106');
xlswrite(File,norm.Normatives.Jointkinematics.L_Knee_Angle_IER.mean,'Examen - norm (2)','AH6:AH106');
xlswrite(File,norm.Normatives.Jointkinematics.L_Knee_Angle_IER.std,'Examen - norm (2)','AI6:AI106');
xlswrite(File,norm.Normatives.Jointkinematics.R_Knee_Angle_IER.mean,'Examen - norm (2)','AJ6:AJ106');
xlswrite(File,norm.Normatives.Jointkinematics.R_Knee_Angle_IER.std,'Examen - norm (2)','AK6:AK106');

% Ankle kinematics
xlswrite(File,norm.Normatives.Jointkinematics.L_Ankle_Angle_FE.mean,'Examen - norm (2)','AL6:AL106'); 
xlswrite(File,norm.Normatives.Jointkinematics.L_Ankle_Angle_FE.std,'Examen - norm (2)','AM6:AM106'); 
xlswrite(File,norm.Normatives.Jointkinematics.R_Ankle_Angle_FE.mean,'Examen - norm (2)','AN6:AN106'); 
xlswrite(File,norm.Normatives.Jointkinematics.R_Ankle_Angle_FE.std,'Examen - norm (2)','AO6:AO106'); 
xlswrite(File,norm.Normatives.Jointkinematics.L_Ankle_Angle_AA.mean,'Examen - norm (2)','AP6:AP106'); 
xlswrite(File,norm.Normatives.Jointkinematics.L_Ankle_Angle_AA.std,'Examen - norm (2)','AQ6:AQ106');
xlswrite(File,norm.Normatives.Jointkinematics.R_Ankle_Angle_AA.mean,'Examen - norm (2)','AR6:AR106');
xlswrite(File,norm.Normatives.Jointkinematics.R_Ankle_Angle_AA.std,'Examen - norm (2)','AS6:AS106');
xlswrite(File,norm.Normatives.Jointkinematics.L_Ankle_Angle_IER.mean,'Examen - norm (2)','AT6:AT106');
xlswrite(File,norm.Normatives.Jointkinematics.L_Ankle_Angle_IER.std,'Examen - norm (2)','AU6:AU106');
xlswrite(File,norm.Normatives.Jointkinematics.R_Ankle_Angle_IER.mean,'Examen - norm (2)','AV6:AV106');
xlswrite(File,norm.Normatives.Jointkinematics.R_Ankle_Angle_IER.std,'Examen - norm (2)','AW6:AW106');

% Foot kinematics
xlswrite(File,norm.Normatives.Segmentkinematics.L_Foot_Angle_FE.mean,'Examen - norm (2)','AX6:AX106'); 
xlswrite(File,norm.Normatives.Segmentkinematics.L_Foot_Angle_FE.std,'Examen - norm (2)','AY6:AY106'); 
xlswrite(File,norm.Normatives.Segmentkinematics.R_Foot_Angle_FE.mean,'Examen - norm (2)','AZ6:AZ106'); 
xlswrite(File,norm.Normatives.Segmentkinematics.R_Foot_Angle_FE.std,'Examen - norm (2)','BA6:BA106'); 
xlswrite(File,-norm.Normatives.Segmentkinematics.L_Foot_Angle_AA.mean,'Examen - norm (2)','BB6:BB106'); 
xlswrite(File,norm.Normatives.Segmentkinematics.L_Foot_Angle_AA.std,'Examen - norm (2)','BC6:BC106');
xlswrite(File,-norm.Normatives.Segmentkinematics.R_Foot_Angle_AA.mean,'Examen - norm (2)','BD6:BD106');
xlswrite(File,norm.Normatives.Segmentkinematics.R_Foot_Angle_AA.std,'Examen - norm (2)','BE6:BE106');
xlswrite(File,-norm.Normatives.Segmentkinematics.L_Foot_Angle_IER.mean,'Examen - norm (2)','BF6:BF106');
xlswrite(File,norm.Normatives.Segmentkinematics.L_Foot_Angle_IER.std,'Examen - norm (2)','BG6:BG106');
xlswrite(File,-norm.Normatives.Segmentkinematics.R_Foot_Angle_IER.mean,'Examen - norm (2)','BH6:BH106');
xlswrite(File,norm.Normatives.Segmentkinematics.R_Foot_Angle_IER.std,'Examen - norm (2)','BI6:BI106');

% invoke(Excel.ActiveWorkbook,'Save');
Excel.Quit
Excel.delete
clear Excel