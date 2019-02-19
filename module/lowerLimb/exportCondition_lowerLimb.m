% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    exportCondition_lowerLimb
% -------------------------------------------------------------------------
% Subject:      Export .mat file for each condition with only intra cycle
%               data of each outcome
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function Output = exportCondition_lowerLimb(Output,Segment,Joint,Marker,Vmarker,EMG,Event,Spatiotemporal,fMarker,fAnalog)

% =========================================================================
% Initialisation
% =========================================================================
% Set outputs
Output.Spatiotemporal = [];
Output.Jointkinematics = [];
Output.Segmentkinematics = [];
Output.Dynamics = [];
Output.EMG = [];
Output.Events = [];
% Express events as % of gait cycle
mRHS = fix(Event.RHS*fMarker);
mRTO = fix(Event.RTO*fMarker);
mLHS = fix(Event.LHS*fMarker);
mLTO = fix(Event.LTO*fMarker);
aRHS = fix(Event.RHS*fAnalog);
aRTO = fix(Event.RTO*fAnalog);
aLHS = fix(Event.LHS*fAnalog);
aLTO = fix(Event.LTO*fAnalog);
% Interpolation parameters
R_n = mRHS(2)-mRHS(1)+1;
R_k = (1:R_n)';
R_ko = (linspace(1,R_n,101))';
L_n = mLHS(2)-mLHS(1)+1;
L_k = (1:L_n)';
L_ko = (linspace(1,L_n,101))';

% =========================================================================
% Spatiotemporal
% =========================================================================
nSpatiotemporal = fieldnames(Spatiotemporal);
for i = 1:size(nSpatiotemporal,1)
    Output.Spatiotemporal.(nSpatiotemporal{i}) = Spatiotemporal.(nSpatiotemporal{i});
end

% =========================================================================
% Joint kinematics
% =========================================================================
% Right gait cycle
if sum(isnan(Joint(2).FE)) ~= size(isnan(Joint(2).FE),1)
    Output.Jointkinematics.R_Ankle_Angle_FE = interp1(R_k,...
        permute(Joint(2).FE(1,1,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
else
    Output.Jointkinematics.R_Ankle_Angle_FE = NaN(101,1);
end
if sum(isnan(Joint(2).AA)) ~= size(isnan(Joint(2).AA),1)
    Output.Jointkinematics.R_Ankle_Angle_AA = interp1(R_k,...
        permute(Joint(2).AA(1,1,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
else
    Output.Jointkinematics.R_Ankle_Angle_AA = NaN(101,1);
end
if sum(isnan(Joint(2).IER)) ~= size(isnan(Joint(2).IER),1)
    Output.Jointkinematics.R_Ankle_Angle_IER = interp1(R_k,...
        permute(Joint(2).IER(1,1,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
else
    Output.Jointkinematics.R_Ankle_Angle_IER = NaN(101,1);
end
if sum(isnan(Joint(3).FE)) ~= size(isnan(Joint(3).FE),1)
    Output.Jointkinematics.R_Knee_Angle_FE = interp1(R_k,...
        permute(Joint(3).FE(1,1,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
else
    Output.Jointkinematics.R_Knee_Angle_FE = NaN(101,1);
end
if sum(isnan(Joint(3).AA)) ~= size(isnan(Joint(3).AA),1)
    Output.Jointkinematics.R_Knee_Angle_AA = interp1(R_k,...
        permute(Joint(3).AA(1,1,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
else
    Output.Jointkinematics.R_Knee_Angle_AA = NaN(101,1);
end
if sum(isnan(Joint(3).IER)) ~= size(isnan(Joint(3).IER),1)
    Output.Jointkinematics.R_Knee_Angle_IER = interp1(R_k,...
        permute(Joint(3).IER(1,1,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
else
    Output.Jointkinematics.R_Knee_Angle_IER = NaN(101,1);
end
if sum(isnan(Joint(4).FE)) ~= size(isnan(Joint(4).FE),1)
    Output.Jointkinematics.R_Hip_Angle_FE = interp1(R_k,...
        permute(Joint(4).FE(1,1,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
else
    Output.Jointkinematics.R_Hip_Angle_FE = NaN(101,1);
end
if sum(isnan(Joint(4).AA)) ~= size(isnan(Joint(4).AA),1)
    Output.Jointkinematics.R_Hip_Angle_AA = interp1(R_k,...
        permute(Joint(4).AA(1,1,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
else
    Output.Jointkinematics.R_Hip_Angle_AA = NaN(101,1);
end
if sum(isnan(Joint(4).IER)) ~= size(isnan(Joint(4).IER),1)
    Output.Jointkinematics.R_Hip_Angle_IER = interp1(R_k,...
        permute(Joint(4).IER(1,1,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
else
    Output.Jointkinematics.R_Hip_Angle_IER = NaN(101,1);
end
% Left gait cycle
if sum(isnan(Joint(102).FE)) ~= size(isnan(Joint(102).FE),1)
    Output.Jointkinematics.L_Ankle_Angle_FE = interp1(L_k,...
        permute(Joint(102).FE(1,1,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
else
    Output.Jointkinematics.L_Ankle_Angle_FE = NaN(101,1);
end
if sum(isnan(Joint(102).AA)) ~= size(isnan(Joint(102).AA),1)
    Output.Jointkinematics.L_Ankle_Angle_AA = interp1(L_k,...
        permute(Joint(102).AA(1,1,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
else
    Output.Jointkinematics.L_Ankle_Angle_AA = NaN(101,1);
end
if sum(isnan(Joint(102).IER)) ~= size(isnan(Joint(102).IER),1)
    Output.Jointkinematics.L_Ankle_Angle_IER = interp1(L_k,...
        permute(Joint(102).IER(1,1,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
else
    Output.Jointkinematics.L_Ankle_Angle_IER = NaN(101,1);
end
if sum(isnan(Joint(103).FE)) ~= size(isnan(Joint(103).FE),1)
    Output.Jointkinematics.L_Knee_Angle_FE = interp1(L_k,...
        permute(Joint(103).FE(1,1,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
else
    Output.Jointkinematics.L_Knee_Angle_FE = NaN(101,1);
end
if sum(isnan(Joint(103).AA)) ~= size(isnan(Joint(103).AA),1)
    Output.Jointkinematics.L_Knee_Angle_AA = interp1(L_k,...
        permute(Joint(103).AA(1,1,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
else
    Output.Jointkinematics.L_Knee_Angle_AA = NaN(101,1);
end
if sum(isnan(Joint(103).IER)) ~= size(isnan(Joint(103).IER),1)
    Output.Jointkinematics.L_Knee_Angle_IER = interp1(L_k,...
        permute(Joint(103).IER(1,1,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
else
    Output.Jointkinematics.L_Knee_Angle_IER = NaN(101,1);
end
if sum(isnan(Joint(104).FE)) ~= size(isnan(Joint(104).FE),1)
    Output.Jointkinematics.L_Hip_Angle_FE = interp1(L_k,...
        permute(Joint(104).FE(1,1,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
else
    Output.Jointkinematics.L_Hip_Angle_FE = NaN(101,1);
end
if sum(isnan(Joint(104).AA)) ~= size(isnan(Joint(104).AA),1)
    Output.Jointkinematics.L_Hip_Angle_AA = interp1(L_k,...
        permute(Joint(104).AA(1,1,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
else
    Output.Jointkinematics.L_Hip_Angle_AA = NaN(101,1);
end
if sum(isnan(Joint(104).IER)) ~= size(isnan(Joint(104).IER),1)
    Output.Jointkinematics.L_Hip_Angle_IER = interp1(L_k,...
        permute(Joint(104).IER(1,1,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
else
    Output.Jointkinematics.L_Hip_Angle_IER = NaN(101,1);
end

% =========================================================================
% Segment kinematics
% =========================================================================
% Right gait cycle
Output.Segmentkinematics.R_Foot_Angle_FE = interp1(R_k,...
    permute(Segment(2).FE(1,1,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
Output.Segmentkinematics.R_Foot_Angle_AA = interp1(R_k,...
    permute(Segment(2).AA(1,1,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
Output.Segmentkinematics.R_Foot_Angle_IER = interp1(R_k,...
    permute(Segment(2).IER(1,1,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
Output.Segmentkinematics.R_Pelvis_Angle_FE = interp1(R_k,...
    permute(Segment(5).FE(1,1,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
Output.Segmentkinematics.R_Pelvis_Angle_AA = interp1(R_k,...
    permute(Segment(5).AA(1,1,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
Output.Segmentkinematics.R_Pelvis_Angle_IER = interp1(R_k,...
    permute(Segment(5).IER(1,1,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
% Left gait cycle
Output.Segmentkinematics.L_Foot_Angle_FE = interp1(L_k,...
    permute(Segment(102).FE(1,1,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
Output.Segmentkinematics.L_Foot_Angle_AA = interp1(L_k,...
    permute(Segment(102).AA(1,1,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
Output.Segmentkinematics.L_Foot_Angle_IER = interp1(L_k,...
    permute(Segment(102).IER(1,1,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
Output.Segmentkinematics.L_Pelvis_Angle_FE = interp1(L_k,...
    permute(Segment(5).FE(1,1,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
Output.Segmentkinematics.L_Pelvis_Angle_AA = interp1(L_k,...
    permute(Segment(5).AA(1,1,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
Output.Segmentkinematics.L_Pelvis_Angle_IER = interp1(L_k,...
    permute(Segment(5).IER(1,1,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');

% =========================================================================
% Dynamics
% =========================================================================
% Right gait cycle
Output.Dynamics.R_Ankle_Moment_FE = interp1(R_k,...
    permute(Joint(2).Mj(1,:,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
Output.Dynamics.R_Ankle_Moment_AA = interp1(R_k,...
    permute(Joint(2).Mj(3,:,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
Output.Dynamics.R_Ankle_Moment_IER = interp1(R_k,...
    permute(Joint(2).Mj(2,:,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
Output.Dynamics.R_Knee_Moment_FE = interp1(R_k,...
    permute(Joint(3).Mj(1,:,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
Output.Dynamics.R_Knee_Moment_AA = interp1(R_k,...
    permute(Joint(3).Mj(2,:,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
Output.Dynamics.R_Knee_Moment_IER = interp1(R_k,...
    permute(Joint(3).Mj(3,:,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
Output.Dynamics.R_Hip_Moment_FE = interp1(R_k,...
    permute(Joint(4).Mj(1,:,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
Output.Dynamics.R_Hip_Moment_AA = interp1(R_k,...
    permute(Joint(4).Mj(2,:,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
Output.Dynamics.R_Hip_Moment_IER = interp1(R_k,...
    permute(Joint(4).Mj(3,:,mRHS(1):mRHS(2)),[3,1,2]),R_ko,'spline');
% Left gait cycle
Output.Dynamics.L_Ankle_Moment_FE = interp1(L_k,...
    permute(Joint(102).Mj(1,:,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
Output.Dynamics.L_Ankle_Moment_AA = interp1(L_k,...
    permute(Joint(102).Mj(3,:,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
Output.Dynamics.L_Ankle_Moment_IER = interp1(L_k,...
    permute(Joint(102).Mj(2,:,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
Output.Dynamics.L_Knee_Moment_FE = interp1(L_k,...
    permute(Joint(103).Mj(1,:,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
Output.Dynamics.L_Knee_Moment_AA = interp1(L_k,...
    permute(Joint(103).Mj(2,:,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
Output.Dynamics.L_Knee_Moment_IER = interp1(L_k,...
    permute(Joint(103).Mj(3,:,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
Output.Dynamics.L_Hip_Moment_FE = interp1(L_k,...
    permute(Joint(104).Mj(1,:,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
Output.Dynamics.L_Hip_Moment_AA = interp1(L_k,...
    permute(Joint(104).Mj(2,:,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');
Output.Dynamics.L_Hip_Moment_IER = interp1(L_k,...
    permute(Joint(104).Mj(3,:,mLHS(1):mLHS(2)),[3,1,2]),L_ko,'spline');

% -------------------------------------------------------------------------
% EMG
% -------------------------------------------------------------------------
nEMG = fieldnames(EMG);
for i = 1:size(nEMG,1)
    % Right gait cycle
    if strfind(nEMG{i},'R_')
        temp = EMG.(nEMG{i}).signal(:,:,aRHS(1):aRHS(2));
        if sum(isnan(temp)) ~= size(isnan(temp),1)
            Output.EMG.([nEMG{i},'_Signal']) = permute(temp,[2,3,1])';
        else
            Output.EMG.([nEMG{i},'_Signal']) = NaN(length(aRHS(1):aRHS(2)),1);
        end    
        temp = EMG.(nEMG{i}).envelop(:,:,mRHS(1):mRHS(2));
        if sum(isnan(temp)) ~= size(isnan(temp),1)
            Output.EMG.([nEMG{i},'_Envelop']) = interp1(R_k,permute(temp,[2,3,1]),R_ko,'spline');
        else
            Output.EMG.([nEMG{i},'_Envelop']) = NaN(101,1);
        end
    end
    % Left gait cycle
    if strfind(nEMG{i},'L_')
        temp = EMG.(nEMG{i}).signal(:,:,aLHS(1):aLHS(2));
        if sum(isnan(temp)) ~= size(isnan(temp),1)
            Output.EMG.([nEMG{i},'_Signal']) = permute(temp,[2,3,1])';
        else
            Output.EMG.([nEMG{i},'_Signal']) = NaN(length(aLHS(1):aLHS(2)),1);
        end    
        temp = EMG.(nEMG{i}).envelop(:,:,mLHS(1):mLHS(2));
        if sum(isnan(temp)) ~= size(isnan(temp),1)
            Output.EMG.([nEMG{i},'_Envelop']) = interp1(R_k,permute(temp,[2,3,1]),R_ko,'spline');
        else
            Output.EMG.([nEMG{i},'_Envelop']) = NaN(101,1);
        end
    end
end

% -------------------------------------------------------------------------
% Events
% -------------------------------------------------------------------------
Output.Event.R_RHS = (mRHS-mRHS(1)+1)*100/(mRHS(2)-mRHS(1)+1);
Output.Event.R_RTO = (mRTO-mRHS(1)+1)*100/(mRHS(2)-mRHS(1)+1);
Output.Event.R_LHS = (mLHS-mRHS(1)+1)*100/(mRHS(2)-mRHS(1)+1);
Output.Event.R_LTO = (mLTO-mRHS(1)+1)*100/(mRHS(2)-mRHS(1)+1);
Output.Event.L_RHS = (mRHS-mLHS(1)+1)*100/(mLHS(2)-mLHS(1)+1);
Output.Event.L_RTO = (mRTO-mLHS(1)+1)*100/(mLHS(2)-mLHS(1)+1);
Output.Event.L_LHS = (mLHS-mLHS(1)+1)*100/(mLHS(2)-mLHS(1)+1);
Output.Event.L_LTO = (mLTO-mLHS(1)+1)*100/(mLHS(2)-mLHS(1)+1);