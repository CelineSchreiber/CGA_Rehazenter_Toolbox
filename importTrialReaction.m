% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    importTrialReaction
% -------------------------------------------------------------------------
% Subject:      Load trial reaction forces
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function [Grf,tGrf] = importTrialReaction(Event,Forceplate,tGrf,Grf,btk2,n0,n,fMarker,fAnalog)

for j = 1:size(Forceplate,1)
     
    Grf(j).M = Grf(j).M*10^(-3); % Convert from Nmm to Nm
    Grf(j).P = Grf(j).P*10^(-3);
    
    % Replace NaN by zeros
    tGrf(j).F = interpNaN(tGrf(j).F);
    tGrf(j).M = interpNaN(tGrf(j).M);
    Grf(j).F  = interpNaN(Grf(j).F);
    Grf(j).M  = interpNaN(Grf(j).M);
    
    % Low pass filter (Butterworth 4nd order, 15 Hz)
    [B,A] = butter(2,15/(fAnalog/2),'low'); %4?
    for i=1:3
        tGrf(j).F(:,i) = filtfilt(B,A,tGrf(j).F(:,i));
        tGrf(j).M(:,i) = filtfilt(B,A,tGrf(j).M(:,i));
        Grf(j).F(:,i) = filtfilt(B,A,Grf(j).F(:,i));
        Grf(j).M(:,i) = filtfilt(B,A,Grf(j).M(:,i));
    end
    
    % Apply a 10N threshold
    threshold = 10; %50?
    for k = 1:length(tGrf(j).F)
        if tGrf(j).F(k,3) < threshold  % vertical tGrf threshold
            tGrf(j).P(k,:) = zeros(1,3);
            tGrf(j).F(k,:) = zeros(1,3);
            tGrf(j).M(k,:) = zeros(1,3);
            Grf(j).P(k,:) = zeros(1,3);
            Grf(j).F(k,:) = zeros(1,3);
            Grf(j).M(k,:) = zeros(1,3);
        end
    end
    
    % Correction of COP
    for i=1:3
        I=[];
        I=find(abs(Grf(j).P(:,i))>1);
        if ~isempty(I)
            for k=1:length(I)
                Grf(j).P(I(k),i)=0;
            end
        end
    end

    % Keep only cycle data (keep 5 frames before and after first and last
    % event)    
    events = round(sort([Event.RHS,Event.RTO,Event.LHS,Event.LTO])*fMarker)-...
        n0+1;
    temp = size(tGrf(j).F(events(1)*fAnalog/fMarker:events(end)*fAnalog/fMarker,:),1);
    extra = (btkGetAnalogFrameNumber(btk2) - temp)/2;
    tGrf(j).F = tGrf(j).F(events(1)*fAnalog/fMarker-extra:events(end)*fAnalog/fMarker+extra,:);
    tGrf(j).M = tGrf(j).M(events(1)*fAnalog/fMarker-extra:events(end)*fAnalog/fMarker+extra,:);
    tGrf(j).P = tGrf(j).P(events(1)*fAnalog/fMarker-extra:events(end)*fAnalog/fMarker+extra,:);
    Grf(j).F = Grf(j).F(events(1)*fAnalog/fMarker-extra:events(end)*fAnalog/fMarker+extra,:);
    Grf(j).M = Grf(j).M(events(1)*fAnalog/fMarker-extra:events(end)*fAnalog/fMarker+extra,:);
    Grf(j).P = Grf(j).P(events(1)*fAnalog/fMarker-extra:events(end)*fAnalog/fMarker+extra,:);
    
    % Additional treatments for Matlab process
    Grf(j).P = [Grf(j).P(:,1) Grf(j).P(:,3) -Grf(j).P(:,2)]; % Modify the ICS
    Grf(j).F = [Grf(j).F(:,1) Grf(j).F(:,3) -Grf(j).F(:,2)];
    Grf(j).M = [zeros(size(Grf(j).M(:,3))) -Grf(j).M(:,3) zeros(size(Grf(j).M(:,3)))];
    Grf(j).P = permute(Grf(j).P,[2,3,1]); % Store as 3-array vectors
    Grf(j).F = permute(Grf(j).F,[2,3,1]);
    Grf(j).M = permute(Grf(j).M,[2,3,1]);
end