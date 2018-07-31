% FUNCTION
% Main_Joint_Kinematics.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of joint angles and displacements
%
% SYNOPSIS
% Joint = Joint_Kinematics(Segment)
%
% INPUT
% Segment (cf. data structure in user guide)
%
% OUTPUT
% Joint (cf. data structure in user guide)
%
% DESCRIPTION
% Definition of JCS axes (e1, e2, e3) from generalized coordinates (Q), and 
% computation of the joint angles and displacement about these axes
%
% REFERENCE
% R Dumas, T Robert, V Pomero, L Cheze. Joint and segment coordinate 
% systems revisited. Computer Methods in Biomechanics and Biomedical  
% Engineering. 2012;15(Suppl 1):183-5
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% Mprod_array3.m
% Tinv_array3.m
% Q2Tuv_array3.m
% Q2Tuw_array3.m
% Q2Twu_array3.m
% R2mobileZXY_array3.m
% R2mobileZYX_array3.m
% Vnop_array3.m
%
% MATLAB VERSION
% Matlab R2016a
%__________________________________________________________________________
%
% CHANGELOG
% Created by Raphaël Dumas
% March 2010
%
% Modified by Raphaël Dumas
% October 2010
% Sequence ZYX for both ankle and wrist joints
%
% Modified by Raphaël Dumas
% July 2012
% New versions of Q2T
% Use of Q2Tuw_array3.m for foot axes
%
% Modified by Raphaël Dumas
% September 2012
% Normalisation of the 2d vector of the non-orthogonal projection on JCS axes
%
% Modified by Raphaël Dumas
% July 2016
% Last updates for Matlab Central
%__________________________________________________________________________
%
% Licence
% Toolbox distributed under BSD license
%__________________________________________________________________________

function Segment = Segment_Kinematics_headTrunk(Segment)

% Number of frames
n = size(Segment(2).Q,3);
s = size(Segment,2);
    
% =====================================================================
% Compute joint angles
% =====================================================================
% Id => Ground/Ground
temp1.R = repmat([-1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1],[1,1,n]);
% Segment i/Ground
for i = 1:s
    Segment(i).R = [Segment(i).X Segment(i).Y Segment(i).Z Segment(i).SCSC;...
        repmat([ 0 0 0 1],[1,1,n])];
    Segment(i).T = Mprod_array3(Tinv_array3(Segment(i).R),temp1.R);
    Segment(i).Euler = R2mobileZXY_array3(Segment(i).T(1:3,1:3,:)); 
end