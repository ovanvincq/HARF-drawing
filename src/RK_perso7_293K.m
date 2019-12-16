function dydt = RK_perso7_293K(param,t,y,Pcore,DeltaP)
    dydt=zeros(7,1);
    Ta=293;
    tau=y(1,:);
    w=y(2,:);
    R2w=y(3,:);
    r2w=y(4,:);
    T=y(5,:);
    Rc2w=y(6,:);
    rc2w=y(7,:);
    R=sqrt(R2w./w);
    r=sqrt(r2w./w);
    mu=viscosite(T);
    dwdz=tau/(3*pi*mu*(R^2-r^2));
    Rc=sqrt(Rc2w./w);
    rc=sqrt(rc2w./w);
    dydt(3)=(Pcore*r^2*R^2-param.gamma*r*R*(r+R))/(mu*(R^2-r^2));
    dydt(1)=param.rho*pi*(R^2-r^2)*(w*dwdz-param.g)-param.gamma*pi*(dydt(3)-R^2*dwdz)/(2*R*w)-param.gamma*pi*(dydt(3)-r^2*dwdz)/(2*r*w);
    dydt(2)=dwdz;
    dydt(4)=dydt(3);
    dydt(5)=(R*param.N*(Ta-T)+R*param.sigma*param.alpha*(Ta^4-T^4))*2/(R^2-r^2)/(param.rho*param.Cp*w);
    dydt(6)=(DeltaP*rc^2*Rc^2-param.gamma*rc*Rc*(rc+Rc))/(mu*(Rc^2-rc^2));         
    dydt(7)=dydt(6);
end

