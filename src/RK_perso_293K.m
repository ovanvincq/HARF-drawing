function dydt = RK_perso_293K(param,t,y,Pcore)
    dydt=zeros(5,1);
    Ta=273+param.Text;
    tau=y(1,:);
    w=y(2,:);
    R2w=y(3,:);
    r2w=y(4,:);
    T=y(5,:);
    R=sqrt(R2w./w);
    r=sqrt(r2w./w);
    mu=param.viscosity(T);
    dwdz=tau/(3*pi*mu*(R^2-r^2));
    dydt(3)=(Pcore*r^2*R^2-param.gamma(T)*r*R*(r+R))/(mu*(R^2-r^2));
    dydt(1)=param.rho(T)*pi*(R^2-r^2)*(w*dwdz-param.g)-param.gamma(T)*pi*(dydt(3)-R^2*dwdz)/(2*R*w)-param.gamma(T)*pi*(dydt(3)-r^2*dwdz)/(2*r*w);
    dydt(2)=dwdz;
    dydt(4)=dydt(3);
    dydt(5)=(R*param.N*(Ta-T)*2/(R^2-r^2)+param.sigma*param.alpha(T)*(Ta^4-T^4))/(param.rho(T)*param.Cp(T)*w);
end

