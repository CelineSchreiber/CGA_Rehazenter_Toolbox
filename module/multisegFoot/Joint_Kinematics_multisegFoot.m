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

function Joint = Joint_Kinematics_multisegFoot(Segment)

% =========================================================================
% RIGHT ANKLE
% =========================================================================
Joint(4).T = Mprod_array3(Tinv_array3(Q2Tw_array3(Segment(5).Q)),...
        Q2Tu_array3(Segment(4).Q));
Joint(4).Euler = R2mobileZYX_array3(Joint(4).T(1:3,1:3,:));

% =========================================================================
% LEFT ANKLE
% =========================================================================
Joint(104).T = Mprod_array3(Tinv_array3(Q2Tw_array3(Segment(105).Q)),...
        Q2Tu_array3(Segment(104).Q));
Joint(104).Euler = R2mobileZYX_array3(Joint(104).T(1:3,1:3,:));

% =========================================================================
% RIGHT CALCA/TIBIA
% =========================================================================
Joint(3).T = Mprod_array3(Tinv_array3(Q2Tw_array3(Segment(5).Q)),...
        Q2Tu_array3(Segment(3).Q));  
Joint(3).Euler = R2mobileZYX_array3(Joint(3).T(1:3,1:3,:));

% =========================================================================
% LEFT CALCA/TIBIA
% =========================================================================
Joint(103).T = Mprod_array3(Tinv_array3(Q2Tw_array3(Segment(105).Q)),...
        Q2Tu_array3(Segment(103).Q));  
Joint(103).Euler = R2mobileZYX_array3(Joint(103).T(1:3,1:3,:));

% =========================================================================
% RIGHT MIDFOOT/CALCA
% =========================================================================
Joint(2).T = Mprod_array3(Tinv_array3(Q2Tw_array3(Segment(3).Q)),...
        Q2Tu_array3(Segment(2).Q));  
Joint(2).Euler = R2mobileZYX_array3(Joint(2).T(1:3,1:3,:));

% =========================================================================
% LEFT MIDFOOT/CALCA
% =========================================================================
Joint(102).T = Mprod_array3(Tinv_array3(Q2Tw_array3(Segment(103).Q)),...
        Q2Tu_array3(Segment(102).Q));  
Joint(102).Euler = R2mobileZYX_array3(Joint(102).T(1:3,1:3,:));

% =========================================================================
% RIGHT FOREFOOT/MIDFOOT
% =========================================================================
Joint(1).T = Mprod_array3(Tinv_array3(Q2Tw_array3(Segment(2).Q)),...
        Q2Tu_array3(Segment(1).Q));  
Joint(1).Euler = R2mobileZYX_array3(Joint(1).T(1:3,1:3,:));

% =========================================================================
% LEFT FOREFOOT/MIDFOOT
% =========================================================================
Joint(101).T = Mprod_array3(Tinv_array3(Q2Tw_array3(Segment(102).Q)),...
        Q2Tu_array3(Segment(101).Q));  
Joint(101).Euler = R2mobileZYX_array3(Joint(101).T(1:3,1:3,:));