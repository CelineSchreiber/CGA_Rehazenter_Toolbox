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

function f = reportKinematics(Patient,Session,Condition,pluginFolder,normFolder,norm)

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
Norm.Event = temp.Normatives.Rphases;
cd(pluginFolder);
for i = 1:size(Condition,2)
    Jkinematics(i) = Condition(i).Average.LowerLimb.Jointkinematics;
    Skinematics(i) = Condition(i).Average.LowerLimb.Segmentkinematics;
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
        '  Cinématique',...
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
    for i = 1:size(Condition,2)
        axesLegend = axes;
        set(axesLegend,'Position',[0 0 1 1]);
        set(axesLegend,'Visible','Off');
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
    
    % Right/Left pelvis tilt
    % ---------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Pelvic tilt (Ant+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(-Norm.Kinematics.Ptilt.mean,Norm.Kinematics.Ptilt.std,[0.5 0.5 0.5]);
    if ~isempty(Skinematics(i).R_Pelvis_Angle_FE.mean)
        corridor(Skinematics(i).R_Pelvis_Angle_FE.mean,Skinematics(i).R_Pelvis_Angle_FE.std,colorR(i,:));
        plot(Skinematics(i).R_Pelvis_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Skinematics(i).L_Pelvis_Angle_FE.mean)
        corridor(Skinematics(i).L_Pelvis_Angle_FE.mean,Skinematics(i).L_Pelvis_Angle_FE.std,colorL(i,:));
        plot(Skinematics(i).L_Pelvis_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right/Left pelvis obliquity
    % ---------------------------------------------------------------------    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Pelvic obliquity (Up+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(-Norm.Kinematics.Pobli.mean,Norm.Kinematics.Pobli.std,[0.5 0.5 0.5]);
    if ~isempty(Skinematics(i).R_Pelvis_Angle_AA.mean)
        corridor(Skinematics(i).R_Pelvis_Angle_AA.mean,Skinematics(i).R_Pelvis_Angle_AA.std,colorR(i,:));
        plot(Skinematics(i).R_Pelvis_Angle_AA.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Skinematics(i).L_Pelvis_Angle_AA.mean)
        corridor(Skinematics(i).L_Pelvis_Angle_AA.mean,Skinematics(i).R_Pelvis_Angle_AA.std,colorL(i,:));
        plot(Skinematics(i).L_Pelvis_Angle_AA.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
        
    % Right/Left pelvis rotation
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Pelvic rotation (Int+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinematics.Prota.mean,Norm.Kinematics.Prota.std,[0.5 0.5 0.5]);
    if ~isempty(Skinematics(i).R_Pelvis_Angle_IER.mean)
        corridor(-Skinematics(i).R_Pelvis_Angle_IER.mean,Skinematics(i).R_Pelvis_Angle_IER.std,colorR(i,:));
        plot(-Skinematics(i).R_Pelvis_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Skinematics(i).L_Pelvis_Angle_IER.mean)
        corridor(Skinematics(i).L_Pelvis_Angle_IER.mean,Skinematics(i).L_Pelvis_Angle_IER.std,colorL(i,:));
        plot(Skinematics(i).L_Pelvis_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right/Left hip flexion/extension
    % ---------------------------------------------------------------------
    y = y - yincr*7.5;
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
    
    % Right/Left hip adduction/abduction
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Hip adduction/abduction (Add+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinematics.AA4.mean,Norm.Kinematics.AA4.std,[0.5 0.5 0.5]);
    if ~isempty(Jkinematics(i).R_Hip_Angle_AA.mean)
        corridor(Jkinematics(i).R_Hip_Angle_AA.mean,Jkinematics(i).R_Hip_Angle_AA.std,colorR(i,:));
        plot(Jkinematics(i).R_Hip_Angle_AA.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Jkinematics(i).L_Hip_Angle_AA.mean)
        corridor(Jkinematics(i).L_Hip_Angle_AA.mean,Jkinematics(i).L_Hip_Angle_AA.std,colorL(i,:));
        plot(Jkinematics(i).L_Hip_Angle_AA.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right/Left hip internal/external rotation
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Hip internal/external rotation (Int+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinematics.IER4.mean,Norm.Kinematics.IER4.std,[0.5 0.5 0.5]);
    if ~isempty(Jkinematics(i).R_Hip_Angle_IER.mean)
        corridor(Jkinematics(i).R_Hip_Angle_IER.mean,Jkinematics(i).R_Hip_Angle_IER.std,colorR(i,:));
        plot(Jkinematics(i).R_Hip_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Jkinematics(i).L_Hip_Angle_IER.mean)
        corridor(Jkinematics(i).L_Hip_Angle_IER.mean,Jkinematics(i).L_Hip_Angle_IER.std,colorL(i,:));
        plot(Jkinematics(i).L_Hip_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right/Left knee flexion/extension
    % ---------------------------------------------------------------------
    y = y - yincr*7.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
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
    
    % Right/Left knee adduction/abduction
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Knee adduction/abduction (Add+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinematics.AA3.mean,Norm.Kinematics.AA3.std,[0.5 0.5 0.5]);
    if ~isempty(Jkinematics(i).R_Knee_Angle_AA.mean)
        corridor(Jkinematics(i).R_Knee_Angle_AA.mean,Jkinematics(i).R_Knee_Angle_AA.std,colorR(i,:));
        plot(Jkinematics(i).R_Knee_Angle_AA.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Jkinematics(i).L_Knee_Angle_AA.mean)
        corridor(Jkinematics(i).L_Knee_Angle_AA.mean,Jkinematics(i).L_Knee_Angle_AA.std,colorL(i,:));
        plot(Jkinematics(i).L_Knee_Angle_AA.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    %     % Right/Left knee internal/external rotation
    %     % ---------------------------------------------------------------------
    %     axesGraph = axes;
    %     set(axesGraph,'Position',[0 0 1 1]);
    %     set(axesGraph,'Visible','Off');
    %     Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
    %         graphWidth/pageWidth graphHeight/pageHeight]);
    %     set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    %     hold on;
    %     title('Knee internal/external rotation (Int+)','FontWeight','Bold');
    %     xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    %     plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    %     corridor(Norm.Kinematics.IER3.mean,Norm.Kinematics.IER3.std,[0.5 0.5 0.5]);
    %     if ~isempty(Rkinematics(i).IER3.mean)
    %     corridor(Rkinematics(i).IER3.mean,Rkinematics(i).IER3.std,colorR(i,:));
    %     plot(Rkinematics(i).IER3.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    %     end
    %     if ~isempty(Lkinematics(i).IER3.mean)
    %     corridor(Lkinematics(i).IER3.mean,Lkinematics(i).IER3.std,colorL(i,:));
    %     plot(Lkinematics(i).IER3.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    %     end
    %     axis tight;
    %     YL = ylim;
    %     YL = setAxisLim(YL,-40,40);
    %     axis([0 100 YL(1) YL(2)]);
    %     box on;
    %     igraph = igraph+1;
    
    % Right/Left ankle flexion/extension
    % ---------------------------------------------------------------------
    y = y - yincr*7.5;
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
    
    %     % Right/Left ankle adduction/abduction
    %     % ---------------------------------------------------------------------
    %     axesGraph = axes;
    %     set(axesGraph,'Position',[0 0 1 1]);
    %     set(axesGraph,'Visible','Off');
    %     Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
    %         graphWidth/pageWidth graphHeight/pageHeight]);
    %     set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    %     hold on;
    %     title('Ankle adduction/abduction (Add+)','FontWeight','Bold');
    %     xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    %     plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    %     corridor(Norm.Kinematics.AA2.mean,Norm.Kinematics.AA2.std,[0.5 0.5 0.5]);
    %     if ~isempty(Rkinematics(i).AA2.mean)
    %     corridor(Rkinematics(i).AA2.mean,Rkinematics(i).AA2.std,colorR(i,:));
    %     plot(Rkinematics(i).AA2.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    %     end
    %     if ~isempty(Lkinematics(i).AA2.mean)
    %     corridor(Lkinematics(i).AA2.mean,Lkinematics(i).AA2.std,colorL(i,:));
    %     plot(Lkinematics(i).AA2.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    %     end
    %     axis tight;
    %     YL = ylim;
    %     YL = setAxisLim(YL,-40,40);
    %     axis([0 100 YL(1) YL(2)]);
    %     box on;
    %     igraph = igraph+1;
    
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
        '  Cinématique',...
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
        nbtrials = 0;
        for j = 1:length(Condition(i).Trial);
            if ~isempty(Condition(i).Trial(j).LowerLimb.Spatiotemporal.Cadence)
                nbtrials = nbtrials+1;
            end
        end
        % Write the legend
        text(0.05,y/pageHeight,['Condition ',num2str(i)],'Color',colorB(i,:),'FontWeight','Bold');
        text(0.25,y/pageHeight,'Droite','Color',colorR(i,:));
        text(0.33,y/pageHeight,'Norme','Color',[0.5 0.5 0.5]);
        text(0.40,y/pageHeight,[char(Session(i).date),...
            '     Nb essais : ',num2str(nbtrials),...
            '     Condition : ',char(regexprep(Condition(i).name,'_','-')),' (cf page 1)'],'color','k');
        y = y - yincr;
    end
    
    % Right pelvis tilt
    % ---------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Pelvic tilt (Ant+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(-Norm.Kinematics.Ptilt.mean,Norm.Kinematics.Ptilt.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Skinematics(i).R_Pelvis_Angle_FE.mean)
            corridor(Skinematics(i).R_Pelvis_Angle_FE.mean,Skinematics(i).R_Pelvis_Angle_FE.std,colorR(i,:));
            plot(Skinematics(i).R_Pelvis_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right pelvis obliquity
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Pelvic obliquity (Up+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(-Norm.Kinematics.Pobli.mean,Norm.Kinematics.Pobli.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Skinematics(i).R_Pelvis_Angle_AA.mean)
            corridor(Skinematics(i).R_Pelvis_Angle_AA.mean,Skinematics(i).R_Pelvis_Angle_AA.std,colorR(i,:));
            plot(Skinematics(i).R_Pelvis_Angle_AA.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right pelvis rotation
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Pelvic rotation (Int+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinematics.Prota.mean,Norm.Kinematics.Prota.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Skinematics(i).R_Pelvis_Angle_IER.mean)
            corridor(-Skinematics(i).R_Pelvis_Angle_IER.mean,Skinematics(i).R_Pelvis_Angle_IER.std,colorR(i,:));
            plot(-Skinematics(i).R_Pelvis_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right hip flexion/extension
    % ---------------------------------------------------------------------
    y = y - yincr*7.5;
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
    
    % Right hip adduction/abduction
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Hip adduction/abduction (Add+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinematics.AA4.mean,Norm.Kinematics.AA4.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Jkinematics(i).R_Hip_Angle_AA.mean)
            corridor(Jkinematics(i).R_Hip_Angle_AA.mean,Jkinematics(i).R_Hip_Angle_AA.std,colorR(i,:));
            plot(Jkinematics(i).R_Hip_Angle_AA.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right hip internal/external rotation
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Hip internal/external rotation (Int+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinematics.IER4.mean,Norm.Kinematics.IER4.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Jkinematics(i).R_Hip_Angle_IER.mean)
            corridor(Jkinematics(i).R_Hip_Angle_IER.mean,Jkinematics(i).R_Hip_Angle_IER.std,colorR(i,:));
            plot(Jkinematics(i).R_Hip_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
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
    y = y - yincr*7.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
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
    
    % Right knee adduction/abduction
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Knee adduction/abduction (Add+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinematics.AA3.mean,Norm.Kinematics.AA3.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Jkinematics(i).R_Knee_Angle_AA.mean)
            corridor(Jkinematics(i).R_Knee_Angle_AA.mean,Jkinematics(i).R_Knee_Angle_AA.std,colorR(i,:));
            plot(Jkinematics(i).R_Knee_Angle_AA.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    %     % Right knee internal/external rotation
    %     % ---------------------------------------------------------------------
    %     axesGraph = axes;
    %     set(axesGraph,'Position',[0 0 1 1]);
    %     set(axesGraph,'Visible','Off');
    %     Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
    %         graphWidth/pageWidth graphHeight/pageHeight]);
    %     set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    %     hold on;
    %     title('Knee internal/external rotation (Int+)','FontWeight','Bold');
    %     xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    %     plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    %     corridor(Norm.Kinematics.IER3.mean,Norm.Kinematics.IER3.std,[0.5 0.5 0.5]);
%         for i = 1:size(Condition,2)
%             if ~isempty(Rkinematics(i).IER3.mean)
%                 corridor(Rkinematics(i).IER3.mean,Rkinematics(i).IER3.std,colorR(i,:));
%                 plot(Rkinematics(i).IER3.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
%             end
%         end
    %     axis tight;
    %     YL = ylim;
    %     YL = setAxisLim(YL,-40,40);
    %     axis([0 100 YL(1) YL(2)]);
    %     box on;
    %     igraph = igraph+1;
    
    % Right ankle flexion/extension
    % ---------------------------------------------------------------------
    y = y - yincr*7.5;
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
    
    %     % Right ankle adduction/abduction
    %     % ---------------------------------------------------------------------
    %     axesGraph = axes;
    %     set(axesGraph,'Position',[0 0 1 1]);
    %     set(axesGraph,'Visible','Off');
    %     Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
    %         graphWidth/pageWidth graphHeight/pageHeight]);
    %     set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    %     hold on;
    %     title('Ankle adduction/abduction (Add+)','FontWeight','Bold');
    %     xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    %     plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    %     corridor(Norm.Kinematics.AA2.mean,Norm.Kinematics.AA2.std,[0.5 0.5 0.5]);
%         for i = 1:size(Condition,2)
%             if ~isempty(Rkinematics(i).AA2.mean)
%                 corridor(Rkinematics(i).AA2.mean,Rkinematics(i).AA2.std,colorR(i,:));
%                 plot(Rkinematics(i).AA2.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
%             end
%         end
    %     axis tight;
    %     YL = ylim;
    %     YL = setAxisLim(YL,-40,40);
    %     axis([0 100 YL(1) YL(2)]);
    %     box on;
    %     igraph = igraph+1;
    
    % Right ankle internal/external rotation
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
    for i = 1:size(Condition,2)
        if ~isempty(Jkinematics(i).R_Ankle_Angle_IER.mean)
            corridor(Jkinematics(i).R_Ankle_Angle_IER.mean,Jkinematics(i).R_Ankle_Angle_IER.std,colorR(i,:));
            plot(Jkinematics(i).R_Ankle_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right foot tilt
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
    for i = 1:size(Condition,2)
        if ~isempty(Skinematics(i).R_Foot_Angle_FE.mean)
            corridor(Skinematics(i).R_Foot_Angle_FE.mean,Skinematics(i).R_Foot_Angle_FE.std,colorR(i,:));
            plot(Skinematics(i).R_Foot_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right foot obliquity
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
    for i = 1:size(Condition,2)
        if ~isempty(Skinematics(i).R_Foot_Angle_AA.mean)
            corridor(-Skinematics(i).R_Foot_Angle_AA.mean,Skinematics(i).R_Foot_Angle_AA.std,colorR(i,:));
            plot(-Skinematics(i).R_Foot_Angle_AA.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right foot rotation
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
    for i = 1:size(Condition,2)
        if ~isempty(Skinematics(i).R_Foot_Angle_IER.mean)
            corridor(-Skinematics(i).R_Foot_Angle_IER.mean,Skinematics(i).R_Foot_Angle_IER.std,colorR(i,:));
            plot(-Skinematics(i).R_Foot_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
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
        '  Cinématique',...
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
        nbtrials = 0;
        for j = 1:length(Condition(i).Trial);
            if ~isempty(Condition(i).Trial(j).LowerLimb.Spatiotemporal.Cadence)
                nbtrials = nbtrials+1;
            end
        end
        % Write the legend
        text(0.05,y/pageHeight,['Condition ',num2str(i)],'Color',colorB(i,:),'FontWeight','Bold');
        text(0.25,y/pageHeight,'Gauche','Color',colorL(i,:));
        text(0.33,y/pageHeight,'Norme','Color',[0.5 0.5 0.5]);
        text(0.40,y/pageHeight,[char(Session(i).date),...
            '     Nb essais : ',num2str(nbtrials),...
            '     Condition : ',char(regexprep(Condition(i).name,'_','-')),' (cf page 1)'],'color','k');
        y = y - yincr;
    end
    
    % Left pelvis tilt
    % ---------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Pelvic tilt (Ant+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(-Norm.Kinematics.Ptilt.mean,Norm.Kinematics.Ptilt.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Skinematics(i).L_Pelvis_Angle_FE)
            corridor(Skinematics(i).L_Pelvis_Angle_FE.mean,Skinematics(i).L_Pelvis_Angle_FE.std,colorL(i,:));
            plot(Skinematics(i).L_Pelvis_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Left pelvis obliquity
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Pelvic obliquity (Up+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(-Norm.Kinematics.Pobli.mean,Norm.Kinematics.Pobli.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Skinematics(i).L_Pelvis_Angle_AA.mean)
            corridor(Skinematics(i).L_Pelvis_Angle_AA.mean,Skinematics(i).L_Pelvis_Angle_AA.std,colorL(i,:));
            plot(Skinematics(i).L_Pelvis_Angle_AA.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Left pelvis rotation
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Pelvic rotation (Int+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinematics.Prota.mean,Norm.Kinematics.Prota.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Skinematics(i).L_Pelvis_Angle_IER.mean)
            corridor(Skinematics(i).L_Pelvis_Angle_IER.mean,Skinematics(i).L_Pelvis_Angle_IER.std,colorL(i,:));
            plot(Skinematics(i).L_Pelvis_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Left hip flexion/extension
    % ---------------------------------------------------------------------
    y = y - yincr*7.5;
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
    
    % Left hip adduction/abduction
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Hip adduction/abduction (Add+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinematics.AA4.mean,Norm.Kinematics.AA4.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Jkinematics(i).L_Hip_Angle_AA.mean)
            corridor(Jkinematics(i).L_Hip_Angle_AA.mean,Jkinematics(i).L_Hip_Angle_AA.std,colorL(i,:));
            plot(Jkinematics(i).L_Hip_Angle_AA.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Left hip internal/external rotation
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Hip internal/external rotation (Int+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinematics.IER4.mean,Norm.Kinematics.IER4.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Jkinematics(i).L_Hip_Angle_IER.mean)
            corridor(Jkinematics(i).L_Hip_Angle_IER.mean,Jkinematics(i).L_Hip_Angle_IER.std,colorL(i,:));
            plot(Jkinematics(i).L_Hip_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
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
    y = y - yincr*7.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
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
    
    % Left knee adduction/abduction
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Knee adduction/abduction (Add+)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinematics.AA3.mean,Norm.Kinematics.AA3.std,[0.5 0.5 0.5]);
    for i = 1:size(Condition,2)
        if ~isempty(Jkinematics(i).L_Knee_Angle_AA.mean)
            corridor(Jkinematics(i).L_Knee_Angle_AA.mean,Jkinematics(i).L_Knee_Angle_AA.std,colorL(i,:));
            plot(Jkinematics(i).L_Knee_Angle_AA.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    %     % Left knee internal/external rotation
    %     % ---------------------------------------------------------------------
    %     axesGraph = axes;
    %     set(axesGraph,'Position',[0 0 1 1]);
    %     set(axesGraph,'Visible','Off');
    %     Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
    %         graphWidth/pageWidth graphHeight/pageHeight]);
    %     set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    %     hold on;
    %     title('Knee internal/external rotation (Int+)','FontWeight','Bold');
    %     xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    %     plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    %     corridor(Norm.Kinematics.IER3.mean,Norm.Kinematics.IER3.std,[0.5 0.5 0.5]);
%         for i = 1:size(Condition,2)
%             if ~isempty(Lkinematics(i).IER3.mean)
%                 corridor(Lkinematics(i).IER3.mean,Lkinematics(i).IER3.std,colorL(i,:));
%                 plot(Lkinematics(i).IER3.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
%             end
%         end
    %     axis tight;
    %     YL = ylim;
    %     YL = setAxisLim(YL,-40,40);
    %     axis([0 100 YL(1) YL(2)]);
    %     box on;
    %     igraph = igraph+1;
    
    % Left ankle flexion/extension
    % ---------------------------------------------------------------------
    y = y - yincr*7.5;
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
    
    %     % Left ankle adduction/abduction
    %     % ---------------------------------------------------------------------
    %     axesGraph = axes;
    %     set(axesGraph,'Position',[0 0 1 1]);
    %     set(axesGraph,'Visible','Off');
    %     Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
    %         graphWidth/pageWidth graphHeight/pageHeight]);
    %     set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    %     hold on;
    %     title('Ankle adduction/abduction (Add+)','FontWeight','Bold');
    %     xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    %     plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    %     corridor(Norm.Kinematics.AA2.mean,Norm.Kinematics.AA2.std,[0.5 0.5 0.5]);
%         for i = 1:size(Condition,2)
%             if ~isempty(Lkinematics(i).AA2.mean)
%                 corridor(Lkinematics(i).AA2.mean,Lkinematics(i).AA2.std,colorL(i,:));
%                 plot(Lkinematics(i).AA2.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
%             end
%         end
    %     axis tight;
    %     YL = ylim;
    %     YL = setAxisLim(YL,-40,40);
    %     axis([0 100 YL(1) YL(2)]);
    %     box on;
    %     igraph = igraph+1;
    
    % Left ankle internal/external rotation
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
    for i = 1:size(Condition,2)
        if ~isempty(Jkinematics(i).L_Ankle_Angle_IER.mean)
            corridor(Jkinematics(i).L_Ankle_Angle_IER.mean,Jkinematics(i).L_Ankle_Angle_IER.std,colorL(i,:));
            plot(Jkinematics(i).L_Ankle_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Left foot tilt
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
    for i = 1:size(Condition,2)
        if ~isempty(Skinematics(i).L_Foot_Angle_FE.mean)
            corridor(Skinematics(i).L_Foot_Angle_FE.mean,Skinematics(i).L_Foot_Angle_FE.std,colorL(i,:));
            plot(Skinematics(i).L_Foot_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Left foot obliquity
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
    for i = 1:size(Condition,2)
        if ~isempty(Skinematics(i).L_Foot_Angle_AA.mean)
            corridor(-Skinematics(i).L_Foot_Angle_AA.mean,Skinematics(i).L_Foot_Angle_AA.std,colorL(i,:));
            plot(-Skinematics(i).L_Foot_Angle_AA.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Left foot rotation
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
    for i = 1:size(Condition,2)
        if ~isempty(Skinematics(i).L_Foot_Angle_IER.mean)
            corridor(-Skinematics(i).L_Foot_Angle_IER.mean,Skinematics(i).L_Foot_Angle_IER.std,colorL(i,:));
            plot(-Skinematics(i).L_Foot_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
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
            corridor(Levent(i).mean,Levent(i).std,colorL(i,:));
            plot([Levent(i).mean Levent(i).mean],[-180 180],'Linestyle','-','Linewidth',2,'Color',colorL(i,:)); %IHS
        end
    end
    
end