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
    setTrialSegment_kinematics_headTrunk(Condition,Marker,btk2)

if isfield(Marker,'R_IPS') && isfield(Marker,'L_IPS')
   Vmarker.sacrum = (Marker.R_IPS+Marker.L_IPS)/2;
end

% Pelvis parameters
% ---------------------------------------------------------------------
% Pelvis axes
if isfield(Marker,'R_IPS') && isfield(Marker,'L_IPS') && isfield(Marker,'R_IAS') && isfield(Marker,'L_IAS')
    Segment(4).Z = Vnorm_array3(Marker.R_IAS - Marker.L_IAS);
    Segment(4).Y = Vnorm_array3(cross(Segment(4).Z,...
           ((Marker.R_IAS + Marker.L_IAS)/2 - Vmarker.sacrum)));
    Segment(4).X = Vnorm_array3(cross(Segment(4).Y, Segment(4).Z)); 
    Segment(4).SCSC = (Marker.R_IAS + Marker.L_IAS)/2;
    rP4 = Marker.L_IPS;
    rD4 = (Marker.R_IPS+Marker.L_IPS)/2;
    w4 = Segment(4).Z;
    u4 = Segment(4).X;
    Segment(4).Q = [u4;rP4;rD4;w4];
    Segment(4).rM = [Marker.R_IAS,Marker.L_IAS,Marker.R_IPS,Marker.L_IPS];
end
    
% Rachis (axe occipital) parameters
% ---------------------------------------------------------------------

if isfield(Vmarker,'sacrum')&& isfield(Marker,'CV7') && isfield(Marker,'R_SAE') && isfield(Marker,'L_SAE')  
    % Rachis axes
    Segment(3).Y = Vnorm_array3(Marker.CV7 - Vmarker.sacrum);
    Segment(3).X = Vnorm_array3(cross(Segment(3).Y,Marker.R_SAE - Marker.L_SAE)); 
    Segment(3).Z = Vnorm_array3(cross(Segment(3).X,Segment(3).Y));
    Segment(3).SCSC = Vmarker.sacrum;
    % Rachis markers
    Segment(3).rM = [Marker.CV7,Marker.R_SAE,Marker.L_SAE];
    % Rachis parameters
    rD3 = Marker.CV7;
    rP3 = Vmarker.sacrum;
    w3 = Segment(3).Z;
    u3 = Segment(3).X;
    Segment(3).Q = [u3;rP3;rD3;w3]; % échanger P et D?
end
    
% Scapular belt parameters
% ---------------------------------------------------------------------
if isfield(Marker,'CV7') && isfield(Marker,'R_SAE') && isfield(Marker,'L_SAE') 
    % Scapular belt axes
    Segment(2).Z = Vnorm_array3(Marker.R_SAE-Marker.L_SAE);    
    Segment(2).Y = Vnorm_array3(cross(Segment(2).Z,((Marker.R_SAE+Marker.L_SAE)/2 - Marker.CV7)));
    Segment(2).X = Vnorm_array3(cross(Segment(2).Y,Segment(2).Z)); 
    Segment(2).SCSC = (Marker.R_SAE+Marker.L_SAE)/4 + (Marker.CV7)/2;
    % Scapular belt markers
    Segment(2).rM = [Marker.CV7,Marker.R_SAE,Marker.L_SAE];
    % Scapular belt parameters
    rP2 = Marker.CV7;
    rD2 = Segment(2).SCSC;
    w2 = Segment(2).Z;
    u2 = Segment(2).X;
    Segment(2).Q = [u2;rP2;rD2;w2];
end
    
% Head parameters
% ---------------------------------------------------------------------    
nmarkers = isfield(Marker,'R_HDF')+isfield(Marker,'L_HDF')+isfield(Marker,'R_HDB')+isfield(Marker,'L_HDB');
if nmarkers == 3
    % Create a fourth head marker
    if ~isfield(Marker,'L_HDB')
        Segment(1).rM = [Marker.R_HDF,Marker.L_HDF,Marker.R_HDB];
        n = size(Marker.R_HDF,3);
        Rotation = [];
        Translation = [];
        RMS = [];
        for i = 1:n
            [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                = soder(Condition.Static.HeadTrunk.Segment(1).rM_LHDB',Segment(1).rM(:,:,i)');
        end
        Marker.L_HDB = ...
            Mprod_array3(Rotation , repmat(Condition.Static.HeadTrunk.Vmarker.L_HDB,[1 1 n])) ...
            + Translation;
        Marker.L_HDB = Marker.L_HDB(1:3,:,:);
        % Export marker in C3D file
        temp = [Marker.L_HDB(1,:,:) -Marker.L_HDB(3,:,:) Marker.L_HDB(2,:,:)];
        btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
        btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
        btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_HDB');

    elseif ~isfield(Marker,'R_HDB')
        Segment(1).rM = [Marker.R_HDF,Marker.L_HDF,Marker.L_HDB];
        n = size(Marker.R_HDF,3);
        Rotation = [];
        Translation = [];
        RMS = [];
        for i = 1:n
            [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                = soder(Condition.Static.HeadTrunk.Segment(1).rM_RHDB',Segment(1).rM(:,:,i)');
        end
        Marker.R_HDB = ...
            Mprod_array3(Rotation , repmat(Condition.Static.HeadTrunk.Vmarker.R_HDB,[1 1 n])) ...
            + Translation;
        Marker.R_HDB = Marker.R_HDB(1:3,:,:);
        % Export marker in C3D file
        temp = [Marker.R_HDB(1,:,:) -Marker.R_HDB(3,:,:) Marker.R_HDB(2,:,:)];
        btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
        btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
        btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_HDB');
        
    elseif ~isfield(Marker,'L_HDF')
        Segment(1).rM = [Marker.R_HDF,Marker.L_HDB,Marker.R_HDB];
        n = size(Marker.R_HDF,3);
        Rotation = [];
        Translation = [];
        RMS = [];
        for i = 1:n
            [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                = soder(Condition.Static.HeadTrunk.Segment(1).rM_LHDF',Segment(1).rM(:,:,i)');
        end
        Marker.L_HDF = ...
            Mprod_array3(Rotation , repmat(Condition.Static.HeadTrunk.Vmarkers.L_HDF,[1 1 n])) ...
            + Translation;
        Marker.L_HDF = Marker.L_HDF(1:3,:,:);
        % Export marker in C3D file
        temp = [Marker.L_HDF(1,:,:) -Marker.L_HDF(3,:,:) Marker.L_HDF(2,:,:)];
        btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
        btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
        btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_HDF');
        
    elseif ~isfield(Marker,'R_HDF')
        Segment(1).rM = [Marker.L_HDF,Marker.L_HDB,Marker.R_HDB];
        n = size(Marker.L_HDF,3);
        Rotation = [];
        Translation = [];
        RMS = [];
        for i = 1:n
            [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                = soder(Condition.Static.HeadTrunk.Segment(1).rM_RHDF',Segment(1).rM(:,:,i)');
        end
        Marker.R_HDF = ...
            Mprod_array3(Rotation , repmat(Condition.Static.HeadTrunk.Vmarker.R_HDF,[1 1 n])) ...
            + Translation;
        Marker.R_HDF = Marker.R_HDF(1:3,:,:);
        % Export marker in C3D file
        temp = [Marker.R_HDF(1,:,:) -Marker.R_HDF(3,:,:) Marker.R_HDF(2,:,:)];
        btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
        btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
        btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_HDF');
        
    end
end

if isfield(Marker,'R_HDF') && isfield(Marker,'R_HDB') && isfield(Marker,'L_HDF') && isfield(Marker,'L_HDB'); 
    % Head axes
    Segment(1).Z = Vnorm_array3((Marker.R_HDF+Marker.R_HDB)/2 - (Marker.L_HDF+Marker.L_HDB)/2);
    Segment(1).Y = Vnorm_array3(cross(Segment(1).Z,...
               ((Marker.R_HDF+Marker.L_HDF)/2 - (Marker.R_HDB+Marker.L_HDB)/2)));
    Segment(1).X = Vnorm_array3(cross(Segment(1).Y, Segment(1).Z)); 
    Segment(1).SCSC = (Marker.R_HDF+Marker.L_HDF+Marker.R_HDB+Marker.L_HDB)/4;
    % Head parameters
    rP1 = (Marker.R_HDB+Marker.L_HDB)/2;
    rD1 = (Marker.R_HDF+Marker.L_HDF)/2;
    w1 = Segment(1).Z;
    u1 = Segment(1).X;
    Segment(1).Q = [u1;rP1;rD1;w1];
    % Head markers
    Segment(1).rM = [Marker.R_HDF,Marker.L_HDF,Marker.R_HDB,Marker.L_HDB];
end