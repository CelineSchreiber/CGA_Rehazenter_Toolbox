% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% fname name:    exportXLS_lowerLimb
% -------------------------------------------------------------------------
% Subject:      Complete the XLS file with CGA data
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 21/02/2019
% Version: 1
% =========================================================================

function exportXLS_lowerLimb(Condition,iCondition,sessionFolder,toolboxFolder)

cd(sessionFolder);
xlsfile = dir('*.xls*');
Excel = actxserver('Excel.Application');
fname = fullfile(pwd,xlsfile(1).name);
if ~exist(fname,'file')
    ExcelWorkbook = Excel.Workbooks.Add;
    ExcelWorkbook.Sheets.Add;
    ExcelWorkbook.SaveAs(fname,1);
    ExcelWorkbook.Close(false);
end
invoke(Excel.Workbooks,'Open',fname);

nline = 107*iCondition-107+1;

% =========================================================================
% Spatiotemporal parameters
% =========================================================================
sheet = 'Examen - data (1)';
xlswrite1(fname,cellstr(['Condition ',num2str(iCondition)]),sheet,['A',num2str(nline)]);
xlswrite1(fname,{'Phase d''appui (% cycle de marche)' 'Phase d''appui (% cycle de marche)' 'Phase d''appui (% cycle de marche)' 'Phase d''appui (% cycle de marche)' ...
    'Phase oscillante (% cycle de marche)' 'Phase oscillante (% cycle de marche)' 'Phase oscillante (% cycle de marche)' 'Phase oscillante (% cycle de marche)' ...
    'Simple appui (% cycle de marche)' 'Simple appui (% cycle de marche)' 'Simple appui (% cycle de marche)' 'Simple appui (% cycle de marche)' ...
    'Double appui 1 (% cycle de marche)' 'Double appui 1 (% cycle de marche)' 'Double appui 1 (% cycle de marche)' 'Double appui 1 (% cycle de marche)' ...
    'Double appui 2 (% cycle de marche)' 'Double appui 2 (% cycle de marche)' 'Double appui 2 (% cycle de marche)' 'Double appui 2 (% cycle de marche)' ...
    'Longueur de foul�e (cm)' 'Longueur de foul�e (cm)' 'Longueur de foul�e (cm)' 'Longueur de foul�e (cm)' ...
    'Longueur de pas (cm)' 'Longueur de pas (cm)' 'Longueur de pas (cm)' 'Longueur de pas (cm)' ...
    'Cycle de marche (s)' 'Cycle de marche (s)' 'Cycle de marche (s)' 'Cycle de marche (s)' ...
    'Largeur de pas (cm)' 'Largeur de pas (cm)' ...
    'Cadence (pas/min)' 'Cadence (pas/min)' ...
    'Vitesse (m/s)' 'Vitesse (m/s)' ...
    },sheet,['B',num2str(nline+1)]);
xlswrite1(fname,{'Gauche' 'Gauche' 'Droite' 'Droite' ...
    'Gauche' 'Gauche' 'Droite' 'Droite' ...
    'Gauche' 'Gauche' 'Droite' 'Droite' ...
    'Gauche' 'Gauche' 'Droite' 'Droite' ...
    'Gauche' 'Gauche' 'Droite' 'Droite' ...
    'Gauche' 'Gauche' 'Droite' 'Droite' ...
    'Gauche' 'Gauche' 'Droite' 'Droite' ...
    'Gauche' 'Gauche' 'Droite' 'Droite' ...
    'Moyen' 'Moyen' ...
    'Moyen' 'Moyen' ...
    'Moyen' 'Moyen' ...
    },sheet,['B',num2str(nline+3)]);
xlswrite1(fname,{'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
    'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
    'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
    'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
    'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
    'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
    'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
    'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
    'Moyenne' 'Ecart-type' ...
    'Moyenne' 'Ecart-type' ...
    'Moyenne' 'Ecart-type' ...
    },sheet,['B',num2str(nline+4)]);
%---
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.L_Stance_Phase.mean,sheet,['B',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.L_Stance_Phase.std,sheet,['C',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.R_Stance_Phase.mean,sheet,['D',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.R_Stance_Phase.std,sheet,['E',num2str(nline+5)]);
%---
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.L_Swing_Phase.mean,sheet,['F',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.L_Swing_Phase.std,sheet,['G',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.R_Swing_Phase.mean,sheet,['H',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.R_Swing_Phase.std,sheet,['I',num2str(nline+5)]);
%---
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.L_Single_Support.mean,sheet,['J',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.L_Single_Support.std,sheet,['K',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.R_Single_Support.mean,sheet,['L',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.R_Single_Support.std,sheet,['M',num2str(nline+5)]);
%---
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.L_Double_Support1.mean,sheet,['N',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.L_Double_Support1.std,sheet,['O',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.R_Double_Support1.mean,sheet,['P',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.R_Double_Support1.std,sheet,['Q',num2str(nline+5)]);
%---
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.L_Double_Support2.mean,sheet,['R',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.L_Double_Support2.std,sheet,['S',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.R_Double_Support2.mean,sheet,['T',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.R_Double_Support2.std,sheet,['U',num2str(nline+5)]);
%---
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.L_Stride_Length.mean,sheet,['V',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.L_Stride_Length.std,sheet,['W',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.R_Stride_Length.mean,sheet,['X',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.R_Stride_Length.std,sheet,['Y',num2str(nline+5)]);
%---
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.L_Step_Length.mean,sheet,['Z',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.L_Step_Length.std,sheet,['AA',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.R_Step_Length.mean,sheet,['AB',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.R_Step_Length.std,sheet,['AC',num2str(nline+5)]);
%---
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.L_Gait_Cycle.mean,sheet,['AD',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.L_Gait_Cycle.std,sheet,['AE',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.R_Gait_Cycle.mean,sheet,['AF',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.R_Gait_Cycle.std,sheet,['AG',num2str(nline+5)]);
%---
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.Stride_Width.mean,sheet,['AH',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.Stride_Width.std,sheet,['AI',num2str(nline+5)]);
%---
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.Cadence.mean,sheet,['AJ',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.Cadence.std,sheet,['AK',num2str(nline+5)]);
%---
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.Velocity.mean,sheet,['AL',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Spatiotemporal.Velocity.std,sheet,['AM',num2str(nline+5)]);

% =========================================================================
% Kinematics
% =========================================================================
sheet = 'Examen - data (2)';
xlswrite1(fname,cellstr(['Condition ',num2str(iCondition)]),sheet,['A',num2str(nline)]);
xlswrite1(fname,cellstr('Temps'),sheet,['A',num2str(nline+4)]);
xlswrite1(fname,(0:1:100)',sheet,['A',num2str(nline+5)]);
xlswrite1(fname,{'Bassin' 'Bassin' 'Bassin' 'Bassin' 'Bassin' 'Bassin' 'Bassin' 'Bassin' 'Bassin' 'Bassin' 'Bassin' 'Bassin' ...
    'Hanche' 'Hanche' 'Hanche' 'Hanche' 'Hanche' 'Hanche' 'Hanche' 'Hanche' 'Hanche' 'Hanche' 'Hanche' 'Hanche' ...
    'Genou' 'Genou' 'Genou' 'Genou' 'Genou' 'Genou' 'Genou' 'Genou' 'Genou' 'Genou' 'Genou' 'Genou' ...
    'Cheville' 'Cheville' 'Cheville' 'Cheville' 'Cheville' 'Cheville' 'Cheville' 'Cheville' 'Cheville' 'Cheville' 'Cheville' 'Cheville' ...
    'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied'},sheet,['B',num2str(nline+1)]);
xlswrite1(fname,{'Anteversion (+) / Retroversion (-) (�)' 'Anteversion (+) / Retroversion (-) (�)' 'Anteversion (+) / Retroversion (-) (�)' 'Anteversion (+) / Retroversion (-) (�)' 'Inclinaison (�l�vation + / chute -) (�)' 'Inclinaison (�l�vation + / chute -) (�)' 'Inclinaison (�l�vation + / chute -) (�)' 'Inclinaison (�l�vation + / chute -) (�)' 'Rotation (externe + / interne -) (�)' 'Rotation (externe + / interne -) (�)' 'Rotation (externe + / interne -) (�)' 'Rotation (externe + / interne -) (�)' ...
    'Flexion (+) / Extension (-) (�)' 'Flexion (+) / Extension (-) (�)' 'Flexion (+) / Extension (-) (�)' 'Flexion (+) / Extension (-) (�)' 'Adduction (+) / Abduction (-) (�)' 'Adduction (+) / Abduction (-) (�)' 'Adduction (+) / Abduction (-) (�)' 'Adduction (+) / Abduction (-) (�)' 'Rotation interne (+) / externe (-) (�)' 'Rotation interne (+) / externe (-) (�)' 'Rotation interne (+) / externe (-) (�)' 'Rotation interne (+) / externe (-) (�)' ...
    'Flexion (+) / Extension (-) (�)' 'Flexion (+) / Extension (-) (�)' 'Flexion (+) / Extension (-) (�)' 'Flexion (+) / Extension (-) (�)' 'Adduction (+) / Abduction (-) (�)' 'Adduction (+) / Abduction (-) (�)' 'Adduction (+) / Abduction (-) (�)' 'Adduction (+) / Abduction (-) (�)' 'Rotation interne (+) / externe (-) (�)' 'Rotation interne (+) / externe (-) (�)' 'Rotation interne (+) / externe (-) (�)' 'Rotation interne (+) / externe (-) (�)' ...
    'Dorsif. (+) / Plantarf. (-) (�)' 'Dorsif. (+) / Plantarf. (-) (�)' 'Dorsif. (+) / Plantarf. (-) (�)' 'Dorsif. (+) / Plantarf. (-) (�)' 'Eversion (+) / Inversion (-) (�)' 'Eversion (+) / Inversion (-) (�)' 'Eversion (+) / Inversion (-) (�)' 'Eversion (+) / Inversion (-) (�)' 'Rotation interne (+) / externe (-) (�)' 'Rotation interne (+) / externe (-) (�)' 'Rotation interne (+) / externe (-) (�)' 'Rotation interne (+) / externe (-) (�)' ...
    'Anteversion (+) / Retroversion (-) (�)' 'Anteversion (+) / Retroversion (-) (�)' 'Anteversion (+) / Retroversion (-) (�)' 'Anteversion (+) / Retroversion (-) (�)' 'Inclinaison (�l�vation + / chute -) (�)' 'Inclinaison (�l�vation + / chute -) (�)' 'Inclinaison (�l�vation + / chute -) (�)' 'Inclinaison (�l�vation + / chute -) (�)' 'Rotation (externe + / interne -) (�)' 'Rotation (externe + / interne -) (�)' 'Rotation (externe + / interne -) (�)' 'Rotation (externe + / interne -) (�)'},sheet,['B',num2str(nline+2)]);
xlswrite1(fname,{'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite' ...
    'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite' ...
    'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite' ...
    'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite' ...
    'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite'},sheet,['B',num2str(nline+3)]);
xlswrite1(fname,{'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
    'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
    'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
    'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
    'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type'},sheet,['B',num2str(nline+4)]);
%---
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Segmentkinematics.L_Pelvis_Angle_FE.mean,sheet,['B',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Segmentkinematics.L_Pelvis_Angle_FE.std,sheet,['C',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Segmentkinematics.R_Pelvis_Angle_FE.mean,sheet,['D',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Segmentkinematics.R_Pelvis_Angle_FE.std,sheet,['E',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Segmentkinematics.L_Pelvis_Angle_AA.mean,sheet,['F',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Segmentkinematics.L_Pelvis_Angle_AA.std,sheet,['G',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Segmentkinematics.R_Pelvis_Angle_AA.mean,sheet,['H',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Segmentkinematics.R_Pelvis_Angle_AA.std,sheet,['I',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Segmentkinematics.L_Pelvis_Angle_IER.mean,sheet,['J',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Segmentkinematics.L_Pelvis_Angle_IER.std,sheet,['K',num2str(nline+5)]);
xlswrite1(fname,-Condition(iCondition).Average.LowerLimb.Segmentkinematics.R_Pelvis_Angle_IER.mean,sheet,['L',num2str(nline+5)]);
xlswrite1(fname,-Condition(iCondition).Average.LowerLimb.Segmentkinematics.R_Pelvis_Angle_IER.std,sheet,['M',num2str(nline+5)]);
%---
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.L_Hip_Angle_FE.mean,sheet,['N',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.L_Hip_Angle_FE.std,sheet,['O',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.R_Hip_Angle_FE.mean,sheet,['P',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.R_Hip_Angle_FE.std,sheet,['Q',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.L_Hip_Angle_AA.mean,sheet,['R',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.L_Hip_Angle_AA.std,sheet,['S',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.R_Hip_Angle_AA.mean,sheet,['T',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.R_Hip_Angle_AA.std,sheet,['U',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.L_Hip_Angle_IER.mean,sheet,['V',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.L_Hip_Angle_IER.std,sheet,['W',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.R_Hip_Angle_IER.mean,sheet,['X',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.R_Hip_Angle_IER.std,sheet,['Y',num2str(nline+5)]);
%---
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.L_Knee_Angle_FE.mean,sheet,['Z',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.L_Knee_Angle_FE.std,sheet,['AA',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.R_Knee_Angle_FE.mean,sheet,['AB',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.R_Knee_Angle_FE.std,sheet,['AC',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.L_Knee_Angle_AA.mean,sheet,['AD',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.L_Knee_Angle_AA.std,sheet,['AE',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.R_Knee_Angle_AA.mean,sheet,['AF',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.R_Knee_Angle_AA.std,sheet,['AG',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.L_Knee_Angle_IER.mean,sheet,['AH',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.L_Knee_Angle_IER.std,sheet,['AI',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.R_Knee_Angle_IER.mean,sheet,['AJ',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.R_Knee_Angle_IER.std,sheet,['AK',num2str(nline+5)]);
%---
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.L_Ankle_Angle_FE.mean,sheet,['AL',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.L_Ankle_Angle_FE.std,sheet,['AM',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.R_Ankle_Angle_FE.mean,sheet,['AN',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.R_Ankle_Angle_FE.std,sheet,['AO',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.L_Ankle_Angle_AA.mean,sheet,['AP',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.L_Ankle_Angle_AA.std,sheet,['AQ',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.R_Ankle_Angle_AA.mean,sheet,['AR',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.R_Ankle_Angle_AA.std,sheet,['AS',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.L_Ankle_Angle_IER.mean,sheet,['AT',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.L_Ankle_Angle_IER.std,sheet,['AU',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.R_Ankle_Angle_IER.mean,sheet,['AV',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Jointkinematics.R_Ankle_Angle_IER.std,sheet,['AW',num2str(nline+5)]);
%---
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Segmentkinematics.L_Foot_Angle_FE.mean,sheet,['AX',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Segmentkinematics.L_Foot_Angle_FE.std,sheet,['AY',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Segmentkinematics.R_Foot_Angle_FE.mean,sheet,['AZ',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Segmentkinematics.R_Foot_Angle_FE.std,sheet,['BA',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Segmentkinematics.L_Foot_Angle_AA.mean,sheet,['BB',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Segmentkinematics.L_Foot_Angle_AA.std,sheet,['BC',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Segmentkinematics.R_Foot_Angle_AA.mean,sheet,['BD',num2str(nline+5)]);
xlswrite1(fname,Condition(iCondition).Average.LowerLimb.Segmentkinematics.R_Foot_Angle_AA.std,sheet,['BE',num2str(nline+5)]);
xlswrite1(fname,-Condition(iCondition).Average.LowerLimb.Segmentkinematics.L_Foot_Angle_IER.mean,sheet,['BF',num2str(nline+5)]);
xlswrite1(fname,-Condition(iCondition).Average.LowerLimb.Segmentkinematics.L_Foot_Angle_IER.std,sheet,['BG',num2str(nline+5)]);
xlswrite1(fname,-Condition(iCondition).Average.LowerLimb.Segmentkinematics.R_Foot_Angle_IER.mean,sheet,['BH',num2str(nline+5)]);
xlswrite1(fname,-Condition(iCondition).Average.LowerLimb.Segmentkinematics.R_Foot_Angle_IER.std,sheet,['BI',num2str(nline+5)]);

% =========================================================================
% EMG
% =========================================================================
sheet = 'Examen - data (4)';
xlswrite1(fname,cellstr(['Condition ',num2str(iCondition)]),sheet,['A',num2str(nline)]);
xlswrite1(fname,cellstr('Temps'),sheet,['A',num2str(nline+4)]);
xlswrite1(fname,(0:1:100)',sheet,['A',num2str(nline+5)]);
eNames = {};
k = 1;
eFields = fieldnames(Condition.Average.LowerLimb.EMG);
for i = 1:length(eFields)
    if ~isempty(strfind(eFields{i}, 'Envelop'))
        for j = 1:3
            eNames{k} = regexprep(eFields{i},'_Envelop','');
            k = k+1;
        end
    end
end
xlswrite1(fname,eNames,sheet,['B',num2str(nline+1)]);
eNames = {};
k = 1;
eFields = fieldnames(Condition.Average.LowerLimb.EMG);
for i = 1:length(eFields)
    if ~isempty(strfind(eFields{i}, 'Envelop'))
        for j = 1
            eNames{k} = 'Signal (V)';
            k = k+1;
        end
        for j = 2:3
            eNames{k} = 'Enveloppe (adim)';
            k = k+1;
        end
    end
end
xlswrite1(fname,eNames,sheet,['B',num2str(nline+2)]);
eNames = {};
k = 1;
eFields = fieldnames(Condition.Average.LowerLimb.EMG);
for i = 1:length(eFields)/2
    if ~isempty(strfind(eFields{i}, 'Envelop'))
        for j = 1:3
            eNames{k} = 'Gauche';
            k = k+1;
        end
    end
end
for i = length(eFields)+1:length(eFields)
    if ~isempty(strfind(eFields{i}, 'Envelop'))
        for j = 1:3
            eNames{k} = 'Droite';
            k = k+1;
        end
    end
end
xlswrite1(fname,eNames,sheet,['B',num2str(nline+3)]);
eNames = {};
k = 1;
eFields = fieldnames(Condition.Average.LowerLimb.EMG);
for i = 1:length(eFields)
    if ~isempty(strfind(eFields{i}, 'Envelop'))
        for j = 1
            eNames{k} = 'R�p�titions';
            k = k+1;
        end
        eNames{k} = 'Moyenne'; k = k+1;
        eNames{k} = 'Ecart-type'; k = k+1;
    end
end
xlswrite1(fname,eNames,sheet,['B',num2str(nline+4)]);
%---
columns = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' ...
    'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z' 'AA' 'AB' 'AC' 'AD' 'AE' 'AF' ...
    'AG' 'AH' 'AI' 'AJ' 'AK' 'AL' 'AM' 'AN' 'AO' 'AP' 'AQ' 'AR' 'AS' 'AT' ...
    'AU' 'AV' 'AW' 'AX' 'AY' 'AZ' 'BA' 'BB' 'BC' 'BD' 'BE' 'BF' ...
    'BG' 'BH' 'BI' 'BJ' 'BK' 'BL' 'BM' 'BN' 'BO' 'BP' 'BQ' 'BR' 'BS' 'BT' ...
    'BU' 'BV' 'BW' 'BX' 'BY' 'BZ' 'CA' 'CB' 'CC' 'CD' 'CE' 'CF' ...
    'CG' 'CH' 'CI' 'CJ' 'CK' 'CL' 'CM' 'CN' 'CO' 'CP' 'CQ' 'CR' 'CS' 'CT' ...
    'CU' 'CV' 'CW' 'CX' 'CY' 'CZ'};
eNames = {};
k = 2;
eFields = fieldnames(Condition.Average.LowerLimb.EMG);
for i = 1:length(eFields)
    if ~isempty(strfind(eFields{i}, 'L_'))
        if ~isempty(strfind(eFields{i}, '_Signal'))
            xlswrite1(fname,Condition(iCondition).Average.LowerLimb.EMG.(eFields{i}).mean*1e3,sheet,[columns{k},num2str(nline+5)]); k = k+1;
        end
        if ~isempty(strfind(eFields{i}, '_Envelop'))
            xlswrite1(fname,Condition(iCondition).Average.LowerLimb.EMG.(eFields{i}).mean,sheet,[columns{k},num2str(nline+5)]); k = k+1;
            xlswrite1(fname,Condition(iCondition).Average.LowerLimb.EMG.(eFields{i}).std,sheet,[columns{k},num2str(nline+5)]); k = k+1;
        end
    end
    if ~isempty(strfind(eFields{i}, 'R_'))
        if ~isempty(strfind(eFields{i}, '_Signal'))
            xlswrite1(fname,Condition(iCondition).Average.LowerLimb.EMG.(eFields{i}).mean*1e3,sheet,[columns{k},num2str(nline+5)]); k = k+1;
        end
        if ~isempty(strfind(eFields{i}, '_Envelop'))
            xlswrite1(fname,Condition(iCondition).Average.LowerLimb.EMG.(eFields{i}).mean,sheet,[columns{k},num2str(nline+5)]); k = k+1;
            xlswrite1(fname,Condition(iCondition).Average.LowerLimb.EMG.(eFields{i}).std,sheet,[columns{k},num2str(nline+5)]); k = k+1;
        end
    end
end    
%---

invoke(Excel.ActiveWorkbook,'Save');
Excel.ActiveWorkbook.Save
Excel.Quit
Excel.delete
clear Excel
cd(toolboxFolder);