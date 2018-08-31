% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    computeSegmentKinematics_lowerLimb
% -------------------------------------------------------------------------
% Subject:      Compute kinematics
% Plugin:       Lower limb
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function [Segment,btk2] = computeSegmentKinematics_headTrunk(Segment,btk2)

Segment=Segment_Kinematics_headTrunk(Segment);
s = size(Segment,2);

for i=1:s
    if max(abs(Segment(i).Euler(1,1,:)*180/pi)) > 150
        Segment(i).FE = -(mod(Segment(i).Euler(1,1,:),2*pi)-pi)*180/pi;
    else
        Segment(i).FE = -Segment(i).Euler(1,1,:)*180/pi;
    end
    if max(abs(Segment(i).Euler(1,3,:)*180/pi)) > 150
        Segment(i).IER = (mod(Segment(i).Euler(1,3,:),2*pi)-pi)*180/pi;
    else
        Segment(i).IER = Segment(i).Euler(1,3,:)*180/pi;
    end
    if max(abs(Segment(i).Euler(1,2,:)*180/pi)) > 150
        Segment(i).AA = (mod(Segment(i).Euler(1,2,:),2*pi)-pi)*180/pi;
    else
        Segment(i).AA = Segment(i).Euler(1,2,:)*180/pi;
    end
end

% =========================================================================
% HEAD
% =========================================================================
% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Segment(1).FE,[3,2,1]) ...
    permute(Segment(1).AA,[3,2,1]) ...
    permute(Segment(1).IER,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'Head_angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: Tup(+)/Tdw, Y-Axis: Oup(+)/Odw, Z-Axis: IR(+)/ER');

% =========================================================================
% SCAPULA
% =========================================================================
% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Segment(2).FE,[3,2,1]) ...
    permute(Segment(2).IER,[3,2,1]) ...
    permute(Segment(2).AA,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'Scapula_angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: Tup(+)/Tdw, Y-Axis: Val(+)/Var, Z-Axis: IR(+)/ER');

% =========================================================================
% RACHIS
% =========================================================================
% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Segment(3).FE,[3,2,1]) ...
    permute(Segment(3).IER,[3,2,1]) ...
    permute(Segment(3).AA,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'Rachis_angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: Tup(+)/Tdw, Y-Axis: Val(+)/Var, Z-Axis: IR(+)/ER');

% =========================================================================
% PELVIS
% =========================================================================
% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Segment(4).FE,[3,2,1]) ...
    permute(Segment(4).IER,[3,2,1]) ...
    permute(Segment(4).AA,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'Pelvis_angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: Tup(+)/Tdw, Y-Axis: Val(+)/Var, Z-Axis: IR(+)/ER');