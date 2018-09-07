Output=Condition;
load('C:\Users\celine.schreiber\Documents\MATLAB\Toolbox_Rehazenter_Normatives\normativeData\2014-07-11_SS2014006_SS2014006_1991-09-22_piste_-_vitesse_max_0.4ms.mat')

for i=3:3
    figure;plot(Condition.Posturo(i).Rangle.Hgr_obli)
    hold on;plot(permute(Output(1).Trial(i).HeadTrunk.Rside.Segment(1).AA,[3,2,1]),'g')
    figure;plot(Condition.Posturo(i).Rangle.Hgr_tilt)
    hold on;plot(permute(Output(1).Trial(i).HeadTrunk.Rside.Segment(1).FE,[3,2,1]),'g')
    figure;plot(Condition.Posturo(i).Rangle.Hgr_rota)
    hold on;plot(permute(Output(1).Trial(i).HeadTrunk.Rside.Segment(1).IER,[3,2,1]),'g')
    figure;plot(Condition.Posturo(i).Rangle.Pgr_tilt)                         
    hold on;plot(permute(Output(1).Trial(i).HeadTrunk.Rside.Segment(4).FE,[3,2,1]),'g')%OK
    figure;plot(Condition.Posturo(i).Rangle.Pgr_obli)                     
    hold on;plot(permute(Output(1).Trial(i).HeadTrunk.Rside.Segment(4).AA,[3,2,1]),'g')%OK
    figure;plot(Condition.Posturo(i).Rangle.Pgr_rota)
    hold on;plot(permute(Output(1).Trial(i).HeadTrunk.Rside.Segment(4).IER,[3,2,1]),'g')%OK
    figure;plot(Condition.Posturo(i).Rangle.Rgr_tilt)
    hold on;plot(permute(Output(1).Trial(i).HeadTrunk.Rside.Segment(3).FE,[3,2,1]),'g')%OK
    figure;plot(Condition.Posturo(i).Rangle.Rgr_rota)
    hold on;plot(permute(Output(1).Trial(i).HeadTrunk.Rside.Segment(3).IER,[3,2,1]),'g')%OK
    figure;plot(Condition.Posturo(i).Rangle.Rgr_obli)
    hold on;plot(permute(Output(1).Trial(i).HeadTrunk.Rside.Segment(3).AA,[3,2,1]),'g')%OK
    
    figure;plot(Condition.Posturo(i).Rangle.Hseg_obli)
    hold on;plot(permute(Output(1).Trial(i).HeadTrunk.Rside.Joint(1).AA,[3,2,1]),'g')
    figure;plot(Condition.Posturo(i).Rangle.Hseg_tilt)
    hold on;plot(permute(Output(1).Trial(i).HeadTrunk.Rside.Joint(1).FE,[3,2,1]),'g')
    figure;plot(Condition.Posturo(i).Rangle.Hseg_rota)
    hold on;plot(permute(Output(1).Trial(i).HeadTrunk.Rside.Joint(1).IER,[3,2,1]),'g')
    figure;plot(Condition.Posturo(i).Rangle.Sseg_obli)
    hold on;plot(permute(Output(1).Trial(i).HeadTrunk.Rside.Joint(2).AA,[3,2,1]),'g')
    figure;plot(Condition.Posturo(i).Rangle.Sseg_tilt)
    hold on;plot(permute(Output(1).Trial(i).HeadTrunk.Rside.Joint(2).FE,[3,2,1]),'g')
    figure;plot(Condition.Posturo(i).Rangle.Sseg_rota)
    hold on;plot(permute(Output(1).Trial(i).HeadTrunk.Rside.Joint(2).IER,[3,2,1]),'g')
end

for i=1:1
    figure;plot(Condition.Gait(i).Rkinematics.Pobli)
    hold on;plot(permute(Output(1).Trial(i).LowerLimb.Rside.Segment(5).AA,[3,2,1]),'g')
    figure;plot(Condition.Gait(i).Rkinematics.Ptilt)
    hold on;plot(-permute(Output(1).Trial(i).LowerLimb.Rside.Segment(5).FE,[3,2,1]),'g')
    figure;plot(Condition.Gait(i).Rkinematics.Prota)
    hold on;plot(permute(Output(1).Trial(i).LowerLimb.Rside.Segment(5).IER,[3,2,1]),'g')
    
    figure;plot(Condition.Gait(i).Rkinematics.FE2)                          
    hold on;plot(permute(Output(1).Trial(i).LowerLimb.Rside.Joint(2).FE,[3,2,1]),'g')
    figure;plot(Condition.Gait(i).Rkinematics.AA2)                          
    hold on;plot(permute(Output(1).Trial(i).LowerLimb.Rside.Joint(2).AA,[3,2,1]),'g')
    figure;plot(Condition.Gait(i).Rkinematics.IER2)                          
    hold on;plot(permute(Output(1).Trial(i).LowerLimb.Rside.Joint(2).IER,[3,2,1]),'g')
    
    figure;plot(Condition.Gait(i).Rkinematics.FE3)
    hold on;plot(permute(Output(1).Trial(i).LowerLimb.Rside.Joint(3).FE,[3,2,1]),'g')
    figure;plot(Condition.Gait(i).Rkinematics.AA3)
    hold on;plot(permute(Output(1).Trial(i).LowerLimb.Rside.Joint(3).AA,[3,2,1]),'g')
    figure;plot(Condition.Gait(i).Rkinematics.IER3)
    hold on;plot(permute(Output(1).Trial(i).LowerLimb.Rside.Joint(3).IER,[3,2,1]),'g')
    
    figure;plot(Condition.Gait(i).Rkinematics.FE4)
    hold on;plot(permute(Output(1).Trial(i).LowerLimb.Rside.Joint(4).FE,[3,2,1]),'g')
    figure;plot(Condition.Gait(i).Rkinematics.AA4)
    hold on;plot(permute(Output(1).Trial(i).LowerLimb.Rside.Joint(4).AA,[3,2,1]),'g')
    figure;plot(Condition.Gait(i).Rkinematics.IER4)
    hold on;plot(permute(Output(1).Trial(i).LowerLimb.Rside.Joint(4).IER,[3,2,1]),'g')
    
    
    figure;plot(Condition.Gait(i).Rkinematics.Ftilt)
    hold on;plot(permute(Output(1).Trial(i).LowerLimb.Rside.Segment(2).FE,[3,2,1]),'g')
    figure;plot(Condition.Gait(i).Rkinematics.Fobli)
    hold on;plot(permute(Output(1).Trial(i).LowerLimb.Rside.Segment(2).IER,[3,2,1]),'g')
    figure;plot(Condition.Gait(i).Rkinematics.Frota)
    hold on;plot(permute(-Output(1).Trial(i).LowerLimb.Rside.Segment(2).AA,[3,2,1]),'g')
end