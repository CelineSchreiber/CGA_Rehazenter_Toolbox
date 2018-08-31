% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    computeJointKinematics_headtrunk
% -------------------------------------------------------------------------
% Subject:      Compute kinematics
% Plugin:       Head / Trunk
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 30/07/2018
% Version: 1
% =========================================================================

function [Joint,btk2] = computeJointKinematics_headTrunk(Segment,btk2)

Joint = Joint_Kinematics_headTrunk(Segment);

% =========================================================================
% HEAD/SCAPULA
% =========================================================================
% Joint(1).FE = -Joint(1).Euler(1,1,:)*180/pi;
% Joint(1).IER = Joint(1).Euler(1,3,:)*180/pi;
% Joint(1).AA = Joint(1).Euler(1,2,:)*180/pi;

for i=1:2
    if max(abs(Joint(i).Euler(1,1,:)*180/pi)) > 150
        Joint(i).FE = -(mod(Joint(i).Euler(1,1,:),2*pi)-pi)*180/pi;
    else
        Joint(i).FE = -Joint(i).Euler(1,1,:)*180/pi;
    end
    if max(abs(Joint(i).Euler(1,3,:)*180/pi)) > 150
        Joint(i).IER = (mod(Joint(i).Euler(1,3,:),2*pi)-pi)*180/pi;
    else
        Joint(i).IER = Joint(i).Euler(1,3,:)*180/pi;
    end
    if max(abs(Joint(i).Euler(1,2,:)*180/pi)) > 150
        Joint(i).AA = (mod(Joint(i).Euler(1,2,:),2*pi)-pi)*180/pi;
    else
        Joint(i).AA = Joint(i).Euler(1,2,:)*180/pi;
    end
end

% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(1).FE,[3,2,1]) ...
    permute(Joint(1).AA,[3,2,1]) ...
    permute(Joint(1).IER,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'Head_Scapula_angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: DF(+)/PF, Y-Axis: Ad(+)/Ab, Z-Axis: IR(+)/ER');


% =========================================================================
% SCAPULA/PELVIS
% =========================================================================
% Joint(2).FE = -Joint(2).Euler(1,1,:)*180/pi;
% Joint(2).IER = Joint(2).Euler(1,3,:)*180/pi;
% Joint(2).AA = Joint(2).Euler(1,2,:)*180/pi;
% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(2).FE,[3,2,1]) ...
    permute(Joint(2).AA,[3,2,1]) ...
    permute(Joint(2).IER,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'Scapula_Pelvis_angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: DF(+)/PF, Y-Axis: Ad(+)/Ab, Z-Axis: IR(+)/ER');