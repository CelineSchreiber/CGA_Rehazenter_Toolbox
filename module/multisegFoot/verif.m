t=1;

planes = {'FE','AA','IER'};
for i=1:3
    figure;hold on;
    Ankle = permute(Condition.Trial(t).MultisegFoot.Rside.Joint(5).(planes{i}),[3,2,1]);
    Calca = permute(Condition.Trial(t).MultisegFoot.Rside.Joint(4).(planes{i}),[3,2,1]);
    Mfoot = permute(Condition.Trial(t).MultisegFoot.Rside.Joint(3).(planes{i}),[3,2,1]);
    Ffoot = permute(Condition.Trial(t).MultisegFoot.Rside.Joint(2).(planes{i}),[3,2,1]);
    plot(Ankle,'k');
    plot(Calca,'r');
    plot(Mfoot,'g');
    plot(Ffoot,'b');
    Calca=Calca-mean(Calca);
    Mfoot=Mfoot-mean(Mfoot);
    Ffoot=Ffoot-mean(Ffoot);
    Tot=Calca+Mfoot+Ffoot;
    plot(Tot,'m')
end