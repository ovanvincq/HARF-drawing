function result = optim_DeltaP3(param,Tmax,Pcore,DeltaP,DeltaP2,DeltaP3)
    x=optim_tension(param,Tmax,Pcore,1E-10);
    fct=@(t,y) RK_perso11(param,t,y,Tmax,Pcore,DeltaP,DeltaP2,DeltaP3);
    T0=Tmax*param.profil(0)+273-param.dT0;
    options = odeset('Reltol',1e-10,'AbsTol',1E-15);
    sol=ode45(fct,[0 param.Lfour],[x,param.w0,param.R0^2*param.w0,param.r0^2*param.w0,T0,param.Rc0^2*param.w0,param.rc0^2*param.w0,param.Rc02^2*param.w0,param.rc02^2*param.w0,param.Rc03^2*param.w0,param.rc03^2*param.w0],options);
    if (sol.x(end)~=param.Lfour)
        %J'ai mis deltaP car si ça ne converge pas, c'est que deltaP est
        %trop grand donc fminbnd va diminiuer deltaP à chaque pas
        result=DeltaP3;
        return;
    end
    fct=@(t,y) RK_perso11_293K(param,t,y,Pcore,DeltaP,DeltaP2,DeltaP3);
    sol=ode45(fct,[param.Lfour param.L],sol.y(:,end),options);
    if (sol.x(end)~=param.L)
        %disp("trop grand")
        result=DeltaP3;
        return;
    end
    w=sol.y(2,end);
    Rc2w=sol.y(10,end);
    Rc=sqrt(Rc2w/w);
    if (~isreal(Rc))
        %disp("trop petit")
        result=1/DeltaP3*1E8;
        return;
    end
    if (Rc<param.Rc03)
        result=abs(Rc-param.Rcf3)/param.Rcf3;
    else
        result=DeltaP3;
    end
end


















