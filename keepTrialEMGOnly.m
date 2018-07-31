% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    keepTrialEMGOnly
% -------------------------------------------------------------------------
% Subject:      Remove analogs channel not associated to EMG
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function Analog = keepTrialEMGOnly(Analog)

names = fieldnames(Analog);
for i = 1:length(names)
    if strcmp(names{i},'Nothing')
        Analog = rmfield(Analog, names{i});
    end
    if strcmp(names{i},'Sync')
        Analog = rmfield(Analog, names{i});
    end
    if strncmp(names{i},'FP',2)
        Analog = rmfield(Analog, names{i});
    end
    if strncmp(names{i},'PF',2)
        Analog = rmfield(Analog, names{i});
    end
    if strncmp(names{i},'TAPIS',5)
        Analog = rmfield(Analog, names{i});
    end
    if strncmp(names{i},'FSW',3)
        Analog = rmfield(Analog, names{i});
    end
    if strfind(names{i},'Channel')
        Analog = rmfield(Analog, names{i});
    end
    if strfind(names{i},'Amti')
        Analog = rmfield(Analog, names{i});
    end
end
EMG=Analog;