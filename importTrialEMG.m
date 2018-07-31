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

function [EMG,btk2] = importTrialEMG(Session,Analog,Event,MaxEMG,btk2,n0,n,fMarker,fAnalog)

% =========================================================================
% EMG signal (only band-pass filter)
% =========================================================================
Analog = keepTrialEMGOnly(Analog);
nAnalog = fieldnames(Analog);
for j = 1:length(nAnalog)
    % Rebase (remove signal mean)
    Analog2.(nAnalog{j}) = Analog.(nAnalog{j}) - mean(Analog.(nAnalog{j}));
    % Band-pass filter (Butterworth 2nd order, 30-300 Hz)
    [B,A] = butter(2,[30/(fAnalog/2) 300/(fAnalog/2)],'bandpass');
    Analog2.(nAnalog{j}) = filtfilt(B, A, Analog2.(nAnalog{j}));
    % Interpolate to number of marker frames
    x = 1:length(Analog2.(nAnalog{j}));
    xx = linspace(1,length(Analog2.(nAnalog{j})),n);
    temp = Analog2.(nAnalog{j});
    Analog2.(nAnalog{j}) = [];
    Analog2.(nAnalog{j}) = (interp1(x,temp,xx,'spline'))';
    % Keep only cycle data (keep 5 frames before and after first and last
    % event)
    events = round(sort([Event.RHS,Event.RTO,Event.LHS,Event.LTO])*fMarker)-...
        n0+1;
    % Zeroing of low signals
    if max(Analog2.(nAnalog{j})) > 1e-6
        Analog2.(nAnalog{j}) = Analog2.(nAnalog{j})...
            (events(1)-5:events(end)+5,:);
    else
        Analog2.(nAnalog{j}) = NaN(size(Analog2.(nAnalog{j})...
            (events(1)-5:events(end)+5,:)));
    end
end
% Export EMG signals (manage if a channel as been removed in the hardware
% for maintenance reasons)
nAnalog2 = fieldnames(Analog2);
for i = 1:length(nAnalog2)
    if ~strcmp(Session.EMG{i},'none')
        btkAppendAnalog(btk2,Session.EMG{i},...
            Analog2.(nAnalog2{i}),'EMG signal (mV)');
        EMG.(Session.EMG{i}).signal = permute(Analog2.(nAnalog2{i}),[2,3,1]);
    end
end

% =========================================================================
% EMG envelop
% =========================================================================
nAnalog = fieldnames(Analog);
for j = 1:length(nAnalog)
    % Rebase (remove signal mean)
    Analog.(nAnalog{j}) = Analog.(nAnalog{j}) - mean(Analog.(nAnalog{j}));
    % Band-pass filter (Butterworth 4nd order, 30-300 Hz)
    [B,A] = butter(4,[30/(fAnalog/2) 300/(fAnalog/2)],'bandpass');
    Analog.(nAnalog{j}) = filtfilt(B, A, Analog.(nAnalog{j}));
    % Rectification (absolute value of the signal)
    Analog.(nAnalog{j}) = abs(Analog.(nAnalog{j}));
    % Low pass filter (Butterworth 2nd order, 50 Hz)
    [B,A] = butter(2,50/(fAnalog/2),'low');
    Analog.(nAnalog{j}) = filtfilt(B, A, Analog.(nAnalog{j}));
    % Interpolate to number of marker frames
    x = 1:length(Analog.(nAnalog{j}));
    xx = linspace(1,length(Analog.(nAnalog{j})),n);
    temp = Analog.(nAnalog{j});
    Analog.(nAnalog{j}) = [];
    Analog.(nAnalog{j}) = (interp1(x,temp,xx,'spline'))';
    % Keep only cycle data (keep 5 frames before and after first and last
    % event)
    events = round(sort([Event.RHS,Event.RTO,Event.LHS,Event.LTO])*fMarker)-...
        n0+1;
    if max(Analog.(nAnalog{j})) > 1e-6
        Analog.(nAnalog{j}) = Analog.(nAnalog{j})...
            (events(1)-5:events(end)+5,:);
    else
        Analog.(nAnalog{j}) = NaN(size(Analog.(nAnalog{j})...
            (events(1)-5:events(end)+5,:)));
    end
end
% Normalise by condition max and export EMG signals (manage if a channel as
% been removed in the hardware for maintenance reasons)
nAnalog2 = fieldnames(Analog2);
for i = 1:length(nAnalog2)
    if ~strcmp(Session.EMG{i},'none')
            btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
            btkSetPointType(btk2,btkGetPointNumber(btk2),'scalar');
            btkSetPoint(btk2,btkGetPointNumber(btk2),...
                [Analog.(nAnalog2{i})/max(Analog.(nAnalog2{i})) ...
                zeros(size(Analog.(nAnalog2{i}))) ...
                zeros(size(Analog.(nAnalog2{i})))]);
            btkSetPointLabel(btk2,btkGetPointNumber(btk2),Session.EMG{i});
            btkSetPointDescription(btk2,btkGetPointNumber(btk2),'EMG envelop normalised by condition max');
            EMG.(Session.EMG{i}).envelop = ...
                permute(Analog.(nAnalog2{i}),[2,3,1])/MaxEMG.(nAnalog2{i}).max;
        end
end