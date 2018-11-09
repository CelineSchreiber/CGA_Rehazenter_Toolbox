% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    setStaticSegment_multisegFoot
% -------------------------------------------------------------------------
% Subject:      Set segment parameters
% Plugin:       Multi segment Foot
% -------------------------------------------------------------------------
% Author: C. Schreiber, F. Moissenet
% Date of creation: 07/09/2018
% Version: 1
% =========================================================================

function [Condition,btk2] = setStaticSegment_multisegFoot(Condition,Marker,btk2)

% =========================================================================
% RIGHT TIBIA/FIBULA
% =========================================================================
% Knee joint centre (Dumas and Wojtusch 2018)
Vmarker.R_KJC = (Marker.R_FLE+Marker.R_FME)/2;
% Export marker in C3D file
temp = [Vmarker.R_KJC(1) -Vmarker.R_KJC(3) Vmarker.R_KJC(2)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_KJC');

Segment(5).rM = [Marker.R_FLE,Marker.R_FAL,Vmarker.R_KJC];
% Save static information
Condition.Static.MultisegFoot.Vmarker.R_KJC = Vmarker.R_KJC;
Condition.Static.MultisegFoot.Segment(5).rM = Segment(5).rM;

% =========================================================================
% RIGHT FOOT
% =========================================================================
% Ankle joint centre (Dumas and Wojtusch 2018)
Vmarker.R_AJC = (Marker.R_FAL+Marker.R_TAM)/2;
% Export marker in C3D file
temp = [Vmarker.R_AJC(1) -Vmarker.R_AJC(3) Vmarker.R_AJC(2)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_AJC');

Segment(4).rM = [Marker.R_FCC,Marker.R_FM1,Marker.R_FM2,Marker.R_FM5];
% Save static information
Condition.Static.MultisegFoot.Vmarker.R_AJC = Vmarker.R_AJC;
Condition.Static.MultisegFoot.Segment(4).rM = Segment(4).rM;

% =========================================================================
% RIGHT CALCA
% =========================================================================
% Metatarsal joint centre
Vmarker.R_CJC = (Marker.R_VMB+Marker.R_MCL)/2;
% Export marker in C3D file
temp = [Vmarker.R_CJC(1) -Vmarker.R_CJC(3) Vmarker.R_CJC(2)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_CJC');

Segment(3).rM = [Marker.R_FCC,Marker.R_MCL,Marker.R_LCL];
% Save static information
Condition.Static.MultisegFoot.Vmarker.R_CJC = Vmarker.R_CJC;
Condition.Static.MultisegFoot.Segment(3).rM = Segment(3).rM;

% =========================================================================
% RIGHT MIDFOOT
% =========================================================================
% Metatarsal joint centre (Dumas and Wojtusch 2018)
Vmarker.R_MJC = (2*Marker.R_FMB+Marker.R_VMB)/3;
% Export marker in C3D file
temp = [Vmarker.R_MJC(1) -Vmarker.R_MJC(3) Vmarker.R_MJC(2)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_MJC');

Segment(2).rM = [Marker.R_VMB,Marker.R_FMB,Marker.R_TN];
% Save static information
Condition.Static.MultisegFoot.Vmarker.R_MJC = Vmarker.R_MJC;
Condition.Static.MultisegFoot.Segment(2).rM = Segment(2).rM;

% =========================================================================
% RIGHT FOREFOOT
% =========================================================================
% Metatarsal joint centre (Dumas and Wojtusch 2018)
Vmarker.R_FJC = Marker.R_FM2;
% Export marker in C3D file
temp = [Vmarker.R_FJC(1) -Vmarker.R_FJC(3) Vmarker.R_FJC(2)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_FJC');

Segment(1).rM = [Marker.R_FMB,Marker.R_FM1,Marker.R_FM2,Marker.R_FM5]
% Save static information
Condition.Static.MultisegFoot.Vmarker.R_FJC = Vmarker.R_FJC;
Condition.Static.MultisegFoot.Segment(1).rM = Segment(1).rM;

% =========================================================================
% LEFT TIBIA/FIBULA
% =========================================================================
% Knee joint centre (Dumas and Wojtusch 2018)
Vmarker.L_KJC = (Marker.L_FLE+Marker.L_FME)/2;
% Export marker in C3D file
temp = [Vmarker.L_KJC(1) -Vmarker.L_KJC(3) Vmarker.L_KJC(2)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_KJC');

Segment(105).rM = [Marker.L_FLE,Marker.L_FAL,Vmarker.L_KJC];
% Save static information
Condition.Static.MultisegFoot.Vmarker.L_KJC = Vmarker.L_KJC;
Condition.Static.MultisegFoot.Segment(105).rM = Segment(105).rM;

% =========================================================================
% LEFT FOOT
% =========================================================================
% Ankle joint centre (Dumas and Wojtusch 2018)
Vmarker.L_AJC = (Marker.L_FAL+Marker.L_TAM)/2;
% Export marker in C3D file
temp = [Vmarker.L_AJC(1) -Vmarker.L_AJC(3) Vmarker.L_AJC(2)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_AJC');

Segment(104).rM = [Marker.L_FCC,Marker.L_FM1,Marker.L_FM2,Marker.L_FM5];
% Save static information
Condition.Static.MultisegFoot.Vmarker.L_AJC = Vmarker.L_AJC;
Condition.Static.MultisegFoot.Segment(104).rM = Segment(104).rM;

% =========================================================================
% LEFT CALCA
% =========================================================================
% Metatarsal joint centre (Dumas and Wojtusch 2018)
Vmarker.L_CJC = (Marker.L_VMB+Marker.L_MCL)/2;
% Export marker in C3D file
temp = [Vmarker.L_CJC(1) -Vmarker.L_CJC(3) Vmarker.L_CJC(2)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_CJC');

Segment(103).rM = [Marker.L_FCC,Marker.L_MCL,Marker.L_LCL];
% Save static information
Condition.Static.MultisegFoot.Vmarker.L_CJC = Vmarker.L_CJC;
Condition.Static.MultisegFoot.Segment(103).rM = Segment(103).rM;

% =========================================================================
% LEFT MIDFOOT
% =========================================================================
% Metatarsal joint centre (Dumas and Wojtusch 2018)
Vmarker.L_MJC = (2*Marker.L_FMB+Marker.L_VMB)/3;
% Export marker in C3D file
temp = [Vmarker.L_MJC(1) -Vmarker.L_MJC(3) Vmarker.L_MJC(2)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_MJC');

Segment(102).rM = [Marker.L_VMB,Marker.L_FMB,Marker.L_TN];
% Save static information
Condition.Static.MultisegFoot.Vmarker.L_MJC = Vmarker.L_MJC;
Condition.Static.MultisegFoot.Segment(102).rM = Segment(102).rM;

% =========================================================================
% RIGHT FOREFOOT
% =========================================================================
% Metatarsal joint centre (Dumas and Wojtusch 2018)
Vmarker.L_FJC = Marker.L_FM2;
% Export marker in C3D file
temp = [Vmarker.L_FJC(1) -Vmarker.L_FJC(3) Vmarker.L_FJC(2)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_FJC');

Segment(101).rM = [Marker.L_FMB,Marker.L_FM1,Marker.L_FM2,Marker.L_FM5];
% Save static information
Condition.Static.MultisegFoot.Vmarker.L_FJC = Vmarker.L_FJC;
Condition.Static.MultisegFoot.Segment(101).rM = Segment(101).rM;
