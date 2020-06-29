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

% EMG %
%------
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
% Case 2: More than 1 condition: page 1 = right, page 2 = left
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
    cd(pluginFolder);
    banner = imread('banner','jpeg');
    axesImage = axes('position',...
        [0 0.89 1 0.12]);
    image(banner);
    set(axesImage,'Visible','Off');
    
    % Header
    % ---------------------------------------------------------------------
    axesText = axes;
    set(axesText,'Position',[0.47 0 1 1]);
    set(axesText,'Visible','Off');
    y = yinit;
    y = y - 0.8;
    text(0.5/pageWidth,y/pageHeight,...
        'CNRFR - Rehazenter',...
        'Color','w','FontSize',12);
    y = y - yincr;
    text(0.5/pageWidth,y/pageHeight,...
        'Laboratoire d''Analyse du Mouvement et de la Posture',...
        'Color','w','FontSize',11);
    
    % Patient
    % ---------------------------------------------------------------------
    y = y - yincr*4;
    axesLegend = axes;
    set(axesLegend,'Position',[0 0 1 1]);
    set(axesLegend,'Visible','Off');
    text(0.05,y/pageHeight,'Patient : ','FontWeight','Bold','Color','black');
    text(0.25,y/pageHeight,[Patient(1).lastname,' ',Patient(1).firstname],'Color','black');
    y = y - yincr;
    text(0.05,y/pageHeight,'Date de naissance : ','FontWeight','Bold','Color','black');
    text(0.25,y/pageHeight,[Patient(1).birthdate],'Color','black');
    
    % Legend
    % ---------------------------------------------------------------------
    y = y - yincr;
    for i = 1:size(Condition,2)
        % Count the number of trials
        nbtrials = 0;
        for j = 1:length(Condition(i).Trial);
            if ~isempty(Condition(i).Trial(j).LowerLimb.Segmentkinematics.R_Pelvis_Angle_AA)
                nbtrials = nbtrials+1;
            end
        end
        % Write the legend
        text(0.05,y/pageHeight,['Condition ',num2str(i)],'Color',colorB(i,:),'FontWeight','Bold');
        text(0.25,y/pageHeight,'Droite','Color',colorR(i,:));
        text(0.30,y/pageHeight,'Gauche','Color',colorL(i,:));
        text(0.37,y/pageHeight,'Norm','Color',[0.5 0.5 0.5]);
        text(0.44,y/pageHeight,[char(Session(i).date),...
            '     Nb essais : ',num2str(nbtrials),...
            '     Condition : ',char(regexprep(Condition(i).name,'_','-')),' (cf page 1)'],'color','k');
        y = y - yincr*1.0;
    end
    
    % Title
    % ---------------------------------------------------------------------
    axesText = axes;
    set(axesText,'Position',[0.47 0 1 1]);
    set(axesText,'Visible','Off');
    y = y - yincr;
    text(0.02,y/pageHeight,...
        '  Cinématique',...
        'Color','k','FontWeight','Bold','FontSize',14,...
        'HorizontalAlignment','Center');
    
    % Right/Left ankle flexion/extension
    % ---------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Ankle flexion/extension (Dorsi+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinematics.FE2.mean,Norm.Kinematics.FE2.std,[0.5 0.5 0.5]);
    if ~isempty(Jkinematics(i).R_Ankle_Angle_FE.mean)
        corridor(Jkinematics(i).R_Ankle_Angle_FE.mean,Jkinematics(i).R_Ankle_Angle_FE.std,colorR(i,:));
        plot(Jkinematics(i).R_Ankle_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Jkinematics(i).L_Ankle_Angle_FE.mean)
        corridor(Jkinematics(i).L_Ankle_Angle_FE.mean,Jkinematics(i).L_Ankle_Angle_FE.std,colorL(i,:));
        plot(Jkinematics(i).L_Ankle_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
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
    if ~isempty(Jkinematics(i).R_Ankle_Angle_IER.mean)
        corridor(Jkinematics(i).R_Ankle_Angle_IER.mean,Jkinematics(i).R_Ankle_Angle_IER.std,colorR(i,:));
        plot(Jkinematics(i).R_Ankle_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Jkinematics(i).L_Ankle_Angle_IER.mean)
        corridor(Jkinematics(i).L_Ankle_Angle_IER.mean,Jkinematics(i).L_Ankle_Angle_IER.std,colorL(i,:));
        plot(Jkinematics(i).L_Ankle_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
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
    if ~isempty(Skinematics(i).R_Foot_Angle_FE.mean)
        corridor(Skinematics(i).R_Foot_Angle_FE.mean,Skinematics(i).R_Foot_Angle_FE.std,colorR(i,:));
        plot(Skinematics(i).R_Foot_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Skinematics(i).L_Foot_Angle_FE.mean)
        corridor(Skinematics(i).L_Foot_Angle_FE.mean,Skinematics(i).L_Foot_Angle_FE.std,colorL(i,:));
        plot(Skinematics(i).L_Foot_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
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
    if ~isempty(Skinematics(i).R_Foot_Angle_AA.mean)
        corridor(-Skinematics(i).R_Foot_Angle_AA.mean,Skinematics(i).R_Foot_Angle_AA.std,colorR(i,:));
        plot(-Skinematics(i).R_Foot_Angle_AA.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Skinematics(i).L_Foot_Angle_AA.mean)
        corridor(-Skinematics(i).L_Foot_Angle_AA.mean,Skinematics(i).L_Foot_Angle_AA.std,colorL(i,:));
        plot(-Skinematics(i).L_Foot_Angle_AA.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
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
    if ~isempty(Skinematics(i).R_Foot_Angle_IER.mean)
        corridor(-Skinematics(i).R_Foot_Angle_IER.mean,Skinematics(i).R_Foot_Angle_IER.std,colorR(i,:));
        plot(-Skinematics(i).R_Foot_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Skinematics(i).L_Foot_Angle_IER.mean)
        corridor(-Skinematics(i).L_Foot_Angle_IER.mean,Skinematics(i).L_Foot_Angle_IER.std,colorL(i,:));
        plot(-Skinematics(i).L_Foot_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Title
    % ---------------------------------------------------------------------
    axesText = axes;
    set(axesText,'Position',[0.47 0 1 1]);
    set(axesText,'Visible','Off');
    y = y - yincr*3;
    text(0.02,y/pageHeight,'  Cinétique','Color','k','FontWeight','Bold','FontSize',14,'HorizontalAlignment','Center');
    
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
    title('Ankle flexion/extension moment (Dorsi+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Moment (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinetics.FE2.mean,Norm.Kinetics.FE2.std,[0.5 0.5 0.5]);
    if ~isempty(Dynamics(i).R_Ankle_Moment_FE.mean)
        corridor(Dynamics(i).R_Ankle_Moment_FE.mean,Dynamics(i).R_Ankle_Moment_FE.std,colorR(i,:));
        plot(Dynamics(i).R_Ankle_Moment_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Dynamics(i).L_Ankle_Moment_FE.mean)
        corridor(Dynamics(i).L_Ankle_Moment_FE.mean,Dynamics(i).L_Ankle_Moment_FE.std,colorL(i,:));
        plot(Dynamics(i).L_Ankle_Moment_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
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
    title('Ankle flexion/extension power (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Power (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinetics.Power2.mean,Norm.Kinetics.Power2.std,[0.5 0.5 0.5]);
    if ~isempty(Dynamics(i).R_Ankle_Power_FE.mean)
        corridor(Dynamics(i).R_Ankle_Power_FE.mean,Dynamics(i).R_Ankle_Power_FE.std,colorR(i,:));
        plot(Dynamics(i).R_Ankle_Power_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Dynamics(i).L_Ankle_Power_FE.mean)
        corridor(Dynamics(i).L_Ankle_Power_FE.mean,Dynamics(i).L_Ankle_Power_FE.std,colorL(i,:));
        plot(Dynamics(i).L_Ankle_Power_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.2,1.2);
    axis([0 100 -1 1]);
%     axis([0 100 YL(1) YL(2)]);
    box on;
%     igraph = igraph+1;
    
    % Events
    % ---------------------------------------------------------------------
    for g = 1:length(Graph)
        axes(Graph(g));
        YL = ylim;
        corridor(Norm.Event.p5.mean,Norm.Event.p5.std,[0.5 0.5 0.5]);
        corridor(Revent(i).mean,Revent(i).std,colorR(i,:));
        plot([Revent(i).mean Revent(i).mean],[-180 180],'Linestyle','-','Linewidth',2,'Color',colorR(i,:)); %IHS
        corridor(Levent(i).mean,Levent(i).std,colorL(i,:));
        plot([Levent(i).mean Levent(i).mean],[-180 180],'Linestyle','-','Linewidth',2,'Color',colorL(i,:)); %IHS
    end
    
    % Title
    % ---------------------------------------------------------------------
    axesText = axes;
    set(axesText,'Position',[0.47 0 1 1]);
    set(axesText,'Visible','Off');
    y = y - yincr*3;
    text(0.02,y/pageHeight,...
        '  EMG','Color','k','FontWeight','Bold','FontSize',14,'HorizontalAlignment','Center');
    
    % EMG %
    %------
    x = [1.50 7.5 11.50 17.50];
    y = y - yincr*5;
    y1=y;
    if ~isempty(Condition(icondition).Trial(itrial).LowerLimb.EMG)
        % Get recorded EMG for right side
        % ---------------------------------------------------------------------
        Remg_raw = nan(90000,8); % 1min maximum as EMG recording (1500Hz * 60s)
        Remg_filt = nan(101,8); % normalized data
        Remg_name = [];
        names = fieldnames(Condition(icondition).Trial(itrial).LowerLimb.EMG);
        k1 = 1;
        k2 = 1;
        for j = 1:length(names)
            if ~isempty(strfind(names{j},'R_tibialis_anterior_Raw')) | ~isempty(strfind(names{j},'R_soleus_Raw')) | ~isempty(strfind(names{j},'R_gastrocnemius_medialis_Raw'))
                Remg_raw(1:size(Condition(icondition).Trial(itrial).LowerLimb.EMG.(names{j}),1),k1) = ...
                    Condition(icondition).Trial(itrial).LowerLimb.EMG.(names{j});
                Remg_name{k1} = regexprep(names{j},'_Raw','');
                k1 = k1+1;
            end
            if ~isempty(strfind(names{j},'R_tibialis_anterior_Envelop')) | ~isempty(strfind(names{j},'R_soleus_Envelop')) | ~isempty(strfind(names{j},'R_gastrocnemius_medialis_Envelop'))
                Remg_filt.mean(1:size(Condition(icondition).Average.LowerLimb.EMG.(names{j}).mean,1),k2) = ...
                    Condition(icondition).Average.LowerLimb.EMG.(names{j}).mean;
                Remg_filt.std(1:size(Condition(icondition).Average.LowerLimb.EMG.(names{j}).mean,1),k2) = ...
                    Condition(icondition).Average.LowerLimb.EMG.(names{j}).std;
                k2 = k2+1;
            end
        end
    
        igraph = igraph+1;
        isize = size(find(~isnan(Remg_raw(:,1))),1);
        y = y1;
        x1=x(1);
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x1/pageWidth y/pageHeight ...
            graphWidth/pageWidth (graphHeight*2/3)/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
        hold on;
        title(regexprep(regexprep(Remg_name{1},'left_',''),'_',' '),'FontWeight','Bold');
        ylabel('Ampl.(uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        plot(Remg_raw(1:isize,1),'Linestyle','-','Linewidth',0.5,'Color',colorR(1,:));
        axis tight;
         for j=1:2
            igraph = igraph+1;
            isize = size(find(~isnan(Remg_raw(:,1))),1);
            y = y1 - yincr*(j-1)*5;
            x1=x(3);
            axesGraph = axes;
            set(axesGraph,'Position',[0 0 1 1]);
            set(axesGraph,'Visible','Off');
            Graph(igraph) = axes('position',[x1/pageWidth y/pageHeight ...
                graphWidth/pageWidth (graphHeight*2/3)/pageHeight]);
            set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
            hold on;
            title(regexprep(regexprep(Remg_name{j+1},'left_',''),'_',' '),'FontWeight','Bold');
            ylabel('Ampl.(uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
            plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
            plot(Remg_raw(1:isize,1),'Linestyle','-','Linewidth',0.5,'Color',colorR(1,:));
            axis tight;
        end
    % ENVELOPPE
        igraph = igraph+1;
        y = y1;
        x1=x(2);
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x1/pageWidth y/pageHeight ...
            graphWidth/2/pageWidth (graphHeight*2/3)/pageHeight]);
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        ylabel('Ampl.(%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        hold on;
            % Find norm
%             inorm = [];
%             names = fieldnames(Norm.EMG);
%             for i = 1:length(names)
%                 if strfind(regexprep(names{i},'right_',''),regexprep(Remg_name{g},'right_',''))
%                     inorm = Norm.EMG.(names{i});
%                 end
%             end
%             % Plot
%             if ~isempty(inorm)
%                 plot(inorm.mean(1:101,1)/max(inorm.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',[0.5 0.5 0.5]);
%             end
        plot(Remg_filt.mean(1:101,j)/max(Remg_filt.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',colorR(1,:));
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0:50:100],'YTick',0:0.25:1,'YTickLabel',{'0' '25' '50' '75' '100'});
        axis tight;
        axis([0 100 0 1]);
        plot([Condition(icondition).Trial(itrial).LowerLimb.Spatiotemporal.R_Stance_Phase ...
            Condition(icondition).Trial(itrial).LowerLimb.Spatiotemporal.R_Stance_Phase],...
            [0 1],'Linestyle','--','Linewidth',1,'Color','black');
        box on;
        for j=1:2
            igraph = igraph+1;
            y = y1 - yincr*(j-1)*5;
            x1=x(4);
            axesGraph = axes;
            set(axesGraph,'Position',[0 0 1 1]);
            set(axesGraph,'Visible','Off');
            Graph(igraph) = axes('position',[x1/pageWidth y/pageHeight ...
                graphWidth/2/pageWidth (graphHeight*2/3)/pageHeight]);
            xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
            ylabel('Ampl.(%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
            hold on;
            % Find norm
%             inorm = [];
%             names = fieldnames(Norm.EMG);
%             for i = 1:length(names)
%                 if strfind(regexprep(names{i},'right_',''),regexprep(Remg_name{g},'right_',''))
%                     inorm = Norm.EMG.(names{i});
%                 end
%             end
%             % Plot
%             if ~isempty(inorm)
%                 plot(inorm.mean(1:101,1)/max(inorm.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',[0.5 0.5 0.5]);
%             end
            plot(Remg_filt.mean(1:101,j)/max(Remg_filt.mean(1:101,j+1)),'Linestyle','-','Linewidth',2,'Color',colorR(1,:));
            set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0:50:100],'YTick',0:0.25:1,'YTickLabel',{'0' '25' '50' '75' '100'});
            axis tight;
            axis([0 100 0 1]);
            plot([Condition(icondition).Trial(itrial).LowerLimb.Spatiotemporal.R_Stance_Phase ...
                Condition(icondition).Trial(itrial).LowerLimb.Spatiotemporal.R_Stance_Phase],...
                [0 1],'Linestyle','--','Linewidth',1,'Color','black');
            box on;
        end
    
    % Mise à échelle de tous les graphes
        for j=igraph-5:igraph-3
            axes(Graph(j));
            YL = [-2e-4,2e-4];
            XL = xlim;
            XL(1) = max(XL(1),X_down);
            XL(2) = min(XL(2),X_up);
            axis([XL(1) XL(2) YL(1) YL(2)]);
            plot([Condition(icondition).Trial(itrial).LowerLimb.Events.e.RHS(1)*Session(icondition).frq.fAnalog ...
                Condition(icondition).Trial(itrial).LowerLimb.Events.e.RHS(1)*Session(icondition).frq.fAnalog],...
                [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
            plot([Condition(icondition).Trial(itrial).LowerLimb.Events.e.RTO(end)*Session(icondition).frq.fAnalog ...
                Condition(icondition).Trial(itrial).LowerLimb.Events.e.RTO(end)*Session(icondition).frq.fAnalog],...
                [YL(1) YL(2)],'Linestyle','--','Linewidth',1,'Color','black');
            plot([Condition(icondition).Trial(itrial).LowerLimb.Events.e.RHS(2)*Session(icondition).frq.fAnalog ...
                Condition(icondition).Trial(itrial).LowerLimb.Events.e.RHS(2)*Session(icondition).frq.fAnalog],...
                [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
            box on;
        end
    end
end