% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    setTrialSegment_kinetics_lowerLimb
% -------------------------------------------------------------------------
% Subject:      Set segment parameters
% Plugin:       Lower limb
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function [Segment,Joint,btk2] = ...
    setTrialSegment_kinetics_lowerLimb(Session,Patient,Segment,Joint,Marker,Grf,btk2,s)

n = size(Marker.R_IAS,3);

% =========================================================================
% RIGHT FORCEPLATE
% =========================================================================
% Set joint parameters
if s(1) == 1
    F1 = Grf(1).F;
    M1 = Grf(1).M;
elseif s(1) == 2
    F1 = Grf(2).F;
    M1 = Grf(2).M;
else
    F1 = NaN(3,1,length(Marker.R_FCC));
    M1 = NaN(3,1,length(Marker.R_FCC));
end
if ~isnan(F1(1,1,1))
    temp1 = permute(-F1,[3,1,2]);
    temp2 = interp1(1:length(temp1),temp1,linspace(1,length(temp1),n),'pchip');
    Joint(1).F = permute(temp2,[2,3,1]);
    temp1 = permute(-M1,[3,1,2]);
    temp2 = interp1(1:length(temp1),temp1,linspace(1,length(temp1),n),'pchip');
    Joint(1).M = permute(temp2,[2,3,1]);
else
    Joint(1).F = NaN(3,1,length(Marker.R_FCC));
    Joint(1).M = NaN(3,1,length(Marker.R_FCC));
end

% =========================================================================
% LEFT FORCEPLATE
% =========================================================================
% Set joint parameters
if s(2) == 1
    F101 = Grf(1).F;
    M101 = Grf(1).M;
elseif s(2) == 2
    F101 = Grf(2).F;
    M101 = Grf(2).M;
else
    F101 = NaN(3,1,length(Marker.L_FCC));
    M101 = NaN(3,1,length(Marker.L_FCC));
end
if ~isnan(F101(1,1,1))
    temp1 = permute(-F101,[3,1,2]);
    temp2 = interp1(1:length(temp1),temp1,linspace(1,length(temp1),n),'pchip');
    Joint(101).F = permute(temp2,[2,3,1]);
    temp1 = permute(-M101,[3,1,2]);
    temp2 = interp1(1:length(temp1),temp1,linspace(1,length(temp1),n),'pchip');
    Joint(101).M = permute(temp2,[2,3,1]);
else
    Joint(101).F = NaN(3,1,length(Marker.R_FCC));
    Joint(101).M = NaN(3,1,length(Marker.R_FCC));
end

% =========================================================================
% Set inertial parameters for all segments
% =========================================================================
% Load the regression table (Dumas and Wojtusch 2018)
if strcmp(Patient.gender,'Femme')
    r_BSIP = dlmread('r_BSIP_Female.csv',';','C2..L17');
elseif strcmp(Patient.gender,'Homme')
    r_BSIP = dlmread('r_BSIP_Male.csv',';','C2..L17');
end
sindex = [13 12 11 10];
% Set parameters
for i = 2:5
    s = sindex(i-1);
    rPi = Segment(i).Q(4:6,:,:);
    rDi = Segment(i).Q(7:9,:,:);
    L(s) = mean(sqrt(sum((rPi-rDi).^2)),3); % length of the segment
    Segment(i).m = r_BSIP(s,1)*Session.weight/100;
    Segment(i).rCs = [r_BSIP(s,2)*L(s)/100; ...
        r_BSIP(s,3)*L(s)/100; ...
        r_BSIP(s,4)*L(s)/100];
    Segment(i).Is = [((r_BSIP(s,5)*L(s)/100).^2)*(r_BSIP(s,1)*Session.weight/100), ...
        ((r_BSIP(s,8)*L(s)/100).^2)*(r_BSIP(s,1)*Session.weight/100), ...
        ((r_BSIP(s,9)*L(s)/100).^2)*(r_BSIP(s,1)*Session.weight/100); ...
        ((r_BSIP(s,8)*L(s)/100).^2)*(r_BSIP(s,1)*Session.weight/100), ...
        ((r_BSIP(s,6)*L(s)/100).^2)*(r_BSIP(s,1)*Session.weight/100), ...
        ((r_BSIP(s,10)*L(s)/100).^2)*(r_BSIP(s,1)*Session.weight/100);...
        ((r_BSIP(s,9)*L(s)/100).^2)*(r_BSIP(s,1)*Session.weight/100),...
        ((r_BSIP(s,10)*L(s)/100).^2)*(r_BSIP(s,1)*Session.weight/100), ...
        ((r_BSIP(s,7)*L(s)/100).^2)*(r_BSIP(s,1)*Session.weight/100)];
end
for i = 102:105
    s = sindex(i-101);
    rPi = Segment(i).Q(4:6,:,:);
    rDi = Segment(i).Q(7:9,:,:);
    L(s) = mean(sqrt(sum((rPi-rDi).^2)),3); % length of the segment
    Segment(i).m = r_BSIP(s,1)*Session.weight/100;
    Segment(i).rCs = [r_BSIP(s,2)*L(s)/100; ...
        r_BSIP(s,3)*L(s)/100; ...
        r_BSIP(s,4)*L(s)/100];
    Segment(i).Is = [((r_BSIP(s,5)*L(s)/100).^2)*(r_BSIP(s,1)*Session.weight/100), ...
        ((r_BSIP(s,8)*L(s)/100).^2)*(r_BSIP(s,1)*Session.weight/100), ...
        ((r_BSIP(s,9)*L(s)/100).^2)*(r_BSIP(s,1)*Session.weight/100); ...
        ((r_BSIP(s,8)*L(s)/100).^2)*(r_BSIP(s,1)*Session.weight/100), ...
        ((r_BSIP(s,6)*L(s)/100).^2)*(r_BSIP(s,1)*Session.weight/100), ...
        ((r_BSIP(s,10)*L(s)/100).^2)*(r_BSIP(s,1)*Session.weight/100);...
        ((r_BSIP(s,9)*L(s)/100).^2)*(r_BSIP(s,1)*Session.weight/100),...
        ((r_BSIP(s,10)*L(s)/100).^2)*(r_BSIP(s,1)*Session.weight/100), ...
        ((r_BSIP(s,7)*L(s)/100).^2)*(r_BSIP(s,1)*Session.weight/100)];
end

% =========================================================================
% Export inertial parameters as metadata in C3D
% =========================================================================
clear info;
info.format = 'Char';
info.values = {'Pelvis mass (3x1)' 'Pelvis CoM (3x1)' 'Pelvis inertia matrix (3x3)' ...
    'R_Thigh mass (3x1)' 'R_Thigh CoM (3x1)' 'R_Thigh inertia matrix (3x3)' ...
    'R_Shank mass (3x1)' 'R_Shank CoM (3x1)' 'R_Shank inertia matrix (3x3)' ...
    'R_Foot mass (3x1)' 'R_Foot CoM (3x1)' 'R_Foot inertia matrix (3x3)' ...
    'L_Thigh mass (3x1)' 'L_Thigh CoM (3x1)' 'L_Thigh inertia matrix (3x3)' ...
    'L_Shank mass (3x1)' 'L_Shank CoM (3x1)' 'L_Shank inertia matrix (3x3)' ...
    'L_Foot mass (3x1)' 'L_Foot CoM (3x1)' 'L_Foot inertia matrix (3x3)'};
btkAppendMetaData(btk2,'INERTIAL_PARAM','LABELS',info);
clear info;
info.format = 'Char';
info.dimensions = ['35x5'];
info.values = {'kg' 'm' 'kg/m²' 'kg/m²' 'kg/m²' ...
    'kg' 'm' 'kg/m²' 'kg/m²' 'kg/m²' ...
    'kg' 'm' 'kg/m²' 'kg/m²' 'kg/m²' ...
    'kg' 'm' 'kg/m²' 'kg/m²' 'kg/m²' ...
    'kg' 'm' 'kg/m²' 'kg/m²' 'kg/m²' ...
    'kg' 'm' 'kg/m²' 'kg/m²' 'kg/m²' ...
    'kg' 'm' 'kg/m²' 'kg/m²' 'kg/m²'}';
btkAppendMetaData(btk2,'INERTIAL_PARAM','UNITS',info);
clear info;
info.format = 'Real';
info.values = [Segment(5).m Segment(5).m Segment(5).m; ...
    Segment(5).rCs'; ...
    Segment(5).Is; ...
    Segment(4).m Segment(4).m Segment(4).m; ...
    Segment(4).rCs'; ...
    Segment(4).Is; ...
    Segment(3).m Segment(3).m Segment(3).m; ...
    Segment(3).rCs'; ...
    Segment(3).Is; ...
    Segment(2).m Segment(2).m Segment(2).m; ...
    Segment(2).rCs'; ...
    Segment(2).Is; ...
    Segment(104).m Segment(104).m Segment(104).m; ...
    Segment(104).rCs'; ...
    Segment(104).Is; ...
    Segment(103).m Segment(103).m Segment(103).m; ...
    Segment(103).rCs'; ...
    Segment(103).Is; ...
    Segment(102).m Segment(102).m Segment(102).m; ...
    Segment(102).rCs'; ...
    Segment(102).Is];
btkAppendMetaData(btk2,'INERTIAL_PARAM','VALUES',info);

% =========================================================================
% Export CoMs as virtual markers in C3D
% =========================================================================
% Pelvis
temp = Mprod_array3(Q2Tu_array3(Segment(5).Q),repmat([Segment(5).rCs;1],[1 1 n]));
temp2 = [temp(1,:,:); -temp(3,:,:); temp(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp2,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'CoM_Pelvis');
% R_Thigh
temp = Mprod_array3(Q2Tu_array3(Segment(4).Q),repmat([Segment(4).rCs;1],[1 1 n]));
temp2 = [temp(1,:,:); -temp(3,:,:); temp(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp2,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'CoM_R_Thigh');
% R_Shank
temp = Mprod_array3(Q2Tu_array3(Segment(3).Q),repmat([Segment(3).rCs;1],[1 1 n]));
temp2 = [temp(1,:,:); -temp(3,:,:); temp(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp2,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'CoM_R_Shank');
% R_Foot
temp = Mprod_array3(Q2Tu_array3(Segment(2).Q),repmat([Segment(2).rCs;1],[1 1 n]));
temp2 = [temp(1,:,:); -temp(3,:,:); temp(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp2,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'CoM_R_Foot');
% L_Thigh
temp = Mprod_array3(Q2Tu_array3(Segment(104).Q),repmat([Segment(104).rCs;1],[1 1 n]));
temp2 = [temp(1,:,:); -temp(3,:,:); temp(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp2,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'CoM_L_Thigh');
% L_Shank
temp = Mprod_array3(Q2Tu_array3(Segment(103).Q),repmat([Segment(103).rCs;1],[1 1 n]));
temp2 = [temp(1,:,:); -temp(3,:,:); temp(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp2,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'CoM_L_Shank');
% L_Foot
temp = Mprod_array3(Q2Tu_array3(Segment(102).Q),repmat([Segment(102).rCs;1],[1 1 n]));
temp2 = [temp(1,:,:); -temp(3,:,:); temp(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp2,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'CoM_L_Foot');