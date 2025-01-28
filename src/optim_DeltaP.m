function result = optim_DeltaP(param,Tmax,Pcore,DeltaP)
    x=optim_tension(param,Tmax,Pcore,1E-10);
    fct=@(t,y) RK_perso7(param,t,y,Tmax,Pcore,DeltaP);
    T0=Tmax*param.profil(0)+273-param.dT0;
    options = odeset('Reltol',1e-10,'AbsTol',1E-15);
    sol=ode45(fct,[0 param.Lfour],[x,param.w0,param.R0^2*param.w0,param.r0^2*param.w0,T0,param.Rc0^2*param.w0,param.rc0^2*param.w0],options);
    if (sol.x(end)~=param.Lfour)
        %J'ai mis deltaP car si ça ne converge pas, c'est que deltaP est
        %trop grand donc fminbnd va diminiuer deltaP à chaque pas
        result=DeltaP;
        return;
    end
    fct=@(t,y) RK_perso7_293K(param,t,y,Pcore,DeltaP);
    sol=ode45(fct,[param.Lfour param.L],sol.y(:,end),options);
    if (sol.x(end)~=param.L)
        result=DeltaP;
        return;
    end
    w=sol.y(2,end);
    Rc2w=sol.y(6,end);
    Rc=sqrt(Rc2w/w);
    if (Rc<param.Rc0)
        result=abs(Rc-param.Rcf)/param.Rcf;
    else
        result=DeltaP;
    end
end


















