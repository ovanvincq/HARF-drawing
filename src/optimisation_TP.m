function result =optimisation_TP(param,TP)
    try
        T=TP(1);
        Pcore=TP(2);
        x=optim_tension(param,T,Pcore,1E-10);
        fct=@(t,y) RK_perso(param,t,y,T,Pcore);
        T0=T*param.profil(0)+273-param.dT0;
        options = odeset('Reltol',1e-10,'AbsTol',1E-15);
        sol=ode45(fct,[0 param.Lfour],[x,param.w0,param.R0^2*param.w0,param.r0^2*param.w0,T0],options);
        fct=@(t,y) RK_perso_293K(param,t,y,Pcore);
        sol=ode45(fct,[param.Lfour param.L],sol.y(:,end),options);
        R2w=sol.y(3,end);
        r2w=sol.y(4,end);
        w=sol.y(2,end);
        R=sqrt(R2w/w);
        r=sqrt(r2w/w);
        if ((R2w>0) && (r2w>0))
            a=abs(R-param.Rf)/param.Rf;
            b=abs(R/r-param.Rf/param.rf)/(param.Rf/param.rf);
        else
            a=Inf;
            b=Inf;
        end
    catch exception
        a=Inf;
        b=Inf;
    end
    result=sqrt(a^2+b^2);
end

