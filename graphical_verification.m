function graphical_verification(Normatives,Population)
%% ////////////////////////////////////////////////////////////////////////
% GRAPHE P1 - CINEMATIQUE

% Quelques parametres de mise en page...
%--------------------------------------------------------------------------
Largeur = 21;
Hauteur = 29.7;
yinit = 29.0;
yincr = 0.5;
x=[1.5 8 14.5];
JKin=Normatives.Jointkinematics;
SKin=Normatives.Segmentkinematics;
Event=Normatives.Spatiotemporal.R_Stance_Phase;
    
%////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%% GENERATION DE LA PAGE 1 : CINEMATIQUE DROITE et GAUCHE si moyenne pour 1! condition
%                            CINEMATIQUE DROITE si plusieurs conditions
%  GENERATION DE LA PAGE 2 : CINEMATIQUE GAUCHE si plusieurs conditions
%////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
f(1) = figure('PaperOrientation','portrait','papertype','A4','Units',...
'centimeters','Position',[0 0 Largeur Hauteur],'Color','white',...
'PaperUnits','centimeters','PaperPosition',[0 0 Largeur Hauteur]);

%% ------------Affichage Logo REHAZENTER-----------------------------------
%--------------------------------------------------------------------------
logo=imread('logo','png');
AxesImages = axes('position',[14.5/Largeur 27.7/Hauteur 6/Largeur 2/Hauteur]);
image(logo);
set(AxesImages,'Visible','Off');

%% ------------Affichage Entête
%--------------------------------------------------------------------------
AxesTextes = axes;
hold on;
set(AxesTextes,'Position',[0 0 1 1]);
axis manual;
set(AxesTextes,'Visible','Off');

y = yinit;
text(0.5/Largeur,y/Hauteur,'Rehazenter','color','k');
y = y - yincr;
text(0.5/Largeur,y/Hauteur,'Centre de Rééducation et de Réadaptation Fonctionnelle','color','k');
y = y - yincr;
text(0.5/Largeur,y/Hauteur,'Laboratoire d''Analyse du Mouvement','color','k');
y = y - yincr;
% text(0.5/Largeur,y/Hauteur,'Dr. Paul Filipetti','color','k');


%% ------------TITRE
%--------------------------------------------------------------------------
y = y - yincr;
text(10.5/Largeur,y/Hauteur,'CINEMATIQUE','color','k','FontWeight','Bold','HorizontalAlignment','Center')
y = y - yincr;
if exist('ajoutTitre','var')
    text(10.5/Largeur,y/Hauteur,ajoutTitre,'color','k','FontWeight','Bold','HorizontalAlignment','Center')
end
y = y - yincr;
if exist('LigneSignifDiff','var')
    if isfield(LigneSignifDiff,'VarianceInfo')
        text(10.5/Largeur,y/Hauteur, LigneSignifDiff.VarianceInfo  ,'color','k','FontWeight','Bold','HorizontalAlignment','Center')
    end
end

%% ------------Affichage Informations Patient
%--------------------------------------------------------------------------

if ~isempty(Population)
    y = y - yincr;  % reprise de l'ancien y pour etre a la suite de Clinicien
    text(0.5/Largeur,y/Hauteur,['Pathologie: Normes     Nombre de sujets: ' num2str(Population.nsujets)]);
    y = y - yincr;
    text(0.5/Largeur,y/Hauteur,['Age moyen: ' num2str(Population.age.mean, '% 10.1f') ' ans    Taille moyenne: ' num2str(Population.height.mean, '% 10.2f') ' m    Poids moyen:  ' num2str(Population.weight.mean, '% 10.1f') ' Kg    Genre (Ho):  ' num2str(Population.gender.homme*100, '% 10.1f') '%']);
    y = y - yincr;
    text(0.5/Largeur,y/Hauteur,['Nombre d''essais cinematiques: ' num2str(Population.nkinematics)...
        '     Nombre d''essais cinétiques: ' num2str(Population.ndynamics) ...
        '     Vitesse moyenne: ' num2str(Normatives.Spatiotemporal.Velocity.mean, '% 10.2f') ' m/s +/-' num2str(Normatives.Spatiotemporal.Velocity.std, '% 10.2f')]);
    y = y - yincr;
end
    
%-------------------------------
%   GRAPHIQUES
%-------------------------------

%-----------------------%
%%    Pelvis Tilt       %%
%-----------------------%
y = y - 6;
Graph(1) = axes('position',[x(2)/Largeur y/Hauteur 5.5/Largeur 4/Hauteur]);
set(Graph(1),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Pelvic tilt (Ant+)','FontWeight','Bold');%'BackGroundColor',[245/256 243/256 89/256],
ylabel('Degree','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');

plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
if ~isempty(SKin.R_Pelvis_Angle_FE.mean)
    corridor(SKin.R_Pelvis_Angle_FE.mean,SKin.R_Pelvis_Angle_FE.std,'r');
    plot(SKin.R_Pelvis_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color','r');
end
axis tight;
axis([0 100 -40 40]);

%----------------------------%
%%    Pelvis Obliquity        %%
%----------------------------%
Graph(2) = axes('position',[x(1)/Largeur y/Hauteur 5.5/Largeur 4/Hauteur]);
set(Graph(2),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Pelvic obliquity','FontWeight','Bold');%'BackGroundColor',[245/256 243/256 89/256],
ylabel('Degree','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');

plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
if ~isempty(SKin.R_Pelvis_Angle_AA.mean)
    corridor(SKin.R_Pelvis_Angle_AA.mean,SKin.R_Pelvis_Angle_AA.std,'r');
    plot(SKin.R_Pelvis_Angle_AA.mean,'Linestyle','-','Linewidth',2,'Color','r');
end
axis tight;
axis([0 100 -40 40]);

%----------------------------%
%%    Pelvis Rotation         %%
%----------------------------%
Graph(3) = axes('position',[x(3)/Largeur y/Hauteur 5.5/Largeur 4/Hauteur]);
set(Graph(3),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Pelvic rotation','FontWeight','Bold');%'BackGroundColor',[245/256 243/256 89/256],
ylabel('Degree','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');

plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
if ~isempty(SKin.R_Pelvis_Angle_IER.mean)
    corridor(SKin.R_Pelvis_Angle_IER.mean,SKin.R_Pelvis_Angle_IER.std,'r');
    plot(SKin.R_Pelvis_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color','r');
end
axis tight;
axis([0 100 -40 40]);
% *************************************************************************
%----------------------------%
%%     Hip Flex/Ext        %%
%----------------------------%
y = y - 5;
Graph(4) = axes('position',[x(2)/Largeur y/Hauteur 5.5/Largeur 4/Hauteur]);
set(Graph(4),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Hip flex/ext (flex+)','FontWeight','Bold');%'BackGroundColor',[89/256 157/256 233/256],
ylabel('Degree','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');

plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
if ~isempty(JKin.R_Hip_Angle_FE.mean)
    corridor(JKin.R_Hip_Angle_FE.mean,JKin.R_Hip_Angle_FE.std,'r');
    plot(JKin.R_Hip_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color','r');
end
axis tight;
axis([0 100 -40 40]);

%----------------------------%
%%     Hip Obliquity        %%
%----------------------------%
Graph(5) = axes('position',[x(1)/Largeur y/Hauteur 5.5/Largeur 4/Hauteur]);
set(Graph(5),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Hip obliquity','FontWeight','Bold');%'BackGroundColor',[89/256 157/256 233/256],
ylabel('Degree','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');

plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
if ~isempty(JKin.R_Hip_Angle_AA.mean)
    corridor(-JKin.R_Hip_Angle_AA.mean,JKin.R_Hip_Angle_AA.std,'r');
    plot(-JKin.R_Hip_Angle_AA.mean,'Linestyle','-','Linewidth',2,'Color','r');
end
axis tight;
axis([0 100 -40 40]);

%-------------------------%
%%     Hip Rotation        %%
%-------------------------%
Graph(6) = axes('position',[x(3)/Largeur y/Hauteur 5.5/Largeur 4/Hauteur]);
set(Graph(6),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Hip rotation','FontWeight','Bold');%'BackGroundColor',[89/256 157/256 233/256],
ylabel('Degree','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');

plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
if ~isempty(JKin.R_Hip_Angle_IER.mean)
    corridor(JKin.R_Hip_Angle_IER.mean,JKin.R_Hip_Angle_IER.std,'r');
    plot(JKin.R_Hip_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color','r');
end
axis tight;
axis([0 100 -40 40]);

% *************************************************************************
%----------------------------%
%%     Knee Flex/Ext        %%
%----------------------------%
y = y - 5;
Graph(7) = axes('position',[x(2)/Largeur y/Hauteur 5.5/Largeur 4/Hauteur]);
set(Graph(7),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Knee flex/ext (flex+)','FontWeight','Bold');%'BackGroundColor',[242/256 156/256 34/256],
ylabel('Degree','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');

plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
if ~isempty(JKin.R_Knee_Angle_FE.mean)
    corridor(JKin.R_Knee_Angle_FE.mean,JKin.R_Knee_Angle_FE.std,'r');
    plot(JKin.R_Knee_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color','r');
end
axis tight;
axis([0 100 -20 60]);

%-------------------------%
%%     Clearance           %%
%-------------------------%
% % Graph(8) = axes('position',[x(3)/Largeur y/Hauteur 5.5/Largeur 4/Hauteur]);
% % set(Graph(8),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-.1:.01:1);
% % hold on;
% % title('Clearance','FontWeight','Bold');% 'BackGroundColor',[251/256 83/256 178/256],
% % ylabel('m','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
% %
% % plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
% % if ~isempty(Kin.Clearance.mean)
% %     corridor(Kin.Clearance.mean,Kin.Clearance.std,'r');
% %     plot(Kin.Clearance.mean,'Linestyle','-','Linewidth',2,'Color','r');
% % end
% % axis([0 100 0 0.1]);
% % % *************************************************************************
%-------------------------%
%%     Ankle Flex/Ext      %%
%-------------------------%
y = y - 5;
Graph(8) = axes('position',[x(2)/Largeur y/Hauteur 5.5/Largeur 4/Hauteur]);
set(Graph(8),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Ankle flex/ext (dors+)','FontWeight','Bold');%,'BackGroundColor',[251/256 83/256 178/256]
xlabel('% cycle','FontSize',8);
ylabel('Degree','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');

plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
if ~isempty(JKin.R_Ankle_Angle_FE.mean)
    corridor(JKin.R_Ankle_Angle_FE.mean,JKin.R_Ankle_Angle_FE.std,'r');
    plot(JKin.R_Ankle_Angle_FE.mean,'Linestyle','-','Linewidth',2,'Color','r');
end
axis tight;
axis([0 100 -40 40]);
%--------------------------------%
%%     Foot varus/valgus          %%
%--------------------------------%
Graph(9) = axes('position',[x(1)/Largeur y/Hauteur 5.5/Largeur 4/Hauteur]);
set(Graph(9),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Foot varus/valgus','FontWeight','Bold');% 'BackGroundColor',[251/256 83/256 178/256],
xlabel('% cycle','FontSize',8);
ylabel('Degree','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');

plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
if ~isempty(JKin.R_Ankle_Angle_AA.mean)
    corridor(JKin.R_Ankle_Angle_AA.mean,JKin.R_Ankle_Angle_AA.std,'r');
    plot(JKin.R_Ankle_Angle_AA.mean,'Linestyle','-','Linewidth',2,'Color','r');
end
axis tight;
axis([0 100 -40 40]);
%--------------------------------%
%%     Foot progression           %%
%--------------------------------%
Graph(10) = axes('position',[x(3)/Largeur y/Hauteur 5.5/Largeur 4/Hauteur]);
set(Graph(10),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Foot progression (ext+)','FontWeight','Bold');% 'BackGroundColor',[251/256 83/256 178/256],
xlabel('% cycle','FontSize',8);
ylabel('Degree','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');

plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
if ~isempty(SKin.R_Foot_Angle_IER.mean)
    corridor(-SKin.R_Foot_Angle_IER.mean,SKin.R_Foot_Angle_IER.std,'r');
    plot(-SKin.R_Foot_Angle_IER.mean,'Linestyle','-','Linewidth',2,'Color','r');
end
axis tight;
axis([0 100 -40 40]);

%**************************************************************************
%% Events
for g=1:length(Graph)
    axes(Graph(g));YL=ylim;
    corridor(Event.mean,Event.std,'r');
    plot([Event.mean Event.mean],[-180 180],'Linestyle','-','Linewidth',2,'Color','r'); %IHS
end

%% Graphe P2 - EMG

% Quelques parametres de mise en page...
%--------------------------------------------------------------------------
Largeur = 21;
Hauteur = 29.7;
LargeurGraphe = 8;
HauteurGraphe = 3.5;
yinit = 29.0;
yincr = 0.5;
x=[1.5 10.5];
EMG=Normatives.EMG;
Event=Normatives.Spatiotemporal.R_Stance_Phase;
X=0:1:100;
Y=ones(1,101);

f(2) = figure('PaperOrientation','portrait','papertype','A4','Units',...
    'centimeters','Position',[0 0 Largeur Hauteur],'Color','white',...
    'PaperUnits','centimeters','PaperPosition',[0 0 Largeur Hauteur]);

%% ------------Affichage Logo REHAZENTER-----------------------------------
%--------------------------------------------------------------------------
logo=imread('logo','png');
AxesImages = axes('position',[14.5/Largeur 27.7/Hauteur 6/Largeur 2/Hauteur]);
image(logo);
set(AxesImages,'Visible','Off');

%% ------------Affichage Entête
%--------------------------------------------------------------------------
AxesTextes = axes;
hold on;
set(AxesTextes,'Position',[0 0 1 1]);
axis manual;
set(AxesTextes,'Visible','Off');

y = yinit;
text(0.5/Largeur,y/Hauteur,'Rehazenter','color','k');
y = y - yincr;
text(0.5/Largeur,y/Hauteur,'Centre de Rééducation et de Réadaptation Fonctionnelle','color','k');
y = y - yincr;
text(0.5/Largeur,y/Hauteur,'Laboratoire d''Analyse du Mouvement','color','k');
y = y - yincr;

%% ------------TITRE
%--------------------------------------------------------------------------
y = y - yincr;
text(10.5/Largeur,y/Hauteur,'EMG','color','k','FontWeight','Bold','HorizontalAlignment','Center')
y = y - yincr;
if exist('ajoutTitre','var')
    text(10.5/Largeur,y/Hauteur,ajoutTitre,'color','k','FontWeight','Bold','HorizontalAlignment','Center')
end
y = y - yincr;
if exist('LigneSignifDiff','var')
    if isfield(LigneSignifDiff,'VarianceInfo')
        text(10.5/Largeur,y/Hauteur, LigneSignifDiff.VarianceInfo  ,'color','k','FontWeight','Bold','HorizontalAlignment','Center')
    end
end

%% ------------Affichage Informations Patient
%--------------------------------------------------------------------------
if ~isempty(Population)
    y = y - yincr;  % reprise de l'ancien y pour etre a la suite de Clinicien
    text(0.5/Largeur,y/Hauteur,['Pathologie: Normes     Nombre de sujets: ' num2str(Population.nsujets)]);
    y = y - yincr;
    text(0.5/Largeur,y/Hauteur,['Age moyen: ' num2str(Population.age.mean, '% 10.1f') ' ans    Taille moyenne: ' num2str(Population.height.mean, '% 10.2f') ' m    Poids moyen:  ' num2str(Population.weight.mean, '% 10.1f') ' Kg    Genre (Ho):  ' num2str(Population.gender.homme*100, '% 10.1f') '%']);
    y = y - yincr;
    text(0.5/Largeur,y/Hauteur,['Nombre d''essais cinematiques: ' num2str(Population.nkinematics)...
        '     Nombre d''essais EMG: ' num2str(Population.nEMG) ...
        '     Vitesse moyenne: ' num2str(Normatives.Spatiotemporal.Velocity.mean, '% 10.2f') ' m/s +/-' num2str(Normatives.Spatiotemporal.Velocity.std, '% 10.2f')]);
    y = y - yincr;
end

%-------------------------------
%   GRAPHIQUES
%-------------------------------

namesEmg=fieldnames(EMG);
y=y-6;
for i=1:length(namesEmg)
    Graph2(i) = axes('position',[x(-mod(i,2)+2)/Largeur y/Hauteur LargeurGraphe/Largeur HauteurGraphe/Hauteur]);
    set(Graph2(i),'FontSize',8,'YGrid','on','XTick',0:10:100,'YTick',[ ]);
    hold on;
    T=char(namesEmg(i));
    T(find(T=='_'))=' ';
    title(T,'FontWeight','Bold');
    ylabel('V','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    corridor(EMG.(namesEmg{i}).mean,EMG.(namesEmg{i}).std,'k');
    plot(EMG.(namesEmg{i}).mean,'Linestyle','-','Linewidth',2,'Color','k');
    axis tight;YL=ylim;axis([0 100 YL(1) YL(2)]);
    y=(y-5*(mod(i,2)==0));
end

end