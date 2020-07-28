% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN CLINICAL REPORT
% =========================================================================
% File name:    reportKinematicsTrial
% -------------------------------------------------------------------------
% Subject:      Check one specific trial kinematics
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

function f = reportKinematicsTrial(Patient,Session,Condition,pluginFolder,normFolder,norm)

% =========================================================================
% Initialisation
% =========================================================================
PageInitialisation;

cd(normFolder);
temp = load(cell2mat(norm));
Norm.Kinematics = temp.Normatives.Rkinematics;
Norm.Event = temp.Normatives.Rphases;
cd(pluginFolder);
% Choose condition
condNames = cell(1,length(Session));
for i = 1:length(Session)
    condNames{i} = [char(Patient(i).lastname),' - ',char(Session(i).date),' - ',char(Condition(i).name)];
end
[cond,ok] = listdlg('ListString',condNames,'ListSize',[300 300]);
% Choose trial
files = [];
for i = 1:length(Session(cond).Trial)
    if strcmp(Session(cond).Trial(i).condition,Condition(cond).name)
        files = [files; Session(cond).Trial(i).filename];
    end
end
[trial,ok] = listdlg('ListString',files);
% Store data
Jkinematics(1) = Condition(cond).Trial(trial).LowerLimb.Jointkinematics;
Skinematics(1) = Condition(cond).Trial(trial).LowerLimb.Segmentkinematics;
Revent(1) = Condition(cond).Trial(trial).LowerLimb.Spatiotemporal.R_Stance_Phase;
Levent(1) = Condition(cond).Trial(trial).LowerLimb.Spatiotemporal.L_Stance_Phase;

% =========================================================================
% Generate the page
% =========================================================================
% Case 1: Only 1 condition: page 1 = right and left parameters
% Case 2: More than 1 condition: page 1 = right, page 2 = left
% =========================================================================

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
axesLegend = axes;
set(axesLegend,'Position',[0 0 1 1]);
set(axesLegend,'Visible','Off');
% Write the legend
text(0.05,y/pageHeight,['Condition ',num2str(cond)],'Color',colorB(cond,:),'FontWeight','Bold');
text(0.25,y/pageHeight,'Droite','Color',colorR(cond,:));
text(0.30,y/pageHeight,'Gauche','Color',colorL(cond,:));
text(0.37,y/pageHeight,'Norm','Color',[0.5 0.5 0.5]);
text(0.44,y/pageHeight,[char(Session(cond).date),...
    '     Fichier : ',char(files(trial,:)),...
    '     Condition : ',char(regexprep(Condition(cond).name,'_','-')),' (cf page 1)'],'color','k');
y = y - yincr*1.0;

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
if ~isempty(Skinematics(1).R_Pelvis_Angle_FE)
    plot(Skinematics(1).R_Pelvis_Angle_FE,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Skinematics(1).L_Pelvis_Angle_FE)
    plot(Skinematics(1).L_Pelvis_Angle_FE,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
end
axis tight;
YL = ylim;
YL = setAxisLim(YL,-40,40);
axis([0 100 YL(1) YL(2)]);
box on;
igraph = igraph+1;

% Right/Left pelvis obliquity
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
if ~isempty(Skinematics(1).R_Pelvis_Angle_AA)
    plot(Skinematics(1).R_Pelvis_Angle_AA,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Skinematics(1).L_Pelvis_Angle_AA)
    plot(Skinematics(1).L_Pelvis_Angle_AA,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
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
if ~isempty(Skinematics(1).R_Pelvis_Angle_IER)
    plot(-Skinematics(1).R_Pelvis_Angle_IER,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Skinematics(1).L_Pelvis_Angle_IER)
    plot(Skinematics(1).L_Pelvis_Angle_IER,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
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
if ~isempty(Jkinematics.R_Hip_Angle_FE)
    plot(Jkinematics.R_Hip_Angle_FE,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Jkinematics.L_Hip_Angle_FE)
    plot(Jkinematics.L_Hip_Angle_FE,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
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
if ~isempty(Jkinematics.R_Hip_Angle_AA)
    plot(Jkinematics.R_Hip_Angle_AA,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Jkinematics.L_Hip_Angle_AA)
    plot(Jkinematics.L_Hip_Angle_AA,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
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
if ~isempty(Jkinematics.R_Hip_Angle_IER)
    plot(Jkinematics.R_Hip_Angle_IER,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Jkinematics.L_Hip_Angle_IER)
    plot(Jkinematics.L_Hip_Angle_IER,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
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
if ~isempty(Jkinematics.R_Knee_Angle_FE)
    plot(Jkinematics.R_Knee_Angle_FE,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Jkinematics.L_Knee_Angle_FE)
    plot(Jkinematics.L_Knee_Angle_FE,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
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
if ~isempty(Jkinematics.R_Knee_Angle_AA)
    plot(Jkinematics.R_Knee_Angle_AA,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Jkinematics.L_Knee_Angle_AA)
    plot(Jkinematics.L_Knee_Angle_AA,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
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
%     if ~isempty(Rkinematics(1).IER3)
%         plot(Rkinematics(1).IER3,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
%     end
%     if ~isempty(Lkinematics(1).IER3)
%         plot(Lkinematics(1).IER3,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
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
if ~isempty(Jkinematics.R_Ankle_Angle_FE)
    plot(Jkinematics.R_Ankle_Angle_FE,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Jkinematics.L_Ankle_Angle_FE)
    plot(Jkinematics.L_Ankle_Angle_FE,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
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
%     if ~isempty(Rkinematics(1).AA2)
%         plot(Rkinematics(1).AA2,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
%     end
%     if ~isempty(Lkinematics(1).AA2)
%         plot(Lkinematics(1).AA2,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
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
if ~isempty(Jkinematics.R_Ankle_Angle_IER)
    plot(Jkinematics.R_Ankle_Angle_IER,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Jkinematics.L_Ankle_Angle_IER)
    plot(Jkinematics.L_Ankle_Angle_IER,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
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
title('Foot tilt (Dors+)','FontWeight','Bold');
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(Norm.Kinematics.Ftilt.mean,Norm.Kinematics.Ftilt.std,[0.5 0.5 0.5]); 
if ~isempty(Skinematics.R_Foot_Angle_FE)
    plot(Skinematics.R_Foot_Angle_FE,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Skinematics.L_Foot_Angle_FE)
    plot(Skinematics.L_Foot_Angle_FE,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
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
if ~isempty(Skinematics.R_Foot_Angle_AA)
    plot(-Skinematics.R_Foot_Angle_AA,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Skinematics.L_Foot_Angle_AA)
    plot(-Skinematics.L_Foot_Angle_AA,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
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
if ~isempty(Skinematics.R_Foot_Angle_IER)
    plot(-Skinematics.R_Foot_Angle_IER,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Skinematics.L_Foot_Angle_IER)
    plot(-Skinematics.L_Foot_Angle_IER,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
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
    plot([Revent Revent],[-180 180],'Linestyle','-','Linewidth',2,'Color',colorR(cond,:)); %IHS
    plot([Levent Levent],[-180 180],'Linestyle','-','Linewidth',2,'Color',colorL(cond,:)); %IHS
end