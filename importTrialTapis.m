% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    importTrialEMG
% -------------------------------------------------------------------------
% Subject:      Load trial EMG signals
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function [Tapis,btk2] = importTrialTapis(Analog,Event,btk2,n0,n,fMarker,fAnalog)

% =========================================================================
% Initialise the EMG structure
% =========================================================================
Tapis = [];

% =========================================================================
% Tapis signal (only band-pass filter)
% =========================================================================
nAnalog = fieldnames(Analog);
Analog2 = [];
for j = 1:length(nAnalog)
    if ~isempty(strfind(nAnalog{j},'TAPIS_')) 
        % Rebase (remove signal mean)
        Analog2.(nAnalog{j}) = Analog.(nAnalog{j}) - mean(Analog.(nAnalog{j}));
        % Band-pass filter (Butterworth 4nd order, 30-300 Hz)
        [B,A] = butter(4,[30/(fAnalog/2) 300/(fAnalog/2)],'bandpass');
        Analog2.(nAnalog{j}) = filtfilt(B, A, Analog2.(nAnalog{j}));
        % Keep only cycle data (keep 5 frames before and after first and last
        % event) & Zeroing low signals
        events = round(sort([Event.RHS,Event.RTO,Event.LHS,Event.LTO])*fMarker)-...
            n0+1;
        temp = size(Analog2.(nAnalog{j})...
            ((events(1))*fAnalog/fMarker:(events(end))*fAnalog/fMarker,:),1);
        extra = (btkGetAnalogFrameNumber(btk2) - temp)/2;
        if max(Analog2.(nAnalog{j})) > 1e-6
            Analog2.(nAnalog{j}) = Analog2.(nAnalog{j})...
                (events(1)*fAnalog/fMarker-extra:events(end)*fAnalog/fMarker+extra,:);
        else
            Analog2.(nAnalog{j}) = NaN(size(Analog2.(nAnalog{j})...
                (events(1)*fAnalog/fMarker-extra:events(end)*fAnalog/fMarker+extra,:)));
        end        
    end
end
% Export EMG signals  ???? A VOIR !!!
if ~isempty(Analog2)
    nAnalog2 = fieldnames(Analog2);
    for i = 1:length(nAnalog2)
        btkAppendAnalog(btk2,Session.Tapis{i},...
                Analog2.(nAnalog2{i}),'Tapis signal');
            Tapis.(nAnalog2{i}).signal = permute(Analog2.(nAnalog2{i}),[2,3,1]);
        end
    end
end
