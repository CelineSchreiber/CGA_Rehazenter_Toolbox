% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    computeJointKinetics_lowerLimb
% -------------------------------------------------------------------------
% Subject:      Compute kinematics
% Plugin:       Lower limb
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function [Segment,Joint,btk2] = computeJointKinetics_lowerLimb(Session,Segment,Joint,btk2)

g=9.81;
den_norm = g*Session.weight*(Session.R_legLength+Session.L_legLength)/2;
% =========================================================================
% Inverse dynamics
% =========================================================================
[Segment,Joint] = Joint_Kinetics_2legs(Segment,Joint,Session.frq.fMarker);

% =========================================================================
% Export moment (normalised by weight) in C3D file => A normaliser par
% (m0*g*l0)???
% =========================================================================
% Right ankle
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'moment');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(-Joint(2).Mj(1,:,:)/den_norm,[3,2,1]) ...
    permute(Joint(2).Mj(2,:,:)/den_norm,[3,2,1]) ...
    permute(Joint(2).Mj(3,:,:)/den_norm,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_Ankle_Moment');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Moment (Nm/kg): X-Axis: PF(+)/DF, Y-Axis: IR(+)/ER, Z-Axis: Ad(+)/Ab');
% Right knee
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'moment');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(3).Mj(1,:,:)/den_norm,[3,2,1]) ...
    permute(-Joint(3).Mj(2,:,:)/den_norm,[3,2,1]) ...
    permute(Joint(3).Mj(3,:,:)/den_norm,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_Knee_Moment');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Moment (Nm/kg): X-Axis: E(+)/F, Y-Axis: Ab(+)/Ad, Z-Axis: IR(+)/ER');
% Right hip
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'moment');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(-Joint(4).Mj(1,:,:)/den_norm,[3,2,1]) ...
    permute(-Joint(4).Mj(2,:,:)/den_norm,[3,2,1]) ...
    permute(Joint(4).Mj(3,:,:)/den_norm,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_Hip_Moment');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Moment (Nm/kg): X-Axis: E(+)/F, Y-Axis: Ab(+)/Ad, Z-Axis: IR(+)/ER');
% Right ground reaction forces
if Segment(5).Q(4,:,end) > Segment(5).Q(4,:,1)
    Joint(1).F(1,1,:) = Joint(1).F(1,1,:);
    Joint(1).F(2,1,:) = Joint(1).F(2,1,:);
    Joint(1).F(3,1,:) = Joint(1).F(3,1,:);
elseif Segment(5).Q(4,:,end) < Segment(5).Q(4,:,1)
    Joint(1).F(1,1,:) = -Joint(1).F(1,1,:);
    Joint(1).F(2,1,:) = Joint(1).F(2,1,:);
    Joint(1).F(3,1,:) = -Joint(1).F(3,1,:);
end
% Left ankle
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'moment');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(-Joint(102).Mj(1,:,:)/den_norm,[3,2,1]) ...
    permute(-Joint(102).Mj(2,:,:)/den_norm,[3,2,1]) ...
    permute(-Joint(102).Mj(3,:,:)/den_norm,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_Ankle_Moment');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Moment (Nm/kg): X-Axis: PF(+)/DF, Y-Axis: IR(+)/ER, Z-Axis: Ad(+)/Ab');
% Left knee
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'moment');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(103).Mj(1,:,:)/den_norm,[3,2,1]) ...
    permute(Joint(103).Mj(2,:,:)/den_norm,[3,2,1]) ...
    permute(-Joint(103).Mj(3,:,:)/den_norm,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_Knee_Moment');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Moment (Nm/kg): X-Axis: Ext(+)/Flex, Y-Axis: Ab(+)/Ad, Z-Axis: IR(+)/ER');
% Left hip
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'moment');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(-Joint(104).Mj(1,:,:)/den_norm,[3,2,1]) ...
    permute(Joint(104).Mj(2,:,:)/den_norm,[3,2,1]) ...
    permute(-Joint(104).Mj(3,:,:)/den_norm,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_Hip_Moment');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Moment (Nm/kg): X-Axis: E(+)/F, Y-Axis: Ab(+)/Ad, Z-Axis: IR(+)/ER');
% Left ground reaction forces
if Segment(5).Q(4,:,end) > Segment(5).Q(4,:,1)
    Joint(101).F(1,1,:) = Joint(101).F(1,1,:);
    Joint(101).F(2,1,:) = Joint(101).F(2,1,:);
    Joint(101).F(3,1,:) = Joint(101).F(3,1,:);
elseif Segment(5).Q(4,:,end) < Segment(5).Q(4,:,1)
    Joint(101).F(1,1,:) = -Joint(101).F(1,1,:);
    Joint(101).F(2,1,:) = Joint(101).F(2,1,:);
    Joint(101).F(3,1,:) = -Joint(101).F(3,1,:);
end

% =========================================================================
% Joint power and alpha angle
% =========================================================================
n = size(Joint(1).F,3);
for j = 1:n
    % Right ankle
    M = permute(Joint(2).Mj(:,:,j),[3,1,2])';
    Omega = abs(Segment(3).Omega(:,:,j) - Segment(2).Omega(:,:,j)); % in ICS
    Joint(2).power(:,:,j) = dot(M,Omega); % 3D joint power
    Joint(2).alpha(:,:,j) = atan(norm(cross(M,Omega))/dot(M,Omega));
    % Right knee
    M = permute(Joint(3).Mj(:,:,j),[3,1,2])';
    Omega = abs(Segment(4).Omega(:,:,j) - Segment(3).Omega(:,:,j)); % in ICS
    Joint(3).power(:,:,j) = dot(M,Omega); % 3D joint power
    Joint(3).alpha(:,:,j) = atan(norm(cross(M,Omega))/dot(M,Omega));
    % Right hip
    M = permute(Joint(4).Mj(:,:,j),[3,1,2])';
    Omega = abs(Segment(5).Omega(:,:,j) - Segment(4).Omega(:,:,j)); % in ICS
    Joint(4).power(:,:,j) = dot(M,Omega); % 3D joint power
    Joint(4).alpha(:,:,j) = atan(norm(cross(M,Omega))/dot(M,Omega));
    % Left ankle
    M = permute(Joint(102).Mj(:,:,j),[3,1,2])';
    Omega = abs(Segment(103).Omega(:,:,j) - Segment(102).Omega(:,:,j)); % in ICS
    Joint(102).power(:,:,j) = dot(M,Omega); % 3D joint power
    Joint(102).alpha(:,:,j) = atan(norm(cross(M,Omega))/dot(M,Omega));
    % Left knee
    M = permute(Joint(103).Mj(:,:,j),[3,1,2])';
    Omega = abs(Segment(104).Omega(:,:,j) - Segment(103).Omega(:,:,j)); % in ICS
    Joint(103).power(:,:,j) = dot(M,Omega); % 3D joint power
    Joint(103).alpha(:,:,j) = atan(norm(cross(M,Omega))/dot(M,Omega));
    % Left hip
    M = permute(Joint(104).Mj(:,:,j),[3,1,2])';
    Omega = abs(Segment(105).Omega(:,:,j) - Segment(104).Omega(:,:,j)); % in ICS
    Joint(104).power(:,:,j) = dot(M,Omega); % 3D joint power
    Joint(104).alpha(:,:,j) = atan(norm(cross(M,Omega))/dot(M,Omega));
end

% =========================================================================
% Export power (normalised by weight) in C3D file  => A normaliser par
% (m0*g^(1/2)*l0^(3.2))???
% =========================================================================
den_norm = 9.81^(1/2)*Session.weight*((Session.R_legLength+Session.L_legLength)/2)^(3/2);
% Right ankle
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'power');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(2).power(:,:,:)/den_norm,[3,2,1]) ...
    zeros(size(permute(Joint(2).power(:,:,:)/den_norm,[3,2,1]))) ...
    zeros(size(permute(Joint(2).power(:,:,:)/den_norm,[3,2,1])))]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_Ankle_Power');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Power (W/kg): Gen(+)/Abs');
% Right knee
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'power');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(-Joint(3).power(:,:,:)/den_norm,[3,2,1]) ...
    zeros(size(permute(Joint(3).power(:,:,:)/den_norm,[3,2,1]))) ...
    zeros(size(permute(Joint(3).power(:,:,:)/den_norm,[3,2,1])))]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_Knee_Power');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Power (W/kg): Gen(+)/Abs');
% Right hip
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'power');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(4).power(:,:,:)/den_norm,[3,2,1]) ...
    zeros(size(permute(Joint(4).power(:,:,:)/den_norm,[3,2,1]))) ...
    zeros(size(permute(Joint(4).power(:,:,:)/den_norm,[3,2,1])))]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_Hip_Power');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Power (W/kg): Gen(+)/Abs');
% Left ankle
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'power');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(-Joint(102).power(:,:,:)/den_norm,[3,2,1]) ...
    zeros(size(permute(Joint(102).power(:,:,:)/den_norm,[3,2,1]))) ...
    zeros(size(permute(Joint(102).power(:,:,:)/den_norm,[3,2,1])))]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_Ankle_Power');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Power (W/kg): Gen(+)/Abs');
% Left knee
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'power');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(103).power(:,:,:)/den_norm,[3,2,1]) ...
    zeros(size(permute(Joint(103).power(:,:,:)/den_norm,[3,2,1]))) ...
    zeros(size(permute(Joint(103).power(:,:,:)/den_norm,[3,2,1])))]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_Knee_Power');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Power (W/kg): Gen(+)/Abs');
% Left hip
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'power');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(-Joint(104).power(:,:,:)/den_norm,[3,2,1]) ...
    zeros(size(permute(Joint(104).power(:,:,:)/den_norm,[3,2,1]))) ...
    zeros(size(permute(Joint(104).power(:,:,:)/den_norm,[3,2,1])))]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_Hip_Power');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Power (W/kg): Gen(+)/Abs');