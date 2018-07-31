% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    setStaticSegment_lowerLimb
% -------------------------------------------------------------------------
% Subject:      Set segment parameters
% Plugin:       Lower limb
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function [Condition,btk2] = setStaticSegment_headTrunk(Condition,Marker,btk2)

% Pelvis parameters
% ---------------------------------------------------------------------
if isfield(Marker,'R_IPS') && isfield(Marker,'L_IPS') && isfield(Marker,'R_IAS') && isfield(Marker,'L_IAS')
    Segment(4).rM = [Marker.R_IAS,Marker.L_IAS,Marker.R_IPS,Marker.L_IPS];
end
    
% Rachis (axe occipital) parameters
% ---------------------------------------------------------------------

if isfield(Marker,'CV7') && isfield(Marker,'R_SAE') && isfield(Marker,'L_SAE')  
    Segment(3).rM = [Marker.CV7,Marker.R_SAE,Marker.L_SAE];
end
    
% Scapular belt parameters
% ---------------------------------------------------------------------
if isfield(Marker,'CV7') && isfield(Marker,'R_SAE') && isfield(Marker,'L_SAE') 
    Segment(2).rM = [Marker.CV7,Marker.R_SAE,Marker.L_SAE];
end
   
% Head parameters
% ---------------------------------------------------------------------    
if isfield(Marker,'R_HDF') && isfield(Marker,'R_HDB') && isfield(Marker,'L_HDF') && isfield(Marker,'L_HDB'); 
    Segment(1).rM_RHDF = [Marker.L_HDF,Marker.R_HDB,Marker.L_HDB];
    Segment(1).rM_LHDF = [Marker.R_HDF,Marker.R_HDB,Marker.L_HDB];
    Segment(1).rM_RHDB = [Marker.R_HDF,Marker.L_HDF,Marker.L_HDB];
    Segment(1).rM_LHDB = [Marker.R_HDF,Marker.L_HDF,Marker.R_HDB];
    Vmarker.R_HDF = Marker.R_HDF;
    Vmarker.L_HDF = Marker.L_HDF;
    Vmarker.R_HDB = Marker.R_HDB;
    Vmarker.L_HDB = Marker.L_HDB;
end

Condition.Static.HeadTrunk.Segment = Segment;
Condition.Static.HeadTrunk.Vmarker = Vmarker;