% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN CLINICAL REPORT
% =========================================================================
% File name:    reportKinematics
% -------------------------------------------------------------------------
% Subject:      Generate the report page for kinematics
% -------------------------------------------------------------------------
% Inpageuts:    - Patient (structure)
%               - Session (structure)
%               - Condition (structure)
%               - pluginFolder (char)
%               - normFolder (char)
%               - norm (char)
% Outputs:      - f (figure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 13/01/2015
% Version: 1
% -------------------------------------------------------------------------
% Updates: -
% =========================================================================

function f = reportAnkle(Patient,Session,Condition,pluginFolder,normFolder,norm)

% =========================================================================
% Initialisation
% =========================================================================
pageWidth = 21; % cm
pageHeight = 29.7; % cm
graphWidth = 5.0; % cm
graphHeight = 2.0; %2.3 cm
yinit = 29.0; % cm
yincr = 0.45; % cm
x = [1.50 8.00 14.50]; % cm
igraph = 1; % graph number
colorR = [0 0.8 0;0 0.8 0.8;0 0.4 0;0 0.4 0.4;0 0.2 0;0 0.2 0.2];
colorL = [0.8 0 0;0.8 0 0.8;0.4 0 0;0.4 0 0.4;0.2 0 0;0.2 0 0.2];
colorB = [0 0 0.8;0.2 0.2 0.8;0.5 0.5 0.8;0.7 0.7 0.8;0.9 0.9 0.8;0.9 0.9 0.6];

cd(normFolder);
temp = load(cell2mat(norm));
Norm.Kinematics = temp.Normatives.Rkinematics;
Norm.Kinetics = temp.Normatives.Rdynamics;
Norm.Event = temp.Normatives.Rphases;
Norm.EMG = temp.Normatives.Remg;

cd(pluginFolder);
for i = 1:size(Condition,2)
    Jkinematics(i) = Condition(i).Average.LowerLimb.Jointkinematics;
    Skinematics(i) = Condition(i).Average.LowerLimb.Segmentkinematics;
    Dynamics(i) = Condition(i).Average.LowerLimb.Dynamics;
    Revent(i) = Condition(i).Average.LowerLimb.Spatiotemporal.R_Stance_Phase;
    Levent(i) = Condition(i).Average.LowerLimb.Spatiotemporal.L_Stance_Phase;
end

% EMG: choix de l'essai %
icondition = [];
itrial = [];
condNames=cell(1,length(Session));
for i=1:length(Session)
    condNames{i}=[char(Patient(i).lastname),' - ',char(Session(i).date),' - ',char(Condition(i).name)];
end
[icondition,ok]=listdlg('ListString',condNames,'ListSize',[300 300]);
files=[];
for i=1:length(Session(icondition).Trial)
    if strcmp(Session(icondition).Trial(i).condition,Condition(icondition).name)
        files=[files;Session(icondition).Trial(i).filename];
    end
end
if ~isempty(files)
    [itrial,ok]=listdlg('ListString',files);
else
    f=0;
    return;
end

number_frame_cycle = Condition(icondition).Trial(itrial).LowerLimb.Events.e.LHS(2)*Session(icondition).frq.fAnalog...
                - Condition(icondition).Trial(itrial).LowerLimb.Events.e.LHS(1)*Session(icondition).frq.fAnalog;
X_down = Condition(icondition).Trial(itrial).LowerLimb.Events.e.LHS(1)*Session(icondition).frq.fAnalog-2*number_frame_cycle;
X_up = Condition(icondition).Trial(itrial).LowerLimb.Events.e.LHS(2)*Session(icondition).frq.fAnalog+2*number_frame_cycle;
nf=1;    

% =========================================================================
% Generate the page
% =========================================================================
% Case 1: Only 1 condition: page 1 = right and left parameters
% Case 2: More than 1 condition: page 1 = right, page 2 = left A FAIRE!
% =========================================================================
if size(Condition,2) == 1
    
    % Set the page
    % ---------------------------------------------------------------------
    f(1) = figure('PaperOrientation','portrait','papertype','A4',...
        'Units','centimeters','Position',[0 0 pageWidth pageHeight],...
        'Color','white','PaperUnits','centimeters',...
        'PaperPosition',[0 0 pageWidth pageHeight],...
        'Name',['parameters',num2str(1)]);
    hold on;
    axis off;
    
    % Rehazenter banner
    % ---------------------------------------------------------------------
    a=annotation('textbox',[0.015 0.925 0.970 0.06],'BackgroundColor','none','EdgeColor',[0 0 0],...
        'LineStyle','-','LineWidth',0.5000,'Units','normalized');
    cd(pluginFolder);
    banner = imread('banner.png');
    axesImage = axes('position',...
        [0.05 0.93 0.2 0.0502]);
    image(banner);
    set(axesImage,'Visible','Off');
    
    % Header
    % ---------------------------------------------------------------------
    axesText = axes;
    set(axesText,'Position',[0.47 0 1 1]);
    set(axesText,'Visible','Off');
    y = yinit;
    y = y - 0.5;
    text(0.5/pageWidth,y/pageHeight,...
        'CNRFR - Rehazenter',...
        'Color','k','FontSize',12);
    y = y - yincr;
    text(0.5/pageWidth,y/pageHeight,...
        'Laboratoire d''Analyse du Mouvement et de la Posture',...
        'Color','k','FontSize',10);
    
    % Patient
    % ---------------------------------------------------------------------
    y = y - yincr*3;
    axesLegend = axes;
    set(axesLegend,'Position',[0 0 1 1]);
    set(axesLegend,'Visible','Off');
    text(0.05,y/pageHeight,'Patient : ','FontWeight','Bold','Color','black');
    text(0.22,y/pageHeight,[Patient(1).lastname,' ',Patient(1).firstname],'Color','black');
    y = y - yincr;
    text(0.05,y/pageHeight,'Date de naissance : ','FontWeight','Bold','Color','black');
    text(0.22,y/pageHeight,[Patient(1).birthdate],'Color','black');
    
    % Legend
    % ---------------------------------------------------------------------
    y = y + yincr;
    text(0.40,y/pageHeight,'Date AQM : ','FontWeight','Bold','Color','black');
    text(0.50,y/pageHeight,[char(Session(1).date)],'Color','black');
    text(0.65,y/pageHeight,['Condition : ',char(regexprep(Condition(1).name,'_','-'))],'Color','black');
    y = y - yincr;
    % Count the number of trials
    nbtrials = 0;
    for j = 1:length(Condition(1).Trial);
        if ~isempty(Condition(1).Trial(j).LowerLimb.Segmentkinematics.R_Pelvis_Angle_AA)
            nbtrials = nbtrials+1;
        end
    end
    % Write the legend
    text(0.40,y/pageHeight,'Nb essais : ','Color','black');
    text(0.50,y/pageHeight,num2str(nbtrials),'Color','black'); 
    text(0.65,y/pageHeight,'Droite','Color',colorR(1,:));
    text(0.75,y/pageHeight,'Gauche','Color',colorL(1,:));
    text(0.85,y/pageHeight,'Norme','Color',[0.5 0.5 0.5]);
    y = y - yincr*1.2;
    
    % Title
    % ---------------------------------------------------------------------
    axesText = axes;
    set(axesText,'Position',[0.47 0 1 1]);
    set(axesText,'Visible','Off');
    y = y - yincr*1.5;
    text(0.02,y/pageHeight,...
        '  Cinématique de la cheville et du pied ',...
        'Color','k','FontWeight','Bold','FontSize',14,...
        'HorizontalAlignment','Center');
    
    % Right/Left ankle flexion/extension
    % ---------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1],'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Ankle flexion/extension (Dorsi+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinematics.FE2.mean,Norm.Kinematics.FE2.std,[0.5 0.5 0.5]);
    if ~isempty(Jkinematics.R_Ankle_Angle_FE.mean)
        corridor(Jkinematics.R_Ankle_Angle_FE.mean,Jkinematics.R_Ankle_Angle_FE.std,colorR(1,:));
        plot(Jkinematics.R_Ankle_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(1,:));
    end
    if ~isempty(Jkinematics.L_Ankle_Angle_FE.mean)
        corridor(Jkinematics.L_Ankle_Angle_FE.mean,Jkinematics.L_Ankle_Angle_FE.std,colorL(1,:));
        plot(Jkinematics.L_Ankle_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(1,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right/Left ankle internal/external rotation
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Ankle internal/external rotation (Int+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinematics.IER2.mean,Norm.Kinematics.IER2.std,[0.5 0.5 0.5]);
    if ~isempty(Jkinematics.R_Ankle_Angle_IER.mean)
        corridor(Jkinematics.R_Ankle_Angle_IER.mean,Jkinematics.R_Ankle_Angle_IER.std,colorR(1,:));
        plot(Jkinematics.R_Ankle_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color',colorR(1,:));
    end
    if ~isempty(Jkinematics.L_Ankle_Angle_IER.mean)
        corridor(Jkinematics.L_Ankle_Angle_IER.mean,Jkinematics.L_Ankle_Angle_IER.std,colorL(1,:));
        plot(Jkinematics.L_Ankle_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color',colorL(1,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right/Left foot tilt
    % ---------------------------------------------------------------------
    y = y - yincr*7.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Foot tilt (Dorsi+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        corridor(Norm.Kinematics.Ftilt.mean,Norm.Kinematics.Ftilt.std,[0.5 0.5 0.5]);
    if ~isempty(Skinematics.R_Foot_Angle_FE.mean)
        corridor(Skinematics.R_Foot_Angle_FE.mean,Skinematics.R_Foot_Angle_FE.std,colorR(1,:));
        plot(Skinematics.R_Foot_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(1,:));
    end
    if ~isempty(Skinematics.L_Foot_Angle_FE.mean)
        corridor(Skinematics.L_Foot_Angle_FE.mean,Skinematics.L_Foot_Angle_FE.std,colorL(1,:));
        plot(Skinematics.L_Foot_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(1,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right/Left foot obliquity
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Foot obliquity (Valgus+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        corridor(Norm.Kinematics.Fobli.mean,Norm.Kinematics.Fobli.std,[0.5 0.5 0.5]);
    if ~isempty(Skinematics.R_Foot_Angle_AA.mean)
        corridor(-Skinematics.R_Foot_Angle_AA.mean,Skinematics.R_Foot_Angle_AA.std,colorR(1,:));
        plot(-Skinematics.R_Foot_Angle_AA.mean,'Linestyle','-','Linewidth',2,'Color',colorR(1,:));
    end
    if ~isempty(Skinematics.L_Foot_Angle_AA.mean)
        corridor(-Skinematics.L_Foot_Angle_AA.mean,Skinematics.L_Foot_Angle_AA.std,colorL(1,:));
        plot(-Skinematics.L_Foot_Angle_AA.mean,'Linestyle','-','Linewidth',2,'Color',colorL(1,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right/Left foot rotation
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Foot progression angle (Int+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        corridor(Norm.Kinematics.Frota.mean,Norm.Kinematics.Frota.std,[0.5 0.5 0.5]);
    if ~isempty(Skinematics.R_Foot_Angle_IER.mean)
        corridor(-Skinematics.R_Foot_Angle_IER.mean,Skinematics.R_Foot_Angle_IER.std,colorR(1,:));
        plot(-Skinematics.R_Foot_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color',colorR(1,:));
    end
    if ~isempty(Skinematics.L_Foot_Angle_IER.mean)
        corridor(-Skinematics.L_Foot_Angle_IER.mean,Skinematics.L_Foot_Angle_IER.std,colorL(1,:));
        plot(-Skinematics.L_Foot_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color',colorL(1,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    if ~isempty(Dynamics.L_Ankle_Moment_FE.mean) | ~isempty(Dynamics.R_Ankle_Moment_FE.mean)
        
        % Title
        % ---------------------------------------------------------------------
        axesText = axes;
        set(axesText,'Position',[0.47 0 1 1]);
        set(axesText,'Visible','Off');
        y = y - yincr*3;
        text(0.02,y/pageHeight,'  Cinétique de la cheville','Color','k','FontWeight','Bold','FontSize',14,'HorizontalAlignment','Center');

        % Right/Left ankle flexion/extension moment
        % ---------------------------------------------------------------------
        y = y - yincr*6.5;
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
            graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.05:10);
        hold on;
        title('Flexion/extension moment (Dorsi+)','FontWeight','Bold');
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Moment (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
        plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        corridor(Norm.Kinetics.FE2.mean,Norm.Kinetics.FE2.std,[0.5 0.5 0.5]);
        if ~isempty(Dynamics.R_Ankle_Moment_FE.mean)
            corridor(Dynamics.R_Ankle_Moment_FE.mean,Dynamics.R_Ankle_Moment_FE.std,colorR(1,:));
            plot(Dynamics.R_Ankle_Moment_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(1,:));
        end
        if ~isempty(Dynamics.L_Ankle_Moment_FE.mean)
            corridor(Dynamics.L_Ankle_Moment_FE.mean,Dynamics.L_Ankle_Moment_FE.std,colorL(1,:));
            plot(Dynamics.L_Ankle_Moment_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(1,:));
        end
        axis tight;
        YL = ylim;
        YL = setAxisLim(YL,-0.20,0.05);
        axis([0 100 -.2 .2]);
    %     axis([0 100 YL(1) YL(2)]);
        box on;
        igraph = igraph+1;

        % Right/Left ankle flexion/extension power
        % ---------------------------------------------------------------------
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
            graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.2:10);
        hold on;
        title('Flexion/extension power (Flex+)','FontWeight','Bold');
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Power (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
        plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        corridor(Norm.Kinetics.Power2.mean,Norm.Kinetics.Power2.std,[0.5 0.5 0.5]);
        if ~isempty(Dynamics.R_Ankle_Power_FE.mean)
            corridor(Dynamics.R_Ankle_Power_FE.mean,Dynamics.R_Ankle_Power_FE.std,colorR(1,:));
            plot(Dynamics.R_Ankle_Power_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(1,:));
        end
        if ~isempty(Dynamics.L_Ankle_Power_FE.mean)
            corridor(Dynamics.L_Ankle_Power_FE.mean,Dynamics.L_Ankle_Power_FE.std,colorL(1,:));
            plot(Dynamics.L_Ankle_Power_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(1,:));
        end
        axis tight;
        YL = ylim;
        YL = setAxisLim(YL,-0.2,1.2);
        axis([0 100 -1 1]);
        box on;
    %     igraph = igraph+1;
    end
    
    % Events
    % ---------------------------------------------------------------------
    for g = 1:length(Graph)
        axes(Graph(g));
        YL = ylim;
        corridor(Norm.Event.p5.mean,Norm.Event.p5.std,[0.5 0.5 0.5]);
        corridor(Revent.mean,Revent.std,colorR(1,:));
        plot([Revent.mean Revent.mean],[-180 180],'Linestyle','-','Linewidth',2,'Color',colorR(1,:)); %IHS
        corridor(Levent.mean,Levent.std,colorL(1,:));
        plot([Levent.mean Levent.mean],[-180 180],'Linestyle','-','Linewidth',2,'Color',colorL(1,:)); %IHS
    end
    
    % EMG %
    %----------------------------------------------------------------------
    if ~isempty(Condition(icondition).Trial(itrial).LowerLimb.EMG)
        
        % Title & page settings
        axesText = axes;
        set(axesText,'Position',[0.47 0 1 1]);
        set(axesText,'Visible','Off');
        y = y - yincr*3;
        text(0.02,y/pageHeight,...
            '  EMG','Color','k','FontWeight','Bold','FontSize',14,'HorizontalAlignment','Center');
        x = [1.50 7.5 11.50 17.50];
        y = y - yincr*5;
        y1=y;

        names = fieldnames(Condition(icondition).Trial(itrial).LowerLimb.EMG);
        n=0;ngraphR=0;ngraphL=0;
        
        emg_raw = nan(90000,6); % 1min maximum as EMG recording (1500Hz * 60s)
        emg_filt = nan(101,6); % normalized data
        emg_name = [];
        for j = 1:length(names)/3
            % Get recorded EMG 
            if ~isempty(strfind(names{3*j-2},'tibialis_anterior_Raw')) | ~isempty(strfind(names{3*j-2},'soleus_Raw')) | ~isempty(strfind(names{3*j-2},'gastrocnemius_medialis_Raw'))
                if ~isempty(strfind(names{3*j-2},'R_'))
                    ngraphR=ngraphR+1;
                elseif ~isempty(strfind(names{3*j-2},'L_'))
                    ngraphL=ngraphL+1;
                end
                k1 = ngraphR+ngraphL;
                emg_raw(1:size(Condition(icondition).Trial(itrial).LowerLimb.EMG.(names{3*j-2}),1),k1) = ...
                        Condition(icondition).Trial(itrial).LowerLimb.EMG.(names{3*j-2});
                emg_name{k1} = regexprep(names{3*j-2},'_Raw','');
                emg_filt.mean(1:size(Condition(icondition).Average.LowerLimb.EMG.(names{3*j}).mean,1),k1) = ...
                        Condition(icondition).Average.LowerLimb.EMG.(names{3*j}).mean;
                emg_filt.std(1:size(Condition(icondition).Average.LowerLimb.EMG.(names{3*j}).mean,1),k1) = ...
                        Condition(icondition).Average.LowerLimb.EMG.(names{3*j}).std;
            end
        end
        
        % Plot Raw EMG
        xi=[];yi=[];ci=[];
        if ngraphR==0 | ngraphL==0
            xi = [x(1) x(3) x(3)];
            yi = [y1 y1 y1-yincr*5];
            if ngraphR>0
                ci = [0 0.8 0;0 0.8 0;0 0.8 0];
            elseif ngraphL>1
                ci = [0.8 0 0;0.8 0 0;0.8 0 0;];
            end
        else
            for i=1:k1
                if ~isempty(strfind(emg_name{i},'L_'))
                    xi = [xi x(1)];
                    ci= [ci;0.8 0 0];
                else
                    xi = [xi x(3)];
                    ci= [ci;0 0.8 0];
                end
                yi = [y1 y1-yincr*5 y1-yincr*10 y1 y1-yincr*5 y1-yincr*10];
            end
        end
        
        for i=1:k1
            igraph = igraph+1;
            y = yi(i);
            x1= xi(i);
            axesGraph = axes;
            set(axesGraph,'Position',[0 0 1 1]);
            set(axesGraph,'Visible','Off');
            Graph(igraph) = axes('position',[x1/pageWidth y/pageHeight ...
                graphWidth/pageWidth (graphHeight*2/3)/pageHeight]);
            set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
            hold on;
            ylabel('Ampl.(uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
            isize = size(find(~isnan(emg_raw(:,i))),1);
            plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
            plot(emg_raw(1:isize,i),'Linestyle','-','Linewidth',0.5,'Color',ci(i,:));
            title(regexprep(emg_name{i},'_',' '),'FontWeight','Bold'); 
            axis tight;
        end
         % Mise à même échelle de tous les graphes & events
        for i=1:k1
            axes(Graph(igraph-k1+i));
            YL = [-2e-4,2e-4];
            XL = xlim;
            XL(1) = max(XL(1),X_down);
            XL(2) = min(XL(2),X_up);
            axis([XL(1) XL(2) YL(1) YL(2)]);
            if ~isempty(strfind(emg_name{i},'L_'))
                plot([Condition(icondition).Trial(itrial).LowerLimb.Events.e.LHS(1)*Session(icondition).frq.fAnalog ...
                    Condition(icondition).Trial(itrial).LowerLimb.Events.e.LHS(1)*Session(icondition).frq.fAnalog],...
                    [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
                plot([Condition(icondition).Trial(itrial).LowerLimb.Events.e.LTO(end)*Session(icondition).frq.fAnalog ...
                    Condition(icondition).Trial(itrial).LowerLimb.Events.e.LTO(end)*Session(icondition).frq.fAnalog],...
                    [YL(1) YL(2)],'Linestyle','--','Linewidth',1,'Color','black');
                plot([Condition(icondition).Trial(itrial).LowerLimb.Events.e.LHS(2)*Session(icondition).frq.fAnalog ...
                    Condition(icondition).Trial(itrial).LowerLimb.Events.e.LHS(2)*Session(icondition).frq.fAnalog],...
                    [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
            elseif ~isempty(strfind(emg_name{i},'R_'))
                plot([Condition(icondition).Trial(itrial).LowerLimb.Events.e.RHS(1)*Session(icondition).frq.fAnalog ...
                    Condition(icondition).Trial(itrial).LowerLimb.Events.e.RHS(1)*Session(icondition).frq.fAnalog],...
                    [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
                plot([Condition(icondition).Trial(itrial).LowerLimb.Events.e.RTO(end)*Session(icondition).frq.fAnalog ...
                    Condition(icondition).Trial(itrial).LowerLimb.Events.e.RTO(end)*Session(icondition).frq.fAnalog],...
                    [YL(1) YL(2)],'Linestyle','--','Linewidth',1,'Color','black');
                plot([Condition(icondition).Trial(itrial).LowerLimb.Events.e.RHS(2)*Session(icondition).frq.fAnalog ...
                    Condition(icondition).Trial(itrial).LowerLimb.Events.e.RHS(2)*Session(icondition).frq.fAnalog],...
                    [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
            end
            box on;
        end
            
        % Plot ENVELOPPE
        if ngraphR==0 | ngraphL==0
            xi = [x(2) x(4) x(4)];
        else
            xi = [x(2) x(2) x(2) x(4) x(4) x(4)];
        end
        for i=1:k1
            igraph = igraph+1;
            y = yi(i);
            x1=xi(i);
            axesGraph = axes;
            set(axesGraph,'Position',[0 0 1 1]);
            set(axesGraph,'Visible','Off');
            Graph(igraph) = axes('position',[x1/pageWidth y/pageHeight ...
                graphWidth/2/pageWidth (graphHeight*2/3)/pageHeight]);
            hold on;
            xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
            ylabel('Ampl.(%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
            hold on;
            % Find & plot norm
            inorm = [];
            names = fieldnames(Norm.EMG);
            for j = 1:length(names)
                if ~isempty(strfind(names{j},emg_name{i}(3:end)))
                    inorm = Norm.EMG.(names{j});
                    plot(inorm.mean(1:101,1)/max(inorm.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',[0.5 0.5 0.5]);
                end
            end
            % plot enveloppe
            plot(emg_filt.mean(1:101,i)/max(emg_filt.mean(1:101,i)),'Linestyle','-','Linewidth',2,'Color',ci(i,:));
            set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0:50:100],'YTick',0:0.25:1,'YTickLabel',{'0' '25' '50' '75' '100'});
            axis tight;
            axis([0 100 0 1]);
            if ~isempty(strfind(emg_name{i},'L_'))
                corridor(Levent.mean,Levent.std,ci(i,:));
                plot([Levent.mean Levent.mean],[0 100],'Linestyle','-','Linewidth',2,'Color',ci(i,:)); %IHS
            elseif ~isempty(strfind(emg_name{i},'R_'))
                corridor(Revent.mean,Revent.std,ci(i,:));
                plot([Revent.mean Revent.mean],[0 100],'Linestyle','-','Linewidth',2,'Color',ci(i,:)); %IHS
            end
            box on;
        end
    end
    
    a=annotation('textbox',[0.015 0.015 0.970 (y-4*yincr)/pageHeight],'FontSize',14,'HorizontalAlignment','center','String','Test',...
        'FontName','Helvetica','FontWeight','bold','Color',[0 0 0],'BackgroundColor','none','EdgeColor',[0 0 0],...
        'LineStyle','-','LineWidth',0.5000,'Units','normalized');

end