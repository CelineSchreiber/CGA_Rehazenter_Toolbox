% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    computeJointKinematics_lowerLimb
% -------------------------------------------------------------------------
% Subject:      Compute kinematics
% Plugin:       Lower limb
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function [Joint,btk2] = computeJointKinematics_multisegFoot(Segment,btk2)

Joint = Joint_Kinematics_multisegFoot(Segment);

% =========================================================================
% RIGHT ANKLE
% =========================================================================
Joint(4).FE = Joint(4).Euler(1,1,:)*180/pi;
Joint(4).IER = Joint(4).Euler(1,2,:)*180/pi;
Joint(4).AA = Joint(4).Euler(1,3,:)*180/pi;
% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(4).FE,[3,2,1]) ...
    permute(Joint(4).AA,[3,2,1]) ...
    permute(Joint(4).IER,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_Ankle_angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: DF(+)/PF, Y-Axis: Ad(+)/Ab, Z-Axis: IR(+)/ER');

% =========================================================================
% RIGHT CALCA
% =========================================================================
Joint(3).FE = Joint(3).Euler(1,1,:)*180/pi;
Joint(3).AA = Joint(3).Euler(1,2,:)*180/pi;
Joint(3).IER = Joint(3).Euler(1,3,:)*180/pi;
% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(-Joint(3).FE,[3,2,1]) ...
    permute(-Joint(3).AA,[3,2,1]) ...
    permute(Joint(3).IER,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_Calca_angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: F(+)/E, Y-Axis: Ad(+)/Ab, Z-Axis: IR(+)/ER');

% =========================================================================
% RIGHT MIDFOOT
% =========================================================================
Joint(2).FE = Joint(2).Euler(1,1,:)*180/pi;
Joint(2).AA = Joint(2).Euler(1,2,:)*180/pi;
Joint(2).IER = -Joint(2).Euler(1,3,:)*180/pi;
% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(2).FE,[3,2,1]) ...
    permute(Joint(4).AA,[3,2,1]) ...
    permute(Joint(4).IER,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_Midfoot_angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: F(+)/E, Y-Axis: Ad(+)/Ab, Z-Axis: IR(+)/ER');

% =========================================================================
% RIGHT FOREFOOT
% =========================================================================
Joint(1).FE = -Joint(1).Euler(1,1,:)*180/pi;
Joint(1).AA = Joint(1).Euler(1,2,:)*180/pi;
Joint(1).IER = Joint(1).Euler(1,3,:)*180/pi;

% if max(Joint(1).Euler(1,1,:)*180/pi) > 150
%     Joint(1).FE = (mod(Joint(1).Euler(1,1,:),2*pi)-pi)*180/pi;
% else
%     Joint(1).FE = Joint(1).Euler(1,1,:)*180/pi;
% end

% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(1).FE,[3,2,1]) ...
    permute(Joint(1).AA,[3,2,1]) ...
    permute(Joint(1).IER,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_Forefoot_angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: F(+)/E, Y-Axis: Ad(+)/Ab, Z-Axis: IR(+)/ER');


% =========================================================================
% LEFT ANKLE
% =========================================================================
Joint(104).FE = Joint(104).Euler(1,1,:)*180/pi;
Joint(104).IER = Joint(104).Euler(1,2,:)*180/pi;
Joint(104).AA = -(Joint(104).Euler(1,3,:)*180/pi); % +180°
% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(104).FE,[3,2,1]) ...
    permute(Joint(104).AA,[3,2,1]) ...
    permute(Joint(104).IER,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_Ankle_angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: DF(+)/PF, Y-Axis: Ad(+)/Ab, Z-Axis: IR(+)/ER');

% =========================================================================
% LEFT CALCA
% =========================================================================
Joint(103).FE = Joint(103).Euler(1,1,:)*180/pi;
Joint(103).AA = -Joint(103).Euler(1,2,:)*180/pi;
Joint(103).IER = Joint(103).Euler(1,3,:)*180/pi;
% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(-Joint(103).FE,[3,2,1]) ...
    permute(-Joint(103).AA,[3,2,1]) ...
    permute(Joint(103).IER,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_Calca_angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: F(+)/E, Y-Axis: Ad(+)/Ab, Z-Axis: IR(+)/ER');

% =========================================================================
% LEFT MIDFOOT
% =========================================================================
Joint(102).FE = Joint(102).Euler(1,1,:)*180/pi;
Joint(102).AA = -Joint(102).Euler(1,2,:)*180/pi;
Joint(102).IER = -Joint(102).Euler(1,3,:)*180/pi;
% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(102).FE,[3,2,1]) ...
    permute(Joint(102).AA,[3,2,1]) ...
    permute(Joint(102).IER,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_Midfoot_angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: F(+)/E, Y-Axis: Ad(+)/Ab, Z-Axis: IR(+)/ER');

% =========================================================================
% LEFT FOREFOOT
% =========================================================================
Joint(101).FE = -Joint(101).Euler(1,1,:)*180/pi;
Joint(101).AA = -Joint(101).Euler(1,2,:)*180/pi;
Joint(101).IER = Joint(101).Euler(1,3,:)*180/pi;
% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(101).FE,[3,2,1]) ...
    permute(Joint(101).AA,[3,2,1]) ...
    permute(Joint(101).IER,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_Forefoot_angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: F(+)/E, Y-Axis: Ad(+)/Ab, Z-Axis: IR(+)/ER');
