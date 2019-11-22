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
% EMG signal (only band-pass filter)
% =========================================================================
nAnalog = fieldnames(Analog);
Analog1 = [];Analog2 = [];
events = round(sort([Event.RHS,Event.RTO,Event.LHS,Event.LTO])*Session.frq.fMarker)-n0+1;

for j = 1:length(nAnalog)
    if ~isempty(strfind(nAnalog{j},'EMG_')) || ...
       ~isempty(strfind(nAnalog{j},'Right_')) || ...
       ~isempty(strfind(nAnalog{j},'Left_'))
        % Rebase (remove signal mean)
        Analog1.(nAnalog{j}) = Analog.(nAnalog{j}) - mean(Analog.(nAnalog{j}));
        % Band-pass filter (Butterworth 4nd order, 30-300 Hz)
        [B,A] = butter(4,[30/(Session.frq.fAnalog/2) 300/(Session.frq.fAnalog/2)],'bandpass');
        Analog1.(nAnalog{j}) = filtfilt(B, A, Analog1.(nAnalog{j}));
        
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
        end
    end
end

% =========================================================================
% EMG envelop
% =========================================================================
nAnalog = fieldnames(Analog);
Analog2 = [];
for j = 1:length(nAnalog)
    if ~isempty(strfind(nAnalog{j},'EMG_')) || ...
       ~isempty(strfind(nAnalog{j},'Right_')) || ...
       ~isempty(strfind(nAnalog{j},'Left_'))
        % Rebase (remove signal mean)
        Analog2.(nAnalog{j}) = Analog.(nAnalog{j}) - mean(Analog.(nAnalog{j}));
        % Band-pass filter (Butterworth 4nd order, 30-300 Hz)
        [B,A] = butter(4,[30/(Session.frq.fAnalog/2) 300/(Session.frq.fAnalog/2)],'bandpass');
        Analog2.(nAnalog{j}) = filtfilt(B, A, Analog2.(nAnalog{j}));
        % Rectification (absolute value of the signal)
        Analog2.(nAnalog{j}) = abs(Analog2.(nAnalog{j}));
        % Low pass filter (Butterworth 4nd order, 10 Hz)
        [B,A] = butter(4,10/(Session.frq.fAnalog/2),'low');
        Analog2.(nAnalog{j}) = filtfilt(B, A, Analog2.(nAnalog{j}));
        % Interpolate to number of marker frames
        x = 1:length(Analog2.(nAnalog{j}));
        xx = linspace(1,length(Analog2.(nAnalog{j})),n);
        temp = Analog2.(nAnalog{j});
        Analog2.(nAnalog{j}) = [];
        Analog2.(nAnalog{j}) = (interp1(x,temp,xx,'spline'))';
        % Keep only cycle data (keep 5 frames before and after first and last
        % event) & Zeroing low signals
        events = round(sort([Event.RHS,Event.RTO,Event.LHS,Event.LTO])*Session.frq.fMarker)-...
            n0+1;
        if max(Analog2.(nAnalog{j})) > 1e-6
            Analog2.(nAnalog{j}) = Analog2.(nAnalog{j})...
                (events(1)-5:events(end)+5,:);
        else
            Analog2.(nAnalog{j}) = NaN(size(Analog2.(nAnalog{j})...
                (events(1)-5:events(end)+5,:)));
        end
    end
end
% Export EMG signals
if ~isempty(Analog2)
    nAnalog2 = fieldnames(Analog2);
    for i = 1:length(nAnalog2)
        if ~strcmp(Session.EMG{i},'none')
            btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
            btkSetPointType(btk2,btkGetPointNumber(btk2),'scalar');
            btkSetPoint(btk2,btkGetPointNumber(btk2),...
                [Analog2.(nAnalog2{i}) ...
                zeros(size(Analog2.(nAnalog2{i}))) ...
                zeros(size(Analog2.(nAnalog2{i})))]);
            btkSetPointLabel(btk2,btkGetPointNumber(btk2),Session.EMG{i});
            btkSetPointDescription(btk2,btkGetPointNumber(btk2),'EMG envelop');
            EMG.(Session.EMG{i}).envelop = permute(Analog2.(nAnalog2{i}),[2,3,1]);
        end
    end
end