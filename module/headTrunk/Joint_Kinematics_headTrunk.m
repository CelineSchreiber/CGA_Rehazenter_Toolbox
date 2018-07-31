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

function Joint = Joint_Kinematics_headTrunk(Segment)
    
% =====================================================================
% Compute joint angles
% =====================================================================
% Head/Scapular belt 
Joint(1).T  = Mprod_array3(Tinv_array3(Segment(1).R),Segment(2).R);
Joint(1).Euler = R2mobileZXY_array3(Joint(1).T(1:3,1:3,:));
% Scapular belt/Pelvis 
Joint(2).T  = Mprod_array3(Tinv_array3(Segment(2).R),Segment(3).R);
Joint(2).Euler = R2mobileZXY_array3(Joint(2).T(1:3,1:3,:));