function dydt = RK_perso7(param,t,y,Tmax,Pcore,DeltaP)
    dydt=zeros(7,1);
    Ta=Tmax*param.profil(t)+273;
    tau=y(1,:);
    w=y(2,:);
    R2w=y(3,:);
    r2w=y(4,:);
    T=y(5,:);
    Rc2w=y(6,:);
    rc2w=y(7,:);
    R=sqrt(R2w./w);
    r=sqrt(r2w./w);
    mu=param.viscosity(T);
    dwdz=tau/(3*pi*mu*(R^2-r^2));
    Rc=sqrt(Rc2w./w);
    rc=sqrt(rc2w./w);
    dydt(3)=(Pcore*r^2*R^2-param.gamma(T)*r*R*(r+R))/(mu*(R^2-r^2));
    dydt(1)=param.rho(T)*pi*(R^2-r^2)*(w*dwdz-param.g)-param.gamma(T)*pi*(dydt(3)-R^2*dwdz)/(2*R*w)-param.gamma(T)*pi*(dydt(3)-r^2*dwdz)/(2*r*w);
    dydt(2)=dwdz;
    dydt(4)=dydt(3);
    %dydt(5)=(R*param.N*(Ta-T)*2/(R^2-r^2)+param.sigma*param.alpha(T)*(Ta^4-T^4))/(param.rho(T)*param.Cp(T)*w);
    dydt(5)=(R*param.N*(Ta-T)+R*param.sigma*(param.alpha(Ta)*Ta^4-param.alpha(T)*T^4))*2/(R^2-r^2)/(param.rho(T)*param.Cp(T)*w);
    dydt(6)=(DeltaP*rc^2*Rc^2-param.gamma(T)*rc*Rc*(rc+Rc))/(mu*(Rc^2-rc^2));         
    dydt(7)=dydt(6);
end

