% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% This toolbox uses the Biomechanical ToolKit for .c3d imp/exportation
% (https://code.google.com/p/b-tk/) 
% and the kinematics/dynamics toolbox developed by Raphaël Dumas 
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
tic
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
normativeFolder = 'C:\Users\celine.schreiber\Documents\MATLAB\CGA_Rehazenter_Toolbox\norm';
addpath(toolboxFolder);
addpath(genpath([toolboxFolder,'\module']));
addpath(genpath([toolboxFolder,'\toolbox']));
disp(' ');

% =========================================================================
% Set patient folder
% =========================================================================
sessionFolder = 'C:\Users\celine.schreiber\Documents\MATLAB\CGA_Rehazenter_Data\normatives_data_adults';
N={'2014001'};

% N={'2014001','2014002','2014003','2014004','2014005','2014006',...
%     '2014007','2014008','2014009','2014011','2014013','2014014'... 
%     '2014015','2014019','2014022','2014024','2014025',...%+2014026?
%     '2014029','2014030','2014031','2014033','2014034','2014040',...%+2014032?
%     '2014046','2014048','2014049','2014050','2014053','2015002',...%+2014051?%+2015001?
%     '2015003','2015004','2015005','2015007','2015013','2015015',...%+2014054?
%     '2015016','2015017','2015020','2015021','2015026','2015027',...
%     '2015030','2015032','2015035','2015037','2015041','2015042',...%+2014034?
%     '2015043'};

% BDD enfants <6ans
% P={'SS2014010','SS2014016','SS2014023','SS2014035','SS2014036','SS2014037',...
% 'SS2014041','SS2014042','SS2014045','SS2015006','SS2015008','SS2015009',...
% 'SS2015010','SS2015011','SS2015014','SS2015023','SS2015025','SS2015031',...
% 'SS2015040','SS2016005','SS2016006','SS2016008','SS2016011'}; 

%BDD enfants [6,12]
% P={'SS2014012','SS2014020','SS2014021','SS2014027','SS2014028','SS2014043',...
% 'SS2014044','SS2014047','SS2015018','SS2015019','SS2015029','SS2015036',...
% 'SS2015038','SS2015039','SS2016002','SS2016003','SS2016004','SS2016007',...
% 'SS2016010'};                     

% BDD enfants [13,18]
% P={'SS2014017','SS2014018','SS2014038','SS2014039','SS2015024','SS2015033',...
%     'SS2016001','SS2017001'};                                            

% BDD spontane/metronome
% P={'SS2014005','SS2014007','SS2014015','SS2014022','SS2014029','SS2014030',...
% 'SS2014053','SS2015005','SS2015024','SS2015030','SS2015032','SS2015037',...
% 'SS2015041','SS2015042',...
% 'SS2015020','SS2015034','SS2015043'}; 

% BDD Tapis
% P={'SS2014001','SS2014002','SS2014003','SS2014004','SS2014005','SS2014006',...
% 'SS2014007','SS2014008','SS2014009','SS2014011','SS2014013','SS2014014',...
% 'SS2014015','SS2014017','SS2014019','SS2014022','SS2014024','SS2014025',...
% 'SS2014026','SS2014029','SS2014030','SS2014031','SS2014032','SS2014033'...
% 'SS2014034','SS2014040','SS2014046','SS2014049','SS2014050'};

% BDD Membre sup
% P={'SS2014001','SS2014002','SS2014003','SS2014004',...%'SS2014005','SS2014006',...
%     'SS2014007','SS2014008','SS2014009','SS2014011','SS2014013','SS2014014',...
%     'SS2014015','SS2014019','SS2014022','SS2014024','SS2014025',...
%     'SS2014026','SS2014029','SS2014030','SS2014031','SS2014032','SS2014033','SS2014034',...
%     'SS2014040','SS2014046','SS2014048','SS2014049',...
%     'SS2014050','SS2014051','SS2014052','SS2014053','SS2014054',...
%     'SS2015002','SS2015003','SS2015004','SS2015005','SS2015007','SS2015013',...
%     'SS2015015'};

for i=1:length(N)
    patientFolder = [sessionFolder,'\',(N{i})];

    % =========================================================================
    % Start Clinical Gait Analysis
    % =========================================================================
    startCGA(toolboxFolder,sessionFolder,patientFolder);
end

%% =========================================================================
% Average all
% =========================================================================
Velocities={'C1','C2','C3','C4','C5'};

for v=1:5
   temp0=[];
   j=0;
   for i=1:length(N)
       temp=[];listing_files=[];
       patientFolder = [sessionFolder,'\',(N{i})];
       cd(patientFolder);
       listing_files=dir('*.mat');
       for m=1:size(listing_files,1)
           k=strfind(listing_files(m).name,(Velocities{v}));
           if ~isempty(k)
               j=j+1;
               temp = load(listing_files(m).name,'-mat','Condition','Patient','Session');
               temp0(j).Patient = temp.Patient;
               temp0(j).Session = temp.Session;
               temp0(j).Condition = temp.Condition;
           end
       end
   end
   clear temp m k i j listing_files
    
   if ~isempty(temp0)
       %%
       %   Population
       %--------------------------------------------------------------------------
       for i=1:length(temp0)
           Population.age.data(i) = temp0(i).Session.age;
           if strcmp(temp0(i).Patient.gender,'Homme')
               Population.gender.data(i)=1;
           else
               Population.gender.data(i)=0;
           end
           Population.weight.data(i)=temp0(i).Session.weight;
           Population.height.data(i)=temp0(i).Session.height;
           Population.L0.data(i)=(temp0(i).Session.R_legLength+temp0(i).Session.L_legLength)/2;
       end
       
       %%
       % Gait parameters STATISTICS
       %--------------------------------------------------------------------------
       names = fieldnames(temp0(1).Condition.Trial(1).LowerLimb.Spatiotemporal);
       
       for k=1:length(names)
           temp = [];
           for i=1:length(temp0)
               for j = 1:length(temp0(i).Condition.Trial)
                   if ~isempty(temp0(i).Condition.Trial(j).LowerLimb.Spatiotemporal)
                       temp = [temp temp0(i).Condition.Trial(j).LowerLimb.Spatiotemporal.(names{k})];
                   end
               end
           end
           Normatives.Spatiotemporal.(names{k}).data = temp;
           Normatives.Spatiotemporal.(names{k}).mean = nanmean(temp,2);
           Normatives.Spatiotemporal.(names{k}).std = nanstd(temp,1,2);
       end
       
       %%
       % Joint Kinematics STATISTICS
       %--------------------------------------------------------------------------
       names = fieldnames(temp0(1).Condition.Trial(1).LowerLimb.Jointkinematics);
       
       for k=1:length(names)
           temp=[];
           for i=1:length(temp0)
               for j = 1:length(temp0(i).Condition.Trial)
                   if ~isempty(temp0(i).Condition.Trial(j).LowerLimb.Jointkinematics.(names{k}))
                       temp = [temp temp0(i).Condition.Trial(j).LowerLimb.Jointkinematics.(names{k})];
                   end
               end
           end
           Normatives.Jointkinematics.(names{k}).data = temp;
           Normatives.Jointkinematics.(names{k}).mean = nanmean(temp,2);
           Normatives.Jointkinematics.(names{k}).std = nanstd(temp,1,2);
       end
       nkinematics=size(Normatives.Jointkinematics.(names{1}).data,2);
       
       %%
       % Segment Kinematics STATISTICS
       %--------------------------------------------------------------------------
       names = fieldnames(temp0(1).Condition.Trial(1).LowerLimb.Segmentkinematics);
       
       for k=1:length(names)
           temp=[];
           for i=1:length(temp0)
               for j = 1:length(temp0(i).Condition.Trial)
                   if ~isempty(temp0(i).Condition.Trial(j).LowerLimb.Segmentkinematics.(names{k}))
                       temp = [temp temp0(i).Condition.Trial(j).LowerLimb.Segmentkinematics.(names{k})];
                   end
               end
           end
           Normatives.Segmentkinematics.(names{k}).data = temp;
           Normatives.Segmentkinematics.(names{k}).mean = nanmean(temp,2);
           Normatives.Segmentkinematics.(names{k}).std = nanstd(temp,1,2);
       end
       
       %%
       % Dynamics STATISTICS
       %--------------------------------------------------------------------------
       names = fieldnames(temp0(1).Condition.Trial(1).LowerLimb.Dynamics);
       
       for k=1:length(names)
           temp=[];
           for i=1:length(temp0)
               for j = 1:length(temp0(i).Condition.Trial)
                   if ~isempty(temp0(i).Condition.Trial(j).LowerLimb.Dynamics.(names{k}))
                       temp = [temp temp0(i).Condition.Trial(j).LowerLimb.Dynamics.(names{k})];
                   end
               end
           end
           Normatives.Dynamics.(names{k}).data = temp;
           Normatives.Dynamics.(names{k}).mean = nanmean(temp,2);
           Normatives.Dynamics.(names{k}).std = nanstd(temp,1,2);
       end
       ndynamics=size(Normatives.Dynamics.(names{1}).data,2);
       
       %%
       % EMG STATISTICS
       %--------------------------------------------------------------------------
       names = fieldnames(temp0(1).Condition.Trial(1).LowerLimb.EMG);
       for k=1:length(names)
           temp=[];
           test = strfind(names{k},'Envelop');
           if ~isempty(test)
               for i=1:length(temp0)
                   for j = 1:length(temp0(i).Condition.Trial)
                       if ~isempty(temp0(i).Condition.Trial(j).LowerLimb.EMG)
                           if isfield(temp0(i).Condition.Trial(j).LowerLimb.EMG,(names{k}))
                               temp = [temp temp0(i).Condition.Trial(j).LowerLimb.EMG.(names{k})];
                           end
                       end
                   end
               end
               Normatives.EMG.(names{k}).data = temp;
               Normatives.EMG.(names{k}).mean = nanmean(temp,2);
               Normatives.EMG.(names{k}).std = nanstd(temp,1,2);
           end
       end
       nEMG=size(Normatives.EMG.(names{2}).data,2);
       
%%       SAUVEGARDE 
%        cd(normativeFolder);
%        save(['Normes ' num2str(Normatives.Spatiotemporal.Velocity.mean) '.mat'],'Normatives','Population');
       
       %%
       % A ajouter: INDEX!!!!!!!!!!!!!!!
       
       Population.nsujets     = length(temp0);
       Population.age.mean    = mean(Population.age.data);
       Population.height.mean = mean(Population.height.data);
       Population.weight.mean = mean(Population.weight.data);
       Population.gender.homme= sum(Population.gender.data)/length(Population.gender.data);
       Population.nkinematics = nkinematics;
       Population.ndynamics   = ndynamics;
       Population.nEMG        = nEMG;
       
       graphical_verification(Normatives,Population);
       
   end
end

