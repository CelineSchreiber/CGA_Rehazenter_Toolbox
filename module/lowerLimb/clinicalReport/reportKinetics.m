% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN CLINICAL REPORT
% =========================================================================
% File name:    reportKinetics
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

function f = reportKinetics(Patient,Session,Condition,pluginFolder,normFolder,norm)

% =========================================================================
% Initialisation
% =========================================================================
pageWidth = 21; % cm
pageHeight = 29.7; % cm
graphWidth = 5.0; % cm
graphHeight = 2.3; % cm
yinit = 29.0; % cm
yincr = 0.5; % cm
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
cd(pluginFolder);
for i = 1:size(Condition,2)
    Jkinematics(i) = Condition(i).Average.LowerLimb.Jointkinematics;
    Dynamics(i) = Condition(i).Average.LowerLimb.Dynamics;
    Revent(i) = Condition(i).Average.LowerLimb.Spatiotemporal.R_Stance_Phase;
    Levent(i) = Condition(i).Average.LowerLimb.Spatiotemporal.L_Stance_Phase;
end

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
    
    % Title
    % ---------------------------------------------------------------------
    y = y - yincr*5;
    text(0.02,y/pageHeight,...
        '  Cinétique',...
        'Color','k','FontWeight','Bold','FontSize',18,...
        'HorizontalAlignment','Center');
    y = y - yincr*2;
    text(0.02,y/pageHeight,...
        '  Côté droit VS côté gauche',...
        'Color','k','FontSize',16,...
        'HorizontalAlignment','Center');
    yinit = y;
    
    % Patient
    % ---------------------------------------------------------------------
    y = y - yincr*3;
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
    axesLegend = axes;
    set(axesLegend,'Position',[0 0 1 1]);
    set(axesLegend,'Visible','Off');
    % Count the number of trials
    nbtrialsR = 0;nbtrialsL = 0;
    for j = 1:length(Condition.Trial);
        if ~isempty(Condition.Trial(j).LowerLimb.Dynamics.R_Ankle_Moment_FE)
            nbtrialsR = nbtrialsR+1;
        end
        if ~isempty(Condition.Trial(j).LowerLimb.Dynamics.L_Ankle_Moment_FE)
            nbtrialsL = nbtrialsL+1;
        end
    end
    % Write the legend
    text(0.05,y/pageHeight,'Condition ','Color',colorB(1,:),'FontWeight','Bold');
    text(0.25,y/pageHeight,'Droite','Color',colorR(1,:));
    text(0.30,y/pageHeight,'Gauche','Color',colorL(1,:));
    text(0.37,y/pageHeight,'Norm','Color',[0.5 0.5 0.5]);
    text(0.44,y/pageHeight,[char(Session.date),...
        '     Nb essais : '],'color','k');
    text(0.63,y/pageHeight,num2str(nbtrialsR),'Color',colorR(1,:));
    text(0.65,y/pageHeight,num2str(nbtrialsL),'Color',colorL(1,:));            
    text(0.68,y/pageHeight,['  Condition : ',char(regexprep(Condition.name,'_','-')),' (cf page 1)'],'color','k');
    y = y - yincr*1.0;
    
    % Right/Left hip flexion/extension
    % ---------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Hip flexion/extension (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinematics.FE4.mean,Norm.Kinematics.FE4.std,[0.5 0.5 0.5]); 
    if ~isempty(Jkinematics(i).R_Hip_Angle_FE.mean)
        corridor(Jkinematics(i).R_Hip_Angle_FE.mean,Jkinematics(i).R_Hip_Angle_FE.std,colorR(i,:));
        plot(Jkinematics(i).R_Hip_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Jkinematics(i).L_Hip_Angle_FE.mean)
        corridor(Jkinematics(i).L_Hip_Angle_FE.mean,Jkinematics(i).L_Hip_Angle_FE.std,colorL(i,:));
        plot(Jkinematics(i).L_Hip_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right/Left knee flexion/extension
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Knee flexion/extension (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(-Norm.Kinematics.FE3.mean,Norm.Kinematics.FE3.std,[0.5 0.5 0.5]); 
    if ~isempty(Jkinematics(i).R_Knee_Angle_FE.mean)
        corridor(Jkinematics(i).R_Knee_Angle_FE.mean,Jkinematics(i).R_Knee_Angle_FE.std,colorR(i,:));
        plot(Jkinematics(i).R_Knee_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Jkinematics(i).L_Knee_Angle_FE.mean)
        corridor(Jkinematics(i).L_Knee_Angle_FE.mean,Jkinematics(i).L_Knee_Angle_FE.std,colorL(i,:));
        plot(Jkinematics(i).L_Knee_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right/Left ankle flexion/extension
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
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
    
    % Right/Left hip flexion/extension moment
    % ---------------------------------------------------------------------
    y = y - yincr*7.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.05:10);
    hold on;
    title('Hip flexion/extension moment (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Moment (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinetics.FE4.mean,Norm.Kinetics.FE4.std,[0.5 0.5 0.5]);
    if ~isempty(Dynamics(i).R_Hip_Moment_FE.mean)
        corridor(Dynamics(i).R_Hip_Moment_FE.mean,Dynamics(i).R_Hip_Moment_FE.std,colorR(i,:));
        plot(Dynamics(i).R_Hip_Moment_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Dynamics(i).L_Hip_Moment_FE.mean)
        corridor(Dynamics(i).L_Hip_Moment_FE.mean,Dynamics(i).L_Hip_Moment_FE.std,colorL(i,:));
        plot(Dynamics(i).L_Hip_Moment_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.10,0.15);
    axis([0 100 -.2 .2]);
%     axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right/Left knee flexion/extension moment
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.05:10);
    hold on;
    title('Knee flexion/extension moment (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Moment (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(-Norm.Kinetics.FE3.mean,Norm.Kinetics.FE3.std,[0.5 0.5 0.5]);
    if ~isempty(Dynamics(i).R_Knee_Moment_FE.mean)
        corridor(Dynamics(i).R_Knee_Moment_FE.mean,Dynamics(i).R_Knee_Moment_FE.std,colorR(i,:));
        plot(Dynamics(i).R_Knee_Moment_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Dynamics(i).L_Knee_Moment_FE.mean)
        corridor(Dynamics(i).L_Knee_Moment_FE.mean,Dynamics(i).L_Knee_Moment_FE.std,colorL(i,:));
        plot(Dynamics(i).L_Knee_Moment_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.15,0.10);
    axis([0 100 -.2 .2]);
%     axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right/Left ankle flexion/extension moment
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
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
    
    % Right/Left hip flexion/extension power
    % ---------------------------------------------------------------------
    y = y - yincr*7.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.2:10);
    hold on;
    title('Hip flexion/extension power (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Power (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinetics.Power4.mean,Norm.Kinetics.Power4.std,[0.5 0.5 0.5]);
    if ~isempty(Dynamics(i).R_Hip_Power_FE.mean)
        corridor(Dynamics(i).R_Hip_Power_FE.mean,Dynamics(i).R_Hip_Power_FE.std,colorR(i,:));
        plot(Dynamics(i).R_Hip_Power_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Dynamics(i).L_Hip_Power_FE.mean)
        corridor(Dynamics(i).L_Hip_Power_FE.mean,Dynamics(i).L_Hip_Power_FE.std,colorL(i,:));
        plot(Dynamics(i).L_Hip_Power_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.3,0.3);
    axis([0 100 -1 1]);
%     axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right/Left knee flexion/extension power
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.2:10);
    hold on;
    title('Knee flexion/extension power (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Power (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinetics.Power3.mean,Norm.Kinetics.Power3.std,[0.5 0.5 0.5]);
    if ~isempty(Dynamics(i).R_Knee_Power_FE.mean)
        corridor(Dynamics(i).R_Knee_Power_FE.mean,Dynamics(i).R_Knee_Power_FE.std,colorR(i,:));
        plot(Dynamics(i).R_Knee_Power_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Dynamics(i).L_Knee_Power_FE.mean)
        corridor(Dynamics(i).L_Knee_Power_FE.mean,Dynamics(i).L_Knee_Power_FE.std,colorL(i,:));
        plot(Dynamics(i).L_Knee_Power_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.3,0.3);
    axis([0 100 -1 1]);
%     axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right/Left ankle flexion/extension power
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
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
    igraph = igraph+1;
    
    % Right/Left ground reaction force (vertical)
    % ---------------------------------------------------------------------
    y = y - yincr*7.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.4:10);
    hold on;
    title('Vertical ground reaction force (Up+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Force (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(-Norm.Kinetics.PD1.mean,Norm.Kinetics.PD1.std,[0.5 0.5 0.5]);
    if ~isempty(Dynamics(i).R_GRF_Y.mean)
        corridor(-Dynamics(i).R_GRF_Y.mean,Dynamics(i).R_GRF_Y.std,colorR(i,:));
        plot(-Dynamics(i).R_GRF_Y.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Dynamics(i).L_GRF_Y.mean)
        corridor(-Dynamics(i).L_GRF_Y.mean,Dynamics(i).L_GRF_Y.std,colorL(i,:));
        plot(-Dynamics(i).L_GRF_Y.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,0,1.2);
    axis([0 100 YL(1) YL(2)]);    
    box on;
    igraph = igraph+1;
    
    % Right/Left ground reaction force (anterior/posterior)
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.1:10);
    hold on;
    title('Ant/post ground reaction force (Ant+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Force (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(-Norm.Kinetics.AP1.mean,Norm.Kinetics.AP1.std,[0.5 0.5 0.5]);
    if ~isempty(Dynamics(i).R_GRF_X.mean)
        corridor(-Dynamics(i).R_GRF_X.mean,Dynamics(i).R_GRF_X.std,colorR(i,:));
        plot(-Dynamics(i).R_GRF_X.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Dynamics(i).L_GRF_X.mean)
        corridor(-Dynamics(i).L_GRF_X.mean,Dynamics(i).L_GRF_X.std,colorL(i,:));
        plot(-Dynamics(i).L_GRF_X.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.3,0.3);
    axis([0 100 YL(1) YL(2)]);   
    box on;
    igraph = igraph+1;
    
    % Right/Left ground reaction force (lateral/medial)
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.05:10);
    hold on;
    title('Lat/med ground reaction force (Lat+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Force (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinetics.LM1.mean,Norm.Kinetics.LM1.std,[0.5 0.5 0.5]);  % Relaunch norm and correct sign here
    if ~isempty(Dynamics(i).R_GRF_Z.mean)
        corridor(Dynamics(i).R_GRF_Z.mean,Dynamics(i).R_GRF_Z.std,colorR(i,:));
        plot(Dynamics(i).R_GRF_Z.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Dynamics(i).L_GRF_Z.mean)
        corridor(-Dynamics(i).L_GRF_Z.mean,Dynamics(i).L_GRF_Z.std,colorL(i,:));
        plot(-Dynamics(i).L_GRF_Z.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.1,0.1);
    axis([0 100 YL(1) YL(2)]);   
    box on;
    igraph = igraph+1;
    
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
    
else
    
    % Set the right side page
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
        'Color','w','FontSize',12);
    
    % Title
    % ---------------------------------------------------------------------
    y = y - yincr*5;
    text(0.02,y/pageHeight,...
        '  Cinétique',...
        'Color','k','FontWeight','Bold','FontSize',18,...
        'HorizontalAlignment','Center');
    y = y - yincr*2;
    text(0.02,y/pageHeight,...
        '  Côté droit',...
        'Color','k','FontSize',16,...
        'HorizontalAlignment','Center');
    yinit = y;
    
    % Patient
    % ---------------------------------------------------------------------
    y = y - yincr*3;
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
        axesLegend = axes;
        set(axesLegend,'Position',[0 0 1 1]);
        set(axesLegend,'Visible','Off');
        % Count the number of trials
        nbtrialsR = 0;
        for j = 1:length(Condition(i).Trial);
            if ~isempty(Condition(i).Trial(j).LowerLimb.Dynamics.R_Ankle_Moment_FE)
                nbtrialsR = nbtrialsR+1;
            end
        end
        % Write the legend
        text(0.05,y/pageHeight,['Condition ',num2str(i)],'Color',colorB(i,:),'FontWeight','Bold');
        text(0.25,y/pageHeight,'Droite','Color',colorR(i,:));
        text(0.37,y/pageHeight,'Norm','Color',[0.5 0.5 0.5]);
        text(0.44,y/pageHeight,[char(Session(i).date),...
            '     Nb essais : '],'color','k');
        text(0.63,y/pageHeight,num2str(nbtrialsR),'Color',colorR(i,:));
        text(0.68,y/pageHeight,['  Condition : ',char(regexprep(Condition(i).name,'_','-')),' (cf page 1)'],'color','k');
        y = y - yincr*1.0;
    end
    
    % Right hip flexion/extension
    % ---------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Hip flexion/extension (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinematics.FE4.mean,Norm.Kinematics.FE4.std,[0.5 0.5 0.5]); 
    for i = 1:size(Condition,2)
        if ~isempty(Jkinematics(i).R_Hip_Angle_FE.mean)
            corridor(Jkinematics(i).R_Hip_Angle_FE.mean,Jkinematics(i).R_Hip_Angle_FE.std,colorR(i,:));
            plot(Jkinematics(i).R_Hip_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right knee flexion/extension
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Knee flexion/extension (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(-Norm.Kinematics.FE3.mean,Norm.Kinematics.FE3.std,[0.5 0.5 0.5]); 
    for i = 1:size(Condition,2)
        if ~isempty(Jkinematics(i).R_Knee_Angle_FE.mean)
            corridor(Jkinematics(i).R_Knee_Angle_FE.mean,Jkinematics(i).R_Knee_Angle_FE.std,colorR(i,:));
            plot(Jkinematics(i).R_Knee_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right ankle flexion/extension
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Ankle flexion/extension (Dorsi+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinematics.FE2.mean,Norm.Kinematics.FE2.std,[0.5 0.5 0.5]); 
    for i = 1:size(Condition,2)
        if ~isempty(Jkinematics(i).R_Ankle_Angle_FE.mean)
            corridor(Jkinematics(i).R_Ankle_Angle_FE.mean,Jkinematics(i).R_Ankle_Angle_FE.std,colorR(i,:));
            plot(Jkinematics(i).R_Ankle_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right hip flexion/extension moment
    % ---------------------------------------------------------------------
    y = y - yincr*7.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.05:10);
    hold on;
    title('Hip flexion/extension moment (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Moment (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinetics.FE4.mean,Norm.Kinetics.FE4.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Dynamics(i).R_Hip_Moment_FE.mean)
            corridor(Dynamics(i).R_Hip_Moment_FE.mean,Dynamics(i).R_Hip_Moment_FE.std,colorR(i,:));
            plot(Dynamics(i).R_Hip_Moment_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.05,0.20);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right knee flexion/extension moment
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.05:10);
    hold on;
    title('Knee flexion/extension moment (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Moment (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(-Norm.Kinetics.FE3.mean,Norm.Kinetics.FE3.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Dynamics(i).R_Knee_Moment_FE.mean)
            corridor(Dynamics(i).R_Knee_Moment_FE.mean,Dynamics(i).R_Knee_Moment_FE.std,colorR(i,:));
            plot(Dynamics(i).R_Knee_Moment_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.15,0.1);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right ankle flexion/extension moment
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.05:10);
    hold on;
    title('Ankle flexion/extension moment (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Moment (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinetics.FE2.mean,Norm.Kinetics.FE2.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Dynamics(i).R_Ankle_Moment_FE.mean)
            corridor(Dynamics(i).R_Ankle_Moment_FE.mean,Dynamics(i).R_Ankle_Moment_FE.std,colorR(i,:));
            plot(Dynamics(i).R_Ankle_Moment_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.20,0.05);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right hip flexion/extension power
    % ---------------------------------------------------------------------
    y = y - yincr*7.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.2:10);
    hold on;
    title('Hip flexion/extension power (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Power (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinetics.Power4.mean,Norm.Kinetics.Power4.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Dynamics(i).R_Hip_Power_FE.mean)
            corridor(Dynamics(i).R_Hip_Power_FE.mean,Dynamics(i).R_Hip_Power_FE.std,colorR(i,:));
            plot(Dynamics(i).R_Hip_Power_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.5,0.5);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right knee flexion/extension power
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.2:10);
    hold on;
    title('Knee flexion/extension power (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Power (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinetics.Power3.mean,Norm.Kinetics.Power3.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Dynamics(i).R_Knee_Power_FE.mean)
            corridor(Dynamics(i).R_Knee_Power_FE.mean,Dynamics(i).R_Knee_Power_FE.std,colorR(i,:));
            plot(Dynamics(i).R_Knee_Power_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.4,0.6);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right ankle flexion/extension power
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.2:10);
    hold on;
    title('Ankle flexion/extension power (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Power (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinetics.Power2.mean,Norm.Kinetics.Power2.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Dynamics(i).R_Ankle_Power_FE.mean)
            corridor(Dynamics(i).R_Ankle_Power_FE.mean,Dynamics(i).R_Ankle_Power_FE.std,colorR(i,:));
            plot(Dynamics(i).R_Ankle_Power_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.4,1);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right ground reaction force (vertical)
    % ---------------------------------------------------------------------
    y = y - yincr*7.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.4:10);
    hold on;
    title('Vertical ground reaction force (Up+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Force (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(-Norm.Kinetics.PD1.mean,Norm.Kinetics.PD1.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Dynamics(i).R_GRF_Y.mean)
            corridor(-Dynamics(i).R_GRF_Y.mean,Dynamics(i).R_GRF_Y.std,colorR(i,:));
            plot(-Dynamics(i).R_GRF_Y.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,0,1.4);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right ground reaction force (anterior/posterior)
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.1:10);
    hold on;
    title('Ant/post ground reaction force (Ant+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Force (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(-Norm.Kinetics.AP1.mean,Norm.Kinetics.AP1.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Dynamics(i).R_GRF_X.mean)
            corridor(-Dynamics(i).R_GRF_X.mean,Dynamics(i).R_GRF_X.std,colorR(i,:));
            plot(-Dynamics(i).R_GRF_X.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.3,0.3);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right ground reaction force (lateral/medial)
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.05:10);
    hold on;
    title('Lat/med ground reaction force (Lat+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Force (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinetics.LM1.mean,Norm.Kinetics.LM1.std,[0.5 0.5 0.5]); % Relaunch norm and correct sign here
    for i = 1:size(Condition,2)
        if ~isempty(Dynamics(i).R_GRF_Z.mean)
            corridor(Dynamics(i).R_GRF_Z.mean,Dynamics(i).R_GRF_Z.std,colorR(i,:));
            plot(Dynamics(i).R_GRF_Z.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.1,0.1);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Events
    % ---------------------------------------------------------------------
    for g = 1:length(Graph)
        axes(Graph(g));
        YL = ylim;
        corridor(Norm.Event.p5.mean,Norm.Event.p5.std,[0.5 0.5 0.5]);
        for i = 1:size(Condition,2)
            corridor(Revent(i).mean,Revent(i).std,colorR(i,:));
            plot([Revent(i).mean Revent(i).mean],[-180 180],'Linestyle','-','Linewidth',2,'Color',colorR(i,:)); %IHS
        end
    end
    
    % Set the left side page
    % ---------------------------------------------------------------------
    igraph = 1;
    yinit = 29.0; % cm    
    f(2) = figure('PaperOrientation','portrait','papertype','A4',...
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
        'Color','w','FontSize',12);
    
    % Title
    % ---------------------------------------------------------------------
    y = y - yincr*5;
    text(0.02,y/pageHeight,...
        '  Cinétique',...
        'Color','k','FontWeight','Bold','FontSize',18,...
        'HorizontalAlignment','Center');
    y = y - yincr*2;
    text(0.02,y/pageHeight,...
        '  Côté gauche',...
        'Color','k','FontSize',16,...
        'HorizontalAlignment','Center');
    yinit = y;
    
    % Patient
    % ---------------------------------------------------------------------
    y = y - yincr*3;
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
        axesLegend = axes;
        set(axesLegend,'Position',[0 0 1 1]);
        set(axesLegend,'Visible','Off');
        % Count the number of trials
        nbtrialsL = 0;
        for j = 1:length(Condition(i).Trial);
            if ~isempty(Condition(i).Trial(j).LowerLimb.Dynamics.R_Ankle_Moment_FE)
                nbtrialsL = nbtrialsL+1;
            end
        end
        % Write the legend
        text(0.05,y/pageHeight,['Condition ',num2str(i)],'Color',colorB(i,:),'FontWeight','Bold');
        text(0.30,y/pageHeight,'Gauche','Color',colorL(i,:));
        text(0.37,y/pageHeight,'Norm','Color',[0.5 0.5 0.5]);
        text(0.44,y/pageHeight,[char(Session(i).date),...
            '     Nb essais : '],'color','k');
        text(0.65,y/pageHeight,num2str(nbtrialsL),'Color',colorL(i,:));            
        text(0.68,y/pageHeight,['  Condition : ',char(regexprep(Condition(i).name,'_','-')),' (cf page 1)'],'color','k');
        y = y - yincr*1.0;
    end
    
    % Left hip flexion/extension
    % ---------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Hip flexion/extension (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinematics.FE4.mean,Norm.Kinematics.FE4.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Jkinematics(i).L_Hip_Angle_FE.mean)
            corridor(Jkinematics(i).L_Hip_Angle_FE.mean,Jkinematics(i).L_Hip_Angle_FE.std,colorL(i,:));
            plot(Jkinematics(i).L_Hip_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Left knee flexion/extension
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Knee flexion/extension (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(-Norm.Kinematics.FE3.mean,Norm.Kinematics.FE3.std,[0.5 0.5 0.5]); 
    for i = 1:size(Condition,2)
        if ~isempty(Jkinematics(i).L_Knee_Angle_FE.mean)
            corridor(Jkinematics(i).L_Knee_Angle_FE.mean,Jkinematics(i).L_Knee_Angle_FE.std,colorL(i,:));
            plot(Jkinematics(i).L_Knee_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Left ankle flexion/extension
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Ankle flexion/extension (Dorsi+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinematics.FE2.mean,Norm.Kinematics.FE2.std,[0.5 0.5 0.5]); 
    for i = 1:size(Condition,2)
        if ~isempty(Jkinematics(i).L_Ankle_Angle_FE.mean)
            corridor(Jkinematics(i).L_Ankle_Angle_FE.mean,Jkinematics(i).L_Ankle_Angle_FE.std,colorL(i,:));
            plot(Jkinematics(i).L_Ankle_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Left hip flexion/extension moment
    % ---------------------------------------------------------------------
    y = y - yincr*7.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.05:10);
    hold on;
    title('Hip flexion/extension moment (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Moment (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinetics.FE4.mean,Norm.Kinetics.FE4.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Dynamics(i).L_Hip_Moment_FE.mean)
            corridor(Dynamics(i).L_Hip_Moment_FE.mean,Dynamics(i).L_Hip_Moment_FE.std,colorL(i,:));
            plot(Dynamics(i).L_Hip_Moment_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.1,0.15);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Left knee flexion/extension moment
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.05:10);
    hold on;
    title('Knee flexion/extension moment (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Moment (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(-Norm.Kinetics.FE3.mean,Norm.Kinetics.FE3.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Dynamics(i).L_Knee_Moment_FE.mean)
            corridor(Dynamics(i).L_Knee_Moment_FE.mean,Dynamics(i).L_Knee_Moment_FE.std,colorL(i,:));
            plot(Dynamics(i).L_Knee_Moment_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.15,0.1);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Left ankle flexion/extension moment
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.05:10);
    hold on;
    title('Ankle flexion/extension moment (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Moment (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinetics.FE2.mean,Norm.Kinetics.FE2.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Dynamics(i).L_Ankle_Moment_FE.mean)
            corridor(Dynamics(i).L_Ankle_Moment_FE.mean,Dynamics(i).L_Ankle_Moment_FE.std,colorL(i,:));
            plot(Dynamics(i).L_Ankle_Moment_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.2,0.05);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Left hip flexion/extension power
    % ---------------------------------------------------------------------
    y = y - yincr*7.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.2:10);
    hold on;
    title('Hip flexion/extension power (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Power (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinetics.Power4.mean,Norm.Kinetics.Power4.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Dynamics(i).L_Hip_Power_FE.mean)
            corridor(Dynamics(i).L_Hip_Power_FE.mean,Dynamics(i).L_Hip_Power_FE.std,colorL(i,:));
            plot(Dynamics(i).L_Hip_Power_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.5,0.5);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Left knee flexion/extension power
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.2:10);
    hold on;
    title('Knee flexion/extension power (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Power (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinetics.Power3.mean,Norm.Kinetics.Power3.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Dynamics(i).L_Knee_Power_FE.mean)
            corridor(Dynamics(i).L_Knee_Power_FE.mean,Dynamics(i).L_Knee_Power_FE.std,colorL(i,:));
            plot(Dynamics(i).L_Knee_Power_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.4,0.6);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Left ankle flexion/extension power
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.2:10);
    hold on;
    title('Ankle flexion/extension power (Flex+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Power (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinetics.Power2.mean,Norm.Kinetics.Power2.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Dynamics(i).L_Ankle_Power_FE.mean)
            corridor(Dynamics(i).L_Ankle_Power_FE.mean,Dynamics(i).L_Ankle_Power_FE.std,colorL(i,:));
            plot(Dynamics(i).L_Ankle_Power_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.4,1);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Left ground reaction force (vertical)
    % ---------------------------------------------------------------------
    y = y - yincr*7.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.4:10);
    hold on;
    title('Vertical ground reaction force (Up+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Force (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(-Norm.Kinetics.PD1.mean,Norm.Kinetics.PD1.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Dynamics(i).L_GRF_Y.mean)
            corridor(-Dynamics(i).L_GRF_Y.mean,Dynamics(i).L_GRF_Y.std,colorL(i,:));
            plot(-Dynamics(i).L_GRF_Y.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,0,1.2);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Left ground reaction force (anterior/posterior)
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.1:10);
    hold on;
    title('Ant/post ground reaction force (Ant+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Force (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(-Norm.Kinetics.AP1.mean,Norm.Kinetics.AP1.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Dynamics(i).L_GRF_X.mean)
            corridor(-Dynamics(i).L_GRF_X.mean,Dynamics(i).L_GRF_X.std,colorL(i,:));
            plot(-Dynamics(i).L_GRF_X.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.3,0.3);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Left ground reaction force (lateral/medial)
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.05:10);
    hold on;
    title('Lat/med ground reaction force (Lat+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Force (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinetics.LM1.mean,Norm.Kinetics.LM1.std,[0.5 0.5 0.5]);  % Relaunch norm and correct sign here
    for i = 1:size(Condition,2)
        if ~isempty(Dynamics(i).L_GRF_Z.mean)
            corridor(-Dynamics(i).L_GRF_Z.mean,Dynamics(i).L_GRF_Z.std,colorL(i,:));
            plot(-Dynamics(i).L_GRF_Z.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-0.1,0.1);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Events
    % ---------------------------------------------------------------------
    for g = 1:length(Graph)
        axes(Graph(g));
        YL = ylim;
        corridor(Norm.Event.p5.mean,Norm.Event.p5.std,[0.5 0.5 0.5]);
        for i = 1:size(Condition,2)
            corridor(Levent(i).p5.mean,Levent(i).p5.std,colorL(i,:));
            plot([Levent(i).mean Levent(i).mean],[-180 180],'Linestyle','-','Linewidth',2,'Color',colorL(i,:)); %IHS
        end
    end
    
end