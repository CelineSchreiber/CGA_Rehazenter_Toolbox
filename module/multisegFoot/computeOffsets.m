% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    computeOffsets
% -------------------------------------------------------------------------
% Subject:      Compute angle offsets and ankle joint
% -------------------------------------------------------------------------
% Inputs:       - Static (structure)
%               - Markers (structure)
%               - Vmarkers (structure)
%               - side (char)
%               - system (char)
% Outputs:      - Static (structure)
% -------------------------------------------------------------------------
% Author: C. Schreiber, F. Moissenet
% Date of creation: 09/11/2018
% Version: 1
% -------------------------------------------------------------------------
% Updates: 
% =========================================================================

function Condition = computeOffsets(Condition,Marker)

Joint = Joint_Kinematics_multisegFoot(Condition.Static.MultisegFoot.Segment);

for i=2:5                                                                   % 2: FF/MF, 3: MF/CC, 4: CC/TB, 5:FOOT/TB
    Offset(i).R.FE  = Joint(i).Euler(1,1,:)*180/pi;
    Offset(i).R.IER = Joint(i).Euler(1,2,:)*180/pi;
    Offset(i).R.AA  = Joint(i).Euler(1,3,:)*180/pi;
    
    Offset(100+i).L.FE  = Joint(100+i).Euler(1,1,:)*180/pi;
    Offset(100+i).L.IER = Joint(100+i).Euler(1,2,:)*180/pi;
    Offset(100+i).L.AA  = Joint(100+i).Euler(1,3,:)*180/pi;
end
Condition.Static.MultisegFoot.Offset = Offset;