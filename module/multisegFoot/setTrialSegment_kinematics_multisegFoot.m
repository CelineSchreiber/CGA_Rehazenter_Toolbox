% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    setTrialSegment_kinematics_lowerLimb
% -------------------------------------------------------------------------
% Subject:      Set segment parameters
% Plugin:       Lower limb
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function [Segment,Vmarker,btk2] = ...
    setTrialSegment_kinematics_multisegFoot(Condition,Marker,btk2)

n = size(Marker.R_FAL,3);

% =========================================================================
% RIGHT TIBIA/FIBULA
% =========================================================================
% Knee joint centre (Dumas and Wojtusch 2018)
Vmarker.R_KJC = (Marker.R_FLE+Marker.R_FME)/2;

% Tibia/fibula Marker
Segment(6).rM = [Marker.R_FLE,Marker.R_FAL,Vmarker.R_KJC];
% Ankle joint centre
% Reconstruction from Condition.Static.MultisegFoot.Rstatic data by rigid body rotation & translation
% Soederqvist and Wedin 1993 and Challis 1995
Rotation = [];
Translation = [];
RMS = [];
for i = 1:n
    [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
        = soder(Condition.Static.MultisegFoot.Segment(6).rM',Segment(6).rM(:,:,i)');
end
Vmarker.R_AJC = ...
    Mprod_array3(Rotation , repmat(Condition.Static.MultisegFoot.Vmarker.R_AJC,[1 1 n])) ...
    + Translation;
Vmarker.R_AJC = Vmarker.R_AJC(1:3,:,:);
Vmarker.R_AJC = ...
    Mprod_array3(Rotation , repmat(Condition.Static.MultisegFoot.Vmarker.R_AJC,[1 1 n])) ...
    + Translation;
Vmarker.R_AJC = Vmarker.R_AJC(1:3,:,:);
% Export marker in C3D file
temp = [Vmarker.R_AJC(1,:,:) -Vmarker.R_AJC(3,:,:) Vmarker.R_AJC(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_AJC');

% Tibia/fibula axes (Dumas and Wojtusch 2018)
Y6 = Vnorm_array3(Vmarker.R_KJC-Vmarker.R_AJC);
X6 = Vnorm_array3(cross(Marker.R_FAL-Vmarker.R_KJC,Marker.R_TAM-Vmarker.R_KJC));
Z6 = Vnorm_array3(cross(X6,Y6));
% Tibia/fibula parameters (Dumas and Chèze 2007)
rP6 = Vmarker.R_KJC;
rD6 = Vmarker.R_AJC;
w6 = Z6;
u6 = X6;
Segment(6).Q = [u6;rP6;rD6;w6];

% =========================================================================
% LEFT TIBIA/FIBULA
% =========================================================================
% Knee joint centre (Dumas and Wojtusch 2018)
Vmarker.L_KJC = (Marker.L_FLE+Marker.L_FME)/2;
% Tibia/fibula Marker
Segment(106).rM = [Marker.L_FLE,Marker.L_FAL,Vmarker.L_KJC];
% Ankle joint centre
% Reconstruction from Condition.Static.LowerLimb.Rstatic data by rigid body rotation & translation
% Soederqvist and Wedin 1993 and Challis 1995
Rotation = [];
Translation = [];
RMS = [];
for i = 1:n
    [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
        = soder(Condition.Static.MultisegFoot.Segment(106).rM',Segment(106).rM(:,:,i)');
end
Vmarker.L_AJC = ...
    Mprod_array3(Rotation , repmat(Condition.Static.MultisegFoot.Vmarker.L_AJC,[1 1 n])) ...
    + Translation;
Vmarker.L_AJC = Vmarker.L_AJC(1:3,:,:);
% Export marker in C3D file
temp = [Vmarker.L_AJC(1,:,:) -Vmarker.L_AJC(3,:,:) Vmarker.L_AJC(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_AJC');
% Tibia/fibula axes (Dumas and Wojtusch 2018)
Y106 = Vnorm_array3(Vmarker.L_KJC-Vmarker.L_AJC);
X106 = -Vnorm_array3(cross(Marker.L_FAL-Vmarker.L_KJC,Marker.L_TAM-Vmarker.L_KJC));
Z106 = Vnorm_array3(cross(X106,Y106));
% Tibia/fibula parameters (Dumas and Chèze 2007)
rP106 = Vmarker.L_KJC;
rD106 = Vmarker.L_AJC;
w106 = Z106;
u106 = X106;
Segment(106).Q = [u106;rP106;rD106;w106];

% =========================================================================
% RIGHT FOOT
% =========================================================================
% Joint center
Vmarker.R_FJC = Marker.R_FM2;
% Export marker in C3D file
temp = [Vmarker.R_FJC(1,:,:) -Vmarker.R_FJC(3,:,:) Vmarker.R_FJC(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_FJC');

% Foot axes (Dumas and Wojtusch 2018)
x5 = Vnorm_array3(Marker.R_FM2-Marker.R_FCC);
Y5 = Vnorm_array3(cross(Marker.R_FM5-Marker.R_FCC,Marker.R_FM1-Marker.R_FCC));
Z5 = Vnorm_array3(cross(x5,Y5));
X5 = Vnorm_array3(cross(Y5,Z5));
% Foot parameters (Dumas and Chèze 2007)
u5 = X5;
rP5 = Vmarker.R_AJC;
rD5 = Vmarker.R_FJC;
w5 = Z5; 
Segment(5).Q = [u5;rP5;rD5;w5];
Segment(5).rM = [Marker.R_FCC,Marker.R_FM1,Marker.R_FM2,Marker.R_FM5];

% =========================================================================
% LEFT FOOT
% =========================================================================
% Joint center
Vmarker.L_FJC = Marker.L_FM2;
% Export marker in C3D file
temp = [Vmarker.L_FJC(1,:,:) -Vmarker.L_FJC(3,:,:) Vmarker.L_FJC(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_FJC');

% Foot axes (Dumas and Wojtusch 2018)
x105 = Vnorm_array3(Marker.L_FM2-Marker.L_FCC);
Y105 = -Vnorm_array3(cross(Marker.L_FM5-Marker.L_FCC,Marker.L_FM1-Marker.L_FCC));
Z105 = Vnorm_array3(cross(x105,Y105));
X105 = Vnorm_array3(cross(Y105,Z105));
% Foot parameters (Dumas and Chèze 2007)
u105 = X105;
rP105 = Vmarker.L_AJC;
rD105 = Vmarker.L_FJC;
w105 = Z105; 
Segment(105).Q = [u105;rP105;rD105;w105];
Segment(105).rM = [Marker.L_FCC,Marker.L_FM1,Marker.L_FM2,Marker.L_FM5];

% =========================================================================
% RIGHT CALCA
% =========================================================================
% Metatarsal joint centre (Dumas and Wojtusch 2018)
Vmarker.R_IC = (Marker.R_MCL+Marker.R_LCL)/2;
Vmarker.R_CJC = (Marker.R_VMB+Marker.R_MCL)/2;
% Export marker in C3D file
temp = [Vmarker.R_CJC(1,:,:) -Vmarker.R_CJC(3,:,:) Vmarker.R_CJC(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_CJC');
temp = [Vmarker.R_IC(1,:,:) -Vmarker.R_IC(3,:,:) Vmarker.R_IC(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_IC');
% Foot axes (Dumas and Wojtusch 2018)
X4 = Vnorm_array3(Vmarker.R_IC-Marker.R_FCC);
Y4 = -Vnorm_array3(cross(Marker.R_MCL-Marker.R_FCC,Marker.R_LCL-Marker.R_FCC));
Z4 = Vnorm_array3(cross(X4,Y4));

% Foot parameters (Dumas and Chèze 2007)
rP4 = Vmarker.R_AJC;
rD4 = Vmarker.R_CJC;
w4 = Z4;
u4 = X4;
Segment(4).Q = [u4;rP4;rD4;w4];
Segment(4).rM = [Marker.R_FCC,Marker.R_MCL,Marker.R_LCL];

% =========================================================================
% LEFT CALCA
% =========================================================================
% Metatarsal joint centre (Dumas and Wojtusch 2018)
Vmarker.L_IC = (Marker.L_MCL+Marker.L_LCL)/2;
Vmarker.L_CJC = (Marker.L_VMB+Marker.L_MCL)/2;
% Export marker in C3D file
temp = [Vmarker.L_CJC(1,:,:) -Vmarker.L_CJC(3,:,:) Vmarker.L_CJC(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_CJC');
temp = [Vmarker.L_IC(1,:,:) -Vmarker.L_IC(3,:,:) Vmarker.L_IC(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_IC');
% Foot axes (Dumas and Wojtusch 2018)
X104 = Vnorm_array3(Vmarker.L_IC-Marker.L_FCC);
Y104 = Vnorm_array3(cross(Marker.L_MCL-Marker.L_FCC,Marker.L_LCL-Marker.L_FCC));
Z104 = Vnorm_array3(cross(X104,Y104));
% Foot parameters (Dumas and Chèze 2007)
rP104 = Vmarker.L_AJC;
rD104 = Vmarker.L_CJC;
w104 = Z104;
u104 = X104;
Segment(104).Q = [u104;rP104;rD104;w104];
Segment(104).rM = [Marker.L_FCC,Marker.L_MCL,Marker.L_LCL];

% =========================================================================
% RIGHT MIDFOOT
% =========================================================================
% Midfoot joint centre
Vmarker.R_MJC = (2*Marker.R_FMB+Marker.R_VMB)/3;
Vmarker.R_ID = (Marker.R_VMB+Marker.R_TN)/2;
% Export marker in C3D file
temp = [Vmarker.R_MJC(1,:,:) -Vmarker.R_MJC(3,:,:) Vmarker.R_MJC(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_MJC');
temp = [Vmarker.R_ID(1,:,:) -Vmarker.R_ID(3,:,:) Vmarker.R_ID(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_ID');

% Foot axes (Dumas and Wojtusch 2018)
X3 = Vnorm_array3(Vmarker.R_MJC-Vmarker.R_ID);
Y3 = Vnorm_array3(cross(Vmarker.R_MJC-Vmarker.R_ID,Marker.R_TN-Vmarker.R_ID));
Z3 = Vnorm_array3(cross(X3,Y3));
% Foot parameters (Dumas and Chèze 2007)
rP3 = Vmarker.R_CJC;
rD3 = Vmarker.R_MJC;
w3 = Z3;
u3 = X3;
Segment(3).Q = [u3;rP3;rD3;w3];
Segment(3).rM = [Marker.R_VMB,Marker.R_FMB,Marker.R_TN];

% =========================================================================
% LEFT MIDFOOT
% =========================================================================
% Midfoot joint centre
Vmarker.L_MJC = (2*Marker.L_FMB+Marker.L_VMB)/3;;
Vmarker.L_ID = (Marker.L_VMB+Marker.L_TN)/2;
% Export marker in C3D file
temp = [Vmarker.L_MJC(1,:,:) -Vmarker.L_MJC(3,:,:) Vmarker.L_MJC(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_MJC');
temp = [Vmarker.L_ID(1,:,:) -Vmarker.L_ID(3,:,:) Vmarker.L_ID(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_ID');

% Foot axes (Dumas and Wojtusch 2018)
X103 = Vnorm_array3(Vmarker.L_MJC-Vmarker.L_ID);
Y103 = -Vnorm_array3(cross(Vmarker.L_MJC-Vmarker.L_ID,Marker.L_TN-Vmarker.L_ID));
Z103 = Vnorm_array3(cross(X103,Y103));
% Foot parameters (Dumas and Chèze 2007)
rP103 = Vmarker.L_CJC;
rD103 = Vmarker.L_MJC;
w103 = Z103;
u103 = X103;
Segment(103).Q = [u103;rP103;rD103;w103];
Segment(103).rM = [Marker.L_VMB,Marker.L_FMB,Marker.L_TN];

% =========================================================================
% RIGHT FOREFOOT/METATARSE
% =========================================================================
% Foot axes (Dumas and Wojtusch 2018)
x2 = Vnorm_array3(Marker.R_FM2-Vmarker.R_MJC);
Y2 = -Vnorm_array3(cross(Marker.R_FM1-Vmarker.R_MJC,Marker.R_FM5-Vmarker.R_MJC));
Z2 = Vnorm_array3(cross(x2,Y2));
X2 = Vnorm_array3(cross(Y2,Z2));
% Foot parameters (Dumas and Chèze 2007)
rP2 = Vmarker.R_MJC;
rD2 = Vmarker.R_FJC;
w2 = Z2;
u2 = X2;
Segment(2).Q = [u2;rP2;rD2;w2];
Segment(2).rM = [Marker.R_FMB,Marker.R_FM1,Marker.R_FM2,Marker.R_FM5];

% =========================================================================
% LEFT FOREFOOT/METATARSE
% =========================================================================

% Foot axes (Dumas and Wojtusch 2018)
x102 = Vnorm_array3(Marker.L_FM2-Vmarker.L_MJC);
Y102 = Vnorm_array3(cross(Marker.L_FM1-Vmarker.L_MJC,Marker.L_FM5-Vmarker.L_MJC));
Z102 = Vnorm_array3(cross(x102,Y102));
X102 = Vnorm_array3(cross(Y102,Z102));
% Foot parameters (Dumas and Chèze 2007)
rP102 = Vmarker.L_MJC;
rD102 = Vmarker.L_FJC;
w102 = Z102;
u102 = X102;
Segment(102).Q = [u102;rP102;rD102;w102];
Segment(102).rM = [Marker.L_SMB,Marker.L_FM1,Marker.L_FM2,Marker.L_FM5];