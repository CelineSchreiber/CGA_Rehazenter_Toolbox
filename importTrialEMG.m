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

function [EMG,btk2] = importTrialEMG(Session,Analog,Event,btk2,n0,n)

% =========================================================================
% Initialise the EMG structure
% =========================================================================
EMG = [];

% =========================================================================
% EMG signal (band-pass & low-pass filter)
% =========================================================================
nAnalog = fieldnames(Analog);
Analog1 = [];Analog2 = [];Analog3 = [];
events = round(sort([Event.RHS,Event.RTO,Event.LHS,Event.LTO])*Session.frq.fMarker)-n0+1;

for j = 1:length(nAnalog)
    if ~isempty(strfind(nAnalog{j},'EMG_')) || ...
       ~isempty(strfind(nAnalog{j},'Right_')) || ...
       ~isempty(strfind(nAnalog{j},'Left_'))
        % Rebase (remove signal mean)
        Analog1.(nAnalog{j}) = Analog.(nAnalog{j}) - mean(Analog.(nAnalog{j}));
        if ~isempty(strfind(nAnalog{j},'wire')) 
            % Band-pass filter (Butterworth 2nd order, 60-300 Hz)
            [B,A] = butter(2,[60/(Session.frq.fAnalog/2) 300/(Session.frq.fAnalog/2)],'bandpass');%[B,A] = butter(4,...
            Analog1.(nAnalog{j}) = filtfilt(B, A, Analog1.(nAnalog{j}));
        else 
            % Band-pass filter (Butterworth 2nd order, 30-300 Hz)
            [B,A] = butter(2,[30/(Session.frq.fAnalog/2) 300/(Session.frq.fAnalog/2)],'bandpass');%[B,A] = butter(4,...
            Analog1.(nAnalog{j}) = filtfilt(B, A, Analog1.(nAnalog{j}));
        end 
        % Keep only cycle data (keep 5 frames before and after first and last
        % event) & Zeroing low signals
        temp = size(Analog1.(nAnalog{j})...
            ((events(1))*Session.frq.fAnalog/Session.frq.fMarker:(events(end))*Session.frq.fAnalog/Session.frq.fMarker,:),1);
        extra = (btkGetAnalogFrameNumber(btk2) - temp)/2;
        if max(Analog1.(nAnalog{j})) > 1e-6
            Analog2.(nAnalog{j}) = Analog1.(nAnalog{j})...
                (events(1)*Session.frq.fAnalog/Session.frq.fMarker-extra:events(end)*Session.frq.fAnalog/Session.frq.fMarker+extra,:);
        else
            Analog2.(nAnalog{j}) = NaN(size(Analog1.(nAnalog{j})...
                (events(1)*Session.frq.fAnalog/Session.frq.fMarker-extra:events(end)*Session.frq.fAnalog/Session.frq.fMarker+extra,:)));
        end
        
        % Enveloppe !!!!!!!!!!!!!
        % low-pass filtering (Butterworth 4nd order, 6Hz)
        [B,A] = butter(4,6/(Session.frq.fAnalog/2),'low');
        Analog3.(nAnalog{j}) = filtfilt(B,A,abs(Analog1.(nAnalog{j})));
        % Interpolate to number of marker frames
        x = 1:length(Analog3.(nAnalog{j}));
        xx = linspace(1,length(Analog3.(nAnalog{j})),n);
        temp = Analog3.(nAnalog{j});
        Analog3.(nAnalog{j}) = [];
        Analog3.(nAnalog{j}) = (interp1(x,temp,xx,'spline'))';
        % Keep only cycle data (keep 5 frames before and after first and last
        % event) & Zeroing low signals
        if max(Analog3.(nAnalog{j})) > 1e-6
            Analog3.(nAnalog{j}) = Analog3.(nAnalog{j})...
                (events(1)-5:events(end)+5,:);
        else
            Analog3.(nAnalog{j}) = NaN(size(Analog3.(nAnalog{j})...
                (events(1)-5:events(end)+5,:)));
        end
    end
end

% Export EMG signals
if ~isempty(Analog2)
    nAnalog2 = fieldnames(Analog2);
    for i = 1:length(nAnalog2)
        if ~strcmp(Session.EMG{i},'none')
            btkAppendAnalog(btk2,Session.EMG{i},...
                Analog2.(nAnalog2{i}),'EMG signal (V)');
            EMG.(Session.EMG{i}).raw = permute(Analog1.(nAnalog2{i}),[2,3,1]);
            EMG.(Session.EMG{i}).signal = permute(Analog2.(nAnalog2{i}),[2,3,1]);
            btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
            btkSetPointType(btk2,btkGetPointNumber(btk2),'scalar');
            btkSetPoint(btk2,btkGetPointNumber(btk2),...
                [Analog3.(nAnalog2{i}) ...
                zeros(size(Analog3.(nAnalog2{i}))) ...
                zeros(size(Analog3.(nAnalog2{i})))]);
            btkSetPointLabel(btk2,btkGetPointNumber(btk2),Session.EMG{i});
            btkSetPointDescription(btk2,btkGetPointNumber(btk2),'EMG envelop');
            EMG.(Session.EMG{i}).envelop = permute(Analog3.(nAnalog2{i}),[2,3,1]);
        end
    end
end