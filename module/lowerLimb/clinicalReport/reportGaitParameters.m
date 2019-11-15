% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN CLINICAL REPORT
% =========================================================================
% File name:    reportGaitParameters
% -------------------------------------------------------------------------
% Subject:      Generate the report page for gait parameters
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
% Date of creation: 16/12/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: -
% =========================================================================

function f = reportGaitParameters(Patient,Session,Condition,pluginFolder,normFolder,norm)

% =========================================================================
% Initialisation
% =========================================================================
pageWidth = 21; % cm
pageHeight = 29.7; % cm
graphWidth = 7.0; % cm
graphHeight = 2; % cm
yinit = 29.0; % cm
yincr = 0.5; % cm
x = [1.05 7.00 11.0 16.45]; % cm
colorR = [0 0.8 0;0 0.8 0.8;0 0.4 0;0 0.4 0.4;0 0.2 0;0 0.2 0.2];
colorL = [0.8 0 0;0.8 0 0.8;0.4 0 0;0.4 0 0.4;0.2 0 0;0.2 0 0.2];
colorB = [0 0 0.8;0.2 0.2 0.8;0.5 0.5 0.8;0.7 0.7 0.8;0.9 0.9 0.8;0.9 0.9 0.6];
cd(normFolder);
temp = load(cell2mat(norm));
names = [fieldnames(temp.Normatives.Gaitparameters);fieldnames(temp.Normatives.Rphases)];
Norm = cell2struct([struct2cell(temp.Normatives.Gaitparameters); struct2cell(temp.Normatives.Rphases)], names, 1);
cd(pluginFolder);
for i = 1:size(Condition,2)
    Param(i) = Condition(i).Average.LowerLimb.Spatiotemporal;
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
        '  Paramètres spatio-temporaux',...
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
    nbtrials = 0;
    for j = 1:length(Condition(1).Trial);
        if ~isempty(Condition(1).Trial(j).LowerLimb.Spatiotemporal.Cadence)
            nbtrials = nbtrials+1;
        end
    end
    % Write the legend
    text(0.05,y/pageHeight,['Condition ',num2str(1)],'Color',colorB(1,:),'FontWeight','Bold');
    text(0.25,y/pageHeight,'Droite','Color',colorR(1,:));
    text(0.30,y/pageHeight,'Gauche','Color',colorL(1,:));
    text(0.37,y/pageHeight,'Norme','Color',[0.5 0.5 0.5]);
    text(0.44,y/pageHeight,[char(Session(1).date),...
        '     Nb essais : ',num2str(nbtrials),...
        '     Condition : ',char(regexprep(Condition(1).name,'_','-')),' (cf page 1)'],'color','k');
    y = y - yincr*1.0;
        
    % Right/Left step length
    % ---------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Labels{1} = [num2str(Param(1).L_Step_Length.mean,'%2.2f'),' +/- ',...
        num2str(Param(1).L_Step_Length.std,'%2.2f')];
    Labels{2} = [num2str(Param(i).R_Step_Length.mean,'%2.2f'),' +/- ',...
        num2str(Param(1).R_Step_Length.std,'%2.2f')];
    Labels{3} = [num2str(Norm.right_step_length.mean,'%2.2f'),'.+/- ',...
        num2str(Norm.right_step_length.std,'%2.2f')];
    Graph(6) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(6),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:.1:2);
    hold on;
    title('Step length (m)','FontWeight','Bold');
    barh(1,Param(1).L_Step_Length.mean,'FaceColor',colorL(1,:));
    barh(1,Param(1).L_Step_Length.mean+Param(1).L_Step_Length.std,...
        'FaceColor','none','LineStyle','-');
    barh(1,Param(1).L_Step_Length.mean-Param(1).L_Step_Length.std,...
        'FaceColor','none','LineStyle','-');
    barh(2,Param(1).R_Step_Length.mean,'FaceColor',colorR(1,:));
    barh(2,Param(1).R_Step_Length.mean+Param(1).R_Step_Length.std,...
        'FaceColor','none','LineStyle','-');
    barh(2,Param(1).R_Step_Length.mean-Param(1).R_Step_Length.std,...
        'FaceColor','none','LineStyle','-');
    barh(3,Norm.left_step_length.mean,'FaceColor',[0.5 0.5 0.5]);
    barh(3,Norm.left_step_length.mean+Norm.left_step_length.std,...
        'FaceColor','none','LineStyle','-');
    barh(3,Norm.left_step_length.mean-Norm.left_step_length.std,...
        'FaceColor','none','LineStyle','-');
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    xlim([0 1.0]);
    box on;
    
    % Right/left gait cycle time
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Labels{1} = [num2str(Param(1).L_Gait_Cycle.mean,'%2.2f'),'  +/-  ',...
        num2str(Param(1).L_Gait_Cycle.std,'%2.2f')];
    Labels{2} = [num2str(Param(1).R_Gait_Cycle.mean,'%2.2f'),' +/- ',...
        num2str(Param(1).R_Gait_Cycle.std,'%2.2f')];
    Labels{3} = [num2str(Norm.right_gait_cycle.mean,'%2.2f'),'  +/-  ',...
        num2str(Norm.right_gait_cycle.std,'%2.2f')];
    Graph(2) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(2),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:.2:2);
    hold on;
    title('Gait cycle time (s)','FontWeight','Bold'); 
    barh(1,Param(1).L_Gait_Cycle.mean,'FaceColor',colorL(1,:));
    barh(1,Param(1).L_Gait_Cycle.mean+Param(1).L_Gait_Cycle.std,...
        'FaceColor','none','LineStyle','-');
    barh(1,Param(1).L_Gait_Cycle.mean-Param(1).L_Gait_Cycle.std,...
        'FaceColor','none','LineStyle','-');   
    barh(2,Param(1).R_Gait_Cycle.mean,'FaceColor',colorR(1,:));
    barh(2,Param(1).R_Gait_Cycle.mean+Param(1).R_Gait_Cycle.std,...
        'FaceColor','none','LineStyle','-');
    barh(2,Param(1).R_Gait_Cycle.mean-Param(1).R_Gait_Cycle.std,...
        'FaceColor','none','LineStyle','-');
    barh(3,Norm.left_gait_cycle.mean,'FaceColor',[0.5 0.5 0.5]);
    barh(3,Norm.left_gait_cycle.mean+Norm.left_gait_cycle.std,...
        'FaceColor','none','LineStyle','-');
    barh(3,Norm.left_gait_cycle.mean-Norm.left_gait_cycle.std,...
        'FaceColor','none','LineStyle','-');
    xlim([0 2]);
    box on;
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    
    % Right/left stride length
    % ---------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Labels{1} = [num2str(Param(1).L_Stride_Length.mean,'%2.2f'),' +/- ',...
        num2str(Param(1).L_Stride_Length.std,'%2.2f')];
    Labels{2} = [num2str(Param(1).R_Stride_Length.mean,'%2.2f'),' +/- ',...
        num2str(Param(1).R_Stride_Length.std,'%2.2f')];
    Labels{3} = [num2str(Norm.right_stride_length.mean,'%2.2f'),' +/- ',...
        num2str(Norm.right_stride_length.std,'%2.2f')];
    Graph(5) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(5),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:.2:2);
    hold on;
    title('Stride length (m)','FontWeight','Bold');
    barh(1,Param(1).L_Stride_Length.mean,'FaceColor',colorL(1,:));
    barh(1,Param(1).L_Stride_Length.mean+Param(1).L_Stride_Length.std,...
        'FaceColor','none','LineStyle','-');
    barh(1,Param(1).L_Stride_Length.mean-Param(1).L_Stride_Length.std,...
        'FaceColor','none','LineStyle','-');
    barh(2,Param(1).R_Stride_Length.mean,'FaceColor',colorR(1,:));
    barh(2,Param(1).R_Stride_Length.mean+Param(1).R_Stride_Length.std,...
        'FaceColor','none','LineStyle','-');
    barh(2,Param(1).R_Stride_Length.mean-Param(1).R_Stride_Length.std,...
        'FaceColor','none','LineStyle','-');
    barh(3,Norm.left_stride_length.mean,'FaceColor',[0.5 0.5 0.5]);
    barh(3,Norm.left_stride_length.mean+Norm.left_stride_length.std,...
        'FaceColor','none','LineStyle','-');
    barh(3,Norm.left_stride_length.mean-Norm.left_stride_length.std,...
        'FaceColor','none','LineStyle','-');
    xlim([0 1.8]);
    box on;
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    
    % Stance/swing
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Labels{1} = [num2str(Param(1).L_Stance_Phase.mean,'%2.2f'),' +/- ',...
        num2str(Param(1).L_Stance_Phase.std,'%2.2f')];
    Labels{2} = [num2str(Param(1).R_Stance_Phase.mean,'%2.2f'),' +/- ',...
        num2str(Param(1).R_Stance_Phase.std,'%2.2f')];
    Labels{3} = [num2str(Norm.right_stance_phase.mean,'%2.2f'),' +/- ',...
        num2str(Norm.right_stance_phase.std,'%2.2f')];
    Graph(1) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(1),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:10:100);
    hold on;
    title('Stance/Swing phases (%)','FontWeight','Bold'); 
    barh(1,100,'FaceColor','none');
    barh(1,Param(1).L_Stance_Phase.mean,'FaceColor',colorL(1,:));
    barh(1,Param(1).L_Stance_Phase.mean+Param(1).L_Stance_Phase.std,...
        'FaceColor','none','LineStyle','-');
    barh(1,Param(1).L_Stance_Phase.mean-Param(1).L_Stance_Phase.std,...
        'FaceColor','none','LineStyle','-');  
    barh(2,100,'FaceColor','none');
    barh(2,Param(1).R_Stance_Phase.mean,'FaceColor',colorR(1,:));
    barh(2,Param(1).R_Stance_Phase.mean+Param(1).R_Stance_Phase.std,...
        'FaceColor','none','LineStyle','-');
    barh(2,Param(1).R_Stance_Phase.mean-Param(1).R_Stance_Phase.std,...
        'FaceColor','none','LineStyle','-');
    barh(3,100,'FaceColor','none');
    barh(3,Norm.right_stance_phase.mean,'FaceColor',[0.5 0.5 0.5]);
    barh(3,Norm.right_stance_phase.mean+Norm.right_stance_phase.std,...
        'FaceColor','none','LineStyle','-');
    barh(3,Norm.right_stance_phase.mean-Norm.right_stance_phase.std,...
        'FaceColor','none','LineStyle','-');
    xlim([0 100]);
    box on;
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    
    % Step width
    % ---------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Labels{1} = [num2str(Param(1).Stride_Width.mean,'%2.2f'),'  +/-  ',num2str(Param(1).Stride_Width.std,'%2.2f')];
    Labels{2} = [num2str(Norm.step_width.mean,'%2.2f'),'  +/-  ',num2str(Norm.step_width.std,'%2.2f')];
    Graph(9) = axes('position',[x(1)/pageWidth y/pageHeight graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(9),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:.05:1);
    hold on;
    title('Step width (m)','FontWeight','Bold');
    barh(1,Param(1).Stride_Width.mean,'FaceColor',colorB(1,:));
    barh(1,Param(1).Stride_Width.mean+Param(1).Stride_Width.std,'FaceColor','none','LineStyle','-');
    barh(1,Param(1).Stride_Width.mean-Param(1).Stride_Width.std,'FaceColor','none','LineStyle','-');
    barh(2,Norm.step_width.mean,'FaceColor',[0.5 0.5 0.5]);
    barh(2,Norm.step_width.mean+Norm.step_width.std,'FaceColor','none','LineStyle','-');
    barh(2,Norm.step_width.mean-Norm.step_width.std,'FaceColor','none','LineStyle','-');
    xlim([0 0.4]);
    box on;
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    
    % Double support
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
%     Labels{1} = [num2str(Param(1).total_double_support.mean,'%2.2f'),' +/- ',...
%         num2str(Param(1).total_double_support.std,'%2.2f')];
%     Labels{2} = [num2str(Norm.total_double_support.mean,'%2.2f'),' +/- ',...
%         num2str(Norm.total_double_support.std,'%2.2f')];
    Graph(4) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(4),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',-100:10:100);
    hold on;
    title('Double support (%)','FontWeight','Bold');   
%     barh(1,Param(1).total_double_support.mean,'FaceColor',colorB(1,:));
%     barh(1,Param(1).total_double_support.mean+Param(1).total_double_support.std,...
%         'FaceColor','none','LineStyle','-');
%     barh(1,Param(1).total_double_support.mean-Param(1).total_double_support.std,...
%         'FaceColor','none','LineStyle','-');
%     barh(2,Norm.total_double_support.mean,'FaceColor',[0.5 0.5 0.5]);
%     barh(2,Norm.total_double_support.mean+Norm.total_double_support.std,...
%         'FaceColor','none','LineStyle','-');
%     barh(2,Norm.total_double_support.mean-Norm.total_double_support.std,...
%         'FaceColor','none','LineStyle','-');
%     xlim([0 100]);
%     box on;
%     set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    
    % Cadence
    % ---------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Labels{1} = [num2str(Param(1).Cadence.mean,'%2.2f'),'  +/-  ',num2str(Param(1).Cadence.std,'%2.2f')];
    Labels{2} = [num2str(Norm.cadence.mean,'%2.2f'),'  +/-  ',num2str(Norm.cadence.std,'%2.2f')];
    Graph(7) = axes('position',[x(1)/pageWidth y/pageHeight graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(7),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:20:160);
    hold on;
    title('Cadence (step/min)','FontWeight','Bold');
    barh(1,Param(1).Cadence.mean,'FaceColor',colorB(1,:));
    barh(1,Param(1).Cadence.mean+Param(1).Cadence.std,'FaceColor','none','LineStyle','-');
    barh(1,Param(1).Cadence.mean-Param(1).Cadence.std,'FaceColor','none','LineStyle','-');
    barh(2,Norm.cadence.mean,'FaceColor',[0.5 0.5 0.5]);
    barh(2,Norm.cadence.mean+Norm.cadence.std,'FaceColor','none','LineStyle','-');
    barh(2,Norm.cadence.mean-Norm.cadence.std,'FaceColor','none','LineStyle','-');
    xlim([0 160]);
    box on;
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    
    if ~strcmp(Session.markerSet,'Aucun')
        % Mean velocity
        % ---------------------------------------------------------------------
        y = y - yincr*6.5;
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        clear Labels;
        Labels{1} = [num2str(Param(1).Velocity.mean,'%2.2f'),'  +/-  ',num2str(Param(1).Velocity.std,'%2.2f')];
        Labels{2} = [num2str(Norm.mean_velocity.mean,'%2.2f'),'  +/-  ',num2str(Norm.mean_velocity.std,'%2.2f')];
        Graph(8) = axes('position',[x(1)/pageWidth y/pageHeight graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(8),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:0.2:2);
        hold on;
        title('Mean velocity (m/s)','FontWeight','Bold');
        barh(1,Param(1).Velocity.mean,'FaceColor',colorB(1,:));
        barh(1,Param(1).Velocity.mean+Param(1).Velocity.std,'FaceColor','none','LineStyle','-');
        barh(1,Param(1).Velocity.mean-Param(1).Velocity.std,'FaceColor','none','LineStyle','-');
        barh(2,Norm.mean_velocity.mean,'FaceColor',[0.5 0.5 0.5]);
        barh(2,Norm.mean_velocity.mean+Norm.mean_velocity.std,'FaceColor','none','LineStyle','-');
        barh(2,Norm.mean_velocity.mean-Norm.mean_velocity.std,'FaceColor','none','LineStyle','-');
        xlim([0 2]);
        box on;
        set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    end

elseif size(Condition,2) > 1
    
    % Set the page for right side parameters
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
        '  Paramètres spatio-temporaux',...
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
    
    % Right step length
    % ---------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Graph(6) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(6),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:.1:2);
    hold on;
    title('Step length (m)','FontWeight','Bold');
    for i = size(Condition,2):-1:1
        Labels{size(Condition,2)-i+1} = [num2str(Param(i).R_Step_Length.mean,'%2.2f'),' +/- ',...
            num2str(Param(i).R_Step_Length.std,'%2.2f')];
        barh(size(Condition,2)-i+1,Param(i).R_Step_Length.mean,'FaceColor',colorR(i,:));
        barh(size(Condition,2)-i+1,Param(i).R_Step_Length.mean+Param(i).R_Step_Length.std,...
            'FaceColor','none','LineStyle','-');
        barh(size(Condition,2)-i+1,Param(i).R_Step_Length.mean-Param(i).R_Step_Length.std,...
            'FaceColor','none','LineStyle','-');
    end
    barh(size(Condition,2)+1,Norm.left_step_length.mean,'FaceColor',[0.5 0.5 0.5]);
    barh(size(Condition,2)+1,Norm.left_step_length.mean+Norm.left_step_length.std,...
        'FaceColor','none','LineStyle','-');
    barh(size(Condition,2)+1,Norm.left_step_length.mean-Norm.left_step_length.std,...
        'FaceColor','none','LineStyle','-');
    Labels{size(Condition,2)+1} = [num2str(Norm.right_step_length.mean,'%2.2f'),'.+/- ',...
        num2str(Norm.right_step_length.std,'%2.2f')];
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    xlim([0 0.8]);
    box on;
    
    % Right gait cycle time
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Graph(2) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(2),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:.2:2);
    hold on;
    title('Gait cycle time (s)','FontWeight','Bold');
    for i = size(Condition,2):-1:1
        Labels{size(Condition,2)-i+1} = [num2str(Param(i).R_Gait_Cycle.mean,'%2.2f'),' +/- ',...
            num2str(Param(i).R_Gait_Cycle.std,'%2.2f')];
        barh(size(Condition,2)-i+1,Param(i).R_Gait_Cycle.mean,'FaceColor',colorR(i,:));
        barh(size(Condition,2)-i+1,Param(i).R_Gait_Cycle.mean+Param(i).R_Gait_Cycle.std,...
            'FaceColor','none','LineStyle','-');
        barh(size(Condition,2)-i+1,Param(i).R_Gait_Cycle.mean-Param(i).R_Gait_Cycle.std,...
            'FaceColor','none','LineStyle','-');
    end
    barh(size(Condition,2)+1,Norm.left_gait_cycle.mean,'FaceColor',[0.5 0.5 0.5]);
    barh(size(Condition,2)+1,Norm.left_gait_cycle.mean+Norm.left_gait_cycle.std,...
        'FaceColor','none','LineStyle','-');
    barh(size(Condition,2)+1,Norm.left_gait_cycle.mean-Norm.left_gait_cycle.std,...
        'FaceColor','none','LineStyle','-');
    Labels{size(Condition,2)+1} = [num2str(Norm.right_gait_cycle.mean,'%2.2f'),'  +/-  ',...
        num2str(Norm.right_gait_cycle.std,'%2.2f')];
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    xlim([0 2]);
    box on;
    
    % Right stride length
    % ---------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Graph(5) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(5),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:.2:2);
    hold on;
    title('Stride length (m)','FontWeight','Bold');
    for i = size(Condition,2):-1:1
        Labels{size(Condition,2)-i+1} = [num2str(Param(i).R_Stride_Length.mean,'%2.2f'),' +/- ',...
            num2str(Param(i).R_Stride_Length.std,'%2.2f')];
        barh(size(Condition,2)-i+1,Param(i).R_Stride_Length.mean,'FaceColor',colorR(i,:));
        barh(size(Condition,2)-i+1,Param(i).R_Stride_Length.mean+Param(i).R_Stride_Length.std,...
            'FaceColor','none','LineStyle','-');
        barh(size(Condition,2)-i+1,Param(i).R_Stride_Length.mean-Param(i).R_Stride_Length.std,...
            'FaceColor','none','LineStyle','-');
    end
    barh(size(Condition,2)+1,Norm.left_stride_length.mean,'FaceColor',[0.5 0.5 0.5]);
    barh(size(Condition,2)+1,Norm.left_stride_length.mean+Norm.left_stride_length.std,...
        'FaceColor','none','LineStyle','-');
    barh(size(Condition,2)+1,Norm.left_stride_length.mean-Norm.left_stride_length.std,...
        'FaceColor','none','LineStyle','-');
    Labels{size(Condition,2)+1} = [num2str(Norm.right_stride_length.mean,'%2.2f'),' +/- ',...
        num2str(Norm.right_stride_length.std,'%2.2f')];
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    xlim([0 1.6]);
    box on;
    
    % Stance/swing
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Graph(1) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(1),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:10:100);
    hold on;
    title('Stance/Swing phases (%)','FontWeight','Bold');
    for i = size(Condition,2):-1:1
        Labels{size(Condition,2)-i+1} = [num2str(Param(i).R_Stance_Phase.mean,'%2.2f'),' +/- ',...
            num2str(Param(i).R_Stance_Phase.std,'%2.2f')];
        barh(size(Condition,2)-i+1,100,'FaceColor','none');
        barh(size(Condition,2)-i+1,Param(i).R_Stance_Phase.mean,'FaceColor',colorR(i,:));
        barh(size(Condition,2)-i+1,Param(i).R_Stance_Phase.mean+Param(i).R_Stance_Phase.std,...
            'FaceColor','none','LineStyle','-');
        barh(size(Condition,2)-i+1,Param(i).R_Stance_Phase.mean-Param(i).R_Stance_Phase.std,...
            'FaceColor','none','LineStyle','-');
    end
    barh(size(Condition,2)+1,100,'FaceColor','none');
    barh(size(Condition,2)+1,Norm.right_stance_phase.mean,'FaceColor',[0.5 0.5 0.5]);
    barh(size(Condition,2)+1,Norm.right_stance_phase.mean+Norm.right_stance_phase.std,...
        'FaceColor','none','LineStyle','-');
    barh(size(Condition,2)+1,Norm.right_stance_phase.mean-Norm.right_stance_phase.std,...
        'FaceColor','none','LineStyle','-');
    Labels{size(Condition,2)+1} = [num2str(Norm.right_stance_phase.mean,'%2.2f'),' +/- ',...
        num2str(Norm.right_stance_phase.std,'%2.2f')];
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    xlim([0 100]);
    box on;
    
    % Step width
    % ---------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Graph(9) = axes('position',[x(1)/pageWidth y/pageHeight graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(9),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:.05:1);
    hold on;
    title('Step width (m)','FontWeight','Bold');
    for i = size(Condition,2):-1:1
        Labels{size(Condition,2)-i+1} = [num2str(Param(i).Stride_Width.mean,'%2.2f'),'  +/-  ',num2str(Param(i).Stride_Width.std,'%2.2f')];
        barh(size(Condition,2)-i+1,Param(i).Stride_Width.mean,'FaceColor',colorB(i,:));
        barh(size(Condition,2)-i+1,Param(i).Stride_Width.mean+Param(i).Stride_Width.std,'FaceColor','none','LineStyle','-');
        barh(size(Condition,2)-i+1,Param(i).Stride_Width.mean-Param(i).Stride_Width.std,'FaceColor','none','LineStyle','-');
    end
    barh(size(Condition,2)+1,Norm.step_width.mean,'FaceColor',[0.5 0.5 0.5]);
    barh(size(Condition,2)+1,Norm.step_width.mean+Norm.step_width.std,'FaceColor','none','LineStyle','-');
    barh(size(Condition,2)+1,Norm.step_width.mean-Norm.step_width.std,'FaceColor','none','LineStyle','-');
    Labels{size(Condition,2)+1} = [num2str(Norm.step_width.mean,'%2.2f'),'  +/-  ',num2str(Norm.step_width.std,'%2.2f')];
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    xlim([0 0.4]);
    box on;
    
    % Double support
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Graph(4) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(4),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',-100:10:100);
    hold on;
    title('Double support (%)','FontWeight','Bold');
%     for i = size(Condition,2):-1:1
%         Labels{size(Condition,2)-i+1} = [num2str(Param(i).total_double_support.mean,'%2.2f'),' +/- ',...
%             num2str(Param(i).total_double_support.std,'%2.2f')];
%         barh(size(Condition,2)-i+1,Param(i).total_double_support.mean,'FaceColor',colorB(i,:));
%         barh(size(Condition,2)-i+1,Param(i).total_double_support.mean+Param(i).total_double_support.std,...
%             'FaceColor','none','LineStyle','-');
%         barh(size(Condition,2)-i+1,Param(i).total_double_support.mean-Param(i).total_double_support.std,...
%             'FaceColor','none','LineStyle','-');
%     end
%     barh(size(Condition,2)+1,Norm.total_double_support.mean,'FaceColor',[0.5 0.5 0.5]);
%     barh(size(Condition,2)+1,Norm.total_double_support.mean+Norm.total_double_support.std,...
%         'FaceColor','none','LineStyle','-');
%     barh(size(Condition,2)+1,Norm.total_double_support.mean-Norm.total_double_support.std,...
%         'FaceColor','none','LineStyle','-');
%     Labels{size(Condition,2)+1} = [num2str(Norm.total_double_support.mean,'%2.2f'),' +/- ',...
%         num2str(Norm.total_double_support.std,'%2.2f')];
%     set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    xlim([0 100]);
    box on;
    
    % Cadence
    % ---------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Graph(7) = axes('position',[x(1)/pageWidth y/pageHeight graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(7),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:20:160);
    hold on;
    title('Cadence (step/min)','FontWeight','Bold');
    for i = size(Condition,2):-1:1
        Labels{size(Condition,2)-i+1} = [num2str(Param(i).Cadence.mean,'%2.2f'),'  +/-  ',num2str(Param(i).Cadence.std,'%2.2f')];
        barh(size(Condition,2)-i+1,Param(i).Cadence.mean,'FaceColor',colorB(i,:));
        barh(size(Condition,2)-i+1,Param(i).Cadence.mean+Param(i).Cadence.std,'FaceColor','none','LineStyle','-');
        barh(size(Condition,2)-i+1,Param(i).Cadence.mean-Param(i).Cadence.std,'FaceColor','none','LineStyle','-');
    end
    barh(size(Condition,2)+1,Norm.cadence.mean,'FaceColor',[0.5 0.5 0.5]);
    barh(size(Condition,2)+1,Norm.cadence.mean+Norm.cadence.std,'FaceColor','none','LineStyle','-');
    barh(size(Condition,2)+1,Norm.cadence.mean-Norm.cadence.std,'FaceColor','none','LineStyle','-');
    Labels{size(Condition,2)+1} = [num2str(Norm.cadence.mean,'%2.2f'),'  +/-  ',num2str(Norm.cadence.std,'%2.2f')];
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    xlim([0 160]);
    box on;
    
    if ~strcmp(Session(i).markerSet,'Paramètres') && ~strcmp(Session(i).markerSet,'Aucun')
        % Mean velocity
        % ---------------------------------------------------------------------
        y = y - yincr*6.5;
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        clear Labels;
        Graph(8) = axes('position',[x(1)/pageWidth y/pageHeight graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(8),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:0.2:2);
        hold on;
        title('Mean velocity (m/s)','FontWeight','Bold');
        for i = size(Condition,2):-1:1
            Labels{size(Condition,2)-i+1} = [num2str(Param(i).Velocity.mean,'%2.2f'),'  +/-  ',num2str(Param(i).Velocity.std,'%2.2f')];
            barh(size(Condition,2)-i+1,Param(i).Velocity.mean,'FaceColor',colorB(i,:));
            barh(size(Condition,2)-i+1,Param(i).Velocity.mean+Param(i).Velocity.std,'FaceColor','none','LineStyle','-');
            barh(size(Condition,2)-i+1,Param(i).Velocity.mean-Param(i).Velocity.std,'FaceColor','none','LineStyle','-');
        end
        barh(size(Condition,2)+1,Norm.mean_velocity.mean,'FaceColor',[0.5 0.5 0.5]);
        barh(size(Condition,2)+1,Norm.mean_velocity.mean+Norm.mean_velocity.std,'FaceColor','none','LineStyle','-');
        barh(size(Condition,2)+1,Norm.mean_velocity.mean-Norm.mean_velocity.std,'FaceColor','none','LineStyle','-');
        Labels{size(Condition,2)+1} = [num2str(Norm.mean_velocity.mean,'%2.2f'),'  +/-  ',num2str(Norm.mean_velocity.std,'%2.2f')];
        set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
        xlim([0 2]);
        box on;
    end
    
    % Set the page for left side parameters
    % ---------------------------------------------------------------------
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
        '  Paramètres spatio-temporaux',...
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
    
    % Left step length
    % ---------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Graph(6) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(6),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:.1:2);
    hold on;
    title('Step length (m)','FontWeight','Bold');
    for i = size(Condition,2):-1:1
        Labels{size(Condition,2)-i+1} = [num2str(Param(i).L_Step_Length.mean,'%2.2f'),' +/- ',...
            num2str(Param(i).L_Step_Length.std,'%2.2f')];
        barh(size(Condition,2)-i+1,Param(i).L_Step_Length.mean,'FaceColor',colorL(i,:));
        barh(size(Condition,2)-i+1,Param(i).L_Step_Length.mean+Param(i).L_Step_Length.std,...
            'FaceColor','none','LineStyle','-');
        barh(size(Condition,2)-i+1,Param(i).L_Step_Length.mean-Param(i).L_Step_Length.std,...
            'FaceColor','none','LineStyle','-');
    end
    barh(size(Condition,2)+1,Norm.left_step_length.mean,'FaceColor',[0.5 0.5 0.5]);
    barh(size(Condition,2)+1,Norm.left_step_length.mean+Norm.left_step_length.std,...
        'FaceColor','none','LineStyle','-');
    barh(size(Condition,2)+1,Norm.left_step_length.mean-Norm.left_step_length.std,...
        'FaceColor','none','LineStyle','-');
    Labels{size(Condition,2)+1} = [num2str(Norm.left_step_length.mean,'%2.2f'),'.+/- ',...
        num2str(Norm.left_step_length.std,'%2.2f')];
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    xlim([0 0.8]);
    box on;
    
    % Left gait cycle time
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Graph(2) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(2),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:.2:2);
    hold on;
    title('Gait cycle time (s)','FontWeight','Bold');
    for i = size(Condition,2):-1:1
        Labels{size(Condition,2)-i+1} = [num2str(Param(i).L_Gait_Cycle.mean,'%2.2f'),' +/- ',...
            num2str(Param(i).L_Gait_Cycle.std,'%2.2f')];
        barh(size(Condition,2)-i+1,Param(i).L_Gait_Cycle.mean,'FaceColor',colorL(i,:));
        barh(size(Condition,2)-i+1,Param(i).L_Gait_Cycle.mean+Param(i).L_Gait_Cycle.std,...
            'FaceColor','none','LineStyle','-');
        barh(size(Condition,2)-i+1,Param(i).L_Gait_Cycle.mean-Param(i).L_Gait_Cycle.std,...
            'FaceColor','none','LineStyle','-');
    end
    barh(size(Condition,2)+1,Norm.left_gait_cycle.mean,'FaceColor',[0.5 0.5 0.5]);
    barh(size(Condition,2)+1,Norm.left_gait_cycle.mean+Norm.left_gait_cycle.std,...
        'FaceColor','none','LineStyle','-');
    barh(size(Condition,2)+1,Norm.left_gait_cycle.mean-Norm.left_gait_cycle.std,...
        'FaceColor','none','LineStyle','-');
    Labels{size(Condition,2)+1} = [num2str(Norm.left_gait_cycle.mean,'%2.2f'),'  +/-  ',...
        num2str(Norm.left_gait_cycle.std,'%2.2f')];
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    xlim([0 2]);
    box on;
    
    % Left stride length
    % ---------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Graph(5) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(5),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:.2:2);
    hold on;
    title('Stride length (m)','FontWeight','Bold');
    for i = size(Condition,2):-1:1
        Labels{size(Condition,2)-i+1} = [num2str(Param(i).L_Stride_Length.mean,'%2.2f'),' +/- ',...
            num2str(Param(i).L_Stride_Length.std,'%2.2f')];
        barh(size(Condition,2)-i+1,Param(i).L_Stride_Length.mean,'FaceColor',colorL(i,:));
        barh(size(Condition,2)-i+1,Param(i).L_Stride_Length.mean+Param(i).L_Stride_Length.std,...
            'FaceColor','none','LineStyle','-');
        barh(size(Condition,2)-i+1,Param(i).L_Stride_Length.mean-Param(i).L_Stride_Length.std,...
            'FaceColor','none','LineStyle','-');
    end
    barh(size(Condition,2)+1,Norm.left_stride_length.mean,'FaceColor',[0.5 0.5 0.5]);
    barh(size(Condition,2)+1,Norm.left_stride_length.mean+Norm.left_stride_length.std,...
        'FaceColor','none','LineStyle','-');
    barh(size(Condition,2)+1,Norm.left_stride_length.mean-Norm.left_stride_length.std,...
        'FaceColor','none','LineStyle','-');
    Labels{size(Condition,2)+1} = [num2str(Norm.left_stride_length.mean,'%2.2f'),' +/- ',...
        num2str(Norm.left_stride_length.std,'%2.2f')];
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    xlim([0 1.6]);
    box on;
    
    % Stance/swing
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Graph(1) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(1),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:10:100);
    hold on;
    title('Stance/Swing phases (%)','FontWeight','Bold');
    for i = size(Condition,2):-1:1
        Labels{size(Condition,2)-i+1} = [num2str(Param(i).L_Stance_Phase.mean,'%2.2f'),' +/- ',...
            num2str(Param(i).L_Stance_Phase.std,'%2.2f')];
        barh(size(Condition,2)-i+1,100,'FaceColor','none');
        barh(size(Condition,2)-i+1,Param(i).L_Stance_Phase.mean,'FaceColor',colorL(i,:));
        barh(size(Condition,2)-i+1,Param(i).L_Stance_Phase.mean+Param(i).L_Stance_Phase.std,...
            'FaceColor','none','LineStyle','-');
        barh(size(Condition,2)-i+1,Param(i).L_Stance_Phase.mean-Param(i).L_Stance_Phase.std,...
            'FaceColor','none','LineStyle','-');
    end
    barh(size(Condition,2)+1,100,'FaceColor','none');
    barh(size(Condition,2)+1,Norm.left_stance_phase.mean,'FaceColor',[0.5 0.5 0.5]);
    barh(size(Condition,2)+1,Norm.left_stance_phase.mean+Norm.left_stance_phase.std,...
        'FaceColor','none','LineStyle','-');
    barh(size(Condition,2)+1,Norm.left_stance_phase.mean-Norm.left_stance_phase.std,...
        'FaceColor','none','LineStyle','-');
    Labels{size(Condition,2)+1} = [num2str(Norm.left_stance_phase.mean,'%2.2f'),' +/- ',...
        num2str(Norm.left_stance_phase.std,'%2.2f')];
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    xlim([0 100]);
    box on;
    
    % Step width
    % ---------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Graph(9) = axes('position',[x(1)/pageWidth y/pageHeight graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(9),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:.05:1);
    hold on;
    title('Step width (m)','FontWeight','Bold');
    for i = size(Condition,2):-1:1
        Labels{size(Condition,2)-i+1} = [num2str(Param(i).Stride_Width.mean,'%2.2f'),'  +/-  ',num2str(Param(i).Stride_Width.std,'%2.2f')];
        barh(size(Condition,2)-i+1,Param(i).Stride_Width.mean,'FaceColor',colorB(i,:));
        barh(size(Condition,2)-i+1,Param(i).Stride_Width.mean+Param(i).Stride_Width.std,'FaceColor','none','LineStyle','-');
        barh(size(Condition,2)-i+1,Param(i).Stride_Width.mean-Param(i).Stride_Width.std,'FaceColor','none','LineStyle','-');
    end
    barh(size(Condition,2)+1,Norm.step_width.mean,'FaceColor',[0.5 0.5 0.5]);
    barh(size(Condition,2)+1,Norm.step_width.mean+Norm.step_width.std,'FaceColor','none','LineStyle','-');
    barh(size(Condition,2)+1,Norm.step_width.mean-Norm.step_width.std,'FaceColor','none','LineStyle','-');
    Labels{size(Condition,2)+1} = [num2str(Norm.step_width.mean,'%2.2f'),...
        '  +/-  ',num2str(Norm.step_width.std,'%2.2f')];
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    xlim([0 0.4]);
    box on;
    
    % Double support
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Graph(4) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(4),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',-100:10:100);
    hold on;
    title('Double support (%)','FontWeight','Bold');
%     for i = size(Condition,2):-1:1
%         Labels{size(Condition,2)-i+1} = [num2str(Param(i).total_double_support.mean,'%2.2f'),' +/- ',...
%             num2str(Param(i).total_double_support.std,'%2.2f')];
%         barh(size(Condition,2)-i+1,Param(i).total_double_support.mean,'FaceColor',colorB(i,:));
%         barh(size(Condition,2)-i+1,Param(i).total_double_support.mean+Param(i).total_double_support.std,...
%             'FaceColor','none','LineStyle','-');
%         barh(size(Condition,2)-i+1,Param(i).total_double_support.mean-Param(i).total_double_support.std,...
%             'FaceColor','none','LineStyle','-');
%     end
%     barh(size(Condition,2)+1,Norm.total_double_support.mean,'FaceColor',[0.5 0.5 0.5]);
%     barh(size(Condition,2)+1,Norm.total_double_support.mean+Norm.total_double_support.std,...
%         'FaceColor','none','LineStyle','-');
%     barh(size(Condition,2)+1,Norm.total_double_support.mean-Norm.total_double_support.std,...
%         'FaceColor','none','LineStyle','-');
%     Labels{size(Condition,2)+1} = [num2str(Norm.total_double_support.mean,'%2.2f'),' +/- ',...
%         num2str(Norm.total_double_support.std,'%2.2f')];
%     set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    xlim([0 100]);
    box on;
    
    % Cadence
    % ---------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Graph(7) = axes('position',[x(1)/pageWidth y/pageHeight graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(7),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:20:160);
    hold on;
    title('Cadence (step/min)','FontWeight','Bold');
    for i = size(Condition,2):-1:1
        Labels{size(Condition,2)-i+1} = [num2str(Param(i).Cadence.mean,'%2.2f'),'  +/-  ',num2str(Param(i).Cadence.std,'%2.2f')];
        barh(size(Condition,2)-i+1,Param(i).Cadence.mean,'FaceColor',colorB(i,:));
        barh(size(Condition,2)-i+1,Param(i).Cadence.mean+Param(i).Cadence.std,'FaceColor','none','LineStyle','-');
        barh(size(Condition,2)-i+1,Param(i).Cadence.mean-Param(i).Cadence.std,'FaceColor','none','LineStyle','-');
    end
    barh(size(Condition,2)+1,Norm.cadence.mean,'FaceColor',[0.5 0.5 0.5]);
    barh(size(Condition,2)+1,Norm.cadence.mean+Norm.cadence.std,'FaceColor','none','LineStyle','-');
    barh(size(Condition,2)+1,Norm.cadence.mean-Norm.cadence.std,'FaceColor','none','LineStyle','-');
    Labels{size(Condition,2)+1} = [num2str(Norm.cadence.mean,'%2.2f'),'  +/-  ',num2str(Norm.cadence.std,'%2.2f')];
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    xlim([0 160]);
    box on;
    
    if ~strcmp(Session(i).markerSet,'Aucun')
        % Mean velocity
        % ---------------------------------------------------------------------
        y = y - yincr*6.5;
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        clear Labels;
        Graph(8) = axes('position',[x(1)/pageWidth y/pageHeight graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(8),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:0.2:2);
        hold on;
        title('Mean velocity (m/s)','FontWeight','Bold');
        for i = size(Condition,2):-1:1
            Labels{size(Condition,2)-i+1} = [num2str(Param(i).Velocity.mean,'%2.2f'),'  +/-  ',num2str(Param(i).Velocity.std,'%2.2f')];
            barh(size(Condition,2)-i+1,Param(i).Velocity.mean,'FaceColor',colorB(i,:));
            barh(size(Condition,2)-i+1,Param(i).Velocity.mean+Param(i).Velocity.std,'FaceColor','none','LineStyle','-');
            barh(size(Condition,2)-i+1,Param(i).Velocity.mean-Param(i).Velocity.std,'FaceColor','none','LineStyle','-');
        end
        barh(size(Condition,2)+1,Norm.mean_velocity.mean,'FaceColor',[0.5 0.5 0.5]);
        barh(size(Condition,2)+1,Norm.mean_velocity.mean+Norm.mean_velocity.std,'FaceColor','none','LineStyle','-');
        barh(size(Condition,2)+1,Norm.mean_velocity.mean-Norm.mean_velocity.std,'FaceColor','none','LineStyle','-');
        Labels{size(Condition,2)+1} = [num2str(Norm.mean_velocity.mean,'%2.2f'),'  +/-  ',num2str(Norm.mean_velocity.std,'%2.2f')];
        set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
        xlim([0 2]);
        box on;
    end
    
end